import 'package:flutter/material.dart';
import 'package:skynest/themes/theme_helper.dart';

class SignInTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const SignInTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appTheme.teal800),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appTheme.teal800),
        ),
        fillColor: appTheme.teal200,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(
          color: appTheme.blueGray700,
        ),
      ),
    );
  }
}

class MakePostTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int minLines;

  const MakePostTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        minLines: minLines,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        textAlign: TextAlign.center,
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(15),
          ),
          fillColor: Colors.transparent,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[1000],
          ),
        ),
      ),
    );
  }
}
