import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi_quotes/widget/quote_widget.dart';
import 'package:hi_quotes/quote_add_screen.dart';

class ShareImageWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quote = ref.read(quoteProvider);
    return RepaintBoundary(
      key: ref.read(imageKeyProvider),
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
              quote.content,
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
                quote.title,
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
