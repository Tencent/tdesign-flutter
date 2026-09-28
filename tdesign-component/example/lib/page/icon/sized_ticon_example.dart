import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart' hide TIcons;
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart';
import 'package:url_launcher/link.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'icon')
class SizedTIconExample extends StatelessWidget {
  const SizedTIconExample({super.key});

  Widget _buildSizedTIcon(BuildContext context) {
    // 构造器参数 size/color 直接生效
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TIcon(TIcons.home_filled, size: 32, color: context.tTheme.brandColor),
        const SizedBox(width: 16),
        TIcon(TIcons.setting, size: 28, color: context.tTheme.errorColor),
        const SizedBox(width: 16),
        TIcon(
          TIcons.notification,
          size: 24,
          color: context.tTheme.warningColor,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSizedTIcon(context);
  }
}
