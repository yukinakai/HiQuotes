import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hi_quotes/service/delete_quote.dart';

class ShowAlertDialog {
  static Future showAlertDialog(BuildContext context) async {
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

  static Future showDeleteComformDialog(BuildContext context, quoteId) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('本当に削除しますか？'),
              content: const Text('一度削除した内容は2復元できません'),
              actions: <Widget>[
                TextButton(
                  key: const Key("yes_button"),
                  onPressed: () => deleteQuote(context, quoteId),
                  child: const Text('はい'),
                ),
                TextButton(
                  key: const Key("no_button"),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('いいえ'),
                ),
              ]);
        });
  }
}
