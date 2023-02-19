import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:anicross/search_button.dart';
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xml/xml.dart';

import 'novel_grid.dart';

class Epub {
  final Archive archive;
  String? path;
  String? document;
  String? folder;
  String? title;
  ArchiveFile? coverImage;
  List<XmlElement>? manifest;
  List<XmlElement>? spine;

  Epub(this.archive) {
    path = XmlDocument.parse(
      utf8.decode(archive.findFile("META-INF/container.xml")?.content),
    ).findAllElements("rootfile").first.getAttribute("full-path");
    if (path!.contains("OPS") ||
        path!.contains("OEBPS") ||
        path!.contains("item")) {
      folder = path?.substring(0, path?.indexOf("/"));
    }
    document = utf8.decode(archive.findFile(path!)?.content);
    manifest = XmlDocument.parse(document!).findAllElements("item").toList();
    spine = XmlDocument.parse(document!).findAllElements("itemref").toList();
    title = XmlDocument.parse(
      document!,
    ).findAllElements("dc:title").first.text;
    for (var i in manifest!) {
      if (i.toString().contains("over") && !i.toString().contains("xhtml")) {
        coverImage = archive.findFile(
              i.getAttribute("href")!,
            ) ??
            archive.findFile(
              "$folder/${i.getAttribute("href")!}",
            );
        break;
      }
    }
  }
}

class EpubReader {
  final Archive archive;
  Epub? epub;
  List chapters = [];

  EpubReader(this.archive) {
    epub = Epub(archive);
  }

  List getChapters() {
    try {
      for (var i in epub!.spine!) {
        for (var j in epub!.manifest!) {
          if (i.getAttribute("idref") == j.getAttribute("id")) {
            chapters.add(
              utf8.decode(archive
                      .findFile("${epub?.folder}/${j.getAttribute("href")}")
                      ?.content ??
                  archive.findFile("${j.getAttribute("href")}")?.content),
            );
          }
        }
      }
    } catch (e) {
      print(e);
    }

    return chapters;
  }
}

openArchive(String location) async {
  return await Future(
    () => ZipDecoder().decodeBuffer(
      InputFileStream(location),
    ),
  );
}

getFilepath() async {
  String? directory;
  if (Platform.isAndroid) {
    await Permission.manageExternalStorage.request();
  }
  directory = await FilePicker.platform.getDirectoryPath();

  if (directory != null) {
    //print(await Directory(directory).list().length);
    //Hive.box("settings").put("novels", directory);
    return Directory(directory);
  }
}

importBooks() async* {
  List books = [];
  Archive archive;
  Directory directory;
  Epub epub;
  Directory documents = await getApplicationDocumentsDirectory();

  directory = await getFilepath();

  //print(files.last);
  for (File i in directory.listSync(recursive: true).whereType<File>()) {
    if (i.toString().contains(".epub")) {
      archive = await openArchive(i.path);
      try {
        epub = Epub(archive);
        var path = documents.path +
            "/anisettings/.covers/${i.path.split(Platform.pathSeparator).last.split(".").first}";

        epub.coverImage?.writeContent(
          OutputFileStream(path),
        );

        books.add({'title': epub.title, 'image': path, 'file': i.path});
        yield books.last['title'];
      } catch (e) {
        print(e);
        //print(i);
      }
    }
  }
  Hive.box("settings").put("novels", books);
}

Future<EpubReader> getBook(String location) async {
  List text = [];

  Archive archive = await openArchive(location);
  //print(archive.files);

  EpubReader reader = EpubReader(archive);
  return reader;
}

class NovelReader extends StatelessWidget {
  final String title;
  final file;
  const NovelReader({Key? key, required this.title, this.file})
      : super(key: key);

  @override
  Widget build(context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const BackButton(),
              FutureBuilder<EpubReader>(
                future: getBook(file),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final chapters = snapshot.data!.getChapters();
                    return ListView.builder(
                      itemCount: chapters.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Html(
                          data: chapters[index],
                          customRenders: {
                            tagMatcher('img'): CustomRender.widget(
                              widget: (context, buildChildren) {
                                final url = context
                                    .tree.element!.attributes['src']!
                                    .replaceAll('../', '');
                                return Image(
                                  image: MemoryImage(
                                    Uint8List.fromList(snapshot.data!.archive
                                            .findFile(
                                                "${snapshot.data?.epub?.folder}/$url")
                                            ?.content ??
                                        snapshot.data?.archive
                                            .findFile(url)
                                            ?.content),
                                  ),
                                );
                              },
                            )
                          },
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NovelPage extends StatefulWidget {
  const NovelPage({Key? key}) : super(key: key);

  @override
  State createState() => NovelPageState();
}

class NovelPageState extends State {
  Directory? directory;
  @override
  Widget build(context) {
    return ListView(
      controller: ScrollController(),
      primary: false,
      shrinkWrap: true,
      children: [
        // const Center(
        //   child: SearchButton(
        //     text: "local novels",
        //   ),
        // ),
        if (Hive.box("settings").get("novels") == null)
          StreamBuilder(
              stream: importBooks(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //print(snapshot.data);
                  setState(() {});
                  return Text(snapshot.data.toString());
                }
                return const CircularProgressIndicator();
              }
              //child: const Text("Please select a directory"),
              ),
        if (Hive.box("settings").get("novels") != null)
          NovelGrid(
            data: Hive.box("settings").get("novels"),
          ),
        IconButton(
          onPressed: () {
            Hive.box("settings").delete("novels");
            setState(() {});
          },
          icon: const Icon(Icons.refresh),
        )
      ],
    );
  }
}
