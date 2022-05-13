import 'package:flutter/material.dart';
import 'package:hi_quotes/quotes_list_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hi_quotes/widget/tweet_share_widget.dart';
import 'package:hi_quotes/widget/share_image_widget.dart';
import 'package:hi_quotes/quote_add_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  void _launchUrl(url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) throw 'Could not launch $url';
  }

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
        Column(children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 28),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.blueGrey[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  child: Text(
                    widget.url,
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        decoration: TextDecoration.underline),
                  ),
                  onTap: () => _launchUrl(Uri.parse(widget.url)),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.updatedAt,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
                  child: Column(children: [
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Text(
                widget.content,
                style: TextStyle(
                  color: Colors.blueGrey[900],
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              color: Colors.white,
              width: double.infinity,
              height: 500,
            ),
            Container(child: _image)
          ]))),
        ])
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
