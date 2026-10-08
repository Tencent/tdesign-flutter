## API

### TUpload

严格受控的文件选择与上传状态展示组件。

#### 构造方法

##### TUpload

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| draggable | bool | false | 是否支持长按拖拽排序，默认为 false。 排序完成后通过 `onChanged` 返回新的不可变文件列表；当 `onChanged` 为 null 时组件禁用，不会开始拖拽。 | 否 |
| files | List&lt;TUploadFile&gt; | - | 受控文件列表。 长度不能超过 maxFiles；各文件 id 应唯一。组件不执行网络上传，由业务更新上传状态。 | 是 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| layout | TUploadLayout | TUploadLayout.grid | 文件布局方式。 | 否 |
| maxFiles | int? | 1 | 最大文件数量；null 表示不限制。 非 null 时必须大于 0；video 模式必须设为 1，包括使用自定义 picker 时。 | 否 |
| maxFileSize | int? | - | 单个文件最大字节数；null 表示不限制。 自定义 picker 返回的文件未提供 size 时跳过大小校验，调用方需自行保证大小限制。 | 否 |
| mediaType | TUploadMediaType | TUploadMediaType.image | 允许选择的媒体类型。 | 否 |
| onChanged | ValueChanged&lt;List&lt;TUploadFile&gt;&gt;? | - | 文件列表变化回调；为 null 时禁用。 | 否 |
| onError | ValueChanged&lt;Object&gt;? | - | 文件选择失败时触发。 | 否 |
| onFileTap | ValueChanged&lt;TUploadFile&gt;? | - | 点击任意状态的已有文件时触发。 组件不会自动预览或重新上传；调用方应根据 `TUploadFile.status` 决定后续行为。组件禁用时不会触发。 | 否 |
| onValidationError | ValueChanged&lt;TUploadValidationError&gt;? | - | 文件校验失败时触发。 新增批次超出数量或大小限制时整批拒绝，不触发 onChanged。 | 否 |
| picker | TUploadPicker? | - | 自定义文件选择器；为空时使用 image_picker。 | 否 |


### TUploadFile

不可变的上传文件数据。

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
| 返回值 | TUploadFile | - | 用非空参数替换对应字段的新文件对象；null 参数保留当前字段。 | - |


### TUploadThemeData

TUpload 组件级 ThemeExtension。

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

复制主题配置。

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
| 返回值 | TUploadThemeData | - | 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。 | - |


##### TUploadThemeData.lerp

位置参数：`other, t`


生成主题过渡配置。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TUploadThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TUploadThemeData | - | 按 t 在当前主题和目标主题之间生成过渡主题。 other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。 | - |


### TUploadFileStatus

上传文件展示状态。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| ready | TUploadFileStatus | - | 已选择，等待业务上传。 | - |
| uploading | TUploadFileStatus | - | 上传中。 | - |
| success | TUploadFileStatus | - | 上传成功。 | - |
| error | TUploadFileStatus | - | 上传失败。 | - |
| retryableError | TUploadFileStatus | - | 上传失败且允许重试。 该状态只控制刷新图标和“重新上传”文案；组件不会自动重试。 | - |


### TUploadLayout

上传文件的布局方式。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| grid | TUploadLayout | - | 宫格布局。 | - |
| list | TUploadLayout | - | 列表布局。 | - |


### TUploadVariant

上传项形状。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| square | TUploadVariant | - | 圆角方形。 | - |
| circle | TUploadVariant | - | 圆形。 | - |


### TUploadMediaType

可选择的上传媒体类型。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| image | TUploadMediaType | - | 图片。 | - |
| video | TUploadMediaType | - | 视频。 | - |


### TUploadValidationError

上传文件校验错误。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| maxFiles | TUploadValidationError | - | 超出最大文件数量。 | - |
| fileSize | TUploadValidationError | - | 文件大小超出限制。 | - |


### TUploadPicker

自定义文件选择器。

#### 回调参数

无参数。


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Future&lt;List&lt;TUploadFile&gt;&gt; | - | 文件选择完成时提供选择的文件列表；空列表表示没有新增文件。 | - |
