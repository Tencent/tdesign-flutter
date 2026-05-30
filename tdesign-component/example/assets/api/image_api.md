## API
### TImage
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| alignment | AlignmentGeometry | Alignment.center | - |
| assetUrl | String? | - | 本地素材地址 |
| cacheHeight | int? | - | - |
| cacheWidth | int? | - | - |
| centerSlice | Rect? | - | - |
| color | Color? | - | - |
| colorBlendMode | BlendMode? | - | - |
| errorBuilder | ImageErrorWidgetBuilder? | - | - |
| errorWidget | Widget? | - | 失败自定义提示 |
| excludeFromSemantics | bool | false | - |
| filterQuality | FilterQuality | FilterQuality.low | - |
| fit | BoxFit? | - | 适配样式 |
| frameBuilder | ImageFrameBuilder? | - | 以下系统Image属性，释义请参考系统`Image`中注释 |
| gaplessPlayback | bool | false | - |
| height | double? | - | 自定义高 |
| imageFile | File? | - | 图片文件路径 |
| imgUrl | String? | - | 图片地址 |
| isAntiAlias | bool | false | - |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| loadingBuilder | ImageLoadingBuilder? | - | - |
| loadingWidget | Widget? | - | 加载自定义提示 |
| matchTextDirection | bool | false | - |
| opacity | Animation<double>? | - | - |
| repeat | ImageRepeat | ImageRepeat.noRepeat | - |
| semanticLabel | String? | - | - |
| type | TImageType | TImageType.roundedSquare | 图片类型 |
| width | double? | - | 自定义宽 |


### TImageType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| clip | 裁剪 |
| fitHeight | 适应高 |
| fitWidth | 适应宽 |
| stretch | 拉伸 |
| square | 方形, |
| roundedSquare | 圆角方形 |
| circle | 圆形 |
