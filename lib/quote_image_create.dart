import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';


class QuoteImageCreate extends StatefulWidget {
  const QuoteImageCreate({ Key? key }) : super(key: key);

  @override
  State<QuoteImageCreate> createState() => _QuoteImageCreateState();
}

class _QuoteImageCreateState extends State<QuoteImageCreate> {
  final GlobalKey _globalKey = GlobalKey();
  Image? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: RepaintBoundary(
        key: _globalKey,
        child: Row(children: [Container(
          height: 540,
          width: 540,
          padding: const EdgeInsets.all(40),
          color: Colors.brown[50],
          child: Column(children: [
            Container(
              // height: 460,
              height: 388,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              color: Colors.red,
              child: AutoSizeText(
                "アイウエオ",
                // "私は、ブランドのP/Lだけに留まらず様々な経営指標に責任を持ちビジネスをしてきた経験があります。多くの成功と失敗を繰り返し、貴重な学びを積み重ねてきました。その中で、パンテーンにおいては、#HairWeGoというSDGsに根ざしたブランドパーパスに基づくブランドキャンペーンを作りました。大きな話題を呼び、日本だけではなくアメリカabcTVやイギリスのBBCなど世界中のメディアからも数多く取り上げられました。そのキャンペーンのシリーズの一つは、話題になっただけではなく、実際に東京都で学校の髪形校則を変えるきっかけにもなりました。また、一連のキャンペーンは、ビジネスをV字回復させることにも貢献しました。\n\n昨今、SDGsをビジネス成長に直接つなげることが多くの企業にとって課題と言われていますが、幸いにも、私はSDGsをリアルに体現しながらビジネスも伸ばす、という貴重な経験をすることができたのです。",
                style: TextStyle(
                  fontSize: 1000,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[900],
                ),
                textAlign: TextAlign.center,
                maxLines: 30,
                minFontSize: 12,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
                height: 32,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                alignment: Alignment.topLeft,
                child: Text(
                  "いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいううううううううええええええ",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blueGrey[900],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )),
            Container(
                width: double.infinity,
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  'assets/images/Logo.png',
                  height: 24,
                )),
          ]),
        ),
        _image ?? const SizedBox(height: 0),
        ])),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => {
            _doCapture()
          },
        ),
        );
  }
    /*
   * キャプチャ開始
   */
  Future<void> _doCapture() async {

    var image  = await _convertWidgetToImage();

    setState(() {
      _image = image;
    });
  }

  /*
   * _globalKeyが設定されたWidgetから画像を生成し返す
   */
  Future<Image> _convertWidgetToImage() async {
    RenderRepaintBoundary boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png) as ByteData;
    var pngBytes = byteData.buffer.asUint8List();
    return Image.memory(pngBytes);
  }
}
