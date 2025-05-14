import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CreatePostScreen extends StatefulWidget {
  static const String id = 'create_post_screen';

  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  String _description = "";

  Future<void> _submit({required File image}) async {
    FocusScope.of(context).unfocus();
    if (_description.trim().isNotEmpty) {
      late String imageUrl;

      firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;

      await storage
          .ref("images/${UniqueKey().toString()}.png")
          .putFile(image)
          .then((taskSnapshot) async {
            imageUrl = await taskSnapshot.ref.getDownloadURL();
          });

      FirebaseFirestore.instance
          .collection("posts")
          .add({
            "timestamp": Timestamp.now(),
            "userId": FirebaseAuth.instance.currentUser!.uid,
            "description": _description,
            "userName": FirebaseAuth.instance.currentUser!.displayName,
            "imageUrl": imageUrl,
          })
          .then(
            (documentReference) async {
              try {
                await documentReference.update({"postId": documentReference.id});
              } catch (err) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Firebase CloudStorage required payment now"),
                  ),
                );
              }
            }
          )
          .catchError((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Firebase CloudStorage required payment now"),
              ),
            );
          });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final File imageFile = ModalRoute.of(context)!.settings.arguments as File;

    return Scaffold(
      appBar: AppBar(title: Text('Create Post')),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 1.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: FileImage(imageFile),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter the description",
                  ),
                  textInputAction: TextInputAction.done,
                  inputFormatters: [LengthLimitingTextInputFormatter(150)],
                  onChanged: (value) {
                    _description = value;
                  },
                  onEditingComplete: () {
                    _submit(image: imageFile);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
