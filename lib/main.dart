import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:hi_quotes/firebase_options.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        auth.signInAnonymously();
      }
    });
    return MaterialApp(
      title: 'Hi Quotes',
      theme: ThemeData(fontFamily: 'Noto Sans JP'),
      home: const QuotesListScreen(),
    );
  }
}

class QuotesListScreen extends StatefulWidget {
  const QuotesListScreen({Key? key}) : super(key: key);

  @override
  State<QuotesListScreen> createState() => _QuotesListScreenState();
}

class _QuotesListScreenState extends State<QuotesListScreen> {
  late ScrollController controller;
  DocumentSnapshot? _lastVisible;
  late bool _isLoading;

  final List<DocumentSnapshot> _data = <DocumentSnapshot<Object>>[];

  @override
  void initState() {
    controller = ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    _getData();
  }

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

  void _scrollListener() {
    if (!_isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        _getData();
      }
    }
  }
}

class QuoteAddScreen extends StatefulWidget {
  const QuoteAddScreen({Key? key}) : super(key: key);

  @override
  State<QuoteAddScreen> createState() => _QuoteAddScreenState();
}

class _QuoteAddScreenState extends State<QuoteAddScreen> {
  String title = '';
  String url = '';
  String content = '';

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
    FirebaseAuth.instance
      .authStateChanges()
      .listen((User? user) {
    if (user == null) {
      _showAlertDialog(context);
      print("user not found");
    } else {
      CollectionReference quotes =
        FirebaseFirestore.instance.collection('quotes');
      final uid = user.uid;
      final now = DateTime.now().toUtc();
      quotes
        .add({
          'user_id': uid,
          'title': title,
          'url': url,
          'content': content,
          'created_at': now,
          'updated_at': now,
        })
        .then((value) => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const QuotesListScreen())))
        .catchError((error) => _showAlertDialog(context));
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
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('キャンセル'),
                ),
              );
            }
          ]),
          KeyboardActionsItem(focusNode: _nodeText2, toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('キャンセル'),
                ),
              );
            }
          ]),
          KeyboardActionsItem(focusNode: _nodeText3, toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('キャンセル'),
                ),
              );
            },
            (node) {
              return GestureDetector(
                onTap: () => addQuotes(),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Text('登録'),
                ),
              );
            },
          ]),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: KeyboardActions(
          config: _buildConfig(context),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 64, right: 32, left: 32),
              child: Column(
                children: <Widget>[
                  TextFormField(
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
            )
          )
        )
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              padding: const EdgeInsets.only(top: 8, left: 24, bottom: 32),
              iconSize: 32,
              icon: const Icon(Icons.arrow_back_ios_new),
              alignment: Alignment.bottomLeft,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            IconButton(
              padding: const EdgeInsets.only(top: 8, right: 24, bottom: 32),
              iconSize: 32,
              icon: const Icon(Icons.add_task),
              onPressed: () => addQuotes(),
            ),
          ],
        ),
      ));
  }
}
