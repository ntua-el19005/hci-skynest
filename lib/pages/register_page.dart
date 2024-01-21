import 'package:flutter/material.dart';
import 'package:skynest/components/text_field.dart';
import 'package:skynest/components/buttons.dart';
import 'package:skynest/themes/theme_helper.dart';
import 'package:skynest/core/global_utils.dart' as globals;

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  // sign user up
  Future<void> signUp() async {
    if (await globals.checkUsername(emailTextController.text)) {
      // username already exists
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                backgroundColor: appTheme.cyan100,
                title: const Text('User already exists')));
        return;
      }
    }

    if (passwordTextController.text != confirmPasswordTextController.text) {
      // passwords do not match
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                backgroundColor: appTheme.cyan100,
                title: const Text('Passwords do not match')));
        return;
      }
    }
    // add credentials
    await globals.addCredentials(
        emailTextController.text, passwordTextController.text);

    int id = await globals.authenticate(
        emailTextController.text, passwordTextController.text);
    globals.credentials.setCredentials(
        id, emailTextController.text, passwordTextController.text,
        notify: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.teal200,
      body: GestureDetector(
        onTap: () {
          // dismiss keyboard when the user taps outside of the text field
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    // some space
                    const SizedBox(height: 50),
                    // logo
                    Image.asset(
                      'assets/images/img_skynest_logo_final.png',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 25),

                    // welcome back message
                    Text(
                      'Let\'s create an account for you!',
                      style: TextStyle(
                        color: appTheme.teal700,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // email textfield
                    const SizedBox(height: 25),

                    SignInTextField(
                      controller: emailTextController,
                      hintText: 'Email',
                      obscureText: false,
                    ),
                    // password textfield
                    const SizedBox(height: 25),

                    SignInTextField(
                      controller: passwordTextController,
                      hintText: 'Password',
                      obscureText: true,
                    ),
                    // confirm password textfield
                    const SizedBox(height: 25),

                    SignInTextField(
                      controller: confirmPasswordTextController,
                      hintText: 'Rewrite Password',
                      obscureText: true,
                    ),
                    // sign-up button
                    const SizedBox(height: 25),
                    MyButton(
                      onTap: signUp,
                      text: 'Sign Up',
                    ),
                    // go to register page
                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(
                            color: appTheme.teal700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: appTheme.teal800,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
