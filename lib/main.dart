import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:withu/Shared/constants.dart';
import 'package:withu/helper/helper_function.dart';
import 'package:withu/pages/auth/login_page.dart';
import 'package:withu/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: constants.apikey,
          appId: constants.appId,
          messagingSenderId: constants.messagingId,
          projectId: constants.projectId),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _signedIn = false;

  @override
  void initState() {
    super.initState();
    getUserLogedInStatus();
  }

  getUserLogedInStatus() async {
    await helperFunction.getUserLogedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _signedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WithU',
      theme: ThemeData(
        primaryColor: constants().primarycolor,
        primarySwatch: constants().primarycolor,
      ),
      home: _signedIn ? const HomePage() : const LoginPage(),
    );
  }
}
