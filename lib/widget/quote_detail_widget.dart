import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi_quotes/model/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hi_quotes/model/quote.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class QuoteDetailWidget extends ConsumerStatefulWidget {
  const QuoteDetailWidget({Key? key}) : super(key: key);

  @override
  QuoteDetailWidgetState createState() => QuoteDetailWidgetState();
}

class QuoteDetailWidgetState extends ConsumerState<QuoteDetailWidget> {
  late DocumentSnapshot document;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _getData();
  }

  Future<void> _getData() async {
    document = await FirebaseFirestore.instance
        .collection('quotes')
        .doc(ref.read(quoteProvider).id)
        .get();
    String updatedAt = DateFormat('yyyy/MM/dd H:m:s')
        .format(document.get('updatedAt').toDate().toLocal());
    final quote = Quote(
        id: document.id,
        title: document.get('title'),
        url: document.get('url'),
        content: document.get('content'),
        updatedAt: updatedAt);
    ref.read(quoteProvider.notifier).update((state) => quote);
    setState(() {
      _isLoading = false;
    });
  }

  void _launchUrl(url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    final quote = ref.read(quoteProvider);
    return Stack(children: [
      Column(children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[100],
          width: double.infinity,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  quote.title,
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
                  quote.url,
                  style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      decoration: TextDecoration.underline),
                ),
                onTap: () => _launchUrl(Uri.parse(quote.url)),
              ),
              const SizedBox(height: 8),
              Text(
                quote.updatedAt,
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
              quote.content,
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
        ]))),
      ]),
      if (_isLoading)
        const LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.yellow),
            backgroundColor: Colors.white),
    ]);
  }
}
