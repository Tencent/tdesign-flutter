
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class ApiWidget extends StatefulWidget {
  const ApiWidget({Key? key, required this.apiName}) : super(key: key);

  final String apiName;

  @override
  State<ApiWidget> createState() => _ApiWidgetState();
}

class _ApiWidgetState extends State<ApiWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      child: FutureBuilder(
        future: getApiData(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Markdown(
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              selectable: true,
              data: snapshot.data ?? '',
              extensionSet: md.ExtensionSet(
                md.ExtensionSet.gitHubWeb.blockSyntaxes,
                [md.EmojiSyntax(), ...md.ExtensionSet.gitHubWeb.inlineSyntaxes],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<String> getApiData() async {
    // print('加载文档：assets/doc/$name.md');
    var result =  rootBundle.loadString('assets/api/${widget.apiName}_api.md');
    return result;
  }
}