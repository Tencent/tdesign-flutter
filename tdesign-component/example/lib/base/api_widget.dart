
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'example_base.dart';

/// API展示页面
class ApiPage extends StatelessWidget {
  const ApiPage({Key? key, this.model}) : super(key: key);

  final ExamplePageModel? model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: TDText('${model?.text} API', textColor: TDTheme.of(context).whiteColor1,),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ApiWidget(apiName: model?.name, visible: true,),
        ),
      ),
    );
  }
}


class ApiWidget extends StatefulWidget {
  const ApiWidget({Key? key, required this.apiName, this.visible = false}) : super(key: key);

  final bool visible;

  final String? apiName;

  @override
  State<ApiWidget> createState() => _ApiWidgetState();
}

class _ApiWidgetState extends State<ApiWidget> {

  String? result;
  String? lastApiName;

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: widget.visible,
        child: FutureBuilder(
      future: getApiData(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            margin: const EdgeInsets.only(bottom: 64),
            child:  Markdown(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              selectable: true,
              data: snapshot.data ?? '',
              extensionSet: md.ExtensionSet(
                md.ExtensionSet.gitHubWeb.blockSyntaxes,
                [md.EmojiSyntax(), ...md.ExtensionSet.gitHubWeb.inlineSyntaxes],
              ),
            ),
          );
        } else {
          return  Container(
            alignment: Alignment.topLeft,
            child: const TDText('加载中…'),
          );
        }
      },
    ));
  }

  Future<String> getApiData() async {
    const defaultResult = '''
## API

暂无对应api
    ''';
    if(widget.apiName == lastApiName && result != null && result != defaultResult){
      return result!;
    }
    try {
      var apiName = widget.apiName ?? 'default';
      result =  await rootBundle.loadString('assets/api/${apiName}_api.md');
      lastApiName = widget.apiName;
    } catch (e) {
      print('getApiData error: $e');
    }
    return result ?? defaultResult;
  }
}