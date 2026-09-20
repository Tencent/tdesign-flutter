import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'picker_area_example.dart';
import 'picker_base_example.dart';
import 'picker_time_example.dart';
import 'picker_title_example.dart';

@ExampleCodeManifest()
class TPickerPage extends StatefulWidget {
  const TPickerPage({super.key});

  @override
  State<TPickerPage> createState() => _TPickerPageState();
}

class _TPickerPageState extends State<TPickerPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于一组预设数据中的选择。',
      exampleCodeGroup: 'picker',
      compactDemo: true,
      // Figma Demo 页面底色；深色模式继续使用当前主题。
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF6F6F6)
          : context.tTheme.bgColorPage,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '基础选择器',
              methodName: 'PickerBaseExample',
              builder: (_) => const PickerBaseExample(),
            ),
            ExampleItem(
              desc: '',
              methodName: 'PickerTimeExample',
              builder: (_) => const PickerTimeExample(),
            ),
            ExampleItem(
              desc: '',
              methodName: 'PickerAreaExample',
              builder: (_) => const PickerAreaExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '是否带标题',
              methodName: 'PickerTitleExample',
              builder: (_) => const PickerTitleExample(),
            ),
          ],
        ),
      ],
    );
  }

  /// 核心组合片段：放入调用方 Widget，导入 flutter/material.dart 和
  /// tdesign_flutter/tdesign_flutter.dart。数据与状态由调用方提供：
  /// value 是 State 持有的不可变列表，onConfirm 用 setState 保存新列表；
  /// 取消不调用 onConfirm，弹层内 onChanged 只更新草稿。
  ///
  /// 本页城市为 TPickerColumns，初始值 ['shenzhen']；时间为两列，
  /// 初始值 [2020, 'autumn']；地区为 TPickerLinked，初始值
  /// ['guangdong', 'shenzhen', 'futian']。带标题与无标题共用城市数据，
  /// popupTitle 分别传 '选择地区' 与 null。id 仅用于示例定位 Key。
}
