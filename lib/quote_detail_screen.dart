import 'package:flutter/material.dart';
import 'package:hi_quotes/icons/twitter_logo_white_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuoteDetailScreen extends StatefulWidget {
  final String id, title, url, content, updatedAt;
  const QuoteDetailScreen({
    Key? key,
    required this.id,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(children: [
        RepaintBoundary(
          key: _globalKey,
          child: Container(
            height: 315,
            width: 600,
            padding: const EdgeInsets.all(24),
            color: Colors.brown[50],
            child: Column(children: [
              Container(
                // color: Colors.red,
                height: 211,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                child: AutoSizeText(
                  widget.content,
                  style: TextStyle(
                    fontSize: 1000,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 12,
                  minFontSize: 12,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                  // color: Colors.green,
                  height: 24,
                  width: double.infinity,
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blueGrey[900],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )),
              Container(
                  // color: Colors.blue,
                  width: double.infinity,
                  alignment: Alignment.bottomRight,
                  child: Image.asset(
                    'assets/images/Logo.png',
                    height: 24,
                  )),
            ]),
          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {});
          await Future.delayed(const Duration(milliseconds: 100));
          _convertWidgetToImage().then(((value) {
            _getImageUrl(value).then((value) {
              if (value != null) {
                _buildDynamicUrl(value);
              }
            });
          }));
        },
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

  // Future<void> _doCapture() async {
  //   setState(() {});
  //   await Future.delayed(const Duration(milliseconds: 100));
  //   var image = await _convertWidgetToImage();
  //   setState(() {
  //     _image = image;
  //   });
  // }

  Future<Uint8List> _convertWidgetToImage() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData =
        await image.toByteData(format: ui.ImageByteFormat.png) as ByteData;
    var imageData = byteData.buffer.asUint8List();
    return imageData;
    // return Image.memory(pngBytes);
  }

  Future<Uri?> _getImageUrl(Uint8List imageData) async {
    final id = widget.id;
    final ref = FirebaseStorage.instance.ref('ogp_images/$id.png');
    final String imageUrl;
    try {
      DocumentReference quote =
          FirebaseFirestore.instance.collection('quotes').doc(widget.id);
      quote.get().then((DocumentSnapshot snapshot) => {
        if (snapshot.data().toString().contains('lastSharedAt')) {
          if (snapshot.get('updatedAt').toDate().isAfter(snapshot.get('lastSharedAt').toDate())) {
            _uploadImage(ref, imageData)
          }
        } else {
          _uploadImage(ref, imageData)
        }
      });
      quote.update({'lastSharedAt': DateTime.now().toUtc()}).catchError(
          (error) => {print(error)});
      imageUrl =
          'https://firebasestorage.googleapis.com/v0/b/${ref.bucket}/o/ogp_images%2F$id.png?alt=media';
      print('OGP Image Upload Url = $imageUrl');
      return Uri.parse(imageUrl);
    } on FirebaseException catch (e) {
      print('OGP Image Upload Error = $e');
    }
  }

  Future<void> _uploadImage(ref, imageData) async{
    await ref.putData(
      imageData,
      SettableMetadata(
        contentType: 'image/png',
      )
    );
  }

  Future<Uri> _buildDynamicUrl(Uri imageUrl) async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://www.example.com/"), // 遷移先URL
      uriPrefix: 'https://hiquotesapp.page.link', // Dynamic Linksで作成したURL接頭辞
      androidParameters:
          const AndroidParameters(packageName: "com.example.hi_quotes"),
      iosParameters: const IOSParameters(bundleId: "com.example.hiQuotes"),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'HiQuotes',
        description: widget.content,
        imageUrl: imageUrl,
      ),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    print('Dynamic Link Short Url = ${dynamicLink.shortUrl}');
    return dynamicLink.shortUrl;
  }
}
