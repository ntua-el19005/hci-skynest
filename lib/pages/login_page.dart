import 'package:flutter/material.dart';
import 'package:skynest/components/text_field.dart';
import 'package:skynest/components/buttons.dart';
import 'package:skynest/themes/theme_helper.dart';
import 'package:skynest/core/global_utils.dart' as globals;

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  // sign user in
  Future<void> signIn() async {
    String username = emailTextController.text;
    String password = passwordTextController.text;

    int id = await globals.authenticate(username, password);

    if (id >= 0) {
      // authentication successful
      globals.credentials.setCredentials(id, username, password, notify: true);
    } else {
      // authentication failed
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: appTheme.cyan100,
                title: const Text('Authentication Failed'),
              ));

      //globals.credentials.clearCredentials();
    }
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
                      'Welcome Back!',
                      style: TextStyle(
                        color: appTheme.teal700,
                        fontSize: 30,
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
                    // login button
                    const SizedBox(height: 25),

                    MyButton(
                      onTap: signIn,
                      text: 'Sign In',
                    ),
                    // go to register page
                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(
                            color: appTheme.teal700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            'Sign Up',
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
