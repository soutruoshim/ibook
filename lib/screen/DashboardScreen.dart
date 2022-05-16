import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:ibook/screen/BookmarkScreen.dart';
import 'package:ibook/utils/Extensions/context_extensions.dart';
import 'package:ibook/utils/colors.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/text_styles.dart';
import 'CategoryScreen.dart';
import 'HomeScreen.dart';
import 'SettingScreen.dart';

class DashboardScreen extends StatefulWidget {
  static String tag = '/DashboardScreen';

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final tab = [
    HomeScreen(),
    CategoryScreen(),
    BookmarkScreen(),
    SettingScreen(onTap: () {}),
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget mLine() {
    return Container(
      height: 3,
      margin: EdgeInsets.only(top: 6),
      width: 20,
      decoration: boxDecorationWithShadowWidget(boxShape: BoxShape.rectangle, backgroundColor: primaryColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tab[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: context.scaffoldBackgroundColor,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedLabelStyle: primaryTextStyle(),
        currentIndex: _currentIndex,
        unselectedItemColor: unSelectIconColor,
        selectedItemColor: primaryColor,
        onTap: (index) {
          _currentIndex = index;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Ionicons.md_book_outline, size: 20), activeIcon: Column(children: [Icon(Ionicons.book, size: 22), mLine()]), label: ""),
          BottomNavigationBarItem(icon: Icon(Ionicons.md_grid_outline, size: 20), activeIcon: Column(children: [Icon(Ionicons.md_grid, size: 22), mLine()]), label: ""),
          BottomNavigationBarItem(icon: Icon(Ionicons.ios_bookmarks_outline, size: 20), activeIcon: Column(children: [Icon(Ionicons.bookmarks, size: 22), mLine()]), label: ""),
          BottomNavigationBarItem(icon: Icon(Ionicons.settings_outline, size: 20), activeIcon: Column(children: [Icon(Ionicons.settings, size: 22), mLine()]), label: ""),
        ],
      ),
    );
  }
}
