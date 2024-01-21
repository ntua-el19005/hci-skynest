import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skynest/core/global_utils.dart' as globals;
import 'package:skynest/pages/customize_post_page.dart';
import 'package:skynest/themes/theme_helper.dart';
import 'package:skynest/components/skynest_post.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skynest/pages/home_page_overlay.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<List<dynamic>>> _fetchCsvData() async {
    // get posts
    List<List<dynamic>> posts = await globals.getIncomingPosts();

    // get usenames
    List<List<dynamic>> credentials =
        await globals.readCsvFromFile("lib/db/credentials.csv");

    // replace user ids with usernames
    for (int i = 0; i < posts.length; i++) {
      List<dynamic> rowData = posts[i];

      // get username
      for (var cred in credentials) {
        if (cred[0] == rowData[1]) {
          rowData[1] = cred[1];
          break;
        }
      }
    }

    return posts;
  }

  void showOverlay() {
    OverlayEntry? overlayEntry = OverlayWidget.createOverlay(context);
    if (overlayEntry != null) {
      Overlay.of(context).insert(overlayEntry);
    }
  }

  //Need to wait between 10 and 30 seconds after a setState for it to trigger.
  //Refreshing post list also triggers a new cooldown for the button

  //This function now actually compares incoming_posts.csv and the post_ids of posts.csv
  //Whatever post_id is in posts.csv but not in incoming_posts.csv,will be put in a list to fetch
  //for the user,and the popup process will begin.

  //If the user dismisses the popup,nothing happens
  //If the user clicks the popup,a random entry from the list of posts to fetch will be selected.
  //We fetch the post_id and add it in incoming_posts.csv.Then,we refresh with setState and the
  //new post will be added

  void showbluetoothevent(BuildContext context) async {
    final random = Random();
    final delaySeconds =
        random.nextInt(20) + 10; //Random delay between 10 and 30 seconds

    //Fetch incoming_posts and posts data
    List<List<dynamic>> incoming =
        await globals.readCsvFromFile("lib/db/incoming_posts.csv");
    List<List<dynamic>> posts =
        await globals.readCsvFromFile("lib/db/posts.csv");

    //remove header and keep it
    List<List<dynamic>> headerIncoming = incoming.sublist(0, 1);
    incoming = incoming.sublist(1, incoming.length);
    posts = posts.sublist(1, posts.length);

    //readCsvFromFile return a list of lists.I iterate this and only keep the first column
    //which are the post ids of the user and of the database accordingly
    List<dynamic> fetchnew = incoming.map((list) => list[0]).toList();
    List<dynamic> postidonly = posts.map((list) => list[0]).toList();

    //calculate which posts are in the database but not shown to the user.

    //Where condition:
    //for every element in postidonly,keep only those which also exist in fetchnew
    //Add these elements with the toList() function in the new sparepoststoshow list.We will use
    //this list to pick a random new post to show

    List<dynamic> sparepoststoshow =
        postidonly.where((element) => !(fetchnew.contains(element))).toList();

    /*
    print(postidonly);
    print(fetchnew);
    print(sparepoststoshow);
    print(sparepoststoshow.length);
    */

    //If there are posts we can show the user
    if (sparepoststoshow.isNotEmpty) {
      //newpostid needs to be dynamic in order to allow it to be 0.
      //Picks a random entry of the spareposts list,which will be then added to
      //incoming_posts.csv later on.
      dynamic newpostid =
          sparepoststoshow[random.nextInt(sparepoststoshow.length)];

      //print(newpostid);

      //Begin popup proccess,actually build the popup which is a textbutton in
      //an alertDialog widget.
      Future.delayed(Duration(seconds: delaySeconds), () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                contentPadding: const EdgeInsets.all(10),
                alignment: Alignment.topCenter,
                backgroundColor: const Color(0xFF27A59D),
                content: Flex(direction: Axis.horizontal, children: [
                  Expanded(
                    //alignment: Alignment.centerLeft,

                    //If the user presses the popup,do the commands of onPressed
                    child: TextButton(
                        onPressed: () async {
                          //form the data of incoming_posts.csv

                          //Prepend the new post id to incoming_posts.csv as a list
                          //in order for the new post to show up first
                          headerIncoming.add([newpostid]);
                          //print(header_incoming);

                          //Add previous incoming_posts.csv data

                          //Because incoming is a list of lists,in order to append it to the header
                          //which is also a list of lists i need to iterate the incoming variable
                          //using addAll

                          incoming = await globals.readCsvFromFile("lib/db/incoming_posts.csv");

                          headerIncoming.addAll(incoming.sublist(1,incoming.length));
                          //print(header_incoming);
                          globals.writeCsvToFile(
                              "lib/db/incoming_posts.csv", headerIncoming);

                          //reload home page and dismiss the dialog
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "New posts are available,refresh to see them!",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                ]),
              );
            });
      });
    }
  }

// Display a popup with two options: 'take picture' and 'choose from gallery'
  void showPostOptionsPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appTheme.teal200,
          content: Column(
            mainAxisSize: MainAxisSize.min, // Vertically align the actions
            children: <Widget>[
              TextButton(
                onPressed: () {
                  imagePickerWrapper(true, ImageSource.camera);
                },
                child: const Text(
                  'Take Picture',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const Divider(color: Colors.black),
              TextButton(
                onPressed: () {
                  imagePickerWrapper(true, ImageSource.gallery);
                },
                child: const Text(
                  'Choose from Gallery',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          //actions: [], // Remove the default actions for more control
          elevation: 5, // Add elevation for a card-like appearance
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
      },
    );
  }

  Future<void> imagePickerWrapper(
      bool allowPop, ImageSource imageSource) async {
    if (allowPop) {
      Navigator.pop(context); // Close the dialog
    }

    final navigator = Navigator.of(context);
    XFile? image = await pickImage(imageSource); // Navigate to TakePhotoPage

    // Navigate to CustomizePostPage
    if (image != null) {
      //print('*****************');
      //print('image is not null');
      //print('*****************');
      //print('');
      navigator.push(
        MaterialPageRoute(
          builder: (context) => CustomizePostPage(image: image),
        ),
      );
    }
  }

  Future<XFile?> pickImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return null;

      final imageTemporary = XFile(image.path);
      setState(() {});
      return imageTemporary;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
      return null;
    }
  }

  bool preventmultiplepopups = true;

  @override
  Widget build(BuildContext context) {
    //Changed logic.Now popup only shows up once because we experience bugs in create a post screen.
    if (preventmultiplepopups) {
      showbluetoothevent(context);
      preventmultiplepopups = false;
    }

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            if ((details.primaryDelta! > 2 &&
                details.globalPosition.dx <
                    (globals.getcorrectwidth(150, context)))) {
              imagePickerWrapper(false, ImageSource.camera);
            }

            //if the drag is right to left and starting from a right-most section of the screen

            //primaryDelta is a way to check the difference between positions,which
            //refers to the speed of the swipe.For a negative speed,which has negative delta,i can increase
            //or decrease the needed swipe speed by decreasing or increasing the swipe delta accordingly.

            //for delta < -6,it is fairly easy to swipe

            else if ((details.primaryDelta! < -2 &&
                details.globalPosition.dx >
                    (globals.getcorrectwidth(250, context)))) {
              //print('******************');
              //print('Detected swipe left');
              //print('Overlay appears!');
              //print('******************');
              // Show the overlay from the separate file
              OverlayEntry? overlayEntry = OverlayWidget.createOverlay(context);
              if (overlayEntry != null) {
                Overlay.of(context).insert(overlayEntry);
              }
            }
            //print("Detected new");
          },
          child: Scaffold(
            backgroundColor: appTheme.teal800,
            appBar: AppBar(
                backgroundColor: appTheme.blue200,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(15),
                  ),
                ),
                title: const Text('SkyNest'),
                actions: [
                  IconButton(
                    icon: SvgPicture.asset('assets/images/img_profile_pic.svg'),
                    onPressed: showOverlay,
                  ),
                ]),
            body: FutureBuilder<List<List<dynamic>>>(
              future: _fetchCsvData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Center(child: Text('Error loading data'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                } else {
                  // Use snapshot.data to access the fetched CSV data
                  List<List<dynamic>> csvList = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    // add 1 for the filler item at the end!
                    itemCount: csvList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == csvList.length) {
                        return Container(
                          height: globals.getcorrectheight(100, context),
                        );
                      }

                      List<dynamic> rowData = csvList[index];
                      return Padding(
                        padding: EdgeInsets.only(
                            top: globals.getcorrectheight(10, context)),
                        child: PostWidget(
                          post: Post(
                            postID: rowData[0] as int,
                            username: rowData[1].toString(),
                            timeRemaining: rowData[2].toString(),
                            postImage: rowData[3].toString(),
                            title: rowData[4].toString(),
                            description: rowData[5].toString(),
                            likes: rowData[6] as int,
                            dislikes: rowData[7] as int,
                            awards: rowData[8] as int,
                            comments: rowData[9] as int,
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: showPostOptionsPopup,
              backgroundColor: appTheme.blue200, // Display post options popup
              child: const Icon(Icons.add), // Customize button color
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          ),
        ),
      ),
    );
  }
}
