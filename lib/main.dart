import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  await dotenv.load();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBUnnSSXRr43Y2RCLd37pahmueMll5HO_0",
          authDomain: "hi-quotes-13d85.firebaseapp.com",
          projectId: "hi-quotes-13d85",
          storageBucket: "hi-quotes-13d85.appspot.com",
          messagingSenderId: "597694034365",
          appId: "1:597694034365:web:4d72b5ead3fbb2e633e2d4",
          measurementId: "G-0SKCGX7SHC"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'アプリタイトルです',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        auth.signInAnonymously();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('ヘッダーです。'),
      ),
      body: const Center(
        child: Text('ボディやで。'),
      ),
    );
  }
}
