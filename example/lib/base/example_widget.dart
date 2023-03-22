import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:tdesign_flutter/td_export.dart';

import '../page/td_theme_page.dart';
import '../web/syntax_highlighter.dart';
import 'api_widget.dart';
import 'example_base.dart';
import 'example_route.dart';
import 'notification_center.dart';

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
    this.test = const [],
  }) : super(key: key);

  final String title;
  final String desc;
  final List<ExampleModule> children;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final String? exampleCodeGroup;
  final List<ExampleItem> test;

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  late List<ExampleModule> list;
  bool apiVisible = false;
  ExamplePageModel? model;
  bool showAction = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var modelTheme = context
          .dependOnInheritedWidgetOfExactType<ExamplePageInheritedTheme>();
      model = modelTheme?.model;
      model?.codePath = widget.exampleCodeGroup;
      model?.apiVisible = apiVisible;
      setState(() {
        showAction = model?.showAction ?? false;
      });
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNavBar(),
                Expanded(
                    child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 24, bottom: 24),
                  itemCount: widget.children.length + 2,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildHeader(context);
                    }
                    ExampleModule data;
                    if (index <= widget.children.length) {
                      data = widget.children[index - 1];
                    } else {
                      data = ExampleModule(
                          title: '单元测试',
                          children: [_buildTestExampleItem(), ...widget.test]);
                    }
                    return _buildModule(index, data, context);
                  },
                ))
              ],
            )));
  }

  ExampleItem _buildTestExampleItem() =>
      ExampleItem(desc: '''未在示例稿中体现，但有必要验证的组件样式，请添加到'test'参数中。以下情景必须有测试：
  1.参数为数字。需测试数字为负数、0、较大数值的场景。
  2.参数为枚举，需测试所有枚举组合（示例已有的可不写）''', builder: (_) => const TDDivider());

  Widget _buildNavBar() {
    var rightBarItems = <TDNavBarItem>[];

    if (showAction) {
      rightBarItems.add(TDNavBarItem(
          icon: TDIcons.info_circle,
          action: () {
            Navigator.pushNamed(context, TDExampleRoute.getApiPath(model));
          }));
      if (!PlatformUtil.isWeb) {
        rightBarItems.add(TDNavBarItem(
            icon: TDIcons.code,
            action: () {
              setState(() {
                apiVisible = !apiVisible;
                if (model != null) {
                  model!.apiVisible = apiVisible;
                }
              });
              TNotification.postNotification(
                  'onApiVisibleChange', {'apiVisible': apiVisible});
            }));
      }
    }
    return TDNavBar(
      title: widget.title,
      rightBarItems:  rightBarItems,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16,right: 16,),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          margin: const EdgeInsets.only(left: 16, right: 16, top: 32),
          child: TDText(
            '${index < 10 ? "0$index" : index} ${data.title}',
            font: TDTheme.of(context).fontTitleLarge,
            textColor: TDTheme.of(context).fontGyColor1,
            fontWeight: FontWeight.bold,
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
      {Key? key,
      this.desc = '',
      required this.builder,
      this.methodName,
      this.center = true,
      this.ignoreCode = false});

  final String desc;

  final WidgetBuilder builder;

  final String? methodName;

  final bool center;

  final bool ignoreCode;
}

/// 组件示例
class ExampleItemWidget extends StatefulWidget {
  const ExampleItemWidget({required this.data, Key? key}) : super(key: key);

  final ExampleItem data;

  @override
  State<ExampleItemWidget> createState() => _ExampleItemWidgetState();
}

class _ExampleItemWidgetState extends State<ExampleItemWidget> {
  @override
  Widget build(BuildContext context) {
    Widget child;
    if (widget.data.ignoreCode) {
      child = widget.data.builder(context);
      if (widget.data.center) {
        child = Center(
          child: widget.data.builder(context),
        );
      }
    } else {
      child = CodeWrapper(
        builder: widget.data.builder,
        methodName: widget.data.methodName,
        isCenter: widget.data.center,
      );
    }
    child = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: widget.data.center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        widget.data.desc.isEmpty
            ? Container()
            : Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(
                    left: 16, right: 16, top: 8, bottom: 16),
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
}

class CodeWrapper extends StatefulWidget {
  const CodeWrapper(
      {Key? key, required this.builder, this.methodName, this.isCenter = false})
      : super(key: key);

  final WidgetBuilder builder;

  final bool isCenter;

  final String? methodName;

  @override
  State<CodeWrapper> createState() => _CodeWrapperState();
}

class _CodeWrapperState extends State<CodeWrapper> {
  bool apiVisible = false;

  String exampleCodeGroup = '';

  @override
  void initState() {
    super.initState();
    TNotification.addObserver('onApiVisibleChange', (arguments) {
      if (arguments is Map) {
        setState(() {
          apiVisible = arguments['apiVisible'] ?? false;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        var modelTheme = context
            .dependOnInheritedWidgetOfExactType<ExamplePageInheritedTheme>();
        exampleCodeGroup = modelTheme?.model.codePath ?? '';
        apiVisible = modelTheme?.model.apiVisible ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var child = widget.builder(context);
    if (widget.isCenter) {
      child = Center(
        child: widget.builder(context),
      );
    }
    if (apiVisible) {
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
    return child;
  }

  String _getCodeAssetsPath() {
    var methodName = widget.methodName ?? '';

    var builderString = widget.builder.toString();
    if (methodName.isEmpty) {
      if (builderString.contains('\'')) {
        var strings = builderString.split('\'');
        if (strings.length > 1) {
          methodName = strings[1];
          if (methodName.isNotEmpty && methodName.contains('@')) {
            methodName = methodName.split('@')[0];
          }
        }
      }
    }
    if (methodName.isNotEmpty && exampleCodeGroup.isNotEmpty) {
      print('example code methodName: $methodName');
      return 'assets/code/${exampleCodeGroup}.$methodName.txt';
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
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(TDTheme.of(context).radiusDefault))),
              height: 500,
              child: TDText(PlatformUtil.isWeb ? 'web不支持演示代码，请在移动端查看' : '暂无演示代码'),
            );
          }

          var lines = codeString.split('\n');
          print('lines: ${lines.length}');
          double height = min(max(300, lines.length * 17 + 32),MediaQuery.of(context).size.height - 150);
          var mdText = '''
```dart
${codeString}
```
                  ''';
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: TDTheme.of(context).grayColor1,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(TDTheme.of(context).radiusDefault))),
            height: height,
            child: Markdown(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              selectable: true,
              shrinkWrap: true,
              syntaxHighlighter: DartSyntaxHighlighter(),
              data: mdText,
              extensionSet: md.ExtensionSet(
                md.ExtensionSet.gitHubWeb.blockSyntaxes,
                [md.EmojiSyntax(), ...md.ExtensionSet.gitHubWeb.inlineSyntaxes],
              ),
            ),
          );
        });
  }
}

/// State获取标题的扩展
extension TDStateExs on State{

  String tdTitle(){
    var modelTheme = context
        .dependOnInheritedWidgetOfExactType<ExamplePageInheritedTheme>();
    return modelTheme?.model.text ?? '';
  }

}

/// StatelessWidget获取标题的扩展
extension TDWidgetExs on StatelessWidget{

  String tdTitle(BuildContext context){
    var modelTheme = context
        .dependOnInheritedWidgetOfExactType<ExamplePageInheritedTheme>();
    return modelTheme?.model.text ?? '';
  }

}