import 'package:flutter/material.dart';
import 'package:hi_quotes/icons/twitter_logo_white_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class QuoteDetailScreen extends StatelessWidget {
  final String title, url, content, updatedAt;
  const QuoteDetailScreen({
    Key? key,
    required this.title,
    required this.url,
    required this.content,
    required this.updatedAt,
  }) : super(key: key);

  void _launchUrl(url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[100],
          width: double.infinity,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 28),
                child: Text(
                  title,
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
                  url,
                  style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      decoration: TextDecoration.underline),
                ),
                onTap: () => _launchUrl(Uri.parse(url)),
              ),
              const SizedBox(height: 8),
              Text(
                "2021/10/20 22:57",
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
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Text(
              content,
              style: TextStyle(
                color: Colors.blueGrey[900],
                fontSize: 24,
              ),
            ),
          ),
        ))
      ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        child: const Icon(TwitterLogoWhite.twitterLogoWhite),
        backgroundColor: Colors.blue,
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
              onPressed: () => {},
            ),
            IconButton(
              padding: const EdgeInsets.only(top: 8, right: 24, bottom: 32),
              iconSize: 32,
              icon: Icon(
                Icons.delete_forever,
                color: Colors.grey[600],
              ),
              alignment: Alignment.bottomLeft,
              onPressed: () => {},
            ),
          ],
        ),
      ),
    );
  }
}
