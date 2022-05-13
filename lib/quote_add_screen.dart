import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:hi_quotes/quotes_list_screen.dart';
import 'package:hi_quotes/widget/tweet_share_widget.dart';
import 'package:hi_quotes/widget/share_image_widget.dart';

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
  late String title = widget.initialTitle ?? "";
  late String url = widget.initialUrl ?? "";
  late String content = widget.initialContent ?? "";

  Future _showAlertDialog(BuildContext context) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('エラー'),
              content: const Text('エラー'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                )
              ]);
        });
  }

  void addQuotes() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        _showAlertDialog(context);
        print("user not found");
      } else {
        CollectionReference quotes =
            FirebaseFirestore.instance.collection('quotes');
        final uid = user.uid;
        final now = DateTime.now().toUtc();
        if (widget.quoteId == null) {
          quotes
              .add({
                'userId': uid,
                'title': title,
                'url': url,
                'content': content,
                'createdAt': now,
                'updatedAt': now,
              })
              .then((value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const QuotesListScreen())))
              .catchError((error) => _showAlertDialog(context));
        } else {
          quotes
              .doc(widget.quoteId)
              .update({
                'title': title,
                'url': url,
                'content': content,
                'updatedAt': now,
              })
              .then((value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const QuotesListScreen())))
              .catchError((error) => _showAlertDialog(context));
        }
      }
    });
  }

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.grey[200],
        nextFocus: true,
        actions: [
          KeyboardActionsItem(focusNode: _nodeText1, toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('閉じる'),
                ),
              );
            }
          ]),
          KeyboardActionsItem(focusNode: _nodeText2, toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('閉じる'),
                ),
              );
            }
          ]),
          KeyboardActionsItem(focusNode: _nodeText3, toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('閉じる'),
                ),
              );
            },
          ]),
        ]);
  }

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
            child: KeyboardActions(
              config: _buildConfig(context),
              child: SingleChildScrollView(
                child: Container(
                  margin:const EdgeInsets.only(top: 64, right: 32, left: 32),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: widget.initialTitle,
                        decoration: const InputDecoration(
                          hintText: '記事タイトル',
                          labelText: '記事タイトル',
                        ),
                        onChanged: (String value) {
                          setState(() {
                            title = value;
                          });
                        },
                        autofocus: true,
                        focusNode: _nodeText1,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: widget.initialUrl,
                        decoration: const InputDecoration(
                          hintText: 'URL',
                          labelText: 'URL',
                        ),
                        onChanged: (String value) {
                          setState(() {
                            url = value;
                          });
                        },
                        focusNode: _nodeText2,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        initialValue: widget.initialContent,
                        decoration: const InputDecoration(
                          hintText: '内容',
                          labelText: '内容',
                        ),
                        onChanged: (String value) {
                          setState(() {
                            content = value;
                          });
                        },
                        focusNode: _nodeText3,
                      ),
                    ],
                  ),
              )))))
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
              onPressed: () => addQuotes(),
            ),
          ],
        ),
      ));
  }
}
