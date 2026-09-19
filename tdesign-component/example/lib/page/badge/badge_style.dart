part of 'badge_page.dart';

extension _BadgeStyleModule on TBadgePage {
  ExampleModule get _badgeStyleModule => ExampleModule(
    title: '组件样式',
    children: [
      ExampleItem(
        desc: '圆形徽标',
        center: false,
        padding: _badgeItemPadding,
        builder: _buildCircleBadge,
      ),
      ExampleItem(
        desc: '方形徽标',
        center: false,
        padding: _badgeItemPadding,
        builder: _buildSquareBadge,
      ),
      ExampleItem(
        desc: '气泡徽标',
        center: false,
        padding: _badgeItemPadding,
        builder: _buildBubbleBadge,
      ),
      ExampleItem(desc: '角标', center: false, builder: _buildRibbonBadge),
      ExampleItem(desc: '三角角标', center: false, builder: _buildTriangleBadge),
    ],
  );
}
