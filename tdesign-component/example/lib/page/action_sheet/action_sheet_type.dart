part of 'action_sheet_page.dart';

extension _ActionSheetTypeModule on TActionSheetPage {
  ExampleModule get _actionSheetTypeModule => ExampleModule(
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
        builder: _pagedGrid,
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
  );
}
