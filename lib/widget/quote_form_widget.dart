import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class QuoteFormWidget extends StatefulWidget {
  final String? quoteId, initialTitle, initialUrl, initialContent;
  const QuoteFormWidget({
    Key? key,
    required this.quoteId,
    required this.initialTitle,
    required this.initialUrl,
    required this.initialContent,
  }) : super(key: key);

  @override
  State<QuoteFormWidget> createState() => _QuoteFormWidgetState();
}

class _QuoteFormWidgetState extends State<QuoteFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late String title = widget.initialTitle ?? "";
  late String url = widget.initialUrl ?? "";
  late String content = widget.initialContent ?? "";

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
    return KeyboardActions(
                      config: _buildConfig(context),
                      child: SingleChildScrollView(
                          child: Container(
                              margin: const EdgeInsets.only(
                                  top: 64, right: 32, left: 32),
                              child: Form(
                                key: _formKey,
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
                                      maxLength: 200,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "必須項目です";
                                        }
                                        if (value.trim() == '') {
                                          return "必須項目です";
                                        }
                                        return null;
                                      },
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
                              ))));
  }
}
