import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart' hide TIcons;
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart';
import 'package:url_launcher/link.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'icon')
class IconPriorityExample extends StatelessWidget {
  const IconPriorityExample({super.key});

  Widget _buildIconPriorityExample(BuildContext context) {
    // 优先级链：构造器参数 > Flutter IconTheme。
    return IconTheme(
      data: IconThemeData(size: 36, color: context.tTheme.brandColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 构造器 size 覆盖 Theme 的 36
              const TIcon(TIcons.home_filled, size: 20),
              const SizedBox(width: 16),
              // 构造器 color 覆盖 Theme 的品牌色
              TIcon(TIcons.setting, color: context.tTheme.errorColor),
              const SizedBox(width: 16),
              // 无构造器参数，继承 Theme 默认
              const TIcon(TIcons.notification),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '↑ 前两个图标构造器覆盖 Theme，第三个继承 Theme',
            style: TextStyle(
              fontSize: 12,
              color: context.tTheme.textColorSecondary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildIconPriorityExample(context);
  }
}
