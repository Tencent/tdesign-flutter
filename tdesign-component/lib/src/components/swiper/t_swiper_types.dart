import 'package:flutter/widgets.dart';

/// 轮播指示器形态。
enum TSwiperPaginationVariant {
  /// 不显示指示器。
  none,

  /// 圆点指示器。
  dots,

  /// 当前项使用长条的圆点指示器。
  dotsBar,

  /// 数字指示器。
  fraction,

  /// 前后切换按钮。
  controls,
}

/// 指示器相对于轮播内容的位置。
enum TSwiperPaginationPlacement {
  /// 覆盖在轮播内容上。
  overlay,

  /// 放在轮播内容外部；横向轮播放在下方，竖向轮播放在右侧。
  outside,
}

/// 单个轮播指示器标记的构建器。
typedef TSwiperPaginationItemBuilder = Widget Function(
  BuildContext context,
  TSwiperPaginationItemDetails details,
);

/// 单个轮播指示器标记的状态信息。
@immutable
class TSwiperPaginationItemDetails {
  const TSwiperPaginationItemDetails({
    required this.index,
    required this.currentIndex,
    required this.itemCount,
    required this.axis,
  });

  /// 当前标记对应的业务下标。
  final int index;

  /// 当前实际展示页的业务下标。
  final int currentIndex;

  /// 轮播项总数。
  final int itemCount;

  /// 轮播滚动主轴。
  final Axis axis;

  /// 当前标记是否对应实际展示页。
  bool get isActive => index == currentIndex;
}

/// 页面切换视觉效果。
enum TSwiperPageEffect {
  /// 无额外效果。
  none,

  /// 卡片间距效果。
  cardMargin,

  /// 缩放和透明度效果。
  scaleAndFade,
}
