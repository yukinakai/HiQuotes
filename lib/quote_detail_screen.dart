import 'package:flutter/material.dart';
import 'package:hi_quotes/widget/tweet_share_widget.dart';
import 'package:hi_quotes/widget/share_image_widget.dart';
import 'package:hi_quotes/quote_add_screen.dart';
import 'package:hi_quotes/widget/quote_detail_widget.dart';
import 'package:hi_quotes/service/delete_quote.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi_quotes/widget/quote_widget.dart';

final imageKeyProvider = StateProvider<GlobalKey?>((ref) => null);

class QuoteDetailScreen extends ConsumerWidget {
  final GlobalKey _globalKey = GlobalKey();
  Image? _image;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(imageKeyProvider.notifier).update((state) => _globalKey);
    final quote = ref.read(quoteProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(children: [
        ShareImageWidget(),
        QuoteDetailWidget(
            title: widget.title,
            url: widget.url,
            content: widget.content,
            updatedAt: widget.updatedAt,
            image: _image),
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
              onPressed: () => {deleteQuote(context, quote.id)},
            ),
          ],
        ),
      ),
    );
  }
}
