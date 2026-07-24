# TRefreshHeader

基于 `easy_refresh` 的刷新头部。行为参数直接由 `TRefreshHeader` 实例控制，视觉默认值由
`TRefreshThemeData` 控制。

```dart
TRefreshHeader(
  extent: 48,
  triggerDistance: 48,
  loadingIcon: TLoadingIcon.circle,
)
```

## API

实例参数包括 `extent`、`triggerDistance`、`clamping`、`float`、`completeDuration`、
`overScroll`、`enableHapticFeedback`、`enableInfiniteRefresh` 和 easy_refresh 原生物理参数。
`loadingIcon` 与 `backgroundColor` 是视觉参数，可由实例显式覆盖 Theme 默认值。

## Theme

`TRefreshThemeData` 只包含 `loadingIcon` 和 `backgroundColor`，使用
`Theme.of(context).mergeExtension(...)` 配置全局或子树默认值。
