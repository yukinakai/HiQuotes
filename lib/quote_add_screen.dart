import 'package:flutter/material.dart';
import 'package:hi_quotes/quotes_list_screen.dart';
import 'package:hi_quotes/widget/tweet_share_widget.dart';
import 'package:hi_quotes/widget/share_image_widget.dart';
import 'package:hi_quotes/service/add_quote.dart';
import 'package:hi_quotes/widget/quote_form_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi_quotes/model/provider.dart';

class QuoteAddScreen extends ConsumerStatefulWidget {
  const QuoteAddScreen({Key? key}) : super(key: key);

  @override
  QuoteAddState createState() => QuoteAddState();
}

class QuoteAddState extends ConsumerState<QuoteAddScreen> {
  final GlobalKey _globalKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final quote = ref.read(quoteProvider);
    return Scaffold(
        body: Stack(children: [
          ShareImageWidget(
            imageWidgetKey: _globalKey,
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
        floatingActionButton: TwitterShareWidget(
          imageWidgetKey: _globalKey,
        ),
        resizeToAvoidBottomInset: false,
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
                onPressed: () => {
                  if (Navigator.canPop(context))
                    {Navigator.pop(context)}
                  else
                    {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QuotesListScreen(),
                          ))
                    }
                },
              ),
              IconButton(
                  padding: const EdgeInsets.only(top: 8, right: 24, bottom: 32),
                  iconSize: 32,
                  icon: Icon(
                    Icons.add_task,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      addQuotes(context, quote.id, quote.title, quote.url,
                          quote.content);
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text("エラーをご確認ください。")));
                    }
                  }),
            ],
          ),
        ));
  }
}
