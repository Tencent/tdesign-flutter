## API

### TImage

#### 构造方法

##### TImage

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| alignment | AlignmentGeometry | Alignment.center | 图片对齐方式。 | 否 |
| cacheHeight | int? | - | 解码缓存高度。 | 否 |
| cacheWidth | int? | - | 解码缓存宽度。 | 否 |
| errorBuilder | ImageErrorWidgetBuilder? | - | 图片错误 UI 构建器；非空时优先于 `errorWidget`。 不用于执行错误上报等副作用；错误事件使用 `onError`。 | 否 |
| errorWidget | Widget? | - | 默认错误占位内容；`errorBuilder` 非空时由其接管错误渲染。 | 否 |
| excludeFromSemantics | bool | false | 是否从语义树排除图片。 | 否 |
| filterQuality | FilterQuality | FilterQuality.low | 图片滤镜质量。 | 否 |
| fit | BoxFit | BoxFit.fill | 图片适配方式，默认为 `BoxFit.fill`。 | 否 |
| frameBuilder | ImageFrameBuilder? | - | 图片帧 UI 构建器；不用于触发加载成功副作用。 | 否 |
| height | double? | - | 图片高度，未指定时为 72。 | 否 |
| imageFile | File? | - | 本地图片文件；不能与 `src` 同时提供。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| loadingBuilder | ImageLoadingBuilder? | - | 网络图片的增量加载进度构建器。 仅透传给 `Image.network`；asset 和 `imageFile` 的首帧 UI 使用 `frameBuilder`。 | 否 |
| loadingWidget | Widget? | - | 默认加载占位内容。 `src` 为 null 时直接显示；网络图片加载时仅在 `loadingBuilder` 为空时显示。 | 否 |
| onError | ImageErrorListener? | - | 图片加载失败后的回调。 每个图片来源生命周期只触发一次，并接收原始错误与堆栈。 | 否 |
| onLoad | VoidCallback? | - | 图片首帧加载成功后的回调。 每个图片来源生命周期只触发一次；动画图片的后续帧不重复触发。 | 否 |
| onTap | GestureTapCallback? | - | 点击回调；为空时不创建点击行为。 | 否 |
| repeat | ImageRepeat | ImageRepeat.noRepeat | 图片重复方式。 | 否 |
| semanticLabel | String? | - | 无障碍标签。 | 否 |
| shape | TImageShape | TImageShape.square | 图片形状，默认为 `TImageShape.square`。 | 否 |
| src | String? | - | 网络 URL 或 asset 路径。 为 null 时显示加载占位；空字符串显示失败占位。 | 否 |
| width | double? | - | 图片宽度，未指定时为 72。 | 否 |


### TImageShape

图片形状。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| square | TImageShape | - | 方形。 | - |
| roundedSquare | TImageShape | - | 圆角方形。 | - |
| circle | TImageShape | - | 圆形。 | - |


### TImageThemeData

图片组件的视觉默认值。

<!-- api-theme: fields -->

#### 配置项


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| centerSlice | Rect? | - | 九宫格中心切片。 | 否 |
| color | Color? | - | 图片叠加色。 | 否 |
| colorBlendMode | BlendMode? | - | 颜色混合模式。 | 否 |
| gaplessPlayback | bool? | - | 更新 provider 时是否保留上一帧。 未配置时为 false。 | 否 |
| isAntiAlias | bool? | - | 是否启用抗锯齿。 未配置时为 false。 | 否 |
| matchTextDirection | bool? | - | 是否匹配文字方向。 未配置时为 false。 | 否 |
