## API
### TDUpload
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| disabled | bool? | false | 是否禁用 |
| enabledReplaceType | bool? | false | 是否启用replace功能 |
| files | List<TDUploadFile> | - | 控制展示的文件列表 |
| height | double? | 80.0 | 图片高度 |
| key |  | - |  |
| max | int | 0 | 用于控制文件上传数量，0为不限制，仅在multiple为true时有效 |
| mediaType | List<TDUploadMediaType> | const [TDUploadMediaType.image, TDUploadMediaType.video] | 支持上传的文件类型，图片或视频 |
| multiple | bool | false | 是否多选上传，默认false |
| onCancel | VoidCallback? | - | 监听取消上传 |
| onChange | TDUploadValueChangedEvent? | - | 监听添加, 删除和替换media事件 |
| onClick | TDUploadClickEvent? | - | 监听点击图片位 |
| onError | TDUploadErrorEvent? | - | 监听获取资源错误 |
| onMaxLimitReached | VoidCallback? | - | 监听文件超过最大数量 |
| onValidate | TDUploadValidatorEvent? | - | 监听文件校验出错 |
| sizeLimit | double? | - | 图片大小限制，单位为KB |
| type | TDUploadBoxType | TDUploadBoxType.roundedSquare | Box类型 |
| width | double? | 80.0 | 图片宽度 |
| wrapAlignment | WrapAlignment? | - | 多图对齐方式 |
| wrapRunSpacing | double? | - | 多图布局时的 runSpacing |
| wrapSpacing | double? | - | 多图布局时的 spacing |
