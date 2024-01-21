import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skynest/components/text_field.dart';
import 'package:skynest/core/global_utils.dart' as globals;
import 'package:skynest/pages/successful_post_page.dart';
import 'package:skynest/themes/theme_helper.dart';

class CustomizePostPage extends StatefulWidget {
  const CustomizePostPage({
    super.key,
    required this.image,
  });

  final XFile image;

  @override
  _CustomizePostPageState createState() => _CustomizePostPageState();
}

class _CustomizePostPageState extends State<CustomizePostPage> {
  final titleTextController = TextEditingController();
  final descriptionTextController = TextEditingController();

  // method to make a post in our app
  Future<void> postNest() async {
    // maybe check that the title is not empty, description should be optional anyway...

    // save the image to the app's directory
    final imagePath = await globals.saveImageToAppDir(widget.image.path);

    try {
      await globals.addPost(
        globals.credentials.id,
        '1h',
        imagePath,
        titleTextController.text,
        descriptionTextController.text,
        0,
        0,
        0,
        0,
      );

      // go to success page 
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SuccessfulPostPage(),
          )
        );
        setState(() {});

        // delay for a bit
        await Future.delayed(const Duration(milliseconds: 500));

        if (context.mounted) {
          // go back to customize post page
          Navigator.pop(context);
          // go to home page
          Navigator.pop(context);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          // dismiss keyboard when the user taps outside of the text field
          FocusScope.of(context).unfocus();
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
            title: const Text('Make a Nest!'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    const Text(
                      'Title',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 25),
                    MakePostTextField(
                      controller: titleTextController,
                      hintText: 'Write a title for your post',
                      minLines: 1,
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'Description',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 25),
                    MakePostTextField(
                      controller: descriptionTextController,
                      hintText: 'Add a Description',
                      minLines: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: postNest,
            child: const Icon(
              Icons.upload,
              color: Colors.black,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ),
      ),
    );
  }
}
