import 'package:flutter/material.dart';
import 'package:hi_quotes/icons/twitter_logo_white_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class QuoteDetailScreen extends StatelessWidget {
  const QuoteDetailScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
      Column(children: [
        Container(
          child: Column(children: [
            Container(
              child: Text(
                "ブランド価値を高めるSDGs時代のマーケティング｜P&GパンテーンをV字回復させた、経営とマーケティングを結ぶ設計図",
                style: TextStyle(
                  color: Colors.blueGrey[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              padding: const EdgeInsets.only(top: 28),
            ),
            const SizedBox(height: 8),
            Text(
              "https://note.com/brand_builder01/n/n2613891a49c0",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "2021/10/20 22:57",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],),
          padding: const EdgeInsets.all(16),
          color: Colors.grey[100],
          width: double.infinity,
        ),
        Expanded(child:
          SingleChildScrollView(child:
            Container(
              child: Text(
                "私は、ブランドのP/Lだけに留まらず様々な経営指標に責任を持ちビジネスをしてきた経験があります。多くの成功と失敗を繰り返し、貴重な学びを積み重ねてきました。その中で、パンテーンにおいては、#HairWeGoというSDGsに根ざしたブランドパーパスに基づくブランドキャンペーンを作りました。大きな話題を呼び、日本だけではなくアメリカabcTVやイギリスのBBCなど世界中のメディアからも数多く取り上げられました。そのキャンペーンのシリーズの一つは、話題になっただけではなく、実際に東京都で学校の髪形校則を変えるきっかけにもなりました。また、一連のキャンペーンは、ビジネスをV字回復させることにも貢献しました。\n\n昨今、SDGsをビジネス成長に直接つなげることが多くの企業にとって課題と言われていますが、幸いにも、私はSDGsをリアルに体現しながらビジネスも伸ばす、という貴重な経験をすることができたのです。",
                style: TextStyle(
                  color: Colors.blueGrey[900],
                  fontSize: 24,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 16
              ),
            ),
          )
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        child: const Icon(TwitterLogoWhite.twitterLogoWhite),
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
              padding: const EdgeInsets.only(top: 8, bottom: 32),
              iconSize: 32,
              icon: Icon(
                Icons.edit,
                color: Colors.grey[600],
              ),
              alignment: Alignment.bottomLeft,
              onPressed: () => {},
            ),
            IconButton(
              padding: const EdgeInsets.only(top: 8, right: 24, bottom: 32),
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
