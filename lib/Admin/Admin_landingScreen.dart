import 'package:flutter/material.dart';
import 'package:quiz_app/Admin/AddQuestion.dart';

class Admin_LandingScreen extends StatefulWidget {
  const Admin_LandingScreen({super.key});

  @override
  State<Admin_LandingScreen> createState() => _Admin_LandingScreenState();
}

class _Admin_LandingScreenState extends State<Admin_LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminDashboard()));
                },
                child: Text("add ques")),
            TextButton(onPressed: () {}, child: Text("redeem request")),
            TextButton(onPressed: () {}, child: Text("redeem  status ")),
            TextButton(onPressed: () {}, child: Text("add ques")),
            TextButton(onPressed: () {}, child: Text("add ques")),
          ],
        ),
      ),
    );
  }
}
