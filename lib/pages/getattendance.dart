import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:easyattendance/model/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:easyattendance/model/API.dart';

class GetAttendance extends StatefulWidget {
  const GetAttendance({Key? key}) : super(key: key);
  @override
  State<GetAttendance> createState() => _GetAttendanceState();
}
class _GetAttendanceState extends State<GetAttendance> {
  Storage storage = Storage();
  List<dynamic>? students = [] ;
  String name = "";
  String url = "";
  String folderName = "attendance/";
  bool flag = false;
  bool isSelected = false;
  bool isVisible = false;
  int value = 0;
  var Data;
  var _sections = ["AI-A","AI-B","AIML"];
  var _currentItemSelected = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Get Attendance"),
      ),
      body: Column(
        children: [
          Center(
          child: DropdownButton<String>(
            hint: Text("Select Section"),
              items: _sections.map((String dropDownStringItem){
                return DropdownMenuItem<String>(
                  value: dropDownStringItem,
                  child: Text(dropDownStringItem),
                );
              }).toList(),
            onChanged: (String? newValueSelected) {
              setState(() {
                this._currentItemSelected = newValueSelected.toString();
                print(this._currentItemSelected);
              });
            },
            value: _currentItemSelected.isNotEmpty? _currentItemSelected:null,
            ),
          ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  ElevatedButton(
                      onPressed: ()async{
                        url = 'https://vishaladem.pythonanywhere.com/getattendance?gname=' +
                            this._currentItemSelected +
                            "`" +
                            name.toString();
                        Data = await Getdata(url);
                        var DecodedData =jsonDecode(Data);
                        setState(() {
                          students = DecodedData["Present"];
                          isVisible = !isVisible;
                          if (value == 1){
                            value = 0;
                          }
                        });
                      },
                      child: Text("Get Attendance")
                  ),

                ],
              ),
              Visibility(
                visible: isVisible,
                child: Expanded(
                    child: SizedBox(
                      height: 200,
                      width: 300,
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: ListView.builder(

                          itemCount: 62,
                          itemBuilder: (ctx,i){
                            return MyListItems(title: i.toString(), present: students!,value: value);
                          },
                        )
                      ),
                    )
                ),
              ),
        ],
      ),
    );
  }
}

class MyListItems extends StatefulWidget {
  final String title;
  final List<dynamic> present;
  final int value;
  const MyListItems({ Key? key, required this.title, required this.present,required this.value}) : super(key: key);

  @override
  State<MyListItems> createState() => _MyListItemsState();
}

class _MyListItemsState extends State<MyListItems> {
  bool isSelected = false;

  void toggleSwitch(bool value){
    setState(() {
      isSelected =! isSelected;
    });
  }
  @override
  Widget build(BuildContext context) {
    int temp = int.parse(widget.title) + 1;
    List<dynamic> tempPresent = widget.present;
    int rollno = 7100 + temp;
    if (tempPresent.contains(rollno.toString())){
      isSelected = true;
    }

    return
        ListTile(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2),
            borderRadius: BorderRadius.circular(50), //<-- SEE HERE
          ),
          title:  Text(
            rollno.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Switch(value: isSelected, onChanged: toggleSwitch,activeColor: Colors.blue)
      );
  }
}