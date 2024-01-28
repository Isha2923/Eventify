import 'package:eventify/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDZG_YbiXNJ55mn3gcigIz-sgGPy2tOeL4",
            appId: "1:709517423234:android:0627edc12be22f36b8fa9b",
            messagingSenderId: "709517423234",
            projectId: "eventify-abdcd"));
  }
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Event Hub",
      home: AnimatedSplashScreen(
        splash: Container(
          width: 100,
          height: 100,
          child: CircleAvatar(
            backgroundImage: AssetImage('images/logo.jpeg'),
            backgroundColor: Colors.transparent,
            radius: 500,
          ),
        ),
        nextScreen: SignUp(),
        splashTransition: SplashTransition.slideTransition,
        backgroundColor: Colors.deepPurple,
        duration:2500,

      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

