import 'dart:io';
import 'package:anicross/novel/novel_parser.dart';
import 'package:anicross/widgets/grid.dart';
import 'package:anicross/models/info_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

enum Color { red, green, blue }

class NovelPage extends StatefulWidget {
  const NovelPage({super.key});

  @override
  State createState() => NovelPageState();
}

class NovelPageState extends State<NovelPage> {
  Isar isar = Isar.getInstance('novels') ??
      Isar.openSync([AniDataSchema], name: 'novels');
  List<AniData> novels = [];

  @override
  void initState() {
    super.initState();
    novels = isar.aniDatas.filter().typeEqualTo("novel").findAllSync();
    print(novels.length);
  }

  importNovel() async {
    bool permission = true;
    if (Platform.isAndroid) {
      if (await Permission.storage.isDenied) {
        permission =
            (await Permission.manageExternalStorage.request()).isGranted;
        print("uwu");
      }
    }
    if (permission) {
      final String? path = await FilePicker.platform.getDirectoryPath();
      if (path != null) {
        novels = await compute(
          (stuff) async {
            BackgroundIsolateBinaryMessenger.ensureInitialized(
              stuff[1] as RootIsolateToken,
            );
            final Directory directory = Directory(stuff[0] as String);
            final List epubs = directory.listSync(recursive: true).toList()
              ..retainWhere(
                (element) => element.path.endsWith(".epub"),
              );
            List<AniData> data = [];
            for (File i in epubs) {
              print(i);
              final Novel novel = Novel(path: i.path);
              await novel.parse();
              await novel.writeCover();
              novel.close();
              data.add(
                AniData(
                  type: "novel",
                  title: novel.title!,
                  image: novel.cover!,
                  mediaId: i.path,
                ),
              );
            }
            return data;
          },
          [
            path,
            RootIsolateToken.instance,
          ],
        );
        updateIsar();
      }
    }
    setState(() {});
  }

  void updateIsar() {
    isar.writeTxnSync(
      () => isar.aniDatas.putAllSync(novels),
    );
  }

  @override
  Widget build(context) {
    return (novels.isEmpty)
        ? Center(
            child: ActionChip(
              label: const Text("Click me to add novels <3"),
              onPressed: () {
                importNovel();
                showDialog(
                  context: context,
                  builder: (context) {
                    return const SimpleDialog(
                      children: [
                        Center(
                          child: Text("Importing..."),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          )
        : CustomScrollView(
            slivers: [
              Grid(
                data: novels,
                length: novels.length,
                paginate: () {},
              ),
            ],
          );
  }
}
