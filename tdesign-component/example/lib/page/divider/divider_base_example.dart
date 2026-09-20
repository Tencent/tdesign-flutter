import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';

@ExampleCode(group: 'divider')
class DividerBaseExample extends StatelessWidget {
  const DividerBaseExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TDivider(),
          _sectionTitle(context, '带文字水平分割线'),
          const TDivider(child: Text('文字信息'), align: TDividerAlign.left),
          const TDivider(child: Text('文字信息')),
          const TDivider(child: Text('文字信息'), align: TDividerAlign.right),
          _sectionTitle(context, '垂直分割线'),
          const Padding(
            padding: EdgeInsetsDirectional.only(start: 16),
            child: Row(
              children: [
                Text('文字信息'),
                TDivider(layout: TDividerLayout.vertical),
                Text('文字信息'),
                TDivider(layout: TDividerLayout.vertical),
                Text('文字信息'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TText(
        text,
        font: context.tTheme.fontBodyMedium,
        style: const TextStyle(height: 20 / 14),
        textColor: context.tTheme.textColorSecondary,
      ),
    );
  }
}
