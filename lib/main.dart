import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class QuoteAddScreen extends StatefulWidget {
  const QuoteAddScreen({Key? key}) : super(key: key);

  @override
  State<QuoteAddScreen> createState() => _QuoteAddScreenState();
}

class _QuoteAddScreenState extends State<QuoteAddScreen> {
  String title = '';
  String url = '';
  String content = '';

  Future _showAlertDialog(BuildContext context) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('エラータイトル'),
              content: const Text('エラーコンテント'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                )
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference quotes =
        FirebaseFirestore.instance.collection('quotes');

    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
          margin: const EdgeInsets.only(top: 64, right: 32, left: 32),
          child: Column(
            children: <Widget>[
              TextFormField(
                  decoration: const InputDecoration(
                    hintText: '記事タイトル',
                    labelText: '記事タイトル',
                  ),
                  onChanged: (String value) {
                    setState(() {
                      title = value;
                    });
                  }),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'URL',
                  labelText: 'URL',
                ),
                onChanged: (String value) {
                  setState(() {
                    url = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: '内容',
                  labelText: '内容',
                ),
                onChanged: (String value) {
                  setState(() {
                    content = value;
                  });
                },
              ),
            ],
          ),
        )),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                padding: const EdgeInsets.only(top: 8, left: 24, bottom: 32),
                iconSize: 32,
                icon: const Icon(Icons.arrow_back_ios_new),
                alignment: Alignment.bottomLeft,
                onPressed: () {},
              ),
              IconButton(
                  padding: const EdgeInsets.only(top: 8, right: 24, bottom: 32),
                  iconSize: 32,
                  icon: const Icon(Icons.add_task),
                  onPressed: () {
                    // final FirebaseAuth auth = FirebaseAuth.instance;
                    FirebaseAuth.instance
                        .authStateChanges()
                        .listen((User? user) {
                      if (user == null) {
                        _showAlertDialog(context);
                        print("user not found");
                      } else {
                        final uid = user.uid;
                        quotes
                            .add({
                              'title': title,
                              'url': url,
                              'content': content,
                            })
                            .then((value) => print(uid))
                            .catchError((error) => _showAlertDialog(context));
                      }
                    });
                  }),
            ],
          ),
        ));
  }
}
