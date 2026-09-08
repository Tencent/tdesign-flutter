import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/example_code.dart';

class TBadgePage extends StatelessWidget {
  const TBadgePage({super.key});

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 16);
    return ExamplePage(
      title: tTitle(context),
      desc: '用于告知用户，该区域的状态变化或者待处理任务的数量。',
      exampleCodeGroup: 'badge',
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '红点徽标',
              ignoreCode: true,
              padding: padding,
              builder: (context) => Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CodeWrapper(builder: _buildDotMessageBadge),
                  const SizedBox(width: 32),
                  CodeWrapper(builder: _buildDotIconBadge),
                  const SizedBox(width: 32),
                  CodeWrapper(builder: _buildDotButtonBadge),
                ],
              ),
            ),
            ExampleItem(
              desc: '数字徽标',
              ignoreCode: true,
              padding: padding,
              builder: (context) => Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CodeWrapper(builder: _buildNumberMessageBadge),
                  const SizedBox(width: 32),
                  CodeWrapper(builder: _buildNumberIconBadge),
                  const SizedBox(width: 32),
                  CodeWrapper(builder: _buildNumberButtonBadge),
                ],
              ),
            ),
            ExampleItem(desc: '自定义徽标', builder: _buildCustomBadge),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(desc: '圆形徽标', builder: _buildNormalBadge),
            ExampleItem(desc: '方形徽标', builder: _buildSquareBadge),
            ExampleItem(desc: '气泡徽标', builder: _buildBubbleBadge),
            ExampleItem(desc: '左侧带状角标', builder: _buildRibbonLeftBadge),
            ExampleItem(desc: '右侧带状角标', builder: _buildRibbonRightBadge),
            ExampleItem(desc: '左侧三角角标', builder: _buildTriangleLeftBadge),
            ExampleItem(desc: '右侧三角角标', builder: _buildTriangleRightBadge),
          ],
        ),
        ExampleModule(
          title: '组件尺寸',
          children: [
            ExampleItem(desc: 'Large', builder: _buildLargeBadge),
            ExampleItem(desc: 'Medium', builder: _buildMediumBadge),
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
    );
  }

  @ExampleCode(group: 'badge')
  Widget _buildDotMessageBadge(BuildContext context) => TBadge(
    variant: TBadgeVariant.dot,
    child: TText('消息', font: context.tTheme.fontBodyLarge),
  );

  @ExampleCode(group: 'badge')
  Widget _buildDotIconBadge(BuildContext context) => const TBadge(
    variant: TBadgeVariant.dot,
    child: Icon(TIcons.notification),
  );

  @ExampleCode(group: 'badge')
  Widget _buildDotButtonBadge(BuildContext context) => TBadge(
    variant: TBadgeVariant.dot,
    child: TButton(
      size: TButtonSize.medium,
      onPressed: () {},
      child: const Text('按钮'),
    ),
  );

  @ExampleCode(group: 'badge')
  Widget _buildNumberMessageBadge(BuildContext context) => TBadge(
    label: '8',
    child: TText('消息', font: context.tTheme.fontBodyLarge),
  );

  @ExampleCode(group: 'badge')
  Widget _buildNumberIconBadge(BuildContext context) =>
      const TBadge(label: '2', child: Icon(TIcons.notification));

  @ExampleCode(group: 'badge')
  Widget _buildNumberButtonBadge(BuildContext context) => TBadge(
    label: '8',
    child: TButton(
      size: TButtonSize.medium,
      onPressed: () {},
      child: const Text('按钮'),
    ),
  );

  @ExampleCode(group: 'badge')
  Widget _buildCustomBadge(BuildContext context) => TBadge(
    label: 'NEW',
    offset: const Offset(-16, 0),
    child: Theme(
      data: Theme.of(
        context,
      ).mergeExtension(const TButtonThemeData(shape: TButtonShape.square)),
      child: TButton(
        size: TButtonSize.medium,
        icon: const Icon(TIcons.notification),
        onPressed: () {},
      ),
    ),
  );

  @ExampleCode(group: 'badge')
  Widget _buildNormalBadge(BuildContext context) =>
      const TBadge(label: '8', child: Icon(TIcons.notification));

  @ExampleCode(group: 'badge')
  Widget _buildSquareBadge(BuildContext context) => const TBadge(
    label: '8',
    variant: TBadgeVariant.square,
    child: Icon(TIcons.notification),
  );

  @ExampleCode(group: 'badge')
  Widget _buildBubbleBadge(BuildContext context) => TBadge(
    label: '领取积分',
    variant: TBadgeVariant.bubble,
    child: Theme(
      data: Theme.of(
        context,
      ).mergeExtension(const TButtonThemeData(shape: TButtonShape.square)),
      child: TButton(
        size: TButtonSize.medium,
        icon: const Icon(TIcons.shop),
        onPressed: () {},
      ),
    ),
  );

  @ExampleCode(group: 'badge')
  Widget _buildRibbonLeftBadge(BuildContext context) => const TBadge(
    label: 'NEW',
    variant: TBadgeVariant.ribbonLeft,
    child: TCell(title: Text('单行标题')),
  );

  @ExampleCode(group: 'badge')
  Widget _buildRibbonRightBadge(BuildContext context) => const TBadge(
    label: 'NEW',
    variant: TBadgeVariant.ribbonRight,
    child: TCell(title: Text('单行标题')),
  );

  @ExampleCode(group: 'badge')
  Widget _buildTriangleLeftBadge(BuildContext context) => const TBadge(
    label: 'NEW',
    variant: TBadgeVariant.triangleLeft,
    child: TCell(title: Text('单行标题')),
  );

  @ExampleCode(group: 'badge')
  Widget _buildTriangleRightBadge(BuildContext context) => const TBadge(
    label: 'NEW',
    variant: TBadgeVariant.triangleRight,
    child: TCell(title: Text('单行标题')),
  );

  @ExampleCode(group: 'badge')
  Widget _buildLargeBadge(BuildContext context) => const TBadge(
    label: '8',
    size: TBadgeSize.large,
    child: TAvatar(size: TAvatarSize.large),
  );

  @ExampleCode(group: 'badge')
  Widget _buildMediumBadge(BuildContext context) => const TBadge(
    label: '8',
    size: TBadgeSize.medium,
    child: TAvatar(size: TAvatarSize.medium),
  );

  Widget _buildHiddenZeroBadge(BuildContext context) => const TBadge(
    label: '0',
    showZero: false,
    child: Icon(TIcons.notification),
  );

  Widget _buildOverflowLabelBadge(BuildContext context) =>
      const TBadge(label: '99+', child: Icon(TIcons.notification));
}
