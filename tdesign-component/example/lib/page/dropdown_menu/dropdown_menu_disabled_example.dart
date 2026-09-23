import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'dropdown_menu')
class DropdownMenuDisabledExample extends StatelessWidget {
  const DropdownMenuDisabledExample({super.key});

  Widget _disabled(BuildContext context) {
    return TDropdownMenu(
      items: [
        TDropdownMenuItem(
          label: '禁用菜单',
          enabled: false,
          panelBuilder: (context, controller) => const SizedBox.shrink(),
        ),
        TDropdownMenuItem(
          label: '禁用菜单',
          enabled: false,
          panelBuilder: (context, controller) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _disabled(context);
  }
}
