part of 'popover_page.dart';

extension _PopoverInteractionModule on _TPopoverPage {
  ExampleModule get _popoverInteractionModule => ExampleModule(
    title: '交互与边界',
    children: [
      ExampleItem(desc: '点击与长按回调', builder: _buildEventPopover),
      ExampleItem(desc: '主题与尺寸约束', builder: _buildThemeSizePopover),
      ExampleItem(desc: '窄屏四角边界与自动翻转', builder: _buildBoundaryPopover),
      ExampleItem(desc: '键盘遮挡场景', builder: _buildKeyboardPopover),
      ExampleItem(desc: '锚点销毁与 Future', builder: _buildLifecyclePopover),
    ],
  );
}
