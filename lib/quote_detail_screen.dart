import 'package:flutter/material.dart';
import 'package:hi_quotes/widget/tweet_share_widget.dart';
import 'package:hi_quotes/widget/share_image_widget.dart';
import 'package:hi_quotes/quote_add_screen.dart';
import 'package:hi_quotes/widget/quote_detail_widget.dart';
import 'package:hi_quotes/service/delete_quote.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi_quotes/widget/quote_widget.dart';

class QuoteDetailScreen extends ConsumerWidget {
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(imageKeyProvider.notifier).update((state) => _globalKey);
    final quote = ref.read(quoteProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(children: [
        ShareImageWidget(),
        QuoteDetailWidget(),
      ])),
      floatingActionButton: TwitterShareWidget(
        imageWidgetKey: _globalKey,
        id: quote.id,
        title: quote.title,
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
                        builder: (context) => QuoteAddScreen()))
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
              onPressed: () => {deleteQuote(context, quote.id)},
            ),
          ],
        ),
      ),
    );
  }
}
