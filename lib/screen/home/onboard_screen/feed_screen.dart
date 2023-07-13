// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitch_clone/models/livestream.dart';
import 'package:twitch_clone/resources/firestore_methods.dart';
import 'package:twitch_clone/screen/home/broadcast_screen.dart';
import 'package:twitch_clone/widgets/loading_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10).copyWith(top: 10),
          child: Column(
            children: [
              Text(
                "Live users",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height * 0.03),
              StreamBuilder<dynamic>(
                stream: FirebaseFirestore.instance
                    .collection("livestream")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingIndicator();
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        LiveStream post = LiveStream.fromMap(
                          snapshot.data.docs[index].data(),
                        );
                        return InkWell(
                          onTap: () async {
                            await FireStoreMethods().updateViewCount(
                              id: post.channelId,
                              isIncrease: true,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BroadcastScreen(
                                  isBroadcaster: true,
                                  channelId: post.channelId,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: height * 0.15,
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Image.network(post.image),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      post.username,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      post.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text("${post.viewers} Watching"),
                                    Text(
                                      "Started: ${timeago.format(post.startedAt.toDate())}",
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.more_vert),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
