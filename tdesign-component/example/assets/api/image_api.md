## API
### TImage
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| alignment | AlignmentGeometry | Alignment.center | 图片对齐方式。 |
| cacheHeight | int? | - | 解码缓存高度。 |
| cacheWidth | int? | - | 解码缓存宽度。 |
| errorBuilder | ImageErrorWidgetBuilder? | - | 图片错误 UI 构建器；非空时优先于 `errorWidget`。 不用于执行错误上报等副作用；错误事件使用 `onError`。 |
| errorWidget | Widget? | - | 默认错误占位内容；`errorBuilder` 非空时由其接管错误渲染。 |
| excludeFromSemantics | bool | false | 是否从语义树排除图片。 |
| filterQuality | FilterQuality | FilterQuality.low | 图片滤镜质量。 |
| fit | BoxFit | BoxFit.fill | 图片适配方式，默认为 `BoxFit.fill`。 |
| frameBuilder | ImageFrameBuilder? | - | 图片帧 UI 构建器；不用于触发加载成功副作用。 |
| height | double? | - | 图片高度，未指定时为 72。 |
| imageFile | File? | - | 本地图片文件；不能与 `src` 同时提供。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| loadingBuilder | ImageLoadingBuilder? | - | 网络图片的增量加载进度构建器。 仅透传给 `Image.network`；asset 和 `imageFile` 的首帧 UI 使用 `frameBuilder`。 |
| loadingWidget | Widget? | - | 默认加载占位内容。 `src` 为 null 时直接显示；网络图片加载时仅在 `loadingBuilder` 为空时显示。 |
| onError | ImageErrorListener? | - | 图片加载失败后的回调。 每个图片来源生命周期只触发一次，并接收原始错误与堆栈。 |
| onLoad | VoidCallback? | - | 图片首帧加载成功后的回调。 每个图片来源生命周期只触发一次；动画图片的后续帧不重复触发。 |
| onTap | GestureTapCallback? | - | 点击回调；为空时不创建点击行为。 |
| repeat | ImageRepeat | ImageRepeat.noRepeat | 图片重复方式。 |
| semanticLabel | String? | - | 无障碍标签。 |
| shape | TImageShape | TImageShape.square | 图片形状，默认为 `TImageShape.square`。 |
| src | String? | - | 网络 URL 或 asset 路径。 为 null 时显示加载占位；空字符串显示失败占位。 |
| width | double? | - | 图片宽度，未指定时为 72。 |


### TImageShape
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| square | 方形。 |
| roundedSquare | 圆角方形。 |
| circle | 圆形。 |
