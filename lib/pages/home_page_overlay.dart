import 'package:flutter/material.dart';
import 'package:skynest/core/global_utils.dart' as globals;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skynest/pages/settings_page.dart';
import 'package:skynest/pages/my_posts.dart';


class OverlayWidget {
  static OverlayEntry? overlayEntry;
  //The caller funciton to display this overlay calls multiple times
  //I need to only display this overlay once,so i use a boolean to do that
  static bool isOverlayVisible = false;

  static OverlayEntry? createOverlay(BuildContext context) {
    if (!isOverlayVisible) {
      isOverlayVisible = true;
      overlayEntry = OverlayEntry(
        builder: (context) => Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              // Handle overlay tap
              //print(MediaQuery.of(context).size);
              //overlayEntry!.remove();
              //overlayEntry=null;
              //isOverlayVisible = false;
              //print(globals.getcorrectwidth(250, context));
              //print(globals.getcorrectheight(800, context));
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: SafeArea(
                //Dismissible is a useful widget that helps handle the event of canceling screens
                //It has the ability to "move" the overlay on its own,without more complex programming

                child: Dismissible(
                  key: const Key('uniquest_key'),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    //Handle Swipe dismissal

                    //print('******************');
                    //print('Swipe Dismissed');
                    //print('******************');

                    overlayEntry!.remove();
                    overlayEntry = null;
                    isOverlayVisible = false;
                  },

                  //In order for the ripple effect of inkwells to happen,there needs to be an Ink widget
                  //At a higher point in the class hierarchy.This Ink widget needs to contain the background
                  //color so the animation knows to play over it

                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            left: BorderSide(
                      color: Color(0xFF156560),
                    ))),
                    child: Ink(
                      color: const Color.fromARGB(255, 39, 165, 157),
                      child: Container(
                        width: globals.getcorrectwidth(250, context),
                        height: globals.getcorrectheight(800, context),
                        color: Colors.transparent,
                        child: Column(children: [
                          //profile button

                          InkWell(
                            onTap: () {
                              overlayEntry!.remove();
                              overlayEntry = null;
                              isOverlayVisible = false;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SettingsPage()
                                )
                              );
                            },
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      left: globals.getcorrectwidth(10, context)),
                                  height: globals.getcorrectheight(60, context),
                                  alignment: Alignment.centerLeft,
                                  child: Image.asset(
                                    'assets/images/Circle-icons-profile.svg.png', // Replace with the actual path to your image
                                    width: globals.getcorrectwidth(40,
                                        context), // Adjust the width as needed
                                    height: globals.getcorrectheight(40,
                                        context), // Adjust the height as needed
                                    fit: BoxFit
                                        .cover, // Adjust the fit as needed
                                  ),
                                ),
                                Container(
                                    height: globals.getcorrectheight(60, context),
                                    padding: EdgeInsets.only(
                                        left: globals.getcorrectwidth(10, context)),
                                    alignment: Alignment.center,
                                    child: Text(globals.credentials.email,
                                        style: TextStyle(fontSize: 24.0)))
                              ],
                            ),
                          ),
                          //this is the column of buttons under profile
                          Column(
                            children: [
                              //This is the display of "Avian Merit"
                              Row(children: [
                                Container(
                                  padding: EdgeInsets.only(
                                  left: globals.getcorrectwidth(16, context)),
                                  height: globals.getcorrectheight(48, context),
                                  alignment: Alignment.centerLeft,
                                  child: SvgPicture.asset(
                                    'assets/images/avian_merit_icon.svg', // Replace with the actual path to your image
                                    width: globals.getcorrectwidth(24,
                                        context), // Adjust the width as needed
                                    height: globals.getcorrectheight(24,
                                        context), // Adjust the height as needed
                                    fit: BoxFit
                                        .contain, // Adjust the fit as needed
                                  ),
                                ),
                                Column(
                                  children: [
                                    Container(
                                        width: globals.getcorrectwidth(160, context),
                                        padding: EdgeInsets.only(
                                            left: globals.getcorrectwidth(8, context)),
                                        alignment: Alignment.centerLeft,
                                        child: const Text("Avian Merit",
                                            style: TextStyle(fontSize: 14.0))),
                                    Container(
                                        width: globals.getcorrectwidth(160, context),
                                        padding: EdgeInsets.only(
                                            left: globals.getcorrectwidth(8, context)),
                                        alignment: Alignment.centerLeft,
                                        child: //const Text("1092",
                                            //style: TextStyle(fontSize: 14.0)
                                            FutureBuilder<int>(
                                          future: getAvianMerit(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<int> snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                  snapshot.data.toString(),
                                                  style: const TextStyle(
                                                      fontSize: 14.0));
                                            } else {
                                              return const Text('Loading...');
                                            }
                                          },
                                        )),
                                  ],
                                )
                              ]),
                              //This is the My Posts button
                              InkWell(
                                onTap: () {
                                  overlayEntry!.remove();
                                  overlayEntry = null;
                                  isOverlayVisible = false;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyPostsPage()));
                                },
                                child: Row(children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: globals.getcorrectwidth(16, context)),
                                    height: globals.getcorrectheight(30, context),
                                    alignment: Alignment.centerLeft,
                                    child: SvgPicture.asset(
                                      'assets/images/my_posts_icon.svg', // Replace with the actual path to your image
                                      width: globals.getcorrectwidth(24,
                                          context), // Adjust the width as needed
                                      height: globals.getcorrectheight(24,
                                          context), // Adjust the height as needed
                                      fit: BoxFit
                                          .contain, // Adjust the fit as needed
                                    ),
                                  ),
                                  Container(
                                      width: globals.getcorrectwidth(160, context),
                                      padding: EdgeInsets.only(
                                          left: globals.getcorrectwidth(8, context)),
                                      alignment: Alignment.centerLeft,
                                      child: const Text("My Posts",
                                          style: TextStyle(fontSize: 14.0))),
                                ]),
                              ),
                              //empty space
                              Container(
                                //original empty space is 568.I reduce it by 1/4 of the following button's size
                                //so as to mimic Figma layout correctly
                                height: globals.getcorrectheight(552, context),
                              ),
                              //little colored bar separating sections of buttons
                              Container(
                                height: 2,
                                color: const Color(0xFF156560),
                              ),
                              InkWell(
                                onTap: () {
                                  overlayEntry!.remove();
                                  overlayEntry = null;
                                  isOverlayVisible = false;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SettingsPage()));
                                },
                                child: Row(children: [
                                  Container(
                                    height: globals.getcorrectheight(60, context),
                                    padding: EdgeInsets.only(
                                        left: globals.getcorrectwidth(16, context)),
                                    alignment: Alignment.centerLeft,
                                    child: SvgPicture.asset(
                                      'assets/images/settings_icon.svg', // Replace with the actual path to your image
                                      width: globals.getcorrectwidth(40,
                                          context), // Adjust the width as needed
                                      height: globals.getcorrectheight(40,
                                          context), // Adjust the height as needed
                                      fit: BoxFit
                                          .contain, // Adjust the fit as needed
                                    ),
                                  ),
                                  Container(
                                      width: globals.getcorrectwidth(160, context),
                                      //icon has enough empty space on its own,this is unneccessary
                                      //padding: EdgeInsets.only(left: getcorrectwidth(0, context)),
                                      alignment: Alignment.centerLeft,
                                      child: const Text("Settings",
                                          style: TextStyle(fontSize: 14.0))),
                                ]),
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      return overlayEntry!;
    } else {
      return null;
    }
  }

  static Future<int> getAvianMerit() async {
    return await globals.getAvianMerit(globals.credentials.id);
  }
}
