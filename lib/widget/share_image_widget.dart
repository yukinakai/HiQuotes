import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ShareImageWidget extends StatefulWidget {
  final GlobalKey imageWidgetKey;
  final String content, title;
  const ShareImageWidget({
    Key? key,
    required this.imageWidgetKey,
    required this.content,
    required this.title
  }) : super(key: key);

  @override
  State<ShareImageWidget> createState() => _ShareImageWidgetState();
}

class _ShareImageWidgetState extends State<ShareImageWidget> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widget.imageWidgetKey,
      child: Container(
        height: 315,
        width: 600,
        padding: const EdgeInsets.symmetric(
          vertical: 64,
          horizontal: 32
        ),
        color: Colors.brown[50],
        child: Column(children: [
          Container(
            // color: Colors.red,
            height: 151,
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
              maxLines: 9,
              minFontSize: 12,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
              // color: Colors.green,
              height: 12,
              width: double.infinity,
              alignment: Alignment.topLeft,
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 8,
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
                height: 16,
              )),
        ]),
      ),
    );
  }
}
