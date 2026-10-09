## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TUpload
#### 简介
严格受控的文件选择与上传状态展示组件。

#### 声明

```dart
class TUpload extends StatelessWidget
```

#### 默认构造方法


```dart
const TUpload({
  super.key,
  required this.files,
  this.onChanged,
  this.mediaType = TUploadMediaType.image,
  this.layout = TUploadLayout.grid,
  this.draggable = false,
  this.maxFiles = 1,
  this.maxFileSize,
  this.picker,
  this.onFileTap,
  this.onValidationError,
  this.onError,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| draggable | bool | false | 是否支持长按拖拽排序，默认为 false。 排序完成后通过 `onChanged` 返回新的不可变文件列表；当 `onChanged` 为 null 时组件禁用，不会开始拖拽。 | 否 |
| files | List&lt;TUploadFile&gt; | - | 受控文件列表。 长度不能超过 maxFiles；各文件 id 应唯一。组件不执行网络上传，由业务更新上传状态。 | 是 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| layout | TUploadLayout | TUploadLayout.grid | 文件布局方式。 | 否 |
| maxFiles | int? | 1 | 最大文件数量；null 表示不限制。 非 null 时必须大于 0；video 模式必须设为 1，包括使用自定义 picker 时。 | 否 |
| maxFileSize | int? | - | 单个文件最大字节数；null 表示不限制。 自定义 picker 返回的文件未提供 size 时跳过大小校验，调用方需自行保证大小限制。 | 否 |
| mediaType | TUploadMediaType | TUploadMediaType.image | 允许选择的媒体类型。 | 否 |
| onChanged | ValueChanged&lt;List&lt;TUploadFile&gt;&gt;? | - | 文件列表变化回调；为 null 时禁用。 | 否 |
| onError | ValueChanged&lt;Object&gt;? | - | 新增文件流程出现异常时触发，包括选择器失败，以及该流程中 onChanged、onValidationError 同步抛出的业务异常。 不表示网络上传失败；组件不执行网络上传。其他点击、删除、排序回调的异常不在此流程内捕获。 | 否 |
| onFileTap | ValueChanged&lt;TUploadFile&gt;? | - | 点击任意状态的已有文件时触发。 组件不会自动预览或重新上传；调用方应根据 `TUploadFile.status` 决定后续行为。组件禁用时不会触发。 | 否 |
| onValidationError | ValueChanged&lt;TUploadValidationError&gt;? | - | 文件校验失败时触发。 新增批次超出数量或大小限制时整批拒绝，不触发 onChanged。 | 否 |
| picker | TUploadPicker? | - | 自定义文件选择器；为空时使用 image_picker。 | 否 |


### TUploadFile
#### 简介
不可变的上传文件数据。

#### 声明

```dart
class TUploadFile
```

#### 默认构造方法


```dart
const TUploadFile({
  required this.id,
  required this.name,
  this.url,
  this.bytes,
  this.size,
  this.status = TUploadFileStatus.ready,
  this.progress,
  this.errorText,
  this.canRemove = true,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| bytes | Uint8List? | - | 本地预览字节。 | 否 |
| canRemove | bool | true | 是否允许移除。 | 否 |
| errorText | String? | - | 失败状态文案。 | 否 |
| id | String | - | 文件唯一标识。 | 是 |
| name | String | - | 文件名。 | 是 |
| progress | double? | - | 上传进度，范围为 0 到 1。 | 否 |
| size | int? | - | 文件字节数。 | 否 |
| status | TUploadFileStatus | TUploadFileStatus.ready | 上传状态。 | 否 |
| url | String? | - | 远程预览地址。 | 否 |


#### 实例方法

##### TUploadFile.copyWith

```dart
TUploadFile copyWith({
  String? id,
  String? name,
  String? url,
  Uint8List? bytes,
  int? size,
  TUploadFileStatus? status,
  double? progress,
  String? errorText,
  bool? canRemove,
})
```


创建部分字段变化的新实例。
## 返回值
用非空参数替换对应字段的新文件对象；null 参数保留当前字段。

返回类型：`TUploadFile`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| id | String? | - | 文件唯一标识。 | 否 |
| name | String? | - | 文件名。 | 否 |
| url | String? | - | 远程预览地址。 | 否 |
| bytes | Uint8List? | - | 本地预览字节。 | 否 |
| size | int? | - | 文件字节数。 | 否 |
| status | TUploadFileStatus? | - | 上传状态。 | 否 |
| progress | double? | - | 上传进度，范围为 0 到 1。 | 否 |
| errorText | String? | - | 失败状态文案。 | 否 |
| canRemove | bool? | - | 是否允许移除。 | 否 |


### TUploadThemeData
#### 简介
TUpload 组件级 ThemeExtension。
{@category ComponentTheme}

#### 声明

```dart
class TUploadThemeData extends ThemeExtension<TUploadThemeData>
```

#### 默认构造方法


```dart
const TUploadThemeData({
  this.variant,
  this.itemSize,
  this.spacing,
  this.runSpacing,
  this.alignment,
  this.backgroundColor,
  this.foregroundColor,
  this.disabledBackgroundColor,
  this.disabledForegroundColor,
  this.overlayColor,
  this.statusTextStyle,
  this.borderRadius,
  this.addIconSize,
  this.statusIconSize,
  this.removeButtonSize,
  this.removeButtonColor,
  this.removeIconSize,
  this.disabledMaskColor,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| addIconSize | double? | - | 网格添加图标尺寸；null 时为 28 逻辑像素。 | 否 |
| alignment | WrapAlignment? | - | 网格 Wrap 对齐方式；null 时为 WrapAlignment.start。 | 否 |
| backgroundColor | Color? | - | 启用项背景色；null 时使用 bgColorSecondaryContainer Token。 | 否 |
| borderRadius | double? | - | 方形上传项圆角，单位为逻辑像素；null 时使用 radiusDefault Token，圆形变体不使用该值。 | 否 |
| disabledBackgroundColor | Color? | - | 禁用添加项背景色；null 时使用 bgColorComponentDisabled Token。 | 否 |
| disabledForegroundColor | Color? | - | 禁用添加项前景色；null 时使用 textColorDisabled Token。 | 否 |
| disabledMaskColor | Color? | - | 有图片预览且处于 ready/success 的禁用文件遮罩色；null 时亮色使用 textColorAnti、暗色使用 fontGray1，alpha 均为 0.6。 | 否 |
| foregroundColor | Color? | - | 启用项前景色；null 时使用 textColorPlaceholder Token。 | 否 |
| itemSize | double? | - | 网格上传项的宽高，单位为逻辑像素；null 时为 80。 | 否 |
| overlayColor | Color? | - | 上传中/失败状态的遮罩色；null 时使用 fontGray3 Token。 | 否 |
| removeButtonColor | Color? | - | 移除按钮背景色；null 时使用 textColorDisabled Token。 | 否 |
| removeButtonSize | double? | - | 移除按钮宽高；null 时为 20 逻辑像素。 | 否 |
| removeIconSize | double? | - | 移除图标尺寸；null 时为 16 逻辑像素。 | 否 |
| runSpacing | double? | - | 网格项纵向间距；null 时使用全局 spacer Token。列表项间距由全局 spacer1 决定。 | 否 |
| spacing | double? | - | 网格项横向间距；null 时使用全局 spacer Token。 | 否 |
| statusIconSize | double? | - | 上传状态图标尺寸；null 时为 24 逻辑像素。 | 否 |
| statusTextStyle | TextStyle? | - | 状态文案样式；null 时使用反色前景色与 fontBodySmall，字号最终回退 12。 | 否 |
| variant | TUploadVariant? | - | 上传项形状；null 时使用圆角方形。 | 否 |


#### 实例方法

##### TUploadThemeData.copyWith

```dart
TUploadThemeData copyWith({
  TUploadVariant? variant,
  double? itemSize,
  double? spacing,
  double? runSpacing,
  WrapAlignment? alignment,
  Color? backgroundColor,
  Color? foregroundColor,
  Color? disabledBackgroundColor,
  Color? disabledForegroundColor,
  Color? overlayColor,
  TextStyle? statusTextStyle,
  double? borderRadius,
  double? addIconSize,
  double? statusIconSize,
  double? removeButtonSize,
  Color? removeButtonColor,
  double? removeIconSize,
  Color? disabledMaskColor,
})
```


复制主题配置。
## 返回值
返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TUploadThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| variant | TUploadVariant? | - | 上传项形状；null 时使用圆角方形。 | 否 |
| itemSize | double? | - | 网格上传项的宽高，单位为逻辑像素；null 时为 80。 | 否 |
| spacing | double? | - | 网格项横向间距；null 时使用全局 spacer Token。 | 否 |
| runSpacing | double? | - | 网格项纵向间距；null 时使用全局 spacer Token。列表项间距由全局 spacer1 决定。 | 否 |
| alignment | WrapAlignment? | - | 网格 Wrap 对齐方式；null 时为 WrapAlignment.start。 | 否 |
| backgroundColor | Color? | - | 启用项背景色；null 时使用 bgColorSecondaryContainer Token。 | 否 |
| foregroundColor | Color? | - | 启用项前景色；null 时使用 textColorPlaceholder Token。 | 否 |
| disabledBackgroundColor | Color? | - | 禁用添加项背景色；null 时使用 bgColorComponentDisabled Token。 | 否 |
| disabledForegroundColor | Color? | - | 禁用添加项前景色；null 时使用 textColorDisabled Token。 | 否 |
| overlayColor | Color? | - | 上传中/失败状态的遮罩色；null 时使用 fontGray3 Token。 | 否 |
| statusTextStyle | TextStyle? | - | 状态文案样式；null 时使用反色前景色与 fontBodySmall，字号最终回退 12。 | 否 |
| borderRadius | double? | - | 方形上传项圆角，单位为逻辑像素；null 时使用 radiusDefault Token，圆形变体不使用该值。 | 否 |
| addIconSize | double? | - | 网格添加图标尺寸；null 时为 28 逻辑像素。 | 否 |
| statusIconSize | double? | - | 上传状态图标尺寸；null 时为 24 逻辑像素。 | 否 |
| removeButtonSize | double? | - | 移除按钮宽高；null 时为 20 逻辑像素。 | 否 |
| removeButtonColor | Color? | - | 移除按钮背景色；null 时使用 textColorDisabled Token。 | 否 |
| removeIconSize | double? | - | 移除图标尺寸；null 时为 16 逻辑像素。 | 否 |
| disabledMaskColor | Color? | - | 有图片预览且处于 ready/success 的禁用文件遮罩色；null 时亮色使用 textColorAnti、暗色使用 fontGray1，alpha 均为 0.6。 | 否 |


##### TUploadThemeData.lerp

```dart
TUploadThemeData lerp(ThemeExtension<TUploadThemeData>? other, double t)
```


生成主题过渡配置。
## 返回值
按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TUploadThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TUploadThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


### TUploadFileStatus
#### 简介
上传文件展示状态。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| ready | 已选择，等待业务上传。 |
| uploading | 上传中。 |
| success | 上传成功。 |
| error | 上传失败。 |
| retryableError | 上传失败且允许重试。 该状态只控制刷新图标和“重新上传”文案；组件不会自动重试。 |


### TUploadLayout
#### 简介
上传文件的布局方式。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| grid | 宫格布局。 |
| list | 列表布局。 |


### TUploadVariant
#### 简介
上传项形状。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| square | 圆角方形。 |
| circle | 圆形。 |


### TUploadMediaType
#### 简介
可选择的上传媒体类型。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| image | 图片。 |
| video | 视频。 |


### TUploadValidationError
#### 简介
上传文件校验错误。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| maxFiles | 超出最大文件数量。 |
| fileSize | 文件大小超出限制。 |


### TUploadPicker
#### 简介
自定义文件选择器。
## 返回值
文件选择完成时提供选择的文件列表；空列表表示没有新增文件。
#### 类型定义

```dart
typedef TUploadPicker = Future<List<TUploadFile>> Function();
```
