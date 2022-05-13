import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class QuoteDetailWidget extends StatefulWidget {
  final String title, url, content, updatedAt;
  final Image? image;
  const QuoteDetailWidget({
    Key? key,
    required this.title,
    required this.url,
    required this.content,
    required this.updatedAt,
    required this.image,
  }) : super(key: key);

  @override
  State<QuoteDetailWidget> createState() => _QuoteDetailWidgetState();
}

class _QuoteDetailWidgetState extends State<QuoteDetailWidget> {
  void _launchUrl(url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
        Container(child: widget.image)
      ]))),
    ]);
  }
}
