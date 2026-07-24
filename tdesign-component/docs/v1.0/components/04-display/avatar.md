# TAvatar

`TAvatar` 展示图片或自定义头像内容，`TAvatarGroup` 负责头像叠放布局。两个组件均不保存业务状态。

## 架构

| 项 | 约定 |
|---|---|
| 内容 | `image` 与 `child` 直接使用 Flutter 类型 |
| 形状 | `TAvatarVariant.circle` / `TAvatarVariant.square` |
| 尺寸 | `TAvatarSize.large` / `medium` / `small` |
| 交互 | `onTap` 为空时不创建点击行为 |
| 头像组 | 组合已有头像 Widget，不解析图片来源 |
| Theme | `TAvatarThemeData` 只保存视觉默认值 |

## TAvatar API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `image` | `ImageProvider<Object>?` | `null` | 头像图片 |
| `child` | `Widget?` | `null` | 文字、图标等自定义内容 |
| `size` | `TAvatarSize?` | Theme / `medium` | 尺寸档位 |
| `variant` | `TAvatarVariant?` | Theme / `circle` | 头像形状 |
| `fit` | `BoxFit` | `cover` | 图片填充方式 |
| `onTap` | `GestureTapCallback?` | `null` | 点击回调 |

`image` 与 `child` 可以同时提供。图片显示期间覆盖 `child`，图片加载失败时保留 `child` 作为背景内容。

```dart
const TAvatar(
  image: AssetImage('assets/avatar.png'),
  size: TAvatarSize.large,
)

const TAvatar(
  variant: TAvatarVariant.square,
  child: Text('TD'),
)
```

## TAvatarGroup API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `children` | `List<Widget>` | 必填 | 头像成员 |
| `maxCount` | `int?` | `null` | 最多显示的成员数 |
| `overflow` | `Widget?` | `null` | 截断时追加的末尾内容 |
| `spacing` | `double?` | Theme / `8` | 相邻头像的重叠宽度 |

```dart
const TAvatarGroup(
  maxCount: 2,
  overflow: TAvatar(child: Text('+2')),
  children: [
    TAvatar(image: AssetImage('assets/a.png')),
    TAvatar(image: AssetImage('assets/b.png')),
    TAvatar(image: AssetImage('assets/c.png')),
  ],
)
```

## Theme

`TAvatarThemeData` 可配置 `size`、`variant`、`dimension`、`iconSize`、`squareBorderRadius`、`backgroundColor`、`foregroundColor`、`groupSpacing`、`groupBorderWidth` 与 `groupBorderColor`。

实例 `size`、`variant` 和 `spacing` 优先于 Theme。Theme 不包含图片、文字、成员列表、截断数量和点击回调。

## 验收要求

- 单头像不通过枚举切换内容类型。
- 头像组不复用单头像构造器承载列表业务。
- Theme 仅控制视觉默认值。
- 组件内容和头像组成员均由调用方提供。
- 公开参数与枚举值均提供可被 tools 解析的 Dartdoc。
