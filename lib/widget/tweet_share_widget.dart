import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hi_quotes/icons/twitter_logo_white_icons.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:uuid/uuid.dart';
import 'package:logger/logger.dart';

class TwitterShareWidget extends StatefulWidget {
  final GlobalKey imageWidgetKey;
  final String? id;
  const TwitterShareWidget({
    Key? key,
    required this.imageWidgetKey,
    this.id,
  }) : super(key: key);

  @override
  State<TwitterShareWidget> createState() => _TwitterShareWidgetState();
}

class _TwitterShareWidgetState extends State<TwitterShareWidget> {
  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(TwitterLogoWhite.twitterLogoWhite),
      backgroundColor: Colors.lightBlueAccent,
      onPressed: () async {
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 100));
        _convertWidgetToImage().then(((value) {
          _getImageUrl(value).then((value) {
            if (value != null) {
              _buildDynamicUrl(value).then((value) {
                _tweet(value);
              });
            }
          });
        }));
      },
    );
  }

  void _tweet(Uri imageUrl) async {
    final Map<String, dynamic> tweetQuery = {
      "text": "@HiQuotesApp \n",
      "url": imageUrl.toString(),
      "hashtags": "HiQuotes",
    };

    final Uri tweetScheme =
        Uri(scheme: "twitter", host: "post", queryParameters: tweetQuery);

    final Uri tweetIntentUrl =
        Uri.https("twitter.com", "/intent/tweet", tweetQuery);

    await canLaunchUrl(tweetScheme)
        ? await launchUrl(tweetScheme)
        : await launchUrl(
            tweetIntentUrl,
            mode: LaunchMode.externalApplication,
          );
  }

  Future<Uint8List> _convertWidgetToImage() async {
    RenderRepaintBoundary boundary = widget.imageWidgetKey.currentContext
        ?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData =
        await image.toByteData(format: ui.ImageByteFormat.png) as ByteData;
    var imageData = byteData.buffer.asUint8List();
    return imageData;
    // return Image.memory(pngBytes);
  }

  Future<Uri?> _getImageUrl(Uint8List imageData) async {
    final id = widget.id ?? const Uuid().v4();
    final ref = FirebaseStorage.instance.ref('ogp_images/$id.png');
    final String imageUrl;
    try {
      _uploadImage(ref, imageData);
      imageUrl =
          'https://firebasestorage.googleapis.com/v0/b/${ref.bucket}/o/ogp_images%2F$id.png?alt=media';
      logger.i('OGP Image Upload Url = $imageUrl');
      return Uri.parse(imageUrl);
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("エラーが発生しました。後ほどお試しください。")));
    }
  }

  Future<void> _uploadImage(ref, imageData) async {
    await ref.putData(
        imageData,
        SettableMetadata(
          contentType: 'image/png',
        ));
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
        imageUrl: imageUrl,
      ),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    logger.i('Dynamic Link Short Url = ${dynamicLink.shortUrl}');
    return dynamicLink.shortUrl;
  }
}
