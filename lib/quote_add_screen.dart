import 'package:flutter/material.dart';
import 'package:hi_quotes/service/share%20on%20twitter.dart';
import 'package:hi_quotes/widget/share_image_widget.dart';
import 'package:hi_quotes/service/add_quote.dart';
import 'package:hi_quotes/widget/quote_form_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi_quotes/model/provider.dart';
import 'package:hi_quotes/icons/twitter_logo_white_icons.dart';

class QuoteAddScreen extends ConsumerStatefulWidget {
  const QuoteAddScreen({Key? key}) : super(key: key);

  @override
  QuoteAddState createState() => QuoteAddState();
}

class QuoteAddState extends ConsumerState<QuoteAddScreen> {
  final GlobalKey _imageKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  String submitButtonLabel = "登録";

  @override
  Widget build(BuildContext context) {
    final quote = ref.read(quoteProvider);
    if (quote.param == "edit") {
      submitButtonLabel = "更新";
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.grey[600],
        ),
      ),
      body: Stack(children: [
        ShareImageWidget(
          imageWidgetKey: _imageKey,
        ),
        Container(
            color: Colors.white,
            child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusScope.of(context).unfocus(),
                child: QuoteFormWidget(
                  formWidgetKey: _formKey,
                ))),
      ]),
      floatingActionButton: FloatingActionButton(
        child: const Icon(TwitterLogoWhite.twitterLogoWhite),
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (quote.param != null) {
              addQuotes(
                  context, quote.id, quote.title, quote.url, quote.content);
            }
            setState(() {});
            shareOnTwitter(_imageKey, quote.id);
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("エラーをご確認ください。")));
          }
        },
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomAppBar(
          color: Colors.yellow[400],
          child: Container(
            child: TextButton(
                key: const Key("quote_submit_button"),
                child: Text(
                  submitButtonLabel,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addQuotes(context, quote.id, quote.title, quote.url,
                        quote.content);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("エラーをご確認ください。")));
                  }
                }),
            padding: const EdgeInsets.all(4),
          )),
    );
  }
}
