import 'package:flutter/material.dart';

class QuoteDetailScreen extends StatelessWidget {
  const QuoteDetailScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
          child: Column(children: [
            Container(
              child: const Text(
                "ブランド価値を高めるSDGs時代のマーケティング｜P&GパンテーンをV字回復させた、経営とマーケティングを結ぶ設計図",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              padding: const EdgeInsets.only(top: 28),
            ),
            const SizedBox(height: 8),
            const Text(
              "https://note.com/brand_builder01/n/n2613891a49c0",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "2021/10/20 22:57",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],),
          padding: const EdgeInsets.all(16),
        ),
        Text("ワーー")
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        child: Image.asset('assets/images/twitter.png'),
        backgroundColor: Colors.blue,
      ),
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
              onPressed: () => {Navigator.pop(context)},
            ),
            IconButton(
              padding: const EdgeInsets.only(top: 8, left: 24, bottom: 32),
              iconSize: 32,
              icon: Icon(
                Icons.edit,
                color: Colors.grey[600],
              ),
              alignment: Alignment.bottomLeft,
              onPressed: () => {},
            ),
            IconButton(
              padding: const EdgeInsets.only(top: 8, left: 24, bottom: 32),
              iconSize: 32,
              icon: Icon(
                Icons.delete_forever,
                color: Colors.grey[600],
              ),
              alignment: Alignment.bottomLeft,
              onPressed: () => {},
            ),
          ],
        ),
      ),
    );
  }
}
