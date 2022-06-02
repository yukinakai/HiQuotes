import 'package:flutter/material.dart';
import 'package:hi_quotes/quotes_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

void addQuotes(
    context, String? quoteId, String title, String url, String content) {
  var logger = Logger();
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("エラーが発生しました。後ほどお試しください。")));
      logger.e("user not found");
    } else {
      CollectionReference quotes =
          FirebaseFirestore.instance.collection('quotes');
      final uid = user.uid;
      final now = DateTime.now().toUtc();
      if (quoteId == "") {
        quotes
            .add({
              'userId': uid,
              'title': title,
              'url': url,
              'content': content,
              'createdAt': now,
              'updatedAt': now,
            })
            .then((value) => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const QuotesListScreen())))
            .catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("エラーが発生しました。後ほどお試しください。")));
              logger.e(error);
            });
      } else {
        quotes
            .doc(quoteId)
            .update({
              'title': title,
              'url': url,
              'content': content,
              'updatedAt': now,
            })
            .then((value) => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const QuotesListScreen())))
            .catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("エラーが発生しました。後ほどお試しください。")));
              logger.e(error);
            });
      }
    }
  });
}
