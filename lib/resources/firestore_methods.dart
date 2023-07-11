// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:twitch_clone/models/livestream.dart';
import 'package:twitch_clone/provider/user_provider.dart';
import 'package:twitch_clone/resources/storage_methods.dart';
import 'package:twitch_clone/utils/utils.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final StorageMethods _storageMethods = StorageMethods();

  Future<String> startLiveStream({
    required BuildContext context,
    required String title,
    required Uint8List? image,
  }) async {
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    String channelId = '';
    try {
      if (title.trim().isNotEmpty && image != null) {
        ///check user already live or not.
        ///user can't multiple live at a time
        if (!((await _firestore
                .collection('livestream')
                .doc("${user.user.uid}${user.user.username}")
                .get())
            .exists)) {
          String thumbnailUrl = await _storageMethods.uploadImageToStorage(
            childName: "livestream-thumbnails",
            file: image,
            uid: user.user.uid,
          );
          channelId = "${user.user.uid}${user.user.username}";
          LiveStream liveStream = LiveStream(
            title: title,
            image: thumbnailUrl,
            uid: user.user.uid,
            username: user.user.username,
            viewers: 0,
            channelId: channelId,
            startedAt: DateTime.now(),
          );
          _firestore
              .collection('livestream')
              .doc(channelId)
              .set(liveStream.toMap());
        } else {
          showSnackBar(
            context: context,
            content: "Two livestream can't start at the same time",
          );
        }
      } else {
        showSnackBar(context: context, content: "Please enter all the fields");
      }
    } on FirebaseException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
    return channelId;
  }

  Future<void> endLiveStream({required String channelId}) async {
    try {
      QuerySnapshot snap = await _firestore
          .collection('livestream')
          .doc(channelId)
          .collection('comments')
          .get();

      for (int i = 0; i < snap.docs.length; i++) {
        await _firestore
            .collection('livestream')
            .doc(channelId)
            .collection('comments')
            .doc(
              ((snap.docs[i].data()! as dynamic)['commentId']),
            )
            .delete();
      }
      await _firestore.collection('livestream').doc(channelId).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateViewCount(
      {required String id, required bool isIncrease}) async {
    try {
      ///if user go from feed screen then increase viewers count value
      ///if user leave from the live then decrease viewers count value
      await _firestore.collection("livestream").doc(id).update({
        'viewers': FieldValue.increment(isIncrease ? 1 : -1),
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> chat(
      {required String text,
      required String id,
      required BuildContext context}) async {
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    try {
      String commentId = const Uuid().v1();
      await _firestore
          .collection('livestream')
          .doc(id)
          .collection('comments')
          .doc(commentId)
          .set({
        'username': user.user.username,
        'message': text,
        'uid': user.user.uid,
        'createdAt': DateTime.now(),
        'commentId': commentId,
      });
    } on FirebaseException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }
}
