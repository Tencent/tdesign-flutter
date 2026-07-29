## API
### TImage
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| alignment | AlignmentGeometry | Alignment.center | 图片对齐方式。 |
| errorBuilder | ImageErrorWidgetBuilder? | - | 图片错误构建器。 |
| errorWidget | Widget? | - | 默认错误占位内容。 |
| filterQuality | FilterQuality | FilterQuality.low | 图片滤镜质量。 |
| fit | BoxFit? | - | 图片适配方式；优先于 `variant` 的默认适配方式。 |
| frameBuilder | ImageFrameBuilder? | - | 图片帧构建器。 |
| height | double? | - | 图片高度。 |
| imageFile | File? | - | 本地图片文件；不能与 `src` 同时提供。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| loadingBuilder | ImageLoadingBuilder? | - | 网络图片加载进度构建器。 |
| loadingWidget | Widget? | - | 默认加载占位内容。 |
| onTap | GestureTapCallback? | - | 点击回调；为空时不创建点击行为。 |
| repeat | ImageRepeat | ImageRepeat.noRepeat | 图片重复方式。 |
| semanticLabel | String? | - | 无障碍标签。 |
| src | String? | - | 网络 URL 或 asset 路径；空字符串显示加载占位。 |
| variant | TImageVariant | TImageVariant.roundedSquare | 图片裁剪形态。 |
| width | double? | - | 图片宽度。 |


### TImageVariant
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| clip | 保持原始尺寸并裁剪。 |
| fitHeight | 适应高度。 |
| fitWidth | 适应宽度。 |
| stretch | 拉伸填充。 |
| square | 方形裁剪。 |
| roundedSquare | 圆角方形裁剪。 |
| circle | 圆形裁剪。 |
