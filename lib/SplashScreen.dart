import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiz_app/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late String? finalloginDetail;
  void initState() {
    super.initState();
    isLogin().whenComplete(() async {
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      });
    });
  }

  Future isLogin() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: Container(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.sizeOf(context).height / 2,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(200),
                  )),
            ),
            Align(
                alignment: Alignment(0, -.2),
                child: Image.asset(
                  "assets/logo.png",
                  scale: 2,
                )),
            Align(
                alignment: Alignment(0, .30),
                child: Text(
                  "Quiz Master",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 35),
                )),
            Align(
                alignment: Alignment(0, .54),
                child: CircularProgressIndicator(
                  color: Colors.white,
                ))
          ],
        ),
      ),
    );
  }
}
