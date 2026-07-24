# TLoading

Loading 是展示型组件，使用 `TLoading` 渲染加载图标和可选文案。

```dart
const TLoading(
  size: TLoadingSize.medium,
  icon: TLoadingIcon.circle,
  text: '加载中',
)
```

`customIcon` 和 `refreshWidget` 是实例内容参数；`TLoadingThemeData` 仅提供图标颜色、
文案颜色、布局方向和动画时长默认值。

`TLoadingController.show` 返回命令式展示入口，参数名为 `theme`，用于给该 Overlay 子树
注入 `TLoadingThemeData`。
