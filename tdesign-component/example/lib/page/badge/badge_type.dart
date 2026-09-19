part of 'badge_page.dart';

extension _BadgeTypeModule on TBadgePage {
  ExampleModule get _badgeTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(
        desc: '红点徽标',
        center: false,
        ignoreCode: true,
        padding: _badgeItemPadding,
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
        padding: _badgeItemPadding,
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
        padding: _badgeItemPadding,
        builder: _buildCustomBadge,
      ),
    ],
  );
}
