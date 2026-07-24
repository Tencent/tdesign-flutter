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
      appBar: AppBar(title: Text('${model?.text} API')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ApiWidget(apiName: model?.name),
        ),
      ),
    );
  }
}

class ApiWidget extends StatefulWidget {
  const ApiWidget({
    Key? key,
    required this.apiName,
  }) : super(key: key);

  final String? apiName;

  @override
  State<ApiWidget> createState() => _ApiWidgetState();
}

class _ApiWidgetState extends State<ApiWidget> {
  String? result;
  String? lastApiName;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getApiData(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            margin: const EdgeInsets.only(bottom: 64),
            child: Markdown(
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
          return const Center(
            // TEMPORARY MIGRATION COMPATIBILITY:
            // Loading 暂未纳入本基础组件 PR，先使用 Flutter 原生 loading 占位。
            // 后续 Loading 组件迁移后恢复为 TLoading。
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 8),
                Text('加载中…'),
              ],
            ),
          );
        }
      },
    );
  }

  Future<String> getApiData() async {
    const defaultResult = '''
## API

暂无对应api
    ''';
    if (widget.apiName == lastApiName &&
        result != null &&
        result != defaultResult) {
      return result!;
    }
    try {
      var apiName = widget.apiName ?? 'default';
      result = await rootBundle.loadString('assets/api/${apiName}_api.md');
      lastApiName = widget.apiName;
    } catch (e) {
      debugPrint('getApiData error: $e');
    }
    return result ?? defaultResult;
  }
}
