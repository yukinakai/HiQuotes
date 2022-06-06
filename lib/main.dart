import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hi_quotes/firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hi_quotes/quote_detail_screen.dart';
import 'package:hi_quotes/quotes_list_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setUrlStrategy(PathUrlStrategy());
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        auth.signInAnonymously();
      }
    });
    return MaterialApp(
      title: 'Hi Quotes',
      theme: ThemeData(textTheme: GoogleFonts.mPlus1TextTheme()),
      home: const QuotesListScreen(),
      onGenerateRoute: (settings) {
        List<String> pathComponents = settings.name!.split('/');
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => const QuoteDetailScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => QuoteDetailScreen(
                arguments: pathComponents.last,
              ),
            );
        }
      },
    );
  }
}
