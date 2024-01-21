import 'package:flutter/material.dart';
import 'package:skynest/themes/theme_helper.dart';
import 'package:skynest/core/global_utils.dart' as globals;

class SuccessfulPostPage extends StatelessWidget {
  const SuccessfulPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          width: globals.getcorrectwidth(360, context),
          height: globals.getcorrectheight(800, context),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: const Alignment(0.5, 0),
              end: const Alignment(0.5, 1),
              colors: [
                appTheme.cyan100,
                appTheme.teal40001,
              ],
            ),
          ),
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 3),
                SizedBox(
                  width: 319,
                  child: Text(
                    "You just made a Nest!\n\nSomeone might fly in!",
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displaySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
