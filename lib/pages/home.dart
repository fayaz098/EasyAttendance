import "package:easyattendance/pages/addstudent.dart";
import "package:easyattendance/pages/getattendance.dart";
import "package:flutter/material.dart";

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
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
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context)=> const AddStudent()),
              );
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 10,top: 10,left: 10,right: 10),
              padding: EdgeInsets.only(left: 30,right: 30,top: 20,bottom: 20),
              child: Text(
                "Add Student",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
            ) ,
          ),
          TextButton(
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context)=> const GetAttendance()),
              );
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
              padding: EdgeInsets.all(20),
              child: Text(
                "Get Attendance",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
            ) ,
          ),
        ],
      ),
    );
  }
}
