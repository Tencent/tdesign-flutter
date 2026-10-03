import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart' hide TIcons;
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart';
import 'package:url_launcher/link.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'icon')
class IconTokenExample extends StatelessWidget {
  const IconTokenExample({super.key});

  Widget _buildIconTokenExample(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TIcon(TIcons.home_filled),
            SizedBox(width: 16),
            TIcon(TIcons.setting),
            SizedBox(width: 16),
            TIcon(TIcons.notification),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '↑ 默认 24dp，颜色使用文字主色 Token',
          style: TextStyle(
            fontSize: 12,
            color: context.tTheme.textColorSecondary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildIconTokenExample(context);
  }
}
