import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'anime/anime.dart';
import 'manga/manga.dart';
import 'novel/novel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      theme: ThemeData(
        dividerColor: Colors.transparent,
        scaffoldBackgroundColor: const Color.fromARGB(200, 0, 0, 20),
        cardColor: Colors.deepPurple,
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.dark,
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
        chipTheme: const ChipThemeData(
          showCheckmark: false,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.macOS: OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.windows: OpenUpwardsPageTransitionsBuilder(),
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        "Dashboard": (context) => const AniNav(),
      },
      initialRoute: 'Dashboard',
    ),
  );
}

class AniNav extends StatelessWidget {
  const AniNav({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: DefaultTabController(
        length: 4,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    AniPage(),
                    MangaPage(),
                    NovelPage(),
                    SizedBox.shrink(),
                  ],
                ),
              ),
              TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                tabs: [
                  Tab(
                    child: Wrap(
                      children: [
                        Icon(MdiIcons.youtubeTv),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Wrap(
                      children: [
                        Icon(MdiIcons.bookOpenOutline),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Wrap(
                      children: [
                        Icon(MdiIcons.book),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Wrap(
                      children: [
                        Icon(MdiIcons.bookmark),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
