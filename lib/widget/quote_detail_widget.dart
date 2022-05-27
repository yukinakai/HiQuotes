import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi_quotes/widget/quote_widget.dart';

class QuoteDetailWidget extends ConsumerWidget {
  void _launchUrl(url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quote = ref.read(quoteProvider);
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
    ]);
  }
}
