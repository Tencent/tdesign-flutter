## API
### TUpload
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| draggable | bool | false | 是否支持长按拖拽排序；禁用时不生效。 |
| files | List<TUploadFile> | - | 受控文件列表。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| layout | TUploadLayout | TUploadLayout.grid | 文件布局方式。 |
| maxFiles | int? | 1 | 最大文件数量；null 表示不限制。 |
| maxFileSize | int? | - | 单个文件最大字节数；null 表示不限制。 |
| mediaType | TUploadMediaType | TUploadMediaType.image | 允许选择的媒体类型。 |
| onChanged | ValueChanged<List<TUploadFile>>? | - | 文件列表变化回调；为 null 时禁用。 |
| onError | ValueChanged<Object>? | - | 文件选择失败时触发。 |
| onFileTap | ValueChanged<TUploadFile>? | - | 点击任意状态的已有文件时触发；组件不会自动预览或重新上传。 |
| onValidationError | ValueChanged<TUploadValidationError>? | - | 文件校验失败时触发。 |
| picker | TUploadPicker? | - | 自定义文件选择器；为空时使用 image_picker。 |


### TUploadFile
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| bytes | Uint8List? | - | 本地预览字节。 |
| canRemove | bool | true | 是否允许移除。 |
| errorText | String? | - | 失败状态文案。 |
| id | String | - | 文件唯一标识。 |
| name | String | - | 文件名。 |
| progress | double? | - | 上传进度，范围为 0 到 1。 |
| size | int? | - | 文件字节数。 |
| status | TUploadFileStatus | TUploadFileStatus.ready | 上传状态。 |
| url | String? | - | 远程预览地址。 |


### TUploadThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| addIconSize | double? | - | 添加图标尺寸。 |
| alignment | WrapAlignment? | - | Wrap 对齐方式。 |
| backgroundColor | Color? | - | 默认背景色。 |
| borderRadius | double? | - | 方形上传项圆角。 |
| disabledBackgroundColor | Color? | - | 禁用背景色。 |
| disabledForegroundColor | Color? | - | 禁用前景色。 |
| disabledMaskColor | Color? | - | 禁用文件遮罩颜色。 |
| foregroundColor | Color? | - | 默认前景色。 |
| itemSize | double? | - | 上传项尺寸。 |
| overlayColor | Color? | - | 状态遮罩颜色。 |
| removeButtonColor | Color? | - | 移除按钮颜色。 |
| removeButtonSize | double? | - | 移除按钮尺寸。 |
| removeIconSize | double? | - | 移除图标尺寸。 |
| runSpacing | double? | - | 纵向间距。 |
| spacing | double? | - | 横向间距。 |
| statusIconSize | double? | - | 状态图标尺寸。 |
| statusTextStyle | TextStyle? | - | 状态文案样式。 |
| variant | TUploadVariant? | - | 上传项形状。 |


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
