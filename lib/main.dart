import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
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

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        auth.signInAnonymously();
      }
    });
    return MaterialApp(
      title: 'アプリタイトルです',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const QuoteAddScreen(),
    );
  }
}

class QuoteAddScreen extends StatelessWidget {
  const QuoteAddScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const TextField(),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('登録')
            )
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('キャンセル')
            )
          ),
        ],
      ),
      persistentFooterButtons: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {}
        ),
        IconButton(
          icon: const Icon(Icons.add_task),
          onPressed: () {}
        )
      ]
    );
  }
}
