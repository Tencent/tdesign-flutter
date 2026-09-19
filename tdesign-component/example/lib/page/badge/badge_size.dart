part of 'badge_page.dart';

extension _BadgeSizeModule on TBadgePage {
  ExampleModule get _badgeSizeModule => ExampleModule(
    title: '组件尺寸',
    children: [
      ExampleItem(
        desc: 'Large',
        center: false,
        padding: _badgeItemPadding,
        builder: _buildLargeBadge,
      ),
      ExampleItem(
        desc: 'Medium',
        center: false,
        padding: _badgeItemPadding,
        builder: _buildMediumBadge,
      ),
    ],
  );
}
