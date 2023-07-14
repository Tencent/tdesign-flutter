## API
### TDUpload
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| files | List<TDUploadFile> | - | 控制展示的文件列表，必传 |
| multiple | bool | false | 是否多选上传 |
| max | int | 0 | 多选上传时，上传文件数量的最大值，为0时不限制数量 |
| mediaType | List<TDUploadMediaType> | [TDUploadMediaType.image, TDUploadMediaType.video] | 支持的文件类型，目前TDUploadMediaType.image代表图片，TDUploadMediaType.video代表视频 |
| sizeLimit | double? | - | 图片大小限制，单位为KB |
| onCancel | VoidCallback? | - | 监听取消上传 |
| onError | TDUploadErrorEvent? | - | 监听文件校验出错 |
| onClick | TDUploadClickEvent? | - |  监听点击图片位 |
| onChange | TDUploadValueChangedEvent? | - | 监听添加或删除照片 |



```
```
 ### TDUploadFile
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| remotePath | String？ | - | 资源远程地址 |
| assetPath | String？ | - | 资源本地地址 |
| file | File? | - | 从相册或相机获取的资源文件 |
| canDelete | bool | true | 是否显示右上角删除icon |
| progress | int? | - | 进度，从0-100，仅在状态为loading时有效 |
| loadingText | String | Loading... | loading状态默认提示语 |
| retryText | String | Re-Upload | retry状态默认提示语 |
| errorText | String | Error | error状态默认提示语 |
| status | TDUploadFileStatus | TDUploadFileStatus.success | 资源状态，具体枚举类型见TDUploadFileStatus |

```
```

### 枚举类型

enum TDUploadMediaType {
  image, // 图片
  video, // 视频
}

enum TDUploadValidatorError {
  overSize, // 超出文件大小
  overQuantity, // 超出文件数量限制
}

enum TDUploadFileStatus {
  success, // 成功
  loading, // 加载中
  error, // 失败
  retry, // 重试
}

enum TDUploadType {
  add, // 添加
  remove, // 删除
}

```
```
### 回调函数类型

typedef TDUploadErrorEvent = void Function(Object e);
typedef TDUploadClickEvent = void Function(int value);
typedef TDUploadValueChangedEvent = void Function(
    List<TDUploadFile> files, TDUploadType type);
typedef TDUploadValidatorEvent = void Function(TDUploadValidatorError e);