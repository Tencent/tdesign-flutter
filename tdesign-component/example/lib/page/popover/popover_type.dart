part of 'popover_page.dart';

extension _PopoverTypeModule on _TPopoverPage {
  ExampleModule get _popoverTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(desc: '带箭头的弹出气泡', builder: _buildPopover),
      ExampleItem(desc: '不带箭头的弹出气泡', builder: _buildNoArrowPopover),
      ExampleItem(desc: '自定义内容弹出气泡', builder: _buildNCustomPopover),
    ],
  );
}
