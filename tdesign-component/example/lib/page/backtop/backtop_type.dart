part of 'backtop_page.dart';

extension _BacktopTypeModule on _TBackTopPageState {
  ExampleModule get _backtopTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(
        desc: '圆形返回顶部',
        padding: const EdgeInsets.symmetric(horizontal: 16),
        builder: _buildCircleTrigger,
      ),
      ExampleItem(
        desc: '半圆形返回顶部',
        padding: const EdgeInsets.symmetric(horizontal: 16),
        builder: _buildHalfRoundTrigger,
      ),
      ExampleItem(
        center: false,
        ignoreCode: true,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        builder: _buildSkeletonContent,
      ),
    ],
  );
}
