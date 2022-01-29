import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'package:yt_downloader/provider/api_content.dart';
import 'package:yt_downloader/screens/download_screen/download_screen.dart';
import 'package:yt_downloader/screens/home_screen/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => APIContent()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'YouTube Downloader',
        home: BottomBarNavigation(),
      ),
    );
  }
}

class BottomBarNavigation extends StatefulWidget {
  const BottomBarNavigation({Key? key}) : super(key: key);

  @override
  _BottomBarNavigationState createState() => _BottomBarNavigationState();
}

class _BottomBarNavigationState extends State<BottomBarNavigation> {
  final Color navigationBarColor = Colors.white;
  final List<Widget> _pages = const [HomePage(), DownloadScreen()];
  int selectedIndex = 0;
  late PageController pageController;
  void onPageChanged(int index){
    setState(() {
      selectedIndex = index;
    });
  }
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: _pages,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: WaterDropNavBar(
          bottomPadding: 5.0,
          waterDropColor: Colors.red,
          backgroundColor: navigationBarColor,
          onItemSelected: (int index) {
            setState(() {
              selectedIndex = index;
            });
            pageController.animateToPage(selectedIndex,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad);
          },
          selectedIndex: selectedIndex,
          barItems: <BarItem>[
            BarItem(
              filledIcon: EvaIcons.home,
              outlinedIcon: EvaIcons.homeOutline,
            ),
            BarItem(
                filledIcon: Icons.favorite_rounded,
                outlinedIcon: Icons.favorite_border_rounded),
          ]),
    );
  }
}
