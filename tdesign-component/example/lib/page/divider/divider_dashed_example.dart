import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

final dividerDashedExampleItem = ExampleItem(
  key: const Key('divider-dashed-example'),
  desc: '虚线样式',
  center: false,
  methodName: 'DividerDashedExample',
  builder: (_) => const DividerDashedExample(),
);

@ExampleCode(group: 'divider')
class DividerDashedExample extends StatelessWidget {
  const DividerDashedExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TDivider(dashed: true),
          TDivider(
            dashed: true,
            child: Text('文字信息'),
            align: TDividerAlign.left,
          ),
          TDivider(dashed: true, child: Text('文字信息')),
          TDivider(
            dashed: true,
            child: Text('文字信息'),
            align: TDividerAlign.right,
          ),
        ],
      ),
    );
  }
}
