// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:twitch_clone/utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  const CustomTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: buttonColor,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: secondaryBackgroundColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
