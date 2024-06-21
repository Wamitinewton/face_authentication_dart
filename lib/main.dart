import 'package:face_auth/pages/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAZ3wdyApjCQMZNdXnRjHmm8NG9MWVUcnY",
          appId: "1:26668030985:android:124af04ec41681b0736cd8",
          messagingSenderId: "26668030985",
          projectId: "ecommercesystem-a37b8",
          storageBucket: "ecommercesystem-a37b8.appspot.com"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}
