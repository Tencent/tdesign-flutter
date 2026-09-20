import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'drawer')
class DrawerIconSimpleExample extends StatelessWidget {
  const DrawerIconSimpleExample({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildIconSimple(context);
  }
}

Widget _buildIconSimple(BuildContext context) {
  const menuLabels = ['菜单一', '菜单二', '菜单三', '菜单四', '菜单五', '菜单六', '菜单七', '菜单八'];
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
          drawer: TDrawer(
            items: List.generate(
              menuLabels.length,
              (index) => TDrawerItem(
                title: menuLabels[index],
                icon: const TIcon(TIcons.app),
              ),
            ),
          ),
        );
      },
      child: const TText('带图标抽屉'),
    ),
  );
}
