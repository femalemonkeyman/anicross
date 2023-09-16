import 'package:sliver_tools/sliver_tools.dart';
import 'package:tokuwari_models/info_models.dart';
import '../media/providers/providers.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import '../widgets/image.dart';

extension on Widget {
  Widget padBottom() {
    return Padding(padding: const EdgeInsets.only(bottom: 15), child: this);
  }
}

class InfoPage extends StatelessWidget {
  final AniData data;

  const InfoPage({super.key, required this.data});

  @override
  Widget build(context) {
    final Widget expands = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        LaterButton(
          data: data,
        ).padBottom(),
        ExpandableText(
          data.description,
          expandText: "More",
          collapseText: "Less",
          maxLines: 4,
        ).padBottom(),
        Wrap(
          spacing: 3,
          runSpacing: 7,
          children: List.generate(
            data.tags.length.clamp(0, 15),
            (index) {
              return ActionChip(
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: Colors.blueGrey[800],
                side: BorderSide.none,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                label: Text(
                  data.tags[index],
                ),
                onPressed: () => context.go(
                  '/${data.type}?tag=${data.tags[index]}',
                ),
              );
            },
          ),
        ).padBottom(),
      ],
    );
    final double ratio =
        MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Continue?'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: Text(data.title),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: 10,
              ),
              sliver: SliverList.list(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        flex: 7,
                        fit: FlexFit.tight,
                        child: AniImage(
                          image: data.image,
                        ).padBottom(),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        flex: 15,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.title,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              data.status,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Score: ${data.score}',
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Count: ${data.count}',
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ).padBottom(),
                            if (ratio > 1.2) expands,
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (ratio < 1.2) expands,
                  //  ⠄⠄⡔⠙⠢⡀⠄⠄⠄⢀⠼⠅⠈⢂⠄⠄⠄⠄
                  //  ⠄⠄⡌⠄⢰⠉⢙⢗⣲⡖⡋⢐⡺⡄⠈⢆⠄⠄⠄
                  //  ⠄⡜⠄⢀⠆⢠⣿⣿⣿⣿⢡⢣⢿⡱⡀⠈⠆⠄⠄
                  //  ⠄⠧⠤⠂⠄⣼⢧⢻⣿⣿⣞⢸⣮⠳⣕⢤⡆⠄⠄
                  //  ⢺⣿⣿⣶⣦⡇⡌⣰⣍⠚⢿⠄⢩⣧⠉⢷⡇⠄⠄
                  //  ⠘⣿⣿⣯⡙⣧⢎⢨⣶⣶⣶⣶⢸⣼⡻⡎⡇⠄⠄
                  //  ⠄⠘⣿⣿⣷⡀⠎⡮⡙⠶⠟⣫⣶⠛⠧⠁⠄⠄⠄
                  //  ⠄⠄⠘⣿⣿⣿⣦⣤⡀⢿⣿⣿⣿⣄⠄⠄⠄⠄⠄
                  //  ⠄⠄⠄⠈⢿⣿⣿⣿⣿⣷⣯⣿⣿⣷⣾⣿⣷⡄⠄
                  //  ⠄⠄⠄⠄⠄⢻⠏⣼⣿⣿⣿⣿⡿⣿⣿⣏⢾⠇⠄
                  //  ⠄⠄⠄⠄⠄⠈⡼⠿⠿⢿⣿⣦⡝⣿⣿⣿⠷⢀⠄
                  //  ⠄⠄⠄⠄⠄⠄⡇⠄⠄⠄⠈⠻⠇⠿⠋⠄⠄⢘⡆
                  //  ⠄⠄⠄⠄⠄⠄⠱⣀⠄⠄⠄⣀⢼⡀⠄⢀⣀⡜⠄
                  //  ⠄⠄⠄⠄⠄⠄⠄⢸⣉⠉⠉⠄⢀⠈⠉⢏⠁⠄⠄
                  //  ⠄⠄⠄⠄⠄⠄⡰⠃⠄⠄⠄⠄⢸⠄⠄⢸⣧⠄⠄
                  //  ⠄⠄⠄⠄⠄⣼⣧⠄⠄⠄⠄⠄⣼⠄⠄⡘⣿⡆⠄
                  //  ⠄⠄⠄⢀⣼⣿⡙⣷⡄⠄⠄⠄⠃⠄⢠⣿⢸⣿⡀
                  //  ⠄⠄⢀⣾⣿⣿⣷⣝⠿⡀⠄⠄⠄⢀⡞⢍⣼⣿⠇
                  //  ⠄⠄⣼⣿⣿⣿⣿⣿⣷⣄⠄⠄⠠⡊⠴⠋⠹⡜⠄
                  //  ⠄⠄⣿⣿⣿⣿⣿⣿⣿⣿⡆⣤⣾⣿⣿⣧⠹⠄⠄
                  //  ⠄⠄⢿⣿⣿⣿⣿⣿⣿⣿⢃⣿⣿⣿⣿⣿⡇⠄⠄
                  //  ⠄⠄⠐⡏⠉⠉⠉⠉⠉⠄⢸⠛⠿⣿⣿⡟⠄⠄⠄
                  //  ⠄⠄⠄⠹⡖⠒⠒⠒⠒⠊⢹⠒⠤⢤⡜⠁⠄⠄⠄
                  //  ⠄⠄⠄⠄⠱⠄⠄⠄⠄⠄⢸
                ],
              ),
            ),
            EpisodeList(
              data: data,
            ),
          ],
        ),
      ),
    );
  }
}

class LaterButton extends StatefulWidget {
  final Isar isar = Isar.getInstance('later')!;
  final AniData data;

  LaterButton({super.key, required this.data});

  @override
  State createState() => LaterButtonState();
}

class LaterButtonState extends State<LaterButton> {
  @override
  Widget build(context) => ActionChip(
        shape: const StadiumBorder(),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        onPressed: () => setState(
          () {
            final media = widget.isar.aniDatas.filter().mediaIdMatches(
                  widget.data.mediaId,
                );
            if (media.isEmptySync()) {
              widget.isar.writeTxnSync(
                () => widget.isar.aniDatas.putSync(widget.data),
              );
            } else {
              widget.isar.writeTxnSync(
                () => media.deleteAllSync(),
              );
            }
          },
        ),
        avatar: (widget.isar.aniDatas
                .filter()
                .mediaIdMatches(widget.data.mediaId)
                .isEmptySync())
            ? const Icon(Icons.bookmark_add_outlined)
            : const Icon(Icons.bookmark_added_rounded),
        label: const Text("Later"),
      );
}

class EpisodeList extends StatefulWidget {
  final AniData data;

  const EpisodeList({
    super.key,
    required this.data,
  });

  @override
  State createState() => EpisodeListState();
}

class EpisodeListState extends State<EpisodeList> {
  final List<MediaProv> content = [];
  late Function init = providers[widget.data.type]![0]['data'];

  @override
  void initState() {
    Future.microtask(
      () async => await loadEpisodes(),
    );
    super.initState();
  }

  Future<void> loadEpisodes() async {
    content
      ..clear()
      ..addAll(
        await init(widget.data),
      );
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(context) {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      sliver: MultiSliver(
        children: [
          SliverList.list(
            children: [
              DropdownButton(
                value: init,
                padding: const EdgeInsets.only(left: 15),
                underline: const SizedBox.shrink(),
                focusColor: const Color.fromARGB(0, 0, 0, 0),
                borderRadius: BorderRadius.circular(30),
                icon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh_rounded),
                ),
                items: List.generate(
                  providers[widget.data.type]!.length,
                  (index) => DropdownMenuItem(
                    value: providers[widget.data.type]![index]['data'],
                    child: Text(
                      providers[widget.data.type]![index]['name'],
                    ),
                  ),
                  growable: false,
                ),
                onChanged: (value) => Future.microtask(
                  () async {
                    init = (value as Function);
                    await loadEpisodes();
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              mainAxisSpacing: 5,
              crossAxisSpacing: 6,
              maxCrossAxisExtent: 400,
              mainAxisExtent: 100,
            ),
            delegate: SliverChildBuilderDelegate(
              childCount: content.length,
              (context, index) {
                return GestureDetector(
                  onTap: () => context.push(
                    '/${widget.data.type}/info/viewer',
                    extra: {
                      'index': index,
                      'contents': content,
                      'data': widget.data,
                    },
                  ),
                  child: Card(
                    elevation: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            content[index].title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            '${(widget.data.type == 'anime') ? 'Episode:' : 'Chapter:'} ${content[index].number}',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
