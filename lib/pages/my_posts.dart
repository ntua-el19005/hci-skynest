import 'package:flutter/material.dart';
import 'package:skynest/core/global_utils.dart' as globals;
import 'package:skynest/themes/theme_helper.dart';
import 'package:skynest/components/skynest_post.dart';
import 'package:skynest/pages/home_page_overlay.dart';

class MyPostsPage extends StatefulWidget {
  const MyPostsPage({
    super.key,
  });

  @override
  State<MyPostsPage> createState() => _MyPostsPageState();
}

Future<List<List<dynamic>>> _fetchSavedPosts() async {
  // get posts
  List<List<dynamic>> posts =
      await globals.getSavedPosts(globals.credentials.id);

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

// given a user ID, fetch their posts
Future<List<List<dynamic>>> _fetchUserPosts(int id) async {
  List<List<dynamic>> csvData =
      await globals.readCsvFromFile("lib/db/posts.csv");
  csvData = csvData.sublist(1, csvData.length);
  List<List<dynamic>> userPosts = [];
  for (var row in csvData) {
    if (row[1] == id) {
      userPosts.add(row);
    }
  }
  return userPosts;
}

class _MyPostsPageState extends State<MyPostsPage> {
  late Widget _currentBody;
  late List<Color> activeindication = [
    const Color(0xFF1C5551),
    appTheme.blue200
  ];
  final Widget savedpagebody = const savedbody();
  final Widget historypagebody = const historybody();

  //initialize currentbody

  @override
  void initState() {
    super.initState();
    _currentBody = const savedbody(); // Initialize with Class1
  }

  void _switchBody(Widget newBody) {
    setState(() {
      _currentBody = newBody;
      List<Color> temp = activeindication;
      activeindication = [temp[1], temp[0]];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.teal800,
        appBar: AppBar(
            backgroundColor: appTheme.blue200,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(15),
              ),
            ),
            actions: [
              Container(
                width: globals.getcorrectwidth(156, context),
                //In order to indicate which body is active,i use the colors of bottom border of buttons
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 3, color: activeindication[0]))),
                child: TextButton(
                  onPressed: () {
                    _switchBody(savedpagebody);
                  },

                  //This code makes the ripple effect of the button rectangular,but it does not look better

                  /*
                    style: ButtonStyle(
                      shape:MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0))
                      ),
                    ),
                    */

                  child: const Text("Saved"),
                ),
              ),
              Container(
                width: globals.getcorrectwidth(156, context),
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 3, color: activeindication[1]))),
                child: TextButton(
                  onPressed: () {
                    _switchBody(historypagebody);
                  },
                  child: const Text("History"),
                ),
              ),
            ]),
        body: _currentBody,
      ),
    );
  }
}

class savedbody extends StatelessWidget {
  const savedbody({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<dynamic>>>(
      future: _fetchSavedPosts(),
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
            itemCount: csvList.length,
            itemBuilder: (context, index) {
              List<dynamic> rowData = csvList[index];
              return Padding(
                padding:
                    EdgeInsets.only(top: globals.getcorrectheight(10, context)),
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
    );
  }
}

class historybody extends StatelessWidget {
  const historybody({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<dynamic>>>(
      future: _fetchUserPosts(globals.credentials.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          // Use snapshot.data to access the fetched CSV data
          List<List<dynamic>> csvList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            itemCount: csvList.length,
            itemBuilder: (context, index) {
              List<dynamic> rowData = csvList[index];
              return Padding(
                padding:
                    EdgeInsets.only(top: globals.getcorrectheight(10, context)),
                child: HistoryPostWidget(
                  post: HistoryPost(
                    postID: rowData[0] as int,
                    username: globals.credentials.email,
                    postImage: rowData[3].toString(),
                    title: rowData[4].toString(),
                    description: rowData[5].toString(),
                    likes: rowData[6] as int,
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
