/// 组件库相关的，只需要引入这个文件，里面暴露td前缀所有需要的类
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';

@ExampleCode(group: 'theme')
class ThemeFunctionColorExample extends StatefulWidget {
  const ThemeFunctionColorExample({super.key});

  @override
  State<ThemeFunctionColorExample> createState() =>
      _ThemeFunctionColorExampleState();
}

class _ThemeFunctionColorExampleState extends State<ThemeFunctionColorExample> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    brandMap.clear();
    errorMap.clear();
    warningMap.clear();
    successMap.clear();
    _collect(context.tTheme.colorMap);
    for (final key in context.tTheme.refMap.keys) {
      final color = context.tTheme.colorMap[key];
      if (color != null) {
        _collect({key: color});
      }
    }
  }

  void _collect(Map<String, Color> colors) {
    colors.forEach((key, value) {
      if (key.startsWith('brand')) {
        brandMap[key] = value;
      }
      if (key.startsWith('error')) {
        errorMap[key] = value;
      }
      if (key.startsWith('warning')) {
        warningMap[key] = value;
      }
      if (key.startsWith('success')) {
        successMap[key] = value;
      }
    });
  }

  Widget _buildFunctionColor(BuildContext context) {
    var functionList = ['brand', 'error', 'warning', 'success'];
    if (brandMap.length == errorMap.length &&
        warningMap.length == successMap.length &&
        brandMap.length == warningMap.length) {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: brandMap.length * 4,
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          var type = index ~/ brandMap.length;
          index = index % brandMap.length;
          var function = functionList[type];
          var map = {};
          if (type == 0) {
            map = brandMap;
          } else if (type == 1) {
            map = errorMap;
          } else if (type == 2) {
            map = warningMap;
          } else if (type == 3) {
            map = successMap;
          }
          if (index < 10) {
            return Container(
              color: context.tTheme.colorMap['${function}Color${index + 1}'],
              child: TText('${function}Color${index + 1}'),
            );
          } else {
            return Container(
              color: map.values.elementAt(index),
              child: TText(map.keys.elementAt(index)),
            );
          }
        },
      );
    } else {
      return TText('功能色数量不一样', textColor: context.tTheme.errorNormalColor);
    }
  }

  var brandMap = <String, Color>{};

  var errorMap = <String, Color>{};

  var warningMap = <String, Color>{};

  var successMap = <String, Color>{};

  @override
  Widget build(BuildContext context) {
    return _buildFunctionColor(context);
  }
}
