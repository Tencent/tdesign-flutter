import 'package:flutter/material.dart';

/// 组件库相关的，只需要引入这个文件，里面暴露td前缀所有需要的类
import 'package:tdesign_flutter/td_export.dart';
import 'package:tdesign_flutter_example/tdesign/example_widget.dart';

/// 主题示例页

class TDThemePage extends StatefulWidget {
  const TDThemePage({Key? key}) : super(key: key);

  @override
  _TDThemePageState createState() => _TDThemePageState();
}

class _TDThemePageState extends State<TDThemePage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(title: '主题示例', children: [
      Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 使用示例
              TDText(
                '使用外层待赋值主题',
                font:
                    TDTheme.of(context).fontM, // 业务方使用时，如果明确跟随全局主题，可以不传context
                textColor:
                    TDTheme.of(context).brandNormalColor, // 点击颜色可查看具体设置和显示效果
              ),

              /// 使用示例
              TDText(
                '使用外层不赋值主题',
                font:
                    TDTheme.of(context).fontL, // 业务方使用时，如果明确跟随全局主题，可以不传context
                textColor:
                    TDTheme.of(context).successNormalColor, // 点击颜色可查看具体设置和显示效果
              ),

              /// 此处替换主题
              TDTheme(
                  // 替换fonts和colors，其他主题从父类拷贝
                  data: TDTheme.of(context).copyWith('custom', fontMap: {
                    'fontM': Font(size: 40, lineHeight: 80),
                  }, colorMap: {
                    'brandNormalColor': Colors.red
                  }),
                  // 不能直接在此处使用contxt，这里虽然被包裹在TGTheme中，但是context未更新，因此阿不到最新数据
                  child: const TestWidget()),
            ],
          ))
    ]);
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
          TDText(
            '使用内层赋值主题',
            font: TDTheme.of(context).fontM, //明确使用内层主题，必须传context
            textColor:
                TDTheme.of(context).brandNormalColor, // 明确使用内层主题，必须传context
          ),
          TDText(
            '使用内层不赋值主题',
            font: TDTheme.of(context).fontL, //明确使用内层主题，必须传context
            textColor:
                TDTheme.of(context).successNormalColor, // 明确使用内层主题，必须传context
          ),
          TDText(
            '使用默认主题',
            font: TDTheme.defaultData().fontM, //不传context，使用默认主题，此处是外层的主题
            textColor: TDTheme.defaultData().brandNormalColor,
          ),
        ],
      ),
    );
  }
}

/// 扩展主题属性示例
extension TGLayouts on TDThemeData {
  /// 因为扩展中不能声明字段，只能借助TDExtraThemeData
  double get layout1 => ofExtra<LayoutExtra>()?.layouts['layout1'] ?? 0;

  Data2? get data2 => ofExtra<LayoutExtra>()?.data2;
}

class LayoutExtra extends TDExtraThemeData {
  Map<String, double> layouts = {};
  Data2? data2;

  @override
  void parse(String name, Map<String, dynamic> curThemeMap) {
    // TODO: implement parse
  }
}

/// 二级扩展测试
class Data2 {}

extension Data2Ext on Data2 {
  String get test => 'test';
}

void test() {
  TDTheme.of(null).layout1;
  TDTheme.of(null).data2!.test;
}
