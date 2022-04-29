// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:hi_quotes/firebase_options.dart';
// import 'package:hi_quotes/quotes_list_screen.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final FirebaseAuth auth = FirebaseAuth.instance;
//     auth.authStateChanges().listen((User? user) {
//       if (user == null) {
//         auth.signInAnonymously();
//       }
//     });
//     return MaterialApp(
//       title: 'Hi Quotes',
//       theme: ThemeData(fontFamily: 'Noto Sans JP'),
//       home: const QuotesListScreen(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription _intentDataStreamSubscription;
  Uri? _sharedUrl;
  String? _sharedText;

  @override
  void initState() {
    super.initState();

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStreamAsUri().listen((Uri value) {
      setState(() {
        _sharedUrl = value;
      });
    }, onError: (err) {
      // print("getLinkStream error: $err");
    });
    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialTextAsUri().then((Uri? value) {
      setState(() {
        _sharedUrl = value;
      });
    });

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      setState(() {
        _sharedText = value;
      });
    }, onError: (err) {
      // print("getLinkStream error: $err");
    });
    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      setState(() {
        _sharedText = value;
      });
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const textStyleBold = const TextStyle(fontWeight: FontWeight.bold);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text("Shared urls:", style: textStyleBold),
              Text(_sharedUrl.toString()),
              SizedBox(height: 100),
              Text("Shared text:", style: textStyleBold),
              Text(_sharedText ?? ""),
            ],
          ),
        ),
      ),
    );
  }
}
