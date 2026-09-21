import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';

@ExampleCode(group: 'tag')
class TagSelectVariantsExample extends StatefulWidget {
  const TagSelectVariantsExample({super.key});

  @override
  State<TagSelectVariantsExample> createState() =>
      _TagSelectVariantsExampleState();
}

class _TagSelectVariantsExampleState extends State<TagSelectVariantsExample> {
  final _values = <TTagVariant, List<bool>>{
    TTagVariant.light: [false, true],
    TTagVariant.dark: [false, true],
    TTagVariant.outline: [false, true],
    TTagVariant.lightOutline: [false, true],
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _row('light', TTagVariant.light),
          _row('dark', TTagVariant.dark),
          _row('outline', TTagVariant.outline),
          _row('light-outline', TTagVariant.lightOutline),
        ],
      ),
    );
  }

  Widget _row(String label, TTagVariant variant) {
    final values = _values[variant]!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(width: 88, child: TText(label)),
          TSelectTag(
            '未选中态',
            value: values[0],
            variant: variant,
            onChanged: (value) => setState(() => values[0] = value),
          ),
          const SizedBox(width: 8),
          TSelectTag(
            '已选中态',
            value: values[1],
            variant: variant,
            onChanged: (value) => setState(() => values[1] = value),
          ),
        ],
      ),
    );
  }
}
