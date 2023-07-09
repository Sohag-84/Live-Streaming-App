// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:twitch_clone/widgets/custom_button.dart';
import 'package:twitch_clone/widgets/custom_textfield.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = "/signup";
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.1),
              Text(
                "Email",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CustomTextField(controller: _emailController),
              SizedBox(height: 20),
              Text(
                "Username",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CustomTextField(controller: _usernameController),
              SizedBox(height: 20),
              Text(
                "Password",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CustomTextField(controller: _passwordController),
              SizedBox(height: 20),
              CustomButton(text: "Sign Up", onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
