import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:hi_quotes/quotes_list_screen.dart';
import 'package:hi_quotes/widget/tweet_share_widget.dart';
import 'package:hi_quotes/widget/share_image_widget.dart';
import 'package:hi_quotes/service/add_quote.dart';
import 'package:hi_quotes/widget/quote_form_widget.dart';

class QuoteAddScreen extends StatefulWidget {
  final String? quoteId, initialTitle, initialUrl, initialContent;
  const QuoteAddScreen(
      {Key? key,
      this.quoteId,
      this.initialTitle,
      this.initialUrl,
      this.initialContent})
      : super(key: key);

  @override
  State<QuoteAddScreen> createState() => _QuoteAddScreenState();
}

class _QuoteAddScreenState extends State<QuoteAddScreen> {
  final GlobalKey _globalKey = GlobalKey();
  // late String title;
  // late String url;
  // late String content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
          ShareImageWidget(
            imageWidgetKey: _globalKey,
            content: content,
            title: title,
          ),
          Container(
              color: Colors.white,
              child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: QuoteFormWidget(
                    quoteId: widget.quoteId,
                    initialTitle: widget.initialTitle,
                    initialUrl: widget.initialUrl,
                    initialContent: widget.initialContent,
                  )
                  ))
        ]),
        floatingActionButton: TwitterShareWidget(
          imageWidgetKey: _globalKey,
          title: title,
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
                onPressed: () => addQuotes(
                  context,
                  widget.quoteId,
                  title,
                  url,
                  content
                ),
              ),
            ],
          ),
        ));
  }
}
