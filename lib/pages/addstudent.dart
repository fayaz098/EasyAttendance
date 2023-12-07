import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:easyattendance/model/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:easyattendance/model/API.dart';
class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);
  @override
  State<AddStudent> createState() => _AddStudentState();
}
class _AddStudentState extends State<AddStudent> {

  Storage storage = Storage();
  String name = "";
  String Result = "";
  String url = "";
  String folderName = "students/";
  bool flag = false;
  var Data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Student"),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                final results = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  type: FileType.custom,
                  allowedExtensions: ['png','jpg'],
                );
                if(results == null){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No file selected'),
                    ),
                  );
                  return null;
                }
                final path = results.files.single.path!;
                final fileName = results.files.single.name;
                name = fileName;
                storage
                    .uploadFile(path, fileName, folderName)
                    .then((value){ print('Done');flag = true;setState((){}); });
                print(name);
              },
              child: Text('Upload File'),
            ),
          ),
          FutureBuilder(
            future: storage.listFiles(folderName),
            builder: (BuildContext context,
                AsyncSnapshot<firebase_storage.ListResult> snapshot) {
              if(snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData && flag)
              {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 50,

                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true ,
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:ElevatedButton(
                            onPressed: () {
                              setState((){});
                            },
                            child: Text(name),
                          ),
                        );
                      }),
                );
              }
              if(flag){
                  if(snapshot.connectionState == ConnectionState.waiting ||
                   !snapshot.hasData ){

                    return CircularProgressIndicator();
                }
              }
              return Container();
            },
          ),
          FutureBuilder(
              future: storage.downloadURL(name, folderName),//IMG-20230506-WA0001
              builder: (BuildContext context,
                  AsyncSnapshot<String> snapshot) {
                if(snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData){
                  return Container(
                      width: 300,
                      height: 300,
                      child: Image.network(
                          snapshot.data!,
                          fit: BoxFit.fill
                      ));
                }
                if(snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData){
                  if (name == ""){
                    return Container();
                  }
                  return CircularProgressIndicator();
                }
                return Container();
              }),
          ElevatedButton(
              onPressed: ()async{
                url = 'https://vishaladem.pythonanywhere.com/addstudent?student=' + name.toString();
                Data = await Getdata(url);
                var DecodedData =jsonDecode(Data);
                setState(() {
                  Result = DecodedData["flag"];
                });
              },
              child: Text("Add Student")),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
                Result,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
