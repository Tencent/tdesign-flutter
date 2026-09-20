/// 组件库相关的，只需要引入这个文件，里面暴露td前缀所有需要的类
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';

@ExampleCode(group: 'theme')
class ThemeOtherColorExample extends StatefulWidget {
  const ThemeOtherColorExample({super.key});

  @override
  State<ThemeOtherColorExample> createState() => _ThemeOtherColorExampleState();
}

class _ThemeOtherColorExampleState extends State<ThemeOtherColorExample> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    grayMap
      ..clear()
      ..addEntries(
        context.tTheme.colorMap.entries.where(
          (entry) =>
              !entry.key.startsWith('brand') &&
              !entry.key.startsWith('error') &&
              !entry.key.startsWith('warning') &&
              !entry.key.startsWith('success') &&
              !entry.key.startsWith('font'),
        ),
      );
  }

  Widget _buildOtherColor(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: grayMap.length,
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var light = index < 6;
        if (index == 0) {
          return Container(
            color: context.tTheme.bgColorContainer,
            child: const TText('whiteColor1'),
          );
        } else {
          return Container(
            color: context.tTheme.colorMap['grayColor${index}'],
            child: TText(
              'grayColor${index}',
              textColor: light ? Colors.black : Colors.white,
            ),
          );
        }
      },
    );
  }

  var grayMap = <String, Color>{};

  @override
  Widget build(BuildContext context) {
    return _buildOtherColor(context);
  }
}
