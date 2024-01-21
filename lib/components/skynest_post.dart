import 'dart:io';

import 'package:flutter/material.dart';
import 'package:skynest/pages/give_post_award_overlay.dart';
import 'package:skynest/pages/view_own_post_awards_page.dart';
import 'package:skynest/themes/theme_helper.dart';
import 'package:skynest/core/global_utils.dart' as globals;

class Post {
  final int postID;
  final String username;
  final String timeRemaining;
  final String postImage;
  final String title;
  final String description;
  int likes;
  int dislikes;
  final int awards;
  final int comments;

  Post({
    required this.postID,
    required this.username,
    required this.timeRemaining,
    required this.postImage,
    required this.title,
    required this.description,
    required this.likes,
    required this.dislikes,
    required this.awards,
    required this.comments,
  });
}

class HistoryPost {
  final int postID;
  final String username;
  final String postImage;
  final String title;
  final String description;
  final int likes;

  HistoryPost({
    required this.postID,
    required this.username,
    required this.postImage,
    required this.title,
    required this.description,
    required this.likes,
  });
}

class PostWidget extends StatefulWidget {
  final Post post;

  const PostWidget({super.key, required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late IconData likeIcon;
  late IconData dislikeIcon;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
        future: globals.getIfLiked(globals.credentials.id, widget.post.postID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Future is still loading, return a placeholder or loading indicator
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Future has an error, handle it accordingly
            print(snapshot.error);
            return const Text('Error loading like/dislike data');
          } else {
            // Future is complete, set the initial icons based on the result
            int likeDislike = snapshot.data ?? 0;

            if (likeDislike == 0) {
              likeIcon = Icons.thumb_up_outlined;
              dislikeIcon = Icons.thumb_down_outlined;
            } else if (likeDislike == -1) {
              likeIcon = Icons.thumb_up_outlined;
              dislikeIcon = Icons.thumb_down;
            } else if (likeDislike == 1) {
              likeIcon = Icons.thumb_up;
              dislikeIcon = Icons.thumb_down_outlined;
            }
            return Container(
              decoration: BoxDecoration(
                color: appTheme.teal200,
                borderRadius: BorderRadius.circular(15.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.post.username,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('• ${widget.post.timeRemaining} left'),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  // some images may be locally stored in the assets folder
                  // we allow for both network and local images
                  Center(
                    child: widget.post.postImage.startsWith('http')
                        ? Image.network(
                            widget.post.postImage,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(widget.post.postImage),
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    widget.post.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(widget.post.description),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(likeIcon),
                            onPressed: () async =>
                                await toggleLikeDislike(true),
                          ),
                          Text('${widget.post.likes}'),
                          const SizedBox(width: 8.0),
                          IconButton(
                            icon: Icon(dislikeIcon),
                            onPressed: () async =>
                                await toggleLikeDislike(false),
                          ),
                          Text('${widget.post.dislikes}'),
                          const SizedBox(width: 8.0),
                          IconButton(
                            icon: const Icon(Icons.star),
                            onPressed: () {
                              handleAwardButtonPress(
                                  widget.post.postID, context);
                            },
                          ),
                          Text('${widget.post.awards}'),
                          const SizedBox(width: 8.0),
                          IconButton(
                            icon: const Icon(Icons.save),
                            onPressed: toggleSaved,
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.comment),
                        onPressed: () {
                          /* Handle comment button press */
                          handleCommentsButtonPress();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        });
  }

  void handleAwardButtonPress(int id, BuildContext context) {
    // show overlay
    // overlay should have a list of awards
    // each award should have a button
    // when the button is pressed, the award is given to the post

    OverlayEntry? overlayEntry = AwardOverlayWidget.createOverlay(id, context);
    if (overlayEntry != null) {
      Overlay.of(context).insert(overlayEntry);
    }
  }

  Future<void> handleCommentsButtonPress() async {
    //Get all comments from database
    List<List<dynamic>> comments =
        await globals.readCsvFromFile("lib/db/comments.csv");

    //Get all users from database,we will need to fetch their usernames
    List<List<dynamic>> userInfo =
        await globals.readCsvFromFile("lib/db/credentials.csv");

    //remove header
    List<List<dynamic>> header= comments.sublist(0,1);
    comments = comments.sublist(1, comments.length);

    //Textinput variable of making comments
    String textinput="";

    //need this to later clear the text on button press
    TextEditingController makecomment=TextEditingController();

    //keep only comments of this post
    List<dynamic> commentsofpost = [];
    for (var comment in comments) {
      if (widget.post.postID == comment[0]) {
        commentsofpost.add(comment);
      }
    }

    //Build Overlay for commoents with AlertDialog Widget

    // ignore: use_build_context_synchronously
    showDialog(
        context: context,
        builder: (BuildContext dialogcontext) {
          //Construct AlertDialog Widget.The Container Widget sets popup's size and we build
          //a scrollable list of comments.
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).previousFocus();
            },
            child: AlertDialog(
              alignment: Alignment.bottomCenter,
            
              //Popup touches bottom of screen
              insetPadding: EdgeInsets.zero,
              contentPadding: const EdgeInsets.only(top:20),
            
              backgroundColor: const Color(0xFF27A59D),
            
              //Define size of popup
              content: SizedBox(
                width: globals.getcorrectwidth(360, context),
                height: globals.getcorrectheight(475, context),
            
                //Create a scrollable list of the following "list elements"
                //In this scrollable list,iterate the commentsofpost data to display information
            
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:20,right:20),
                      child: SizedBox(
                        width: globals.getcorrectwidth(360, context),
                        height: globals.getcorrectheight(395, context),
                        child: ListView.builder(
                          itemCount: commentsofpost.length,
                          itemBuilder: (context, index) {
                            //Iterate commentsofpost.A single instance of iteration is the rowData list
                            List<dynamic> rowData = commentsofpost[index];
                            return Padding(
                              //Make sure this list element is padded by 5 pixels from the top of the popup
                              //and 5 pixels from the bottom for better visuals
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF9AE8F9),
                                  borderRadius: BorderRadius.circular(15.0)
                                ),
                                //define width and height of each comment element
                                width: globals.getcorrectwidth(360, context),
                                height: globals.getcorrectheight(100, context),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10, left: 15),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            //With firstWhere(...) we search user database to find which row contains info on the user
                                            //who has made the current comment we are about to display.After that,
                                            //display his username,which is the 2nd element of the row.
                                            userInfo.firstWhere((element) =>
                                                element[0] == rowData[1])[1],
                                            style: const TextStyle(fontSize: 18.0),
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          rowData[2],
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    //Padding
                    Container(height: globals.getcorrectheight(10, context)),
                    //Type your own comment area
                    Container(
                      height: globals.getcorrectheight(70, context),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9AE8F9),
                        borderRadius: BorderRadius.circular(15.0)
                      ),
                      width: globals.getcorrectwidth(360, context),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left:globals.getcorrectwidth(15, context)),
                            width: globals.getcorrectwidth(315, context),
                            alignment: Alignment.center,
                              child: TextField(
                                controller: makecomment,
                                onChanged: (text) {
                                  textinput = text;
                                },
                                textAlignVertical: TextAlignVertical.top,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type...",
                                  //border: const OutlineInputBorder(),
                                  contentPadding: EdgeInsets.only(
                                    bottom: globals.getcorrectheight(30, context),
                                    left: 6,
                                    top: 6
                                  )
                                ),
                              ),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (makecomment.text.isNotEmpty) {
                                //I use a temporary variable to properly prepend it to the comments list of lists
                                List<List<dynamic>> temp =[[widget.post.postID,globals.credentials.id,makecomment.text]];
                                //Add all data of comments under the first row
                                temp.addAll(comments);
                                //Add header before all current
                                header.addAll(temp);
                                //Clear text field by using its text controller
                                makecomment.clear();
                                //properly change csv file
                                await globals.writeCsvToFile("lib/db/comments.csv",header);
                                //Close and reopen alertDialog,initiating its "update"
                                Navigator.of(context).pop();
                                handleCommentsButtonPress();
                                //print(header);
                              }
                            },
                            icon: const Icon(Icons.comment)
                          )
                        ],
                      ),
                    )
                  ]
                ),
              ),
            ),
          );
        });
  }

  Future<void> toggleLikeDislike(bool likePressed) async {
    if (likeIcon == Icons.thumb_up_outlined &&
        dislikeIcon == Icons.thumb_down_outlined) {
      if (likePressed) {
        // pressed like button
        await globals.updateLikeDislike(
            globals.credentials.id, widget.post.postID, 1, 0);
        setState(() => widget.post.likes++);
      } else {
        // pressed dislike button
        await globals.updateLikeDislike(
            globals.credentials.id, widget.post.postID, 0, 1);
        setState(() => widget.post.dislikes++);
      }
    } else if (likeIcon == Icons.thumb_up_outlined &&
        dislikeIcon == Icons.thumb_down) {
      if (likePressed) {
        // pressed like button
        await globals.updateLikeDislike(
            globals.credentials.id, widget.post.postID, 1, -1);
        setState(() {
          widget.post.likes++;
          widget.post.dislikes--;
        });
      } else {
        // pressed dislike button
        await globals.updateLikeDislike(
            globals.credentials.id, widget.post.postID, 0, -1);
        setState(() {
          widget.post.dislikes--;
        });
      }
    } else if (likeIcon == Icons.thumb_up &&
        dislikeIcon == Icons.thumb_down_outlined) {
      if (likePressed) {
        // pressed like button
        await globals.updateLikeDislike(
            globals.credentials.id, widget.post.postID, -1, 0);
        setState(() {
          widget.post.likes--;
        });
      } else {
        // pressed dislike button
        await globals.updateLikeDislike(
            globals.credentials.id, widget.post.postID, -1, 1);
        setState(() {
          widget.post.likes--;
          widget.post.dislikes++;
        });
      }
    }
  }

  Future<void> toggleSaved() async {
    // if the post is already saved, unsave it
    // if the post is not saved, save it
    bool isSaved =
        await globals.getIfSaved(globals.credentials.id, widget.post.postID);

    if (isSaved) {
      await globals.updateSaved(
          globals.credentials.id, widget.post.postID, false);
    } else {
      await globals.updateSaved(
          globals.credentials.id, widget.post.postID, true);
    }
  }
}

class HistoryPostWidget extends StatelessWidget {
  final HistoryPost post;

  const HistoryPostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.teal200,
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                post.username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              //Text('• ${post.timeRemaining} left'),
            ],
          ),
          const SizedBox(height: 8.0),
          // some images may be locally stored in the assets folder
          // we allow for both network and local images
          Center(
            child: post.postImage.startsWith('http')
                ? Image.network(
                    post.postImage,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(post.postImage),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(height: 8.0),
          Text(
            post.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Text(post.description),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.thumb_up),
                    onPressed: () {/* Handle like button press */},
                  ),
                  Text('${post.likes}'),
                  const SizedBox(width: 8.0),
                  IconButton(
                    icon: const Icon(Icons.star),
                    onPressed: () {
                      handleAwardButtonPress(post.postID, context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void handleAwardButtonPress(int id, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewOwnPostAwardsPage(postId: id),
      ),
    );
  }
}
