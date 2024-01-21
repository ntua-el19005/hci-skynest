import 'package:flutter/material.dart';
import 'package:skynest/themes/theme_helper.dart';
import 'package:skynest/core/global_utils.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  const MyButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: appTheme.teal700,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: appTheme.teal200,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  final String text;
  final VoidCallback dothis;

  const SettingsButton({super.key, required this.text, required this.dothis});

  @override
  Widget build(BuildContext context) {
    return Ink(
        width: double.infinity,
        height: getcorrectheight(44, context),
        //padding: EdgeInsets.only(left: getcorrectwidth(17, context)),
        //alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
            border:
                Border(top: BorderSide(width: 6, color: Color(0xFF1C5551)))),
        child: InkWell(
            onTap: () {
              dothis();
            },
            child: Container(
                padding: EdgeInsets.only(left: getcorrectwidth(17, context)),
                alignment: Alignment.centerLeft,
                child: Text(text, style: const TextStyle(fontSize: 18.0)))));
  }
}