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
          username: username,
          email: email,
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
}
