import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'action_sheet')
class ActionSheetBadgeGridExample extends StatelessWidget {
  const ActionSheetBadgeGridExample({super.key});

  Widget _badgeGrid(BuildContext context) => _trigger(
    label: '带徽标宫格型',
    onPressed: () => TActionSheet.showGrid(
      context,
      cancelText: 'Cancel',
      items: _badgeGridItems(),
      onSelected: (item) => _showSelection(context, item),
    ),
  );

  Widget _trigger({required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: Text(label),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: onPressed,
      ),
    );
  }

  List<TActionSheetItem<String>> _badgeGridItems() => [
    TActionSheetItem(
      value: 'wechat',
      label: '微信',
      icon: _assetGridIcon('assets/img/t_action_sheet_1.png'),
      badge: const TBadgeConfig(label: 'NEW'),
    ),
    TActionSheetItem(
      value: 'moments',
      label: '朋友圈',
      icon: _assetGridIcon('assets/img/t_action_sheet_2.png'),
    ),
    TActionSheetItem(
      value: 'qq',
      label: 'QQ',
      icon: _assetGridIcon('assets/img/t_action_sheet_3.png'),
    ),
    TActionSheetItem(
      value: 'wecom',
      label: '企业微信',
      icon: _assetGridIcon('assets/img/t_action_sheet_4.png'),
    ),
    TActionSheetItem(
      value: 'favorite',
      label: '收藏',
      icon: _iconGridIcon(TIcons.star),
      badge: const TBadgeConfig(variant: TBadgeVariant.dot),
    ),
    TActionSheetItem(
      value: 'refresh',
      label: '刷新',
      icon: _iconGridIcon(TIcons.refresh),
    ),
    TActionSheetItem(
      value: 'download',
      label: '下载',
      icon: _iconGridIcon(TIcons.download),
      badge: const TBadgeConfig(label: '8'),
    ),
    TActionSheetItem(
      value: 'copy',
      label: '复制',
      icon: _iconGridIcon(TIcons.queue),
    ),
  ];

  void _showSelection(BuildContext context, TActionSheetItem<String> item) {
    TToast.showText('已选择：${item.label}', context: context);
  }

  Widget _assetGridIcon(String path) {
    return Container(
      key: ValueKey(path),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.06),
          width: 0.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(path, fit: BoxFit.cover),
    );
  }

  Widget _iconGridIcon(IconData icon) => Builder(
    builder: (context) => Container(
      key: ValueKey(icon),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: context.tTheme.bgColorSecondaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 24),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return _badgeGrid(context);
  }
}
