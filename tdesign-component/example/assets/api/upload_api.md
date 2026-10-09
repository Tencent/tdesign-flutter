## API

### TUpload

#### 构造方法

##### TUpload

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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

#### 构造方法

##### TUploadFile

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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

创建部分字段变化的新实例。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| id | String? | - | 字段含义：文件唯一标识。 调用时的空值行为见方法说明。 | 否 |
| name | String? | - | 字段含义：文件名。 调用时的空值行为见方法说明。 | 否 |
| url | String? | - | 字段含义：远程预览地址。 调用时的空值行为见方法说明。 | 否 |
| bytes | Uint8List? | - | 字段含义：本地预览字节。 调用时的空值行为见方法说明。 | 否 |
| size | int? | - | 字段含义：文件字节数。 调用时的空值行为见方法说明。 | 否 |
| status | TUploadFileStatus? | - | 字段含义：上传状态。 调用时的空值行为见方法说明。 | 否 |
| progress | double? | - | 字段含义：上传进度，范围为 0 到 1。 调用时的空值行为见方法说明。 | 否 |
| errorText | String? | - | 字段含义：失败状态文案。 调用时的空值行为见方法说明。 | 否 |
| canRemove | bool? | - | 字段含义：是否允许移除。 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TUploadFile | - | - | - |


### TUploadThemeData

#### 构造方法

##### TUploadThemeData

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| variant | TUploadVariant? | - | 字段含义：上传项形状。 调用时的空值行为见方法说明。 | 否 |
| itemSize | double? | - | 字段含义：上传项尺寸。 调用时的空值行为见方法说明。 | 否 |
| spacing | double? | - | 字段含义：横向间距。 调用时的空值行为见方法说明。 | 否 |
| runSpacing | double? | - | 字段含义：纵向间距。 调用时的空值行为见方法说明。 | 否 |
| alignment | WrapAlignment? | - | 字段含义：Wrap 对齐方式。 调用时的空值行为见方法说明。 | 否 |
| backgroundColor | Color? | - | 字段含义：默认背景色。 调用时的空值行为见方法说明。 | 否 |
| foregroundColor | Color? | - | 字段含义：默认前景色。 调用时的空值行为见方法说明。 | 否 |
| disabledBackgroundColor | Color? | - | 字段含义：禁用背景色。 调用时的空值行为见方法说明。 | 否 |
| disabledForegroundColor | Color? | - | 字段含义：禁用前景色。 调用时的空值行为见方法说明。 | 否 |
| overlayColor | Color? | - | 字段含义：状态遮罩颜色。 调用时的空值行为见方法说明。 | 否 |
| statusTextStyle | TextStyle? | - | 字段含义：状态文案样式。 调用时的空值行为见方法说明。 | 否 |
| borderRadius | double? | - | 字段含义：方形上传项圆角。 调用时的空值行为见方法说明。 | 否 |
| addIconSize | double? | - | 字段含义：添加图标尺寸。 调用时的空值行为见方法说明。 | 否 |
| statusIconSize | double? | - | 字段含义：状态图标尺寸。 调用时的空值行为见方法说明。 | 否 |
| removeButtonSize | double? | - | 字段含义：移除按钮尺寸。 调用时的空值行为见方法说明。 | 否 |
| removeButtonColor | Color? | - | 字段含义：移除按钮颜色。 调用时的空值行为见方法说明。 | 否 |
| removeIconSize | double? | - | 字段含义：移除图标尺寸。 调用时的空值行为见方法说明。 | 否 |
| disabledMaskColor | Color? | - | 字段含义：禁用文件遮罩颜色。 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TUploadThemeData | - | - | - |


##### TUploadThemeData.lerp

位置参数：`other, t`


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TUploadThemeData&gt;? | - | - | 是 |
| t | double | - | - | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TUploadThemeData | - | - | - |


### TUploadFileStatus
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| ready | TUploadFileStatus | - | 已选择，等待业务上传。 | - |
| uploading | TUploadFileStatus | - | 上传中。 | - |
| success | TUploadFileStatus | - | 上传成功。 | - |
| error | TUploadFileStatus | - | 上传失败。 | - |
| retryableError | TUploadFileStatus | - | 上传失败且允许重试。 该状态只控制刷新图标和“重新上传”文案；组件不会自动重试。 | - |


### TUploadLayout
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| grid | TUploadLayout | - | 宫格布局。 | - |
| list | TUploadLayout | - | 列表布局。 | - |


### TUploadVariant
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| square | TUploadVariant | - | 圆角方形。 | - |
| circle | TUploadVariant | - | 圆形。 | - |


### TUploadMediaType
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| image | TUploadMediaType | - | 图片。 | - |
| video | TUploadMediaType | - | 视频。 | - |


### TUploadValidationError
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| maxFiles | TUploadValidationError | - | 超出最大文件数量。 | - |
| fileSize | TUploadValidationError | - | 文件大小超出限制。 | - |


### TUploadPicker

#### 回调参数

无参数。


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Future&lt;List&lt;TUploadFile&gt;&gt; | - | - | - |
