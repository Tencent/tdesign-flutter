## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TUpload

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
| draggable | bool | false | 是否支持长按拖拽排序；禁用时不生效。 | 否 |
| files | List&lt;TUploadFile&gt; | - | 受控文件列表。 | 是 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| layout | TUploadLayout | TUploadLayout.grid | 文件布局方式。 | 否 |
| maxFiles | int? | 1 | 最大文件数量；null 表示不限制。 | 否 |
| maxFileSize | int? | - | 单个文件最大字节数；null 表示不限制。 | 否 |
| mediaType | TUploadMediaType | TUploadMediaType.image | 允许选择的媒体类型。 | 否 |
| onChanged | ValueChanged&lt;List&lt;TUploadFile&gt;&gt;? | - | 文件列表变化回调；为 null 时禁用。 | 否 |
| onError | ValueChanged&lt;Object&gt;? | - | 文件选择失败时触发。 | 否 |
| onFileTap | ValueChanged&lt;TUploadFile&gt;? | - | 点击任意状态的已有文件时触发；组件不会自动预览或重新上传。 | 否 |
| onValidationError | ValueChanged&lt;TUploadValidationError&gt;? | - | 文件校验失败时触发。 | 否 |
| picker | TUploadPicker? | - | 自定义文件选择器；为空时使用 image_picker。 | 否 |


### TUploadFile

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
| addIconSize | double? | - | 添加图标尺寸。 | 否 |
| alignment | WrapAlignment? | - | Wrap 对齐方式。 | 否 |
| backgroundColor | Color? | - | 默认背景色。 | 否 |
| borderRadius | double? | - | 方形上传项圆角。 | 否 |
| disabledBackgroundColor | Color? | - | 禁用背景色。 | 否 |
| disabledForegroundColor | Color? | - | 禁用前景色。 | 否 |
| disabledMaskColor | Color? | - | 禁用文件遮罩颜色。 | 否 |
| foregroundColor | Color? | - | 默认前景色。 | 否 |
| itemSize | double? | - | 上传项尺寸。 | 否 |
| overlayColor | Color? | - | 状态遮罩颜色。 | 否 |
| removeButtonColor | Color? | - | 移除按钮颜色。 | 否 |
| removeButtonSize | double? | - | 移除按钮尺寸。 | 否 |
| removeIconSize | double? | - | 移除图标尺寸。 | 否 |
| runSpacing | double? | - | 纵向间距。 | 否 |
| spacing | double? | - | 横向间距。 | 否 |
| statusIconSize | double? | - | 状态图标尺寸。 | 否 |
| statusTextStyle | TextStyle? | - | 状态文案样式。 | 否 |
| variant | TUploadVariant? | - | 上传项形状。 | 否 |


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


返回类型：`TUploadThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| variant | TUploadVariant? | - | 上传项形状。 | 否 |
| itemSize | double? | - | 上传项尺寸。 | 否 |
| spacing | double? | - | 横向间距。 | 否 |
| runSpacing | double? | - | 纵向间距。 | 否 |
| alignment | WrapAlignment? | - | Wrap 对齐方式。 | 否 |
| backgroundColor | Color? | - | 默认背景色。 | 否 |
| foregroundColor | Color? | - | 默认前景色。 | 否 |
| disabledBackgroundColor | Color? | - | 禁用背景色。 | 否 |
| disabledForegroundColor | Color? | - | 禁用前景色。 | 否 |
| overlayColor | Color? | - | 状态遮罩颜色。 | 否 |
| statusTextStyle | TextStyle? | - | 状态文案样式。 | 否 |
| borderRadius | double? | - | 方形上传项圆角。 | 否 |
| addIconSize | double? | - | 添加图标尺寸。 | 否 |
| statusIconSize | double? | - | 状态图标尺寸。 | 否 |
| removeButtonSize | double? | - | 移除按钮尺寸。 | 否 |
| removeButtonColor | Color? | - | 移除按钮颜色。 | 否 |
| removeIconSize | double? | - | 移除图标尺寸。 | 否 |
| disabledMaskColor | Color? | - | 禁用文件遮罩颜色。 | 否 |


##### TUploadThemeData.lerp

```dart
TUploadThemeData lerp(ThemeExtension<TUploadThemeData>? other, double t)
```


返回类型：`TUploadThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TUploadThemeData&gt;? | - | - | 是 |
| t | double | - | - | 是 |


### TUploadFileStatus
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| ready | 已选择，等待业务上传。 |
| uploading | 上传中。 |
| success | 上传成功。 |
| error | 上传失败。 |
| retryableError | 上传失败且允许重试。 该状态只控制刷新图标和“重新上传”文案；组件不会自动重试。 |


### TUploadLayout
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| grid | 宫格布局。 |
| list | 列表布局。 |


### TUploadVariant
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| square | 圆角方形。 |
| circle | 圆形。 |


### TUploadMediaType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| image | 图片。 |
| video | 视频。 |


### TUploadValidationError
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| maxFiles | 超出最大文件数量。 |
| fileSize | 文件大小超出限制。 |


### TUploadPicker
#### 类型定义

```dart
typedef TUploadPicker = Future<List<TUploadFile>> Function();
```
