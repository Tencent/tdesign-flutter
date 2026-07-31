## API
### TUpload
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| files | List<TUploadFile> | - | 受控文件列表。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| maxFiles | int? | 1 | 最大文件数量；null 表示不限制。 |
| maxFileSize | int? | - | 单个文件最大字节数；null 表示不限制。 |
| mediaType | TUploadMediaType | TUploadMediaType.image | 允许选择的媒体类型。 |
| onChanged | ValueChanged<List<TUploadFile>>? | - | 文件列表变化回调；为 null 时禁用。 |
| onError | ValueChanged<Object>? | - | 文件选择失败时触发。 |
| onPreview | ValueChanged<TUploadFile>? | - | 点击已有文件时触发。 |
| onRetry | ValueChanged<TUploadFile>? | - | 点击错误文件的重试操作时触发。 |
| onValidationError | ValueChanged<TUploadValidationError>? | - | 文件校验失败时触发。 |
| picker | TUploadPicker? | - | 自定义文件选择器；为空时使用 image_picker。 |
