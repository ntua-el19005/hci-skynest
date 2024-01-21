import 'package:flutter/material.dart';
import 'package:skynest/core/global_utils.dart';
import 'package:skynest/auth/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initFS();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: true,
        //for testing purposes i change this
        home: AuthPage(),
      );
  }
}
