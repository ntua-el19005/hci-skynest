import 'package:flutter/material.dart';
import 'package:skynest/core/global_utils.dart' as globals;
import 'package:skynest/themes/theme_helper.dart';

class ViewOwnPostAwardsPage extends StatelessWidget {
  final int postId;

  const ViewOwnPostAwardsPage({super.key, required this.postId});

  // generic function for fetching CSV data
  Future<List<List<dynamic>>> _fetchCsvData(String filePath) async {
    return globals.readCsvFromFile(filePath);
  }

  // given a post ID, fetch the award ids for that post
  Future<List<dynamic>> _fetchPostAwards(int id) async {
    List<List<dynamic>> csvData =
        await _fetchCsvData("lib/db/posts_awards.csv");
    csvData = csvData.sublist(1, csvData.length);
    List<dynamic> postAwards = [];
    for (var row in csvData) {
      if (row[0] == id) {
        postAwards.add(row[1]);
      }
    }
    return postAwards;
  }

  // given an award ID, fetch the award path
  Future<String> _fetchAwardPath(int id) async {
    List<List<dynamic>> csvData = await _fetchCsvData("lib/db/awards.csv");
    csvData = csvData.sublist(1, csvData.length);
    for (var row in csvData) {
      if (row[0] == id) {
        return row[3];
      }
    }
    return "";
  }

  Future<List<String>> _fetchPostAwardPaths(int id) async {
    List<dynamic> postAwards = await _fetchPostAwards(id);
    List<String> postAwardPaths = [];
    for (var awardId in postAwards) {
      String awardPath = await _fetchAwardPath(awardId);
      postAwardPaths.add(awardPath);
    }
    return postAwardPaths;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.teal800,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<String>>(
        future: _fetchPostAwardPaths(postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No awards received for this post'));
          } else {
            List<String> awardPaths = snapshot.data!;
            return ListView.builder(
              itemCount: awardPaths.length,
              itemBuilder: (context, index) {
                String awardPath = awardPaths[index];
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    globals.getcorrectwidth(50, context),
                    globals.getcorrectwidth(8, context),
                    globals.getcorrectwidth(50, context),
                    globals.getcorrectwidth(8, context),
                  ),
                  child: Container(
                    width: globals.getcorrectwidth(170, context),
                    height: globals.getcorrectheight(170, context),
                    decoration: BoxDecoration(
                      color: appTheme.teal400,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Container(
                        width: globals.getcorrectwidth(150, context),
                        height: globals.getcorrectheight(150, context),
                        decoration: BoxDecoration(
                          color: appTheme.teal400,
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            awardPath,
                            width: globals.getcorrectwidth(150, context),
                            height: globals.getcorrectheight(150, context),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
