import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_chat/entities/Chat/chat_entity.dart';
import 'package:flutter_chat/entities/Post/post_entity.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String _message = "";
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = ModalRoute.of(context)!.settings.arguments as PostModel;

    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection("posts")
                      .doc(post.id)
                      .collection("comments")
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error"));
                }

                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.connectionState == ConnectionState.none) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: snapshot.data?.docs.length ?? 0,
                  itemBuilder: (context, index) {
                    final QueryDocumentSnapshot doc =
                        snapshot.data!.docs[index];

                    final ChatModel chatModel = ChatModel(
                      userName: doc["userName"],
                      timestamp: doc["timestamp"],
                      userId: doc["userId"],
                      message: doc["message"],
                    );

                    return Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text("By: ${chatModel.userName}"),
                            SizedBox(height: 4,),
                            Text(chatModel.message)
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                      controller: _textEditingController,
                      maxLines: 2,
                      decoration: InputDecoration(hintText: "Enter message"),
                      onChanged: (value) {
                        _message = value;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: IconButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("posts")
                          .doc(post.id)
                          .collection('comments')
                          .add({
                            "userId": FirebaseAuth.instance.currentUser!.uid,
                            "userName":
                                FirebaseAuth.instance.currentUser!.displayName,
                            "message": _message,
                            "timestamp": Timestamp.now(),
                          })
                          .then((value) => print("Chat doc added"))
                          .catchError(
                            (onError) => print(
                              "Error has occurred while adding chat doc",
                            ),
                          );

                      _textEditingController.clear();
                      setState(() {
                        _message = "";
                      });
                    },
                    icon: Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
