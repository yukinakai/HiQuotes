import 'package:flutter/material.dart';
import 'package:hi_quotes/quotes_list_screen.dart';
import 'package:hi_quotes/widget/tweet_share_widget.dart';
import 'package:hi_quotes/widget/share_image_widget.dart';
import 'package:hi_quotes/quote_add_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hi_quotes/widget/quote_detail_widget.dart';

class QuoteDetailScreen extends StatefulWidget {
  final String quoteId, title, url, content, updatedAt;
  const QuoteDetailScreen({
    Key? key,
    required this.quoteId,
    required this.title,
    required this.url,
    required this.content,
    required this.updatedAt,
  }) : super(key: key);

  @override
  State<QuoteDetailScreen> createState() => _QuoteDetailScreenState();
}

class _QuoteDetailScreenState extends State<QuoteDetailScreen> {
  final GlobalKey _globalKey = GlobalKey();
  Image? _image;

  void deleteQuote() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print("user not found");
      } else {
        DocumentReference quote =
            FirebaseFirestore.instance.collection('quotes').doc(widget.quoteId);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(children: [
        ShareImageWidget(
          imageWidgetKey: _globalKey,
          content: widget.content,
          title: widget.title,
        ),
        QuoteDetailWidget(
          title: widget.title,
          url: widget.url,
          content: widget.content,
          updatedAt: widget.updatedAt,
          image: _image
        ),
      ])),
      floatingActionButton: TwitterShareWidget(
        imageWidgetKey: _globalKey,
        id: widget.quoteId,
        title: widget.title,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              padding: const EdgeInsets.only(top: 8, left: 24, bottom: 32),
              iconSize: 32,
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.grey[600],
              ),
              alignment: Alignment.bottomLeft,
              onPressed: () => {Navigator.pop(context)},
            ),
            IconButton(
              padding: const EdgeInsets.only(top: 8, bottom: 32),
              iconSize: 32,
              icon: Icon(
                Icons.edit,
                color: Colors.grey[600],
              ),
              alignment: Alignment.bottomLeft,
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QuoteAddScreen(
                              quoteId: widget.quoteId,
                              initialTitle: widget.title,
                              initialUrl: widget.url,
                              initialContent: widget.content,
                            )))
              },
            ),
            IconButton(
              padding: const EdgeInsets.only(top: 8, right: 24, bottom: 32),
              iconSize: 32,
              icon: Icon(
                Icons.delete_forever,
                color: Colors.grey[600],
              ),
              alignment: Alignment.bottomLeft,
              onPressed: () => {deleteQuote()},
            ),
          ],
        ),
      ),
    );
  }
}
