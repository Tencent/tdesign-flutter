# TImage

> **状态**：已实现 | **控制类**：A | **Sprint**：S2

**源码路径**：`lib/src/components/image`

## 架构

`TImage` 直接包装 Flutter `Image`，不维护第二套图片加载状态机。网络、asset 和本地文件最终都使用标准 `ImageProvider`、`loadingBuilder` 和 `errorBuilder` 生命周期。

- `src` 接受 HTTP(S) URL 或 asset 路径。
- `imageFile` 接受本地 `File`。
- `src` 与 `imageFile` 必须且只能提供一个。
- `onTap == null` 时不创建点击行为。
- `TImageThemeData` 只承载视觉和解码默认，不承载 source、尺寸、Animation、Widget 或回调。

## API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `src` | `String?` | `null` | 网络 URL 或 asset 路径 |
| `imageFile` | `File?` | `null` | 本地图片文件 |
| `variant` | `TImageVariant` | `roundedSquare` | 裁剪和默认 fit 形态 |
| `width` | `double?` | `null` | 图片宽度，未传时为 72 |
| `height` | `double?` | `null` | 图片高度，未传时为 72 |
| `fit` | `BoxFit?` | `null` | 覆盖 variant 的默认 fit |
| `loadingWidget` | `Widget?` | `null` | 默认加载占位 |
| `errorWidget` | `Widget?` | `null` | 默认错误占位 |
| `frameBuilder` | `ImageFrameBuilder?` | `null` | 帧构建器 |
| `loadingBuilder` | `ImageLoadingBuilder?` | `null` | 网络加载构建器 |
| `errorBuilder` | `ImageErrorWidgetBuilder?` | `null` | 错误构建器 |
| `semanticLabel` | `String?` | `null` | 无障碍标签 |
| `filterQuality` | `FilterQuality` | `low` | 滤镜质量 |
| `alignment` | `AlignmentGeometry` | `center` | 对齐方式 |
| `repeat` | `ImageRepeat` | `noRepeat` | 重复方式 |
| `onTap` | `GestureTapCallback?` | `null` | 点击回调 |

## Theme

`TImageThemeData` 包含叠加色、混合模式、中心切片、文字方向、无缝播放、语义排除、抗锯齿和解码缓存尺寸。

## Export

公开导出 `TImage`、`TImageVariant` 和 `TImageThemeData`。内部加载 Widget 已删除。

## 验收

- 网络、asset、file、加载、错误、全部 variant、Theme 和点击行为均有测试。
- Image 源码逐文件覆盖率为 100%。
