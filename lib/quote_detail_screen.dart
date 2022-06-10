import 'package:flutter/material.dart';
import 'package:hi_quotes/service/share%20on%20twitter.dart';
import 'package:hi_quotes/widget/share_image_widget.dart';
import 'package:hi_quotes/quote_add_screen.dart';
import 'package:hi_quotes/widget/quote_detail_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi_quotes/model/provider.dart';
import 'package:hi_quotes/service/show_alart_dialog.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:hi_quotes/icons/twitter_logo_white_icons.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class QuoteDetailScreen extends ConsumerStatefulWidget {
  final String? arguments;
  const QuoteDetailScreen({Key? key, this.arguments}) : super(key: key);

  @override
  QuoteDetailState createState() => QuoteDetailState();
}

class QuoteDetailState extends ConsumerState<QuoteDetailScreen> {
  final GlobalKey _imageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    bool _automaticallyImplyLeading = true;
    if (UniversalPlatform.isWeb) {
      _automaticallyImplyLeading = false;
    }
    final quote = ref.watch(quoteProvider);
    if (widget.arguments != null) {
      quote.id = widget.arguments!;
      ref.read(quoteProvider.notifier).update((state) => quote);
    }
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Image.asset(
            'assets/images/Logo.png',
            height: 32,
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.grey[600],
          ),
          automaticallyImplyLeading: _automaticallyImplyLeading,
          actions: <Widget>[
            if (!UniversalPlatform.isWeb)
              IconButton(
                key: const Key("edit_icon"),
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
            if (!UniversalPlatform.isWeb)
              IconButton(
                key: const Key("delete_icon"),
                onPressed: () {
                  ShowAlertDialog.showDeleteComformDialog(context, quote.id);
                },
                icon: const Icon(Icons.delete_forever),
              )
          ],
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              ShareImageWidget(
                imageWidgetKey: _imageKey,
              ),
              const QuoteDetailWidget(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(TwitterLogoWhite.twitterLogoWhite),
          backgroundColor: Colors.lightBlueAccent,
          onPressed: () {
            setState(() {});
            shareOnTwitter(_imageKey, quote.id);
          },
        ));
  }
}
