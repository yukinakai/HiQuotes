import 'package:flutter/material.dart';
import 'package:hi_quotes/quotes_list_screen.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:hi_quotes/Introduction_app_screen.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isWeb) {
      return const IntroductionAppScreen();
    } else {
      return const QuotesListScreen();
    }
  }
}
