import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:hi_quotes/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("group", () {
    final floatingAddButtonFinder =
        find.byKey(const Key('floating_add_button'));
    final formTitleFinder = find.byKey(const Key('form_title'));
    final formUrlFinder = find.byKey(const Key('form_url'));
    final formContentFinder = find.byKey(const Key('form_content'));
    final quoteSubmitButton = find.byKey(const Key("quote_submit_button"));
    const testTitle = "タイトルです。";
    const testTitleEdit = "タイトルです。更新しました";
    const testUrl = "https://google.com";
    const testUrlEdit = "https://google.com/edited";
    const testContent = "内容です。";
    const testContentEdit = "内容です。更新しました";
    final quoteTitleFinder = find.text(testTitle);
    final quoteUrlFinder = find.text(testUrl);
    final quoteContentFinder = find.text(testContent);
    testWidgets("run app", (WidgetTester tester) async {
      // アプリを開く
      app.main();
      await tester.pumpAndSettle();
      // リストの表示を待つ
      await tester.pump(const Duration(seconds: 1));
      // 初期はリストが0件であることを確認する
      expect(find.byType(ListTile), findsNothing);
    });
    testWidgets("add quote", (WidgetTester tester) async {
      // アプリを開く
      app.main();
      await tester.pumpAndSettle();
      // フローティングボタンの存在を確認
      expect(floatingAddButtonFinder, findsOneWidget);
      // 登録画面への遷移
      await tester.tap(floatingAddButtonFinder);
      await tester.pumpAndSettle();
      // フォームとボタンの確認
      final quoteSubmitButtonText = find.text("登録");
      expect(formTitleFinder, findsOneWidget);
      expect(formUrlFinder, findsOneWidget);
      expect(formContentFinder, findsOneWidget);
      expect(quoteSubmitButton, findsOneWidget);
      expect(quoteSubmitButtonText, findsOneWidget);
      // 登録内容の入力
      await tester.enterText(formTitleFinder, testTitle);
      await tester.enterText(formUrlFinder, testUrl);
      await tester.enterText(formContentFinder, testContent);
      // キーボードを閉じる
      await tester.tap(find.byKey(const Key("close_focus_node_3")));
      await tester.pumpAndSettle();
      // 登録＆一案画面への遷移
      await tester.tap(quoteSubmitButton);
      await tester.pumpAndSettle();
      // リストの表示を待つ
      await tester.pump(const Duration(seconds: 1));
      // 登録結果の確認
      expect(find.byType(ListTile), findsOneWidget);
      expect(quoteTitleFinder, findsOneWidget);
      expect(quoteContentFinder, findsOneWidget);
    });

    testWidgets("edit quote", (WidgetTester tester) async {
      // アプリを開く
      app.main();
      await tester.pumpAndSettle();
      // リストの読み込みを待つ
      await tester.pump(const Duration(seconds: 1));
      // 求人詳細へ画面遷移 ※ケース上1件しかないはずなので、これで通る
      await tester.tap(find.byType(ListTile));
      await tester.pumpAndSettle();
      // 編集画面に遷移
      final editButton = find.byKey(const Key("edit_icon"));
      expect(editButton, findsOneWidget);
      await tester.tap(editButton);
      await tester.pumpAndSettle();
      // 登録した内容が入力されているかを確認
      expect(quoteTitleFinder, findsWidgets);
      expect(quoteUrlFinder, findsWidgets);
      expect(quoteContentFinder, findsWidgets);
      final quoteSubmitButtonText = find.text("更新");
      expect(quoteSubmitButtonText, findsOneWidget);
      // 登録内容の更新＆一覧画面への遷移
      await tester.enterText(formTitleFinder, testTitleEdit);
      await tester.enterText(formUrlFinder, testUrlEdit);
      await tester.enterText(formContentFinder, testContentEdit);
      await tester.tap(quoteSubmitButton);
      await tester.pumpAndSettle();
      // リストの読み込みを待つ
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      // 更新した内容の確認
      expect(find.text(testTitleEdit), findsOneWidget);
      expect(find.text(testContentEdit), findsOneWidget);
    });

    testWidgets("delete quote", (WidgetTester tester) async {
      // アプリを開く
      app.main();
      await tester.pumpAndSettle();
      // リストの読み込みを待つ
      await tester.pump(const Duration(seconds: 1));
      // 求人詳細へ画面遷移 ※ケース上1件しかないはずなので、これで通る
      await tester.tap(find.byType(ListTile));
      await tester.pumpAndSettle();
      // 削除アイコンをタップ
      final deleteButton = find.byKey(const Key("delete_icon"));
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();
      // キャンセルボタンをタップ
      await tester.tap(find.byKey(const Key("no_button")));
      await tester.pumpAndSettle();
      // 削除アイコンをタップ
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();
      // はいボタンをタップ＆一覧画面への遷移
      await tester.tap(find.byKey(const Key("yes_button")));
      await tester.pumpAndSettle();
      // リストの読み込みを待つ
      await tester.pump(const Duration(seconds: 1));
      // 削除を確認
      expect(find.text(testTitleEdit), findsNothing);
    });
  });
}
