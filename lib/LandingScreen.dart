import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/HomeScreen.dart';
import 'package:quiz_app/Profile.dart';
import 'package:quiz_app/QuizList.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  int _page = 1;
  List<Widget> Widgetlist = [QuizListScreen(), QuizHomePage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.pink[700],
          bottomNavigationBar: CurvedNavigationBar(
            height: 60,
            index: _page,
            key: _bottomNavigationKey,
            backgroundColor: const Color.fromRGBO(194, 24, 91, 1),
            color: Colors.white,
            animationCurve: Curves.fastEaseInToSlowEaseOut,
            items: <Widget>[
              Icon(
                Icons.favorite,
                color: Colors.pink,
              ),
              Icon(
                Icons.home,
                color: Colors.pink,
              ),
              Icon(
                Icons.person,
                color: Colors.pink,
              ),
            ],
            onTap: (index) {
              setState(() {
                _page = index;
              });
            },
          ),
          body: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Stack(
              children: [
                IndexedStack(
                  children: Widgetlist,
                  index: _page,
                )
              ],
            ),
          )),
    );
  }
}
