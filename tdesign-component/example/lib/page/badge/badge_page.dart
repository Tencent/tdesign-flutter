import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'bubble_badge_example.dart';
import 'circle_badge_example.dart';
import 'custom_badge_example.dart';
import 'dot_message_badge_example.dart';
import 'large_badge_example.dart';
import 'medium_badge_example.dart';
import 'number_message_badge_example.dart';
import 'ribbon_badge_example.dart';
import 'square_badge_example.dart';
import 'triangle_badge_example.dart';

const _badgeItemPadding = EdgeInsets.symmetric(horizontal: 16);

@ExampleCodeManifest()
class TBadgePage extends StatelessWidget {
  const TBadgePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageBackground = Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFF6F6F6)
        : context.tTheme.bgColorPage;
    return Theme(
      data: Theme.of(
        context,
      ).mergeExtension(TNavBarThemeData(backgroundColor: pageBackground)),
      child: ExamplePage(
        title: tTitle(context),
        desc: '用于告知用户，该区域的状态变化或者待处理任务的数量。',
        exampleCodeGroup: 'badge',
        backgroundColor: pageBackground,
        showTestModule: false,
        children: [
          ExampleModule(
            title: '组件类型',
            children: [
              ExampleItem(
                desc: '红点徽标',
                center: false,
                padding: _badgeItemPadding,
                methodName: 'DotMessageBadgeExample',
                builder: (_) => const DotMessageBadgeExample(),
              ),
              ExampleItem(
                desc: '数字徽标',
                center: false,
                padding: _badgeItemPadding,
                methodName: 'NumberMessageBadgeExample',
                builder: (_) => const NumberMessageBadgeExample(),
              ),
              ExampleItem(
                desc: '自定义徽标',
                center: false,
                padding: _badgeItemPadding,
                methodName: 'CustomBadgeExample',
                builder: (_) => const CustomBadgeExample(),
              ),
            ],
          ),
          ExampleModule(
            title: '组件样式',
            children: [
              ExampleItem(
                desc: '圆形徽标',
                center: false,
                padding: _badgeItemPadding,
                methodName: 'CircleBadgeExample',
                builder: (_) => const CircleBadgeExample(),
              ),
              ExampleItem(
                desc: '方形徽标',
                center: false,
                padding: _badgeItemPadding,
                methodName: 'SquareBadgeExample',
                builder: (_) => const SquareBadgeExample(),
              ),
              ExampleItem(
                desc: '气泡徽标',
                center: false,
                padding: _badgeItemPadding,
                methodName: 'BubbleBadgeExample',
                builder: (_) => const BubbleBadgeExample(),
              ),
              ExampleItem(
                desc: '角标',
                center: false,
                methodName: 'RibbonBadgeExample',
                builder: (_) => const RibbonBadgeExample(),
              ),
              ExampleItem(
                desc: '三角角标',
                center: false,
                methodName: 'TriangleBadgeExample',
                builder: (_) => const TriangleBadgeExample(),
              ),
            ],
          ),
          ExampleModule(
            title: '组件尺寸',
            children: [
              ExampleItem(
                desc: 'Large',
                center: false,
                padding: _badgeItemPadding,
                methodName: 'LargeBadgeExample',
                builder: (_) => const LargeBadgeExample(),
              ),
              ExampleItem(
                desc: 'Medium',
                center: false,
                padding: _badgeItemPadding,
                methodName: 'MediumBadgeExample',
                builder: (_) => const MediumBadgeExample(),
              ),
            ],
          ),
        ],
        test: [
          ExampleItem(
            ignoreCode: true,
            desc: '零值隐藏',
            builder: _buildHiddenZeroBadge,
          ),
          ExampleItem(
            ignoreCode: true,
            desc: '自定义溢出文本',
            builder: _buildOverflowLabelBadge,
          ),
        ],
      ),
    );
  }

  Widget _buildHiddenZeroBadge(BuildContext context) => const TBadge(
    label: '0',
    showZero: false,
    child: Icon(TIcons.notification),
  );

  Widget _buildOverflowLabelBadge(BuildContext context) =>
      const TBadge(label: '99+', child: Icon(TIcons.notification));
}
