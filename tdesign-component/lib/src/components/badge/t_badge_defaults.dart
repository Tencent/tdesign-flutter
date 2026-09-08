/// TBadge 的 TDesign 内置视觉默认值。
abstract final class TBadgeDefaults {
  /// Dot 的默认直径，单位为逻辑像素。
  ///
  /// 当前主题尚无 Badge 专属的尺寸语义 token，不能仅因数值相同而复用
  /// `spacer8`。后续建立正式的 Badge 组件 token 后，应将该默认值迁移到
  /// 对应 token，同时保留 `BadgeThemeData.smallSize` 的显式覆盖能力。
  static const dotSize = 8.0;
}
