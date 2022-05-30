import 'package:flutter/material.dart';
import 'package:hi_quotes/widget/tweet_share_widget.dart';
import 'package:hi_quotes/widget/share_image_widget.dart';
import 'package:hi_quotes/quote_add_screen.dart';
import 'package:hi_quotes/widget/quote_detail_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi_quotes/model/provider.dart';
import 'package:hi_quotes/service/show_alart_dialog.dart';

class QuoteDetailScreen extends ConsumerStatefulWidget {
  const QuoteDetailScreen({Key? key}) : super(key: key);

  @override
  QuoteDetailState createState() => QuoteDetailState();
}

class QuoteDetailState extends ConsumerState<QuoteDetailScreen> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final quote = ref.read(quoteProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.grey[600],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              quote.param = "edit";
              ref.read(quoteProvider.notifier).update((state) => quote);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const QuoteAddScreen()));
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              ShowAlertDialog.showDeleteComformDialog(context, quote.id);
              // deleteQuote(context, quote.id);
            },
            icon: const Icon(Icons.delete_forever),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(children: [
        ShareImageWidget(
          imageWidgetKey: _globalKey,
        ),
        const QuoteDetailWidget(),
      ])),
      floatingActionButton: TwitterShareWidget(
        imageWidgetKey: _globalKey,
        id: quote.id,
      ),
    );
  }
}
