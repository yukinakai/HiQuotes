import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hi_quotes/quotes_list_screen.dart';
import 'package:logger/logger.dart';

void deleteQuote(context, String quoteId) {
  var logger = Logger();
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("エラーをご確認ください。")));
      logger.e("user not found");
    } else {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('quotes').doc(quoteId);
      docRef.get().then((value) {
        DocumentSnapshot document = value;
        if (document.get("userId") == user.uid) {
          docRef
              .delete()
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
      });
    }
  });
}
