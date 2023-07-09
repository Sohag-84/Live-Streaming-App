// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:twitch_clone/models/user.dart' as model;
import 'package:twitch_clone/provider/user_provider.dart';
import 'package:twitch_clone/utils/utils.dart';

class AuthMethods {
  final _userRef = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;

  ///get user
  Future<Map<String, dynamic>?> getCurrentUser({required String? uid}) async {
    if (uid != null) {
      final snap = await _userRef.doc(uid).get();
      return snap.data();
    }
    return null;
  }

  Future<bool> signUpUser({
    required BuildContext context,
    required String email,
    required String username,
    required String password,
  }) async {
    bool res = false;
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        model.User user = model.User(
          uid: credential.user!.uid,
          username: username.trim(),
          email: email.trim(),
        );
        _userRef.doc(credential.user!.uid).set(user.toMap());
        Provider.of<UserProvider>(context, listen: false).setUser(user: user);
        res = true;
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
    return res;
  }

  Future<bool> signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    bool res = false;
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        Provider.of<UserProvider>(context, listen: false).setUser(
          user: model.User.fromMap(
            await getCurrentUser(uid: credential.user!.uid) ?? {},
          ),
        );
        res = true;
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
    return res;
  }
}
