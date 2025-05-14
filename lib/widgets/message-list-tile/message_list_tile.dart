import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/entities/Chat/chat_entity.dart';

class MessageListTile extends StatelessWidget {
  MessageListTile(this.chatModel, {super.key});

  final ChatModel chatModel;
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight:
                chatModel.userId == currentUserId
                    ? Radius.zero
                    : Radius.circular(16),
            bottomLeft:
                chatModel.userId == currentUserId
                    ? Radius.circular(16)
                    : Radius.zero,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: chatModel.userId == currentUserId ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisAlignment: chatModel.userId == currentUserId ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                "By: ${chatModel.userName}",
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 4),
              Text(chatModel.message, style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}
