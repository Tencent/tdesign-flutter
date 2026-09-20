import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'drawer')
class DrawerBaseSimpleExample extends StatelessWidget {
  const DrawerBaseSimpleExample({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBaseSimple(context);
  }
}

Widget _buildBaseSimple(BuildContext context) {
  final items = [
    for (final label in const [
      '菜单一',
      '菜单二',
      '菜单三',
      '菜单四',
      '菜单五',
      '菜单六',
      '菜单七',
      '菜单八',
    ])
      TDrawerItem(title: label),
  ];
  return SizedBox(
    width: double.infinity,
    child: TButton(
      size: TButtonSize.large,
      variant: TButtonVariant.outline,
      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showTDrawer(
          context,
          placement: TDrawerPlacement.left,
          drawer: TDrawer(items: items, onItemClick: (_, __) {}),
        );
      },
      child: const TText('基础抽屉'),
    ),
  );
}
