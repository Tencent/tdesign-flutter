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

/// 页面切换视觉效果。
enum TSwiperPageEffect {
  /// 无额外效果。
  none,

  /// 卡片间距效果。
  cardMargin,

  /// 缩放和透明度效果。
  scaleAndFade,
}
