import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Storage{
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  Future<void> uploadFile(
      String filePath,
      String fileName,
      String folder
      ) async {
    File file = File(filePath);

    try{
      await storage.ref("$folder/$fileName").putFile(file);
    } on firebase_core.FirebaseException catch(e) {
      print(e);
    }
  }
  Future<firebase_storage.ListResult> listFiles(String folder) async {
    firebase_storage.ListResult results = await storage.ref(folder).listAll();
    results.items.forEach((firebase_storage.Reference ref){
      print("Found file: $ref");
    });
    return results;
  }
  Future<String> downloadURL(String imageName, String folder) async{
    String downloadURL = await storage.ref("$folder/$imageName").getDownloadURL();
    return downloadURL;
  }
}