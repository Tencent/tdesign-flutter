part of 'swipe_cell_page.dart';

extension _SwipeCellTypeModule on TSwipeCellPage {
  ExampleModule get _swipeCellTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(desc: '左滑操作', builder: _buildSwiperCell),
      ExampleItem(desc: '右滑操作', builder: _buildSwiperRightCell),
      ExampleItem(desc: '左右滑操作', builder: _buildSwiperRightLeftCell),
      ExampleItem(desc: '带图标的滑动操作', builder: _buildSwiperIconCell),
    ],
  );
}
