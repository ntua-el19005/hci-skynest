import 'package:flutter/material.dart';
import 'package:skynest/pages/home_page.dart';
import 'package:skynest/auth/login_or_register.dart';
import 'package:skynest/core/global_utils.dart' as globals;

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: globals.credentials,
      builder: (context, snapshot) {
        return FutureBuilder(
          future: _authenticate(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              int? id = snapshot.data;

              if (id != null && id >= 0) {
                return const HomePage();
              } else {
                globals.credentials.clearCredentials(notify: false);
                return const LoginOrRegister();
              }
            } else {
              // You can return a loading indicator here if needed
              return const CircularProgressIndicator();
            }
          },
        );
      },
    );
  }

  Future<int> _authenticate() async {
    return await globals.authenticate(
        globals.credentials.email, globals.credentials.password);
  }
}
