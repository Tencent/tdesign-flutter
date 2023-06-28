import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:markdown/markdown.dart' as md;
import 'package:tdesign_flutter/td_export.dart';

import 'syntax_highlighter.dart';

class CodeWidget extends StatefulWidget {
  const CodeWidget({Key? key, this.codePath}) : super(key: key);

  final String? codePath;

  @override
  State<CodeWidget> createState() => _CodeWidgetState();
}

class _CodeWidgetState extends State<CodeWidget> {
  String? result;
  String? lastApiName;

  @override
  void initState() {
    super.initState();
    getCodeData();
  }

  Future<String> getCodeData() async {
    const defaultResult = '加载失败';
    if (widget.codePath == lastApiName &&
        result != null &&
        result != defaultResult) {
      return result!;
    }
    try {
      var url = 'https://raw.githubusercontent.com/TDesignOteam/tdesign-flutter/main/example/lib/page/td_${widget.codePath}_page.dart';

      print('getCodeData url:$url');
      var resp = await http.get(Uri.parse(url));
      result = String.fromCharCodes(resp.body.codeUnits);
      lastApiName = widget.codePath;
    } catch (e) {
      print('getCodeData error: $e');
    }
    return result ?? defaultResult;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft,
        child: FutureBuilder(
          future: getCodeData(),
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  Container(
                    height: 36,
                    color: TDTheme.of(context).brandColor1,
                    child: Row(
                      children: [
                        GestureDetector(
                          child: const Icon(TDIcons.file_copy),
                          onTap: () {
                            if (result != null) {
                              Clipboard.setData(ClipboardData(text: result!));
                              TDToast.showText('复制成功', context: context);
                            } else {
                              TDToast.showText('复制失败', context: context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Markdown(
                    padding: EdgeInsets.zero,
                    selectable: true,
                    shrinkWrap: true,
                    syntaxHighlighter: DartSyntaxHighlighter(),
                    data: '''
```dart
${snapshot.data}
```
                  ''',
                    extensionSet: md.ExtensionSet(
                      md.ExtensionSet.gitHubWeb.blockSyntaxes,
                      [
                        md.EmojiSyntax(),
                        ...md.ExtensionSet.gitHubWeb.inlineSyntaxes
                      ],
                    ),
                  ))
                ],
              );
            } else {
              return Container(
                alignment: Alignment.topLeft,
                child: const TDText('加载中…'),
              );
            }
          },
        ));
  }
}
