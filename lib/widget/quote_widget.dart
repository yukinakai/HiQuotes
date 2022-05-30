import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hi_quotes/model/quote.dart';
import 'package:hi_quotes/quote_detail_screen.dart';
import 'package:hi_quotes/model/provider.dart';


class QuoteWidget extends ConsumerWidget {
  final DocumentSnapshot document;
  const QuoteWidget({Key? key, required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String updatedAt = DateFormat('yyyy/MM/dd H:m:s')
        .format(document.get('updatedAt').toDate().toLocal());
    return Column(children: <Widget>[
      ListTile(
        title: Text(
          document.get('content'),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color.fromRGBO(0, 0, 0, 100),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            document.get('title'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(updatedAt),
        ]),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        onTap: () => {
          ref.read(quoteProvider.notifier).update((state) => Quote(
            id: document.id,
            title: document.get('title'),
            url: document.get('url'),
            content: document.get('content'),
            updatedAt: updatedAt,
          )),
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const QuoteDetailScreen())),
        },
      ),
      const Divider(
        thickness: 6,
        color: Color.fromRGBO(218, 210, 197, 75),
      )
    ]);
  }
}
