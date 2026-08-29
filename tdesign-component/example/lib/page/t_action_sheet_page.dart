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
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '常规列表型', builder: _basicList),
          ExampleItem(desc: '带描述列表型', builder: _descriptionList),
          ExampleItem(desc: '带图标列表型', builder: _iconList),
          ExampleItem(desc: '常规宫格型', builder: _basicGrid),
          ExampleItem(desc: '带描述宫格型', builder: _descriptionGrid),
          ExampleItem(desc: '带翻页宫格型', builder: _paginationGrid),
        ]),
        ExampleModule(title: '组件状态', children: [
          ExampleItem(desc: '列表型选项状态', builder: _statusList),
        ]),
        ExampleModule(title: '组件样式', children: [
          ExampleItem(desc: '居中列表型', builder: _centerList),
          ExampleItem(desc: '左对齐列表型', builder: _leftList),
        ]),
      ],
    );
  }

  Widget _trigger({required String label, required VoidCallback onPressed}) {
    return TButton(child: Text(label), onPressed: onPressed);
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
  Widget _paginationGrid(BuildContext context) => _trigger(
        label: '带翻页宫格型',
        onPressed: () => TActionSheet.showGrid(
          context,
          items: [
            ..._gridItems(context),
            ...List.generate(
              8,
              (_) => TActionSheetItem(
                label: '标题文字',
                icon: const Icon(TIcons.image),
              ),
            ),
          ],
          showPagination: true,
          count: 8,
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
  Widget _centerList(BuildContext context) =>
      _alignedList(context, '居中列表型', TActionSheetAlign.center);

  @ExampleCode(group: 'action_sheet')
  Widget _leftList(BuildContext context) =>
      _alignedList(context, '左对齐列表型', TActionSheetAlign.left);

  Widget _alignedList(
    BuildContext context,
    String label,
    TActionSheetAlign align,
  ) {
    return _trigger(
      label: label,
      onPressed: () => TActionSheet.showList(
        context,
        cancelText: 'cancel',
        subtitle: 'Email Settings',
        align: align,
        items: _iconItems(),
        onChanged: (item, _) => _showSelection(context, item),
      ),
    );
  }
}
