/// 折叠面板展开模式。
enum TCollapseMode {
  /// 多个面板可同时展开。
  multiple,

  /// 最多展开一个面板。
  accordion,
}

/// 折叠面板视觉形态。
enum TCollapseVariant {
  /// 通栏形态。
  block,

  /// 卡片形态。
  card,
}

/// 折叠内容相对标题的展开方向。
enum TCollapsePlacement {
  /// 内容在标题下方展开。
  bottom,

  /// 内容在标题上方展开。
  top,
}
