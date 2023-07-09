// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitch_clone/provider/user_provider.dart';
import 'package:twitch_clone/screen/home/onboard_screen/feed_screen.dart';
import 'package:twitch_clone/screen/home/onboard_screen/go_live_screen.dart';
import 'package:twitch_clone/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0;

  List<Widget> pages = [
    FeedScreen(),
    GoLiveScreen(),
    Center(
      child: Text("Browse Screen"),
    ),
  ];
  onPageChange(int index) {
    _pageIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: buttonColor,
        unselectedItemColor: primaryColor,
        backgroundColor: backgroundColor,
        unselectedFontSize: 12,
        currentIndex: _pageIndex,
        onTap: onPageChange,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Following",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_rounded),
            label: "Go Live",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.copy),
            label: "Browse",
          ),
        ],
      ),
      body: pages[_pageIndex],
    );
  }
}
