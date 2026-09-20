import 'package:flutter/material.dart';

/// 组件库相关的，只需要引入这个文件，里面暴露td前缀所有需要的类
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'theme_function_color_example.dart';
import 'theme_other_color_example.dart';
import 'theme_text_color_example.dart';

@ExampleCodeManifest()
/// 主题颜色示例页
class TThemeColorsPage extends StatefulWidget {
  const TThemeColorsPage({Key? key}) : super(key: key);

  @override
  _TThemeColorsPageState createState() => _TThemeColorsPageState();
}

class _TThemeColorsPageState extends State<TThemeColorsPage> {
  final brandMap = <String, Color>{};
  final errorMap = <String, Color>{};
  final warningMap = <String, Color>{};
  final successMap = <String, Color>{};
  final grayMap = <String, Color>{};

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '点击标题栏右上角图标可查看使用示例代码',
      exampleCodeGroup: 'theme',
      children: [
        ExampleModule(
          title: '颜色示例',
          children: [
            ExampleItem(
              desc: '功能色',
              methodName: 'ThemeFunctionColorExample',
              builder: (_) => const ThemeFunctionColorExample(),
            ),
            ExampleItem(
              desc: '文字&图标颜色',
              methodName: 'ThemeTextColorExample',
              builder: (_) => const ThemeTextColorExample(),
            ),
            ExampleItem(
              desc: '中性色板',
              methodName: 'ThemeOtherColorExample',
              builder: (_) => const ThemeOtherColorExample(),
            ),
          ],
        ),
      ],
      test: [
        ExampleItem(builder: _buildDefaultTheme),
        ExampleItem(builder: _buildCustomTheme),
      ],
    );
  }

  var fontMap = <String, Color>{};

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.tTheme.colorMap.forEach((key, value) {
        if (key.startsWith('brand')) {
          brandMap[key] = value;
        } else if (key.startsWith('error')) {
          errorMap[key] = value;
        } else if (key.startsWith('warning')) {
          warningMap[key] = value;
        } else if (key.startsWith('success')) {
          successMap[key] = value;
        } else if (key.startsWith('font')) {
          fontMap[key] = value;
        } else {
          grayMap[key] = value;
        }
      });

      context.tTheme.refMap.forEach((key, value) {
        var color = context.tTheme.colorMap[key];
        if (color == null) {
          return;
        }
        if (key.startsWith('brand')) {
          brandMap[key] = color;
        } else if (key.startsWith('error')) {
          errorMap[key] = color;
        } else if (key.startsWith('warning')) {
          warningMap[key] = color;
        } else if (key.startsWith('success')) {
          successMap[key] = color;
        } else if (key.startsWith('font')) {
          fontMap[key] = color;
        } else {
          grayMap[key] = color;
        }
      });
      setState(() {});
    });
  }

  Widget _buildDefaultTheme(BuildContext context) {
    // 通过context.tTheme.xxx使用公共主题属性
    return Container(
      margin: EdgeInsets.all(context.tTheme.spacer8),
      padding: EdgeInsets.all(context.tTheme.spacer8),
      decoration: BoxDecoration(
        color: context.tTheme.bgColorSecondaryContainer,
        borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
        boxShadow: context.tTheme.shadowsBase,
      ),
      child: TText(
        '使用外层默认主题',
        font: context.tTheme.fontBodyLarge, // 字体，业务方使用时，
        textColor: context.tTheme.brandNormalColor, // 颜色，AS中点击颜色可查看具体设置和显示效果
      ),
    );
  }

  Widget _buildCustomTheme(BuildContext context) {
    /// 此处替换主题
    return Theme(
      // 替换fonts和colors，其他主题从父类拷贝
      data: Theme.of(context).copyWith(
        extensions: [
          context.tTheme.copyWithTThemeData(
            'custom',
            fontMap: {'fontBodyLarge': Font(size: 40, lineHeight: 80)},
            colorMap: {'brandNormalColor': Colors.red},
          ),
        ],
      ),
      // 不能直接在此处使用context，这里虽然被包裹在TGTheme中，但是context未更新，因此读不到最新数据
      child: const TestWidget(),
    );
  }
}

/// 测试控件
class TestWidget extends StatelessWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TText(
            '使用内层赋值主题',
            font: context.tTheme.fontBodyLarge, //明确使用内层主题，必须传context
            textColor: context.tTheme.brandNormalColor, // 明确使用内层主题，必须传context
          ),
          TText(
            '使用内层不赋值主题',
            font: context.tTheme.fontTitleExtraLarge, //明确使用内层主题，必须传context
            textColor: context.tTheme.successNormalColor, // 明确使用内层主题，必须传context
          ),
          const TButton(
            child: Text('使用内层赋值主题'),
            colorScheme: TButtonColorScheme.primary,
          ),
          TText(
            '使用默认主题',
            font: TThemeData.defaultData()
                .fontBodyLarge, //不传context，使用默认主题，此处是外层的主题
            textColor: TThemeData.defaultData().brandNormalColor,
          ),
        ],
      ),
    );
  }
}

/// 扩展主题属性示例
extension TGLayouts on TThemeData {
  /// 因为扩展中不能声明字段，只能借助TExtraThemeData
  double get layout1 => ofExtra<LayoutExtra>()?.layouts['layout1'] ?? 0;

  Data2? get data2 => ofExtra<LayoutExtra>()?.data2;
}

class LayoutExtra extends TExtraThemeData {
  Map<String, double> layouts = {};
  Data2? data2;

  @override
  void parse(String name, Map<String, dynamic> curThemeMap) {}
}

/// 二级扩展测试
class Data2 {}

extension Data2Ext on Data2 {
  String get test => 'test';
}

// 注：原 test() 函数使用 null.tTheme 验证扩展链编译，
// 重构后 tTheme 扩展挂在 BuildContext 上，null 不再合法，且该函数从未被调用，故移除。
