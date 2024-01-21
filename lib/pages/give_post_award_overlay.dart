import 'package:flutter/material.dart';
import 'package:skynest/core/global_utils.dart' as globals;
import 'package:skynest/core/global_utils.dart';
import 'package:skynest/themes/theme_helper.dart';

class AwardOverlayWidget {
  static Future<List<List<dynamic>>> _fetchCsvData() async {
    return globals.readCsvFromFile("lib/db/awards.csv");
  }

  static OverlayEntry? overlayEntry;
  static bool isOverlayVisible = false;
  static int postId = -1;

  static OverlayEntry? createOverlay(int postId, BuildContext context) {
    if (isOverlayVisible) return null;

    postId = postId;
    isOverlayVisible = true;
    overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Handle overlay tap
            //print(MediaQuery.of(context).size);
            //overlayEntry!.remove();
            //overlayEntry=null;
            //isOverlayVisible = false;
            //print(getcorrectwidth(250, context));
            //print(getcorrectheight(800, context));
          },
          child: Align(
            alignment: Alignment.centerRight,
            child: SafeArea(
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
                child: Container(
                  width: getcorrectwidth(250, context),
                  height: getcorrectheight(800, context),
                  color: const Color.fromARGB(255, 39, 165, 157),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            overlayEntry!.remove();
                            overlayEntry = null;
                            isOverlayVisible = false;
                          },
                        ),
                      ),
                      FutureBuilder(
                        future: _fetchCsvData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            List<List<dynamic>> awardsData =
                                snapshot.data as List<List<dynamic>>;
                            return Expanded(
                              child: ListView.builder(
                                itemCount: awardsData.length - 1,
                                itemBuilder: (context, index) {
                                  index = index + 1; // skip column names row
                                  var awardId = awardsData[index][0];
                                  var awardTitle = awardsData[index][1];
                                  var awardPrice = awardsData[index][2];
                                  var awardImagePath = awardsData[index][3];

                                  return InkWell(
                                    onTap: () async {
                                      int result = await _handleAwardTap(
                                          awardId, postId, awardPrice);

                                      if (result >= 0) {
                                        overlayEntry!.remove();
                                        overlayEntry = null;
                                        isOverlayVisible = false;
                                      } else {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Error: Award could not be given'),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: Card(
                                      color: appTheme.teal400,
                                      child: ListTile(
                                        title: Text('$awardTitle: $awardPrice'),
                                        leading: CircleAvatar(
                                          backgroundColor: appTheme.teal400,
                                          child: Image.asset('$awardImagePath'),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return overlayEntry;
  }

  static Future<int> _handleAwardTap(
      int awardId, int postId, int awardPrice) async {
    return await globals.addAward(
        postId, awardId, globals.credentials.id, awardPrice);
  }
}
