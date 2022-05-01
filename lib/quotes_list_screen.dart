import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:hi_quotes/quote_add_screen.dart';

import 'dart:async';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class QuotesListScreen extends StatefulWidget {
  const QuotesListScreen({Key? key}) : super(key: key);

  @override
  State<QuotesListScreen> createState() => _QuotesListScreenState();
}

class _QuotesListScreenState extends State<QuotesListScreen> {
  late StreamSubscription _intentDataStreamSubscription;
  String content = '';
  @override
  void initState() {
    super.initState();
    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      setState(() {
        content = value;
      });
    }, onError: (err) {
      print("getLinkStream error: $err");
    });
    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      setState(() {
        content = value ?? '';
      });
    }
    );
    ReceiveSharingIntent.reset();

    controller = ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    _getData();
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  late ScrollController controller;
  DocumentSnapshot? _lastVisible;
  late bool _isLoading;
  final List<DocumentSnapshot> _data = <DocumentSnapshot<Object>>[];

  Future<void> _getData() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        String uid = user.uid;
        QuerySnapshot data;
        if (_lastVisible == null) {
          data = await FirebaseFirestore.instance
              .collection('quotes')
              .where('user_id', isEqualTo: uid)
              .orderBy('updated_at', descending: true)
              .limit(10)
              .get();
        } else {
          data = await FirebaseFirestore.instance
              .collection('quotes')
              .where('user_id', isEqualTo: uid)
              .orderBy('updated_at', descending: true)
              .startAfter([_lastVisible!['updated_at']])
              .limit(10)
              .get();
        }
        if (data.docs.isNotEmpty) {
          _lastVisible = data.docs[data.docs.length - 1];
          if (mounted) {
            setState(() {
              _isLoading = false;
              _data.addAll(data.docs);
            });
          }
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (content.isNotEmpty) {
      return QuoteAddScreen(defaultContent: content);
    } else {
      return Scaffold(
        appBar: AppBar(
            centerTitle: false,
            title: Image.asset(
              'assets/images/Logo.jpg',
              height: 32,
            ),
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false),
        body: RefreshIndicator(
          child: ListView.builder(
              controller: controller,
              itemCount: _data.length,
              itemBuilder: (_, index) {
                if (index < _data.length) {
                  final DocumentSnapshot document = _data[index];
                  String updateAt = DateFormat('yyyy/MM/dd H:m:s')
                      .format(document.get('updated_at').toDate().toLocal());
                  return Column(children: <Widget>[
                    ListTile(
                      title: Text(
                        document.get('content'),
                        maxLines: 3,
                        style: const TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 100),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(document.get('title') + '\n' + updateAt),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      onTap: () => {},
                    ),
                    const Divider(
                      thickness: 6,
                      color: Color.fromRGBO(218, 210, 197, 75),
                    )
                  ]);
                }
                return const SizedBox();
              }),
          onRefresh: () async {
            _data.clear();
            _lastVisible = null;
            await _getData();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const QuoteAddScreen()))
          },
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
          backgroundColor: Colors.yellow[400],
        ),
      );
    }
  }

  void _scrollListener() {
    if (!_isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        _getData();
      }
    }
  }
}
