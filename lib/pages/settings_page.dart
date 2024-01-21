import 'package:flutter/material.dart';
import 'package:skynest/core/global_utils.dart';
import 'package:skynest/themes/theme_helper.dart';
import 'package:skynest/components/buttons.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

Future<void> updateUsernameOrPassword(
    bool checkifUsername, String newinfo) async {
  // open posts.csv
  List<List<dynamic>> userdb = await readCsvFromFile('lib/db/credentials.csv');
  //print(userdb);
  //print(newinfo);
  // update the like/dislike counter
  for (var user in userdb.sublist(1, userdb.length)) {
    if (user[1] == credentials.email) {
      // update the like/dislike counter
      if (checkifUsername) {
        user[1] = newinfo;
      } else {
        user[2] = newinfo;
      }
      break;
    }
  }
  await writeCsvToFile("lib/db/credentials.csv", userdb);
}

class _SettingsPageState extends State<SettingsPage> {
  void settingsPopup(int condition) {
    //I keep all the possible texts of the popup in a list
    //because the condition for the popup is an integer and i can
    //easily match the integer with the corresponding text and popup type

    String textinput = "";

    List<String> buttonText = [
      //the user's username is credentials.email

      "Current Username: ${credentials.email}\nType your new username:",
      "\nType your new password",
      "We are trying to make a social media app",
      "In using our app you void your personal data. You agreed to this already",
      "EULA Terms And Conditions: Lorem Ipsum..."
    ];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        //Check if the popup is either from Change Username and Change Password or the other 3

        //Display the popup type to change Username or Password
        if (condition < 3) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).previousFocus();
            },
            child: AlertDialog(
              backgroundColor: appTheme.teal200,
              content: SizedBox(
                height: getcorrectheight(350, context),
                width: getcorrectwidth(200, context),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(buttonText[condition - 1]),
                    ),
                    TextField(
                      onChanged: (text) {
                        textinput = text;
                      },
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                          hintText: "Type...",
                          border: const OutlineInputBorder(),
                          contentPadding: EdgeInsets.only(
                              bottom: getcorrectheight(195, context),
                              left: 6,
                              top: 6)),
                    ),
                    //I need the container itself to align to center right.Therefore,i use the aling widget
                    //to set the following child,that is a container,to the right
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.only(top:getcorrectheight(5, context)),
                        width: getcorrectwidth(60, context),
                        child: TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              if (textinput != "") {
                                //Case of Changing Username
                                if (condition == 1) {
                                  await updateUsernameOrPassword(true, textinput);
                                  credentials.setCredentials(
                                    credentials.id,
                                    textinput,
                                    credentials.password,
                                    notify: false,
                                  );
                                }
                                //Case of Changing Password
                                else {
                                  await updateUsernameOrPassword(false, textinput);
                                  credentials.setCredentials(
                                    credentials.id,
                                    credentials.email,
                                    textinput,
                                    notify: false,
                                  );
                                }
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFF27A59D)),
                              // You can customize other properties hrere as well
                            ),
                            child: Center(
                              child: Text("Done",
                                style: TextStyle(color: appTheme.blueGray800)
                              ),
                            )
                          ),
                      ),
                    ),
                  ],
                ),
              ),
              //actions: [], // Remove the default actions for more control
              elevation: 5, // Add elevation for a card-like appearance
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          );
        } else {
          return AlertDialog(
            backgroundColor: appTheme.teal200,
            content: SizedBox(
              height: getcorrectheight(300, context),
              width: getcorrectwidth(200, context),
              child: Column(
                children: <Widget>[
                  Text(buttonText[condition - 1]),
                ],
              ),
            ),
            //actions: [], // Remove the default actions for more control
            elevation: 5, // Add elevation for a card-like appearance
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          );
        }
      },
    );
  }

  // sign user out
  void signOut() {
    // maybe change the order in which these two things happen...

    credentials.clearCredentials(notify: true);
    // remove settings page from navigator
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.teal800,
        appBar: AppBar(
            toolbarHeight: getcorrectheight(50, context),
            backgroundColor: appTheme.teal800),
        body: Column(
          children: [
            Container(
              height: getcorrectheight(17, context),
              //decoration: BoxDecoration(border: Border.all(color: Colors.blue,width: 2.0)),
            ),
            //First button
            SettingsButton(
                text: 'Change Username',
                dothis: () {
                  settingsPopup(1);
                }),
            SettingsButton(
                text: 'Change Password',
                dothis: () {
                  settingsPopup(2);
                }),
            SettingsButton(
                text: 'About Us',
                dothis: () {
                  settingsPopup(3);
                }),
            SettingsButton(
                text: 'License Agreement',
                dothis: () {
                  settingsPopup(4);
                }),
            SettingsButton(
                text: 'EULA',
                dothis: () {
                  settingsPopup(5);
                }),
            SettingsButton(
                text: 'Sign Out',
                dothis: signOut),
            Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 6, color: Color(0xFF1C5551))))),
            Padding(
              padding: EdgeInsets.only(top: getcorrectheight(100, context)),
              child: Image.asset(
                'assets/images/img_bird_mechanic_2.png', // Replace with the actual path to your image
                width:
                    getcorrectwidth(353, context), // Adjust the width as needed
                height: getcorrectheight(
                    310, context), // Adjust the height as needed
                fit: BoxFit.cover, // Adjust the fit as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}
