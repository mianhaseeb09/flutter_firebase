import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String imageURL = '';

  Future<void> uploadImage(XFile file) async {
    var ref = FirebaseStorage.instance.ref('files/${file.name}');

    var task = await ref.putFile(File(file.path));
    var fileURL = (await task.ref.getDownloadURL());
    setState(() {
      imageURL = fileURL;
    });
  }
  late final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: imageURL.isEmpty ? null : () async {
              var id = await ImageDownloader.downloadImage(imageURL);
              if(id != null) {
                if (kDebugMode) {
                  print("Image is saved! $id");
                }
              }
            },
            icon: const Icon(Icons.download),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var file = await ImagePicker().pickImage(source: ImageSource.gallery);
          uploadImage(file!);
        },
        child: const Icon(Icons.upload),
      ),
      body: Center(
        child: imageURL.isEmpty
            ? const Text('No image is uploaded.')
            : Image.network(imageURL),
      ),
    );

  }

}

class ImageDownloader {
  static downloadImage(String imageURL) {}
}