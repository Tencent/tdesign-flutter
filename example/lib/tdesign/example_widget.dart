import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:tdesign_flutter/td_export.dart';

import '../web/syntax_highlighter.dart';
import 'api_widget.dart';
import 'example_base.dart';

/// 示例页面控件，建议每个页面返回一个ExampleWidget即可，不用独自封装
class ExamplePage extends StatefulWidget {
  const ExamplePage({
    Key? key,
    required this.title,
    this.desc = '',
    required this.children,
    this.padding,
    this.backgroundColor,
    this.exampleCodeGroup,
  }) : super(key: key);

  final String title;
  final String desc;
  final List<ExampleModule> children;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final String? exampleCodeGroup;

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  late List<ExampleModule> list;
  bool apiVisible = false;
  ExamplePageModel? model;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var modelTheme = context
          .dependOnInheritedWidgetOfExactType<ExamplePageInheritedTheme>();
      model = modelTheme?.model;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: widget.backgroundColor,
        body: ScrollbarTheme(
            data: ScrollbarThemeData(
                trackVisibility: MaterialStateProperty.all(true)),
            child: Column(
              children: [
                _buildNavBar(),
                Expanded(
                    child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  itemCount: widget.children.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildHeader(context);
                    }
                    var data = widget.children[index - 1];
                    return _buildModule(index, data, context);
                  },
                ))
              ],
            )));
  }

  Widget _buildNavBar() {
    return TDNavBar(
      title: widget.title,
      rightBarItems: [
        TDNavBarItem(
            icon: TDIcons.info_circle,
            action: () {
              setState(() {
                apiVisible = !apiVisible;
              });
            })
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ApiWidget(
            apiName: model?.apiPath,
            visible: apiVisible,
          ),
          TDText(
            widget.title,
            font: TDTheme.of(context).fontHeadlineSmall,
            textColor: TDTheme.of(context).fontGyColor1,
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 4,
            ),
            child: TDText(
              widget.desc,
              font: TDTheme.of(context).fontBodyMedium,
              textColor: TDTheme.of(context).fontGyColor2,
            ),
          ),
          // Expanded(child: ),
        ],
      ),
    );
  }

  Widget _buildModule(int index, ExampleModule data, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: TDText(
            '${index < 10 ? "0$index" : index} ${data.title}',
            font: TDTheme.of(context).fontTitleLarge,
            textColor: TDTheme.of(context).fontGyColor1,
          ),
        ),
        for (var item in data.children) _buildExampleItem(item)
      ],
    );
  }

  Widget _buildExampleItem(ExampleItem data) {
    return Container(
      margin: widget.padding,
      child: ExampleItemWidget(
        data: data,
        apiVisible: apiVisible,
        exampleCodeGroup: widget.exampleCodeGroup,
      ),
    );
  }
}

/// 示例模块
class ExampleModule {
  const ExampleModule({Key? key, required this.title, required this.children});

  final String title;

  final List<ExampleItem> children;
}

/// 示例样例数据
class ExampleItem {
  const ExampleItem(
      {Key? key, this.desc = '', required this.builder, this.center = true});

  final String desc;

  final WidgetBuilder builder;

  final bool center;
}

/// 组件示例
class ExampleItemWidget extends StatefulWidget {
  const ExampleItemWidget(
      {required this.data,
      required this.apiVisible,
      this.exampleCodeGroup,
      Key? key})
      : super(key: key);

  final ExampleItem data;

  final bool apiVisible;

  final String? exampleCodeGroup;

  @override
  State<ExampleItemWidget> createState() => _ExampleItemWidgetState();
}

class _ExampleItemWidgetState extends State<ExampleItemWidget> {
  @override
  Widget build(BuildContext context) {
    var child = widget.data.builder(context);
    if (widget.data.center) {
      child = Center(
        child: widget.data.builder(context),
      );
    }
    if (widget.apiVisible) {
      child = Stack(
        children: [
          child,
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: _showCodePanel,
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  alignment: Alignment.center,
                  child: TDText(
                    'code',
                    textColor: TDTheme.of(context).whiteColor1,
                  ),
                ),
              ))
        ],
      );
    }
    child = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.data.desc.isEmpty
            ? Container()
            : Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(
                    left: 16, right: 16, top: 8, bottom: 8),
                child: TDText(
                  widget.data.desc,
                  font: TDTheme.of(context).fontBodyMedium,
                  textColor: TDTheme.of(context).fontGyColor2,
                ),
              ),
        child
      ],
    );
    return child;
  }

  String _getCodeAssetsPath() {
    var methodName = '';
    var builderString = widget.data.builder.toString();
    if (builderString.contains('\'')) {
      var strings = builderString.split('\'');
      if (strings.length > 1) {
        methodName = strings[1];
        if (methodName.isNotEmpty && methodName.contains('@')) {
          methodName = methodName.split('@')[0];
        }
      }
    }
    if (methodName.isNotEmpty) {
      print('example code methodName: $methodName');
      return 'assets/code/${widget.exampleCodeGroup}.$methodName.txt';
    }
    return '';
  }

  void _showCodePanel() async {
    var assetsPath = _getCodeAssetsPath();
    var codeString = '';
    if (assetsPath.isNotEmpty) {
      try {
        codeString = await rootBundle.loadString(assetsPath);
      } catch (e) {
        print(e);
      }
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        barrierColor: Colors.black.withOpacity(0.5),
        backgroundColor: Colors.transparent,
        context: context,
        builder: (_) {
          if (codeString.isEmpty) {
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: TDTheme.of(context).grayColor1,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(TDTheme.of(context).radiusDefault ?? 6))),
              height: 500,
              child: const TDText('暂无演示代码'),
            );
          }
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: TDTheme.of(context).grayColor1,
                borderRadius: BorderRadius.vertical(top: Radius.circular(TDTheme.of(context).radiusDefault ?? 6))),
            height: 500,
            child: SingleChildScrollView(
              child: Markdown(
                padding: EdgeInsets.zero,
                selectable: true,
                shrinkWrap: true,
                syntaxHighlighter: DartSyntaxHighlighter(),
                data: '''
```dart
${codeString}
```
                  ''',
                extensionSet: md.ExtensionSet(
                  md.ExtensionSet.gitHubWeb.blockSyntaxes,
                  [
                    md.EmojiSyntax(),
                    ...md.ExtensionSet.gitHubWeb.inlineSyntaxes
                  ],
                ),
              ),
            ),
          );
        });
  }
}
