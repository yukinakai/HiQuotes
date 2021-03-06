import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi_quotes/model/provider.dart';

class QuoteFormWidget extends ConsumerStatefulWidget {
  final GlobalKey formWidgetKey;
  const QuoteFormWidget({
    Key? key,
    required this.formWidgetKey,
  }) : super(key: key);

  @override
  QuoteFormState createState() => QuoteFormState();
}

class QuoteFormState extends ConsumerState<QuoteFormWidget> {
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
                key: const Key("close_focus_node_3"),
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
    final quote = ref.read(quoteProvider);
    bool _autoFocus = true;
    if (quote.param == "edit") {
      _autoFocus = false;
    }

    return KeyboardActions(
        config: _buildConfig(context),
        child: SingleChildScrollView(
          child: Container(
              margin: const EdgeInsets.all(32),
              child: Form(
                key: widget.formWidgetKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                        key: const Key("form_content"),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        initialValue: quote.content,
                        decoration: const InputDecoration(
                          hintText: '内容',
                          labelText: '内容 *',
                        ),
                        onChanged: (String value) {
                          setState(() {
                            quote.content = value;
                            ref
                                .read(quoteProvider.notifier)
                                .update((state) => quote);
                          });
                        },
                        autofocus: _autoFocus,
                        focusNode: _nodeText1,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '必須項目です。';
                          }
                          return null;
                        }),
                    const SizedBox(height: 8),
                    TextFormField(
                      key: const Key("form_title"),
                      initialValue: quote.title,
                      decoration: const InputDecoration(
                        hintText: '記事タイトル',
                        labelText: '記事タイトル',
                      ),
                      onChanged: (String value) {
                        setState(() {
                          quote.title = value;
                          ref
                              .read(quoteProvider.notifier)
                              .update((state) => quote);
                        });
                      },
                      focusNode: _nodeText2,
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.length > 200) {
                          return '200文字以内にしてください。';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      key: const Key("form_url"),
                      initialValue: quote.url,
                      decoration: const InputDecoration(
                        hintText: 'URL',
                        labelText: 'URL',
                      ),
                      onChanged: (String value) {
                        setState(() {
                          quote.url = value;
                          ref
                              .read(quoteProvider.notifier)
                              .update((state) => quote);
                        });
                      },
                      focusNode: _nodeText3,
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value != "") {
                          if (!Uri.parse(value!).isAbsolute) {
                            return 'URLが不正です。';
                          }
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              )),
        ));
  }
}
