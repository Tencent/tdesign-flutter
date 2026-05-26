## API
### TUpload
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| disabled | bool? | false | 是否禁用 |
| enabledReplaceType | bool? | false | 是否启用replace功能 |
| files | List<TUploadFile> | - | 控制展示的文件列表 |
| height | double? | 80.0 | 图片高度 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| max | int | 0 | 用于控制文件上传数量，0为不限制，仅在multiple为true时有效 |
| mediaType | List<TUploadMediaType> | const [TUploadMediaType.image, TUploadMediaType.video] | 支持上传的文件类型，图片或视频 |
| multiple | bool | false | 是否多选上传，默认false |
| onCancel | VoidCallback? | - | 监听取消上传 |
| onChange | TUploadValueChangedEvent? | - | 监听添加, 删除和替换media事件 |
| onClick | TUploadClickEvent? | - | 监听点击图片位 |
| onError | TUploadErrorEvent? | - | 监听获取资源错误 |
| onMaxLimitReached | VoidCallback? | - | 监听文件超过最大数量 |
| onUploadTap | VoidCallback? | - | 自定义upload按钮事件 |
| onValidate | TUploadValidatorEvent? | - | 监听文件校验出错 |
| sizeLimit | double? | - | 图片大小限制，单位为KB |
| type | TUploadBoxType | TUploadBoxType.roundedSquare | Box类型 |
| width | double? | 80.0 | 图片宽度 |
| wrapAlignment | WrapAlignment? | - | 多图对齐方式 |
| wrapRunSpacing | double? | - | 多图布局时的 runSpacing |
| wrapSpacing | double? | - | 多图布局时的 spacing |


### TUploadMediaType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| image | - |
| video | - |


### TUploadValidatorError
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| overSize | - |
| overQuantity | - |


### TUploadFileStatus
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| success | - |
| loading | - |
| error | - |
| retry | - |


### TUploadType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| add | - |
| remove | - |
| replace | - |


### TUploadBoxType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| roundedSquare | - |
| circle | - |


### TUploadErrorEvent
#### 类型定义

```dart
typedef TUploadErrorEvent = void Function(Object e);
```


### TUploadClickEvent
#### 类型定义

```dart
typedef TUploadClickEvent = void Function(int value);
```


### TUploadValueChangedEvent
#### 类型定义

```dart
typedef TUploadValueChangedEvent = void Function(List<TUploadFile> files, TUploadType type);
```


### TUploadValidatorEvent
#### 类型定义

```dart
typedef TUploadValidatorEvent = void Function(TUploadValidatorError e);
```
