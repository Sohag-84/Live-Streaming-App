// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitch_clone/provider/user_provider.dart';
import 'package:twitch_clone/resources/firestore_methods.dart';
import 'package:twitch_clone/widgets/custom_textfield.dart';
import 'package:twitch_clone/widgets/loading_indicator.dart';

class Chat extends StatefulWidget {
  final String channelId;
  const Chat({super.key, required this.channelId});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _chatController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _chatController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    double size = MediaQuery.sizeOf(context).height;
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: StreamBuilder<dynamic>(
              stream: FirebaseFirestore.instance
                  .collection("livestream")
                  .doc(widget.channelId)
                  .collection('comments')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingIndicator();
                }
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        snapshot.data.docs[index]['username'],
                        style: TextStyle(
                          color: snapshot.data.docs[index]['uid'] ==
                                  userProvider.user.uid
                              ? Colors.blue
                              : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        snapshot.data.docs[index]['message'],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          CustomTextField(
            controller: _chatController,
            onTap: (value) {
              FireStoreMethods().chat(
                text: _chatController.text,
                id: widget.channelId,
                context: context,
              );
              setState(() {
                _chatController.text = "";
              });
            },
          )
        ],
      ),
    );
  }
}
