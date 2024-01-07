import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:tokuwari/viewers/Novel/novel_controller.dart';

import 'package:tokuwari/widgets/loading.dart';
import 'package:tokuwari_models/info_models.dart';

class NovelViewer extends StatefulWidget {
  final NovData data;

  const NovelViewer({super.key, required this.data});

  @override
  State createState() => NovelViewerState();
}

class NovelViewerState extends State<NovelViewer> with AutomaticKeepAliveClientMixin {
  late NovelController controller;
  late final novel = getNovel();
  //late final height = MediaQuery.sizeOf(context).height;

  Future<void> getNovel() async {
    controller = await NovelController.create(widget.data.path);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: FutureBuilder(
        future: novel,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                GesturePageView.builder(
                  itemCount: controller.chapterSpans.length,
                  itemBuilder: (context, index) {
                    return SafeArea(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: RichText(
                            text: controller.chapterSpans[index],
                            textScaler: TextScaler.linear(controller.fontScale),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => setState(() {
                    print('yes');
                    controller.setFontScale(16);
                  }),
                ),
                const BackButton(),
              ],
            );
          }
          return const Loading();
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
