import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hi_quotes/quotes_list_screen.dart';

void deleteQuote(
  context,
  String quoteId
) {
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print("user not found");
    } else {
      DocumentReference quote =
          FirebaseFirestore.instance.collection('quotes').doc(quoteId);
      quote
          .delete()
          .then((value) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const QuotesListScreen())))
          .catchError((error) => print(error));
    }
  });
}
