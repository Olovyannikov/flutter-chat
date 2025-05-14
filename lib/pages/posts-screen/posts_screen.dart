import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat/entities/Post/post_entity.dart';
import 'package:flutter_chat/entities/User/user_entity.dart';
import 'package:flutter_chat/pages/pages.dart';
import 'package:image_picker/image_picker.dart';

class PostsScreen extends StatefulWidget {
  static final String id = 'posts_screen';

  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              final picker = ImagePicker();
              picker
                  .pickImage(source: ImageSource.gallery, imageQuality: 40)
                  .then((xFile) {
                    if (xFile != null) {
                      final File file = File(xFile.path);
                      Navigator.of(
                        context,
                      ).pushNamed(CreatePostScreen.id, arguments: file);
                    }
                  });
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              context.read<AuthCubit>().signOut().then((_) {
                Navigator.of(context).pushReplacementNamed(SignInScreen.id);
              });
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error'));
          }

          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              final QueryDocumentSnapshot doc = snapshot.data!.docs[index];
              final PostModel post = PostModel(
                  id: doc["postId"],
                  userName: doc["userName"],
                  timestamp: doc["timestamp"],
                  description: doc["description"],
                  imageUrl: doc["imageUrl"],
                  userId: doc["userId"]);

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(ChatScreen.id, arguments: post);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(post.imageUrl),
                            fit: BoxFit.cover
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        post.userName,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 4),
                      Text(
                        post.description,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
