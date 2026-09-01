import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TActionSheetPage extends StatelessWidget {
  const TActionSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '从底部弹出的模态框，提供和当前场景相关的操作动作，也支持提供信息输入和描述。',
      exampleCodeGroup: 'action_sheet',
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '列表型动作面板',
              builder: _basicList,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            ExampleItem(
              builder: _descriptionList,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            ),
            ExampleItem(
              builder: _iconList,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            ),
            ExampleItem(
              builder: _badgeList,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            ),
            ExampleItem(
              desc: '宫格型动作面板',
              builder: _basicGrid,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            ExampleItem(
              builder: _descriptionGrid,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            ),
            ExampleItem(
              builder: _iconGrid,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            ),
            ExampleItem(
              builder: _badgeGrid,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            ),
            ExampleItem(
              builder: _scrollGrid,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            ),
            ExampleItem(
              builder: _descriptionScrollGrid,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            ),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(
              desc: '列表型选项状态',
              builder: _statusList,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '列表型对齐方式',
              builder: _centerList,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            ExampleItem(
              builder: _leftList,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            ),
          ],
        ),
      ],
    );
  }

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

  List<TActionSheetItem> _textItems() => [
    TActionSheetItem(label: 'Move'),
    TActionSheetItem(label: 'Mark as important'),
    TActionSheetItem(label: 'Unsubscribe'),
    TActionSheetItem(label: 'Add to Tasks'),
  ];

  List<TActionSheetItem> _iconItems() => [
    TActionSheetItem(label: 'Move', icon: const Icon(TIcons.folder)),
    TActionSheetItem(
      label: 'Mark as important',
      icon: const Icon(TIcons.notification),
    ),
    TActionSheetItem(label: 'Unsubscribe', icon: const Icon(TIcons.delete)),
    TActionSheetItem(
      label: 'Add to Tasks',
      icon: const Icon(TIcons.cloud_upload),
    ),
  ];

  List<TActionSheetItem> _badgeItems() => [
    TActionSheetItem(label: 'Move'),
    TActionSheetItem(
      label: 'Mark as important',
      badge: const TBadge(label: '8'),
    ),
    TActionSheetItem(
      label: 'Unsubscribe',
      badge: const TBadge(variant: TBadgeVariant.dot),
    ),
    TActionSheetItem(
      label: 'Add to Tasks',
      badge: const TBadge(label: '99+'),
    ),
  ];

  Widget _gridIcon(IconData icon, Color color) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 24, color: color),
    );
  }

  List<TActionSheetItem> _gridItems(BuildContext context) => [
    TActionSheetItem(
      label: '微信',
      icon: _gridIcon(TIcons.chat, context.tTheme.successNormalColor),
    ),
    TActionSheetItem(
      label: '朋友圈',
      icon: _gridIcon(TIcons.share, context.tTheme.successNormalColor),
    ),
    TActionSheetItem(
      label: 'QQ',
      icon: _gridIcon(TIcons.user, context.tTheme.brandNormalColor),
    ),
    TActionSheetItem(
      label: '企业微信',
      icon: _gridIcon(TIcons.app, context.tTheme.brandNormalColor),
    ),
    TActionSheetItem(label: '收藏', icon: const Icon(TIcons.star)),
    TActionSheetItem(label: '刷新', icon: const Icon(TIcons.refresh)),
    TActionSheetItem(label: '下载', icon: const Icon(TIcons.download)),
    TActionSheetItem(label: '复制', icon: const Icon(TIcons.file_copy)),
  ];

  List<TActionSheetItem> _iconGridItems() => [
    TActionSheetItem(label: '分享', icon: const Icon(TIcons.share)),
    TActionSheetItem(label: '收藏', icon: const Icon(TIcons.star)),
    TActionSheetItem(label: '下载', icon: const Icon(TIcons.download)),
    TActionSheetItem(label: '编辑', icon: const Icon(TIcons.edit)),
    TActionSheetItem(label: '复制', icon: const Icon(TIcons.file_copy)),
    TActionSheetItem(label: '刷新', icon: const Icon(TIcons.refresh)),
    TActionSheetItem(label: '上传', icon: const Icon(TIcons.cloud_upload)),
    TActionSheetItem(label: '删除', icon: const Icon(TIcons.delete)),
  ];

  List<TActionSheetItem> _badgeGridItems(BuildContext context) {
    final items = _gridItems(context);
    return List.generate(items.length, (index) {
      final item = items[index];
      return TActionSheetItem(
        label: item.label,
        icon: item.icon,
        badge: switch (index) {
          1 => const TBadge(variant: TBadgeVariant.dot),
          3 => const TBadge(label: '8'),
          7 => const TBadge(label: '99+'),
          _ => null,
        },
      );
    });
  }

  List<TActionSheetItem> _scrollGridItems(BuildContext context) => [
    ..._gridItems(context),
    ..._iconGridItems(),
  ];

  void _showSelection(BuildContext context, TActionSheetItem item) {
    TToast.showText('已选择：${item.label}', context: context);
  }

  @ExampleCode(group: 'action_sheet')
  Widget _basicList(BuildContext context) => _trigger(
    label: '常规列表型',
    onPressed: () => TActionSheet.showList(
      context,
      cancelText: 'cancel',
      items: _textItems(),
      onChanged: (item, _) => _showSelection(context, item),
    ),
  );

  @ExampleCode(group: 'action_sheet')
  Widget _descriptionList(BuildContext context) => _trigger(
    label: '带描述列表型',
    onPressed: () => TActionSheet.showList(
      context,
      cancelText: 'cancel',
      subtitle: 'Email Settings',
      items: _textItems(),
      onChanged: (item, _) => _showSelection(context, item),
    ),
  );

  @ExampleCode(group: 'action_sheet')
  Widget _iconList(BuildContext context) => _trigger(
    label: '带图标列表型',
    onPressed: () => TActionSheet.showList(
      context,
      cancelText: 'cancel',
      items: _iconItems(),
      onChanged: (item, _) => _showSelection(context, item),
    ),
  );

  @ExampleCode(group: 'action_sheet')
  Widget _badgeList(BuildContext context) => _trigger(
    label: '带徽标列表型',
    onPressed: () => TActionSheet.showList(
      context,
      cancelText: 'cancel',
      items: _badgeItems(),
      onChanged: (item, _) => _showSelection(context, item),
    ),
  );

  @ExampleCode(group: 'action_sheet')
  Widget _basicGrid(BuildContext context) => _trigger(
    label: '常规宫格型',
    onPressed: () => TActionSheet.showGrid(
      context,
      items: _gridItems(context),
      onChanged: (item, _) => _showSelection(context, item),
    ),
  );

  @ExampleCode(group: 'action_sheet')
  Widget _descriptionGrid(BuildContext context) => _trigger(
    label: '带描述宫格型',
    onPressed: () => TActionSheet.showGrid(
      context,
      subtitle: '动作面板描述文字',
      items: _gridItems(context),
      onChanged: (item, _) => _showSelection(context, item),
    ),
  );

  @ExampleCode(group: 'action_sheet')
  Widget _iconGrid(BuildContext context) => _trigger(
    label: '带图标宫格型',
    onPressed: () => TActionSheet.showGrid(
      context,
      items: _iconGridItems(),
      onChanged: (item, _) => _showSelection(context, item),
    ),
  );

  @ExampleCode(group: 'action_sheet')
  Widget _badgeGrid(BuildContext context) => _trigger(
    label: '带徽标宫格型',
    onPressed: () => TActionSheet.showGrid(
      context,
      items: _badgeGridItems(context),
      onChanged: (item, _) => _showSelection(context, item),
    ),
  );

  @ExampleCode(group: 'action_sheet')
  Widget _scrollGrid(BuildContext context) => _trigger(
    label: '多行滚动宫格型',
    onPressed: () => TActionSheet.showGrid(
      context,
      items: _scrollGridItems(context),
      scrollable: true,
      rows: 2,
      onChanged: (item, _) => _showSelection(context, item),
    ),
  );

  @ExampleCode(group: 'action_sheet')
  Widget _descriptionScrollGrid(BuildContext context) => _trigger(
    label: '带描述多行滚动宫格型',
    onPressed: () => TActionSheet.showGrid(
      context,
      subtitle: '动作面板描述文字',
      items: _scrollGridItems(context),
      scrollable: true,
      rows: 2,
      onChanged: (item, _) => _showSelection(context, item),
    ),
  );

  @ExampleCode(group: 'action_sheet')
  Widget _statusList(BuildContext context) => _trigger(
    label: '列表型选项状态',
    onPressed: () => TActionSheet.showList(
      context,
      cancelText: 'cancel',
      items: [
        TActionSheetItem(label: 'Move', icon: const Icon(TIcons.folder)),
        TActionSheetItem(
          label: 'Mark as important',
          icon: const Icon(TIcons.notification),
          textStyle: TextStyle(color: context.tTheme.brandNormalColor),
        ),
        TActionSheetItem(
          label: 'Unsubscribe',
          icon: const Icon(TIcons.delete),
          textStyle: TextStyle(color: context.tTheme.errorNormalColor),
        ),
        TActionSheetItem(
          label: 'Add to Tasks',
          icon: const Icon(TIcons.cloud_upload),
          disabled: true,
        ),
      ],
      onChanged: (item, _) => _showSelection(context, item),
    ),
  );

  @ExampleCode(group: 'action_sheet')
  Widget _centerList(BuildContext context) => _trigger(
    label: '居中列表型',
    onPressed: () => TActionSheet.showList(
      context,
      cancelText: 'cancel',
      subtitle: 'Email Settings',
      align: TActionSheetAlign.center,
      items: _iconItems(),
      onChanged: (item, _) => _showSelection(context, item),
    ),
  );

  @ExampleCode(group: 'action_sheet')
  Widget _leftList(BuildContext context) => _trigger(
    label: '左对齐列表型',
    onPressed: () => TActionSheet.showList(
      context,
      cancelText: 'cancel',
      subtitle: 'Email Settings',
      align: TActionSheetAlign.left,
      items: _iconItems(),
      onChanged: (item, _) => _showSelection(context, item),
    ),
  );
}
