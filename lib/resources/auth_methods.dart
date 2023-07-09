import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods{
  final _userRef = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;

  signUpUser()async{

  }
}