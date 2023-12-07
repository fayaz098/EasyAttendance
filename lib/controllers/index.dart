import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easyattendance/pages/home.dart';
import 'package:easyattendance/pages/addstudent.dart';
import 'package:easyattendance/pages/getattendance.dart';


class IndexApp extends StatelessWidget {
  const IndexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Welcome to Easy Attendance"),
      ),
      body: Column(
        children: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/addstudent');
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
              padding: EdgeInsets.all(20),
              child: Text(
                "Add Student",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.green,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/getattendance');
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
              padding: EdgeInsets.all(20),
              child: Text(
                "Get Attendance",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

// {
  //
  //   return MaterialApp(
  //       debugShowCheckedModeBanner: false,
  //       initialRoute: '/home',
  //       routes:{
  //         '/home': (context) => Home(),
  //         '/addstudent': (context) => AddStudent(),
  //         '/getattendance': (context) => GetAttendance(),
  //       }
  //   );

