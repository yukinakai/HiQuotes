import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class IntroductionAppScreen extends StatelessWidget {
  const IntroductionAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Image.asset(
          'assets/images/Logo.png',
          height: 32,
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        alignment: Alignment.center,
        child: const Text(
          "この画面はアプリでのみご利用いただけます。",
          style: TextStyle(
            fontSize: 32,
          ),
        ),
      ),
    );
  }
}
