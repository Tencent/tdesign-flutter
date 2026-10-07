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
  const ApiWidget({Key? key, required this.apiName}) : super(key: key);

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
          return Center(
            child: Theme(
              // TLoading 已移除 themeData 构造参数，改用 mergeExtension 注入子树主题
              data: Theme.of(
                context,
              ).mergeExtension(const TLoadingThemeData(axis: Axis.horizontal)),
              child: const TLoading(
                size: 32,
                icon: TLoadingIcon.circle,
                text: '加载中…',
              ),
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
    final requestedName = widget.apiName;
    if (requestedName == lastApiName &&
        result != null &&
        result != defaultResult) {
      return result!;
    }
    try {
      // Demo route names predate the canonical API slugs (backtop/back-top,
      // tabBar/tab-bar). Resolve the real asset without maintaining aliases.
      String normalize(String name) =>
          name.replaceAll(RegExp('[-_]'), '').toLowerCase();
      const prefix = 'assets/api/';
      const suffix = '_api.md';
      final name = normalize(requestedName ?? 'default');
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final asset = manifest.listAssets().singleWhere(
        (asset) =>
            asset.startsWith(prefix) &&
            asset.endsWith(suffix) &&
            normalize(
                  asset.substring(prefix.length, asset.length - suffix.length),
                ) ==
                name,
      );
      final data = await rootBundle.loadString(asset);
      if (widget.apiName == requestedName) {
        result = data;
        lastApiName = requestedName;
      }
      return data;
    } catch (e) {
      debugPrint('getApiData error: $e');
      if (widget.apiName == requestedName) {
        result = defaultResult;
        lastApiName = requestedName;
      }
      return defaultResult;
    }
  }
}
