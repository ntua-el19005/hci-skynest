# SkyNest: Nest your Experiences!

SkyNest is an application that allows you to share experiences with the world around you.
It is developed as a project for the Human-Computer Interaction course at NTUA.

# Group
Group 111

- Dimitrios Georgousis, 03119005
- Michail-Angelos Eleftheriadis, 03119913
- Georgios-Alexios Kapetanakis, 03119062

## Description
SkyNest is an app that lets you share your experiences with people local
to you and engage in each other's real life activities. Award your favorite
posts to appreciate their content, reward and be rewarded!
Take or upload a photo from your album with a caption and have it stay
in the real world for some time. People in your vicinity can see your post
and be charmed by it.
Collect “Avian Merit” by making interesting posts that others fancy and
spend it to gift special rewards to those you like.
You can also view and reminisce about your past posts and save your
dearest to encapsulate them forever.
Download the app and start exploring Nests now!

## Platform

The application is a flutter/dart project created on `Visual Studio Code` and the Android Emulators were created on `Android Studio`.

The development platform environment was similar to the one we'll show below:
```
PS C:\Users\dimig> dart --version
Dart SDK version: 3.2.3 (stable) (Tue Dec 5 17:58:33 2023 +0000) on "windows_x64"
PS C:\Users\dimig> flutter --version
Flutter 3.16.6 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 46787ee49c (12 days ago) • 2024-01-09 14:36:07 -0800
Engine • revision 3f3e560236
Tools • Dart 3.2.3 • DevTools 2.28.4
```


The application was created for `Android`. It has been testing with Android Emulators with API 33 and API 34. It has also been tested with a physical device running Android 12 (API 31) (device is: Xiaomi Redmi Note 9S). Screen is 360x800 or a similar ratio.

## Installation after downloading the app-debug.apk we provided

This method works on Windows 11 platform with android device connected via USB cable.
1. Download `app-debug.apk` file
2. right-click on the file and choose the "Send To" option
3. Send it to your device (after you have already connected it to your PC via USB)
4. Go to your devices file manager and find the `apk` file
5. Install it from there

## Installation

Before attempting any installation it might be good to run `flutter clean` and `flutter pub get`.

### Release

Connect your device to your computer and run the following:
```
PS C:\Users\dimig\Desktop\Computer-Human_Interaction\skynest> flutter build apk
Resolving dependencies... (1.1s)
  camera_avfoundation 0.9.13+10 (0.9.13+11 available)
  ffi 2.1.0 (2.1.2 available)
  http 1.1.2 (1.2.0 available)
  matcher 0.12.16 (0.12.16+1 available)
  material_color_utilities 0.5.0 (0.8.0 available)
  meta 1.10.0 (1.11.0 available)
  path 1.8.3 (1.9.0 available)
  test_api 0.6.1 (0.7.0 available)
  web 0.3.0 (0.4.2 available)
Got dependencies!
9 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.

Font asset "MaterialIcons-Regular.otf" was tree-shaken, reducing it from 1645184 to 2260 bytes (99.9% reduction). Tree-shaking can be disabled by providing the --no-tree-shake-icons flag when building your app.
e: C:/Users/dimig/.gradle/caches/transforms-3/b91d5b010bb7c1fbb9d04195e8906de4/transformed/jetified-activity-1.7.2/jars/classes.jar!/META-INF/activity_release.kotlin_module: Module was compiled with an incompatible version of Kotlin. The binary version of its metadata is 1.8.0, expected version is 1.6.0.
e: C:/Users/dimig/.gradle/caches/transforms-3/51c4237b152abce1e932c12a63f62b14/transformed/lifecycle-livedata-core-2.6.1/jars/classes.jar!/META-INF/lifecycle-livedata-core_release.kotlin_module: Module was compiled with an incompatible version of Kotlin. The binary version of its metadata is 1.8.0, expected version is 1.6.0.
e: C:/Users/dimig/.gradle/caches/transforms-3/33dd62f120e2f491197015f785af45ee/transformed/lifecycle-livedata-2.6.1/jars/classes.jar!/META-INF/lifecycle-livedata_release.kotlin_module: Module was compiled with an incompatible version of Kotlin. The binary version of its metadata is 1.8.0, expected version is 1.6.0.
e: C:/Users/dimig/.gradle/caches/transforms-3/045a9e306a37c835747f925a3fff2d6e/transformed/lifecycle-viewmodel-2.6.1/jars/classes.jar!/META-INF/lifecycle-viewmodel_release.kotlin_module: Module was compiled with an incompatible version of Kotlin. The binary version of its metadata is 1.8.0, expected version is 1.6.0.
e: C:/Users/dimig/.gradle/caches/transforms-3/726878209e2d58122feae6e5e9c50e0f/transformed/jetified-lifecycle-viewmodel-savedstate-2.6.1/jars/classes.jar!/META-INF/lifecycle-viewmodel-savedstate_release.kotlin_module: Module was compiled with an incompatible version of Kotlin. The binary version of its metadata is 1.8.0, expected version is 1.6.0.
e: C:/Users/dimig/.gradle/caches/transforms-3/47085114ff49c80095b55db1e8d4ce63/transformed/jetified-core-ktx-1.10.1/jars/classes.jar!/META-INF/core-ktx_release.kotlin_module: Module was compiled with an incompatible version of Kotlin. The binary version of its metadata is 1.8.0, expected version is 1.6.0.
e: C:/Users/dimig/.gradle/caches/transforms-3/889ce5bd12f1117e5357d5fcdb5e1305/transformed/core-1.10.1/jars/classes.jar!/META-INF/core_release.kotlin_module: Module was compiled with an incompatible version of Kotlin. The binary version of its metadata is 1.8.0, expected version is 1.6.0.
e: C:/Users/dimig/.gradle/caches/transforms-3/f9ab57318e353231e2e9f0f159e658ae/transformed/lifecycle-runtime-2.6.1/jars/classes.jar!/META-INF/lifecycle-runtime_release.kotlin_module: Module was compiled with an incompatible version of Kotlin. The binary version of its metadata is 1.8.0, expected version is 1.6.0.
e: C:/Users/dimig/.gradle/caches/modules-2/files-2.1/androidx.lifecycle/lifecycle-common/2.6.1/10f354fdb64868baecd67128560c5a0d6312c495/lifecycle-common-2.6.1.jar!/META-INF/lifecycle-common.kotlin_module: Module was compiled with an incompatible version of Kotlin. The binary version of its metadata is 1.8.0, expected version is 1.6.0.
e: C:/Users/dimig/.gradle/caches/transforms-3/06f1f6593869a63768ed146cfbaa0e2a/transformed/jetified-savedstate-1.2.1/jars/classes.jar!/META-INF/savedstate_release.kotlin_module: Module was compiled with an incompatible version of Kotlin. The binary version of its metadata is 1.8.0, expected version is 1.6.0.
e: C:/Users/dimig/.gradle/caches/modules-2/files-2.1/org.jetbrains.kotlin/kotlin-stdlib/1.8.22/636bf8b320e7627482771bbac9ed7246773c02bd/kotlin-stdlib-1.8.22.jar!/META-INF/kotlin-stdlib-jdk7.kotlin_module: Module was compiled with an incompatible version of Kotlin. The binary version of its metadata is 1.8.0, expected version is 1.6.0.
e: C:/Users/dimig/.gradle/caches/modules-2/files-2.1/org.jetbrains.kotlin/kotlin-stdlib/1.8.22/636bf8b320e7627482771bbac9ed7246773c02bd/kotlin-stdlib-1.8.22.jar!/META-INF/kotlin-stdlib.kotlin_module: Module was compiled with an incompatible version of Kotlin. The binary version of its metadata is 1.8.0, expected version is 1.6.0.
e: C:/Users/dimig/.gradle/caches/modules-2/files-2.1/org.jetbrains.kotlin/kotlin-stdlib/1.8.22/636bf8b320e7627482771bbac9ed7246773c02bd/kotlin-stdlib-1.8.22.jar!/META-INF/kotlin-stdlib-jdk8.kotlin_module: Module was compiled with an incompatible version of Kotlin. The binary version of its metadata is 1.8.0, expected version is 1.6.0.
e: C:/Users/dimig/.gradle/caches/modules-2/files-2.1/org.jetbrains.kotlin/kotlin-stdlib-common/1.8.22/1a8e3601703ae14bb58757ea6b2d8e8e5935a586/kotlin-stdlib-common-1.8.22.jar!/META-INF/kotlin-stdlib-common.kotlin_module: Module was compiled with an incompatible version of Kotlin. The binary version of its metadata is 1.8.0, expected version is 1.6.0.
Running Gradle task 'assembleRelease'...                           80.4s
√  Built build\app\outputs\flutter-apk\app-release.apk (22.2MB).
PS C:\Users\dimig\Desktop\Computer-Human_Interaction\skynest> flutter install
Installing app-release.apk to Redmi Note 9S...
Installing build\app\outputs\flutter-apk\app-release.apk...         3.2s
```

### Debug

Connect your device to your computer and run the following:

```
PS C:\Users\dimig\Desktop\Computer-Human_Interaction\skynest> flutter build apk --debug
Running Gradle task 'assembleDebug'...                             30.1s
√  Built build\app\outputs\flutter-apk\app-debug.apk.
PS C:\Users\dimig\Desktop\Computer-Human_Interaction\skynest> flutter install --debug
Installing app-debug.apk to Redmi Note 9S...
Uninstalling old version...
Installing build\app\outputs\flutter-apk\app-debug.apk...           9.4s
```

## Project Structure

- `assets/images`: is a directory which contains images that are used for various graphical interfaces in our app. As the name suggests. It contains assets our app uses for display purposes.
- `lib`: this directory is where the main code of our app was written.
- `lib/db`: our app would normally use a remote database to store data. Since we developed the application for display purposes we implemented a placeholder database in the form of `.csv` data. The initial data we use exists in the `.csv` files of this directory. When the application is installed and first run the `.csv` files get copied over to the local file system of the device running it and, then, any other data the user might produce is saved locally in those directories (data is persistent). In the **Comments** section we will be explaining what the functionality of the different `.csv` files is.
- `lib/core`: contains some general tools used throughout the app. Mainly the `global_utils.dart` file has a lot of functions and global data which help in the usability of our app. These functions mainly involve connectivity with our database (which in this case, as we have already mentioned, is some local `.csv` files)
- `lib/themes`: directory with themes (colors/formats) which are used in our app. A nice way to keep them all at a central location
- `lib/auth`: simple authentication and appropriate redirection pages
- `lib/components`: basic blocks and widgets which are used in multiple pages of our application
- `lib/pages`: All the pages/screens of our app. It also includes overlays and pop-up buttons which may appear while using the app.

## Comments

### Refresh/Reload
- a lot of changes you may make. e.g. Like/Dislike, make a new post, give an award, add/remove from saved posts may require you to perform a refresh before the results are visible.

### Gestures

Since the app was designed for use on mobile phones, we have implemented gestures which seemed reasonable (e.g. swipe right->left to reveal the user profile overlay
or swipe left->right to activate the camera in the home page/screen). There are some gestures which were included in the figma prototype and we did not implement.

### Features not implemented

- expiry of posts: we implemented `time remaining` as a string for display purposes. It doesn't have the appropriate functionality, which would be the deletion of the post from the database after the appropriate time has elapsed.
- bluetooth sharing: implementing this feature would greatly increase the work load of the development. Since we aim to only showcase our idea we did not actually implement this feature, instead, we chose to simulate it.
Firstly, let's briefly go over what the feature actually is supposed to be: User A and User B are spacially close in the physical world. User A makes a new post X. Post X is uploaded to the SkyNest database and a notification (containing the post ID of post X) is transmitted from User's A device to local devices. User B gets this notification and his application automatically downloads and shows him the new post he received from his environment(post X).
Our method for simulating this event is the following: we have set-up the app so that a notification will appear on screen at some time. When the user clicks on this notification, then a new post is added to the posts they are seeing in the home-page (might need refresh). Now let's explain the different files in the `lib/db` directory and what they are supposed to act as: all `.csv` files are supposed to simulate the remote database, except for `incoming_posts.csv`. This file would exist one a user's device and it would contain the post ids of posts made close to them (post ids they received from other users through notifications).
