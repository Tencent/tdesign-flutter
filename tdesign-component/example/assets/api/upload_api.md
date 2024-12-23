## API
### TDUpload
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| max | int | 0 | 用于控制文件上传数量，0为不限制，仅在multiple为true时有效 |
| mediaType | List<TDUploadMediaType> | const [TDUploadMediaType.image, TDUploadMediaType.video] | 支持上传的文件类型，图片或视频 |
| sizeLimit | double? | - | 图片大小限制，单位为KB |
| onCancel | VoidCallback? | - | 监听取消上传 |
| onError | TDUploadErrorEvent? | - | 监听获取资源错误 |
| onValidate | TDUploadValidatorEvent? | - | 监听文件校验出错 |
| onClick | TDUploadClickEvent? | - | 监听点击图片位 |
| files | List<TDUploadFile> | - | 控制展示的文件列表 |
| onChange | TDUploadValueChangedEvent? | - | 监听添加或删除照片 |
| multiple | bool | false | 是否多选上传，默认false |
