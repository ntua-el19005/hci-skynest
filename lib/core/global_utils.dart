library globals;

import 'package:skynest/components/credentials.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

// get the path to the documents directory in the android device
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

// get the path to a specific file in the android device
Future<File> getSafeFile(String filePath) async {
  final path = await _localPath;
  return File('$path/$filePath');
}

// read the contents of a csv file and return a list of lists
// the first list is the list of column names
// the rest of the lists are the rows of the csv file
Future<List<List<dynamic>>> readCsvFromFile(String filePath) async {
  File file = await getSafeFile(filePath);
  String fileContent = await file.readAsString();
  return const CsvToListConverter().convert(fileContent);
}

// turn a List of Lists into a string
Future<String> listToCsvConversion(
    String filePath, List<List<dynamic>> rows) async {
  String csv = const ListToCsvConverter().convert(rows);
  return csv;
}

// write a csv to a file
Future<File> writeCsvToFile(String filePath, List<List<dynamic>> rows) async {
  String csv = await listToCsvConversion(filePath, rows);
  File file = await getSafeFile(filePath);
  return file.writeAsString(csv);
}

// write a string to a file
Future<File> writeStringToFile(String filePath, String csv) async {
  File file = await getSafeFile(filePath);
  return file.writeAsString(csv);
}

// helper function to get the last id from a csv file
Future<int?> _getLastIdFromCsv(String filePath) async {
  List<List<dynamic>> csvData = await readCsvFromFile(filePath);
  if (csvData.isNotEmpty) {
    List<dynamic> lastRow = csvData.last;
    if (lastRow.isNotEmpty) {
      return lastRow[0];
    }
  }
  return null;
}

Future<int?> getLastPostId() {
  return _getLastIdFromCsv('lib/db/posts.csv');
}

Future<int?> getLastUserId() async {
  return _getLastIdFromCsv('lib/db/credentials.csv');
}

// add a new user to the credentials.csv file (automatically finds the last id
// which is assigned to this user!)
Future<void> addCredentials(String username, String password) async {
  int? id = await getLastUserId();
  if (id == null) {
    id = 0;
  } else {
    id++;
  }

  File file = await getSafeFile('lib/db/credentials.csv');

  List<List<dynamic>> csvData = await readCsvFromFile('lib/db/credentials.csv');
  //print('read from csv: $csvData');
  csvData.add([id, username, password, 100000]);
  await writeCsvToFile('lib/db/credentials.csv', csvData);
}

// append new post to posts.csv
Future<void> addPost(
  int userId,
  String timeRemaining,
  String postImage,
  String title,
  String description,
  int likes,
  int dislikes,
  int awards,
  int comments,
) async {
  // get the new post id
  int? postId = await getLastPostId();
  if (postId == null) {
    postId = 0;
  } else {
    postId++;
  }

  // Prepare the new post data
  List<dynamic> newPost = [
    postId,
    userId,
    timeRemaining,
    postImage,
    title,
    description,
    likes,
    dislikes,
    awards,
    comments,
  ];

  // Read existing posts data
  List<List<dynamic>> postsData = await readCsvFromFile('lib/db/posts.csv');

  /*
  print('***********************');
  print('read from posts.csv');
  print(postsData);
  print('***********************');
  */

  // Add the new post to the list
  postsData.add(newPost);

  // Write the updated CSV string to the file
  await writeCsvToFile('lib/db/posts.csv', postsData);

  // add post_id to incoming_posts.csv
  List<List<dynamic>> incomingPostsData =
      await readCsvFromFile('lib/db/incoming_posts.csv');

  List<List<dynamic>> header = incomingPostsData.sublist(0, 1);
  incomingPostsData = incomingPostsData.sublist(1, incomingPostsData.length);

  // Add the new post to the list
  header.add([postId]);
  header.addAll(incomingPostsData);

  // Write the updated CSV string to the file
  await writeCsvToFile('lib/db/incoming_posts.csv', header);
}

Future<List<List<dynamic>>> getIncomingPosts() async {
  List<List<dynamic>> posts = await readCsvFromFile("lib/db/posts.csv");
  List<List<dynamic>> postIdInputs =
      await readCsvFromFile("lib/db/incoming_posts.csv");

  List<dynamic> postIds = [];
  for (var postIdInput in postIdInputs.sublist(1, postIdInputs.length)) {
    postIds.add(postIdInput[0]);
  }

  List<List<dynamic>> incomingPosts = [];
  for (var postId in postIds) {
    for (var post in posts.sublist(1, posts.length)) {
      if (post[0] == postId) {
        incomingPosts.add(post);
        break;
      }
    }
  }

  return incomingPosts;
}

Future<int> getPostUserId(postId) async {
  List<List<dynamic>> posts = await readCsvFromFile("lib/db/posts.csv");

  for (var post in posts.sublist(1, posts.length)) {
    if (post[0] == postId) {
      return post[1];
    }
  }
  return -1;
}

Future<int> addAward(
    int postId, int awardId, int userId, int awardPrice) async {
  int avianMerit = await getAvianMerit(userId);

  if (avianMerit < awardPrice) {
    return -1;
  }

  // decrease avian merit of user
  await updateAvianMerit(userId, -awardPrice);

  // get the post user id
  int postUserId = await getPostUserId(postId);

  // increase avian merit of post user if they are not the current user
  if (postUserId != userId) {
    await updateAvianMerit(postUserId, awardPrice ~/ 2);
  }

  // Prepare the new award data
  List<dynamic> newAward = [
    postId,
    awardId,
  ];

  // Read existing awards data
  List<List<dynamic>> awardsData =
      await readCsvFromFile('lib/db/posts_awards.csv');

  // Add the new award to the list
  awardsData.insert(1, newAward);

  // Write the updated CSV string to the file
  await writeCsvToFile('lib/db/posts_awards.csv', awardsData);

  // increase award counter of the post
  List<List<dynamic>> postsData = await readCsvFromFile('lib/db/posts.csv');

  // find the post with the given id
  for (var post in postsData.sublist(1, postsData.length)) {
    if (post[0] == postId) {
      // increase the award counter
      post[8] = post[8] + 1;
      break;
    }
  }

  // Write the updated CSV string to the file
  await writeCsvToFile('lib/db/posts.csv', postsData);

  return 0;
}

// there are 6 possible combinations of likeCnt/dislikeCnt
// 1. likeCnt = 1, dislikeCnt = 0   (liked)
// 2. likeCnt = 0, dislikeCnt = 1   (disliked)
// 3. likeCnt = 1, dislikeCnt = -1  (disliked -> liked)
// 4. likeCnt = 0, dislikeCnt = -1  (removed dislike)
// 5. likeCnt = -1, dislikeCnt = 0  (removed like)
// 6. likeCnt = -1, dislikeCnt = 1  (liked -> disliked)
//
// So, in combinations 1, 3 we set newPostLike = 1
// In combinations 2, 6 we set newPostLike = -1
// In combinations 4, 5 we set newPostLike = 0
Future<void> updateLikeDislike(
    int userId, int postId, int likeCnt, int dislikeCnt) async {
  // open posts.csv
  List<List<dynamic>> posts = await readCsvFromFile('lib/db/posts.csv');

  // update the like/dislike counter
  for (var post in posts.sublist(1, posts.length)) {
    if (post[0] == postId) {
      // update the like/dislike counter
      post[6] += likeCnt;
      post[7] += dislikeCnt;
      break;
    }
  }

  // Write the updated CSV string to the file
  await writeCsvToFile('lib/db/posts.csv', posts);

  // open posts_likes.csv
  List<List<dynamic>> postsLikes =
      await readCsvFromFile('lib/db/posts_likes.csv');

  int newPostLike;
  if (likeCnt == 1) {
    newPostLike = 1;
  } else if (dislikeCnt == 1) {
    newPostLike = -1;
  } else {
    newPostLike = 0;
  }

  // search for entry with the given postId
  for (var postLike in postsLikes.sublist(1, postsLikes.length)) {
    if (postLike[0] == userId && postLike[1] == postId) {
      postsLikes.remove(postLike);
      break;
    }
  }

  // add new entry
  postsLikes.add([userId, postId, newPostLike]);

  // Write the updated CSV string to the file
  await writeCsvToFile('lib/db/posts_likes.csv', postsLikes);
}

// get if the current user like or disliked the post
Future<int> getIfLiked(int userId, int postId) async {
  // open posts_likes.csv
  List<List<dynamic>> postsLikesData =
      await readCsvFromFile('lib/db/posts_likes.csv');

  // check if the user has already liked/disliked the post
  for (var postLike in postsLikesData.sublist(1, postsLikesData.length)) {
    if (postLike[0] == userId && postLike[1] == postId) {
      // user has already liked/disliked the post
      // update the like/dislike
      return postLike[2];
    }
  }
  return 0;
}

// get posts that the user has saved in order to display them in the saved page
Future<List<List<dynamic>>> getSavedPosts(int userId) async {
  // load posts_saved.csv and find all postIds saved by userId
  List<List<dynamic>> postsSavedData =
      await readCsvFromFile('lib/db/posts_saved.csv');

  List<dynamic> postIds = [];
  for (var postSaved in postsSavedData.sublist(1, postsSavedData.length)) {
    if (postSaved[0] == userId) {
      postIds.add(postSaved[1]);
    }
  }

  // load posts.csv and find all posts with the given postIds
  List<List<dynamic>> postsData = await readCsvFromFile('lib/db/posts.csv');

  List<List<dynamic>> savedPosts = [];
  for (var post in postsData.sublist(1, postsData.length)) {
    if (postIds.contains(post[0])) {
      savedPosts.add(post);
    }
  }

  return savedPosts;
}

// get if the current user has saved the post
Future<bool> getIfSaved(int userId, int postId) async {
  List<List<dynamic>> postsSavedData =
      await readCsvFromFile('lib/db/posts_saved.csv');

  for (var postSaved in postsSavedData.sublist(1, postsSavedData.length)) {
    if (postSaved[0] == userId && postSaved[1] == postId) {
      return true;
    }
  }
  return false;
}

// update the saved status of the post
Future<void> updateSaved(int userId, int postId, bool newValue) async {
  // open posts_saved.csv
  List<List<dynamic>> postsSavedData =
      await readCsvFromFile('lib/db/posts_saved.csv');

  if (newValue) {
    // add new entry
    postsSavedData.add([userId, postId]);
  } else {
    for (var postSaved in postsSavedData.sublist(1, postsSavedData.length)) {
      if (postSaved[0] == userId && postSaved[1] == postId) {
        postsSavedData.remove(postSaved);
        break;
      }
    }
  }

  // Write the updated CSV string to the file
  await writeCsvToFile('lib/db/posts_saved.csv', postsSavedData);
}

// check if user already exists
Future<bool> checkUsername(String username) async {
  List<List<dynamic>> csvData = await readCsvFromFile('lib/db/credentials.csv');

  for (var cred in csvData.sublist(1, csvData.length)) {
    String usr = cred[1].toString();
    if (usr == username) {
      // Authentication successful
      return true;
    }
  }
  return false;
}

// get avian merit of user
Future<int> getAvianMerit(int userId) async {
  List<List<dynamic>> csvData = await readCsvFromFile('lib/db/credentials.csv');

  for (var cred in csvData.sublist(1, csvData.length)) {
    int id = cred[0];
    if (id == userId) {
      // Authentication successful
      return cred[3];
    }
  }
  return -1;
}

// update avian merit of user
Future<void> updateAvianMerit(int userId, int newAvianMerit) async {
  List<List<dynamic>> csvData = await readCsvFromFile('lib/db/credentials.csv');

  for (var cred in csvData.sublist(1, csvData.length)) {
    int id = cred[0];
    if (id == userId) {
      // Authentication successful
      cred[3] += newAvianMerit;
      break;
    }
  }

  await writeCsvToFile('lib/db/credentials.csv', csvData);
}

// save XFile image to app's directory and return the filePath
Future<String> saveImageToAppDir(String filePath) async {
  // Get the app's document directory
  final directory = await getApplicationDocumentsDirectory();

  // Get the file name from the original file path
  String fileName = filePath.split('/').last;

  // Create a new file in the app's directory
  File destinationFile = File('${directory.path}/$fileName');

  // Copy the image file to the destination file
  await File(filePath).copy(destinationFile.path);
  return destinationFile.path;
}

Credentials credentials = Credentials(id: -1, email: '', password: '');

// authenticate whether the user exists in our csv database
Future<int> authenticate(String username, String password) async {
  List<List<dynamic>> csvData = await readCsvFromFile('lib/db/credentials.csv');

  int id = -1;
  for (var cred in csvData.sublist(1, csvData.length)) {
    String usr = cred[1].toString();
    String pswrd = cred[2].toString();
    if (usr == username && pswrd == password) {
      // Authentication successful
      return cred[0];
    }
  }
  return id;
}

// initializer function to read the csv files from the assets folder
// and place them in the apps documents directory
Future<String> _readCsvFromLocalFile(String filePath) async {
  final rawData = await rootBundle.loadString(filePath);
  return rawData;
}

Future<void> initFS() async {
  // create directories
  Directory dir = await getApplicationDocumentsDirectory();
  if (!Directory('${dir.path}/lib').existsSync()) {
    await Directory('${dir.path}/lib').create();
  }
  if (!Directory('${dir.path}/lib/db').existsSync()) {
    await Directory('${dir.path}/lib/db').create();
  }
  //if (!Directory('${dir.path}/lib/db/user_images').existsSync()) {
  //  await Directory('${dir.path}/lib/db/user_images').create();
  //}

  // add here all our initialiazer csv files
  for (var filePath in [
    'lib/db/credentials.csv',
    'lib/db/posts.csv',
    'lib/db/awards.csv',
    'lib/db/posts_awards.csv',
    'lib/db/posts_likes.csv',
    'lib/db/incoming_posts.csv',
    'lib/db/comments.csv',
    'lib/db/posts_saved.csv',
  ]) {
    File file = await getSafeFile(filePath);
    if (!file.existsSync()) {
      file = await file.create();
      //} // for production merge the two blocks into the if statement
      //{
      String csvString = await _readCsvFromLocalFile(filePath);
      await file.writeAsString(csvString);
    }
  }
}

//Because specifications from Figma differ to android emulator,and possibly from other devices
//I employ a percentage-based width and height calculation.Because i use Figma frame sizes for
//reference,i calculate the percentage in reference to total size instead

double getcorrectwidth(int figmaWidth, context) {
  double widthinpercent = figmaWidth / 360;
  return MediaQuery.of(context).size.width * widthinpercent;
}

double getcorrectheight(int figmaHeight, context) {
  double heightinpercent = figmaHeight / 800;
  return MediaQuery.of(context).size.height * heightinpercent;
}
