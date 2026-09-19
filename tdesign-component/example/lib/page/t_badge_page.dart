import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/example_code.dart';

class TBadgePage extends StatelessWidget {
  const TBadgePage({super.key});

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 16);
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
                ignoreCode: true,
                padding: padding,
                builder: (context) => Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CodeWrapper(builder: _buildDotMessageBadge),
                    const SizedBox(width: 48),
                    CodeWrapper(builder: _buildDotIconBadge),
                    const SizedBox(width: 48),
                    CodeWrapper(builder: _buildDotButtonBadge),
                  ],
                ),
              ),
              ExampleItem(
                desc: '数字徽标',
                center: false,
                ignoreCode: true,
                padding: padding,
                builder: (context) => Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CodeWrapper(builder: _buildNumberMessageBadge),
                    const SizedBox(width: 48),
                    CodeWrapper(builder: _buildNumberIconBadge),
                    const SizedBox(width: 48),
                    CodeWrapper(builder: _buildNumberButtonBadge),
                  ],
                ),
              ),
              ExampleItem(
                desc: '自定义徽标',
                center: false,
                padding: padding,
                builder: _buildCustomBadge,
              ),
            ],
          ),
          ExampleModule(
            title: '组件样式',
            children: [
              ExampleItem(
                desc: '圆形徽标',
                center: false,
                padding: padding,
                builder: _buildCircleBadge,
              ),
              ExampleItem(
                desc: '方形徽标',
                center: false,
                padding: padding,
                builder: _buildSquareBadge,
              ),
              ExampleItem(
                desc: '气泡徽标',
                center: false,
                padding: padding,
                builder: _buildBubbleBadge,
              ),
              ExampleItem(
                desc: '角标',
                center: false,
                builder: _buildRibbonBadge,
              ),
              ExampleItem(
                desc: '三角角标',
                center: false,
                builder: _buildTriangleBadge,
              ),
            ],
          ),
          ExampleModule(
            title: '组件尺寸',
            children: [
              ExampleItem(
                desc: 'Large',
                center: false,
                padding: padding,
                builder: _buildLargeBadge,
              ),
              ExampleItem(
                desc: 'Medium',
                center: false,
                padding: padding,
                builder: _buildMediumBadge,
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

  @ExampleCode(group: 'badge')
  Widget _buildDotMessageBadge(BuildContext context) => TBadge(
    variant: TBadgeVariant.dot,
    offset: const Offset(-1, 1),
    child: TText('消息', font: context.tTheme.fontBodyLarge),
  );

  @ExampleCode(group: 'badge')
  Widget _buildDotIconBadge(BuildContext context) => const TBadge(
    variant: TBadgeVariant.dot,
    offset: Offset(-1, 1),
    child: Icon(TIcons.notification),
  );

  @ExampleCode(group: 'badge')
  Widget _buildDotButtonBadge(BuildContext context) => TBadge(
    variant: TBadgeVariant.dot,
    offset: const Offset(-1, 1),
    child: TButton(
      size: TButtonSize.large,
      style: const ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 24)),
      ),
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
      const TBadge(label: '8', child: Icon(TIcons.notification));

  @ExampleCode(group: 'badge')
  Widget _buildNumberButtonBadge(BuildContext context) => TBadge(
    label: '8',
    child: TButton(
      size: TButtonSize.large,
      style: const ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 24)),
      ),
      onPressed: () {},
      child: const Text('按钮'),
    ),
  );

  @ExampleCode(group: 'badge')
  Widget _buildCustomBadge(BuildContext context) => TBadge.custom(
    badge: Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: context.tTheme.errorNormalColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: TText(
        'NEW',
        font: context.tTheme.fontMarkExtraSmall,
        textColor: context.tTheme.textColorAnti,
      ),
    ),
    child: Theme(
      data: Theme.of(
        context,
      ).mergeExtension(const TButtonThemeData(shape: TButtonShape.square)),
      child: TButton(
        size: TButtonSize.large,
        icon: const Icon(TIcons.notification),
        onPressed: () {},
      ),
    ),
  );

  @ExampleCode(group: 'badge')
  Widget _buildCircleBadge(BuildContext context) => const TBadge(
    label: '8',
    offset: Offset(2, -2),
    child: Icon(TIcons.notification),
  );

  @ExampleCode(group: 'badge')
  Widget _buildSquareBadge(BuildContext context) => const TBadge(
    label: '8',
    variant: TBadgeVariant.square,
    offset: Offset(2, -2),
    child: Icon(TIcons.notification),
  );

  @ExampleCode(group: 'badge')
  Widget _buildBubbleBadge(BuildContext context) => TBadge(
    label: '领取积分',
    variant: TBadgeVariant.bubble,
    offset: const Offset(8, 0),
    child: Theme(
      data: Theme.of(
        context,
      ).mergeExtension(const TButtonThemeData(shape: TButtonShape.square)),
      child: TButton(
        size: TButtonSize.large,
        icon: const Icon(TIcons.shop),
        onPressed: () {},
      ),
    ),
  );

  @ExampleCode(group: 'badge')
  Widget _buildRibbonBadge(BuildContext context) => TCellGroup(
    cells: const [
      TCell(title: Text('单行标题')),
      TCell(title: Text('单行标题')),
    ],
    builder: (context, cell, index) => TBadge(
      label: 'NEW',
      variant: index == 0
          ? TBadgeVariant.ribbonLeft
          : TBadgeVariant.ribbonRight,
      size: TBadgeSize.large,
      child: cell,
    ),
  );

  @ExampleCode(group: 'badge')
  Widget _buildTriangleBadge(BuildContext context) => TCellGroup(
    cells: const [
      TCell(title: Text('单行标题')),
      TCell(title: Text('单行标题')),
    ],
    builder: (context, cell, index) => TBadge(
      label: 'NEW',
      variant: index == 0
          ? TBadgeVariant.triangleLeft
          : TBadgeVariant.triangleRight,
      size: TBadgeSize.large,
      child: cell,
    ),
  );

  @ExampleCode(group: 'badge')
  Widget _buildLargeBadge(BuildContext context) => const TBadge(
    label: '8',
    size: TBadgeSize.large,
    child: TAvatar(
      size: TAvatarSize.large,
      image: AssetImage('assets/img/t_avatar_1.png'),
    ),
  );

  @ExampleCode(group: 'badge')
  Widget _buildMediumBadge(BuildContext context) => const TBadge(
    label: '8',
    size: TBadgeSize.medium,
    child: TAvatar(
      size: TAvatarSize.medium,
      image: AssetImage('assets/img/t_avatar_1.png'),
    ),
  );

  Widget _buildHiddenZeroBadge(BuildContext context) => const TBadge(
    label: '0',
    showZero: false,
    child: Icon(TIcons.notification),
  );

  Widget _buildOverflowLabelBadge(BuildContext context) =>
      const TBadge(label: '99+', child: Icon(TIcons.notification));
}
