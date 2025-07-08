---
title: Upload 上传
description: 用于相册读取或拉起拍照的图片上传功能。
spline: base
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在tdesign_flutter/tdesign_flutter.dart中有所有组件的路径。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

[td_upload_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_upload_page.dart)

### 1 组件类型

单选上传
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _uploadSingle(BuildContext context) {
    return wrapDemoContainer('单选上传',
        child: TDUpload(
          files: files1,
          onClick: onClick,
          onCancel: onCancel,
          onError: print,
          onValidate: print,
          onChange: ((files, type) => onValueChanged(files1, files, type)),
        ));
  }</pre>

</td-code-block>
                                  

单选上传(替换)
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _uploadSingleWithReplace(BuildContext context) {
    return wrapDemoContainer('单选上传(替换)',
        child: TDUpload(
          files: files6,
          width: 60,
          height: 60,
          type: TDUploadBoxType.circle,
          enabledReplaceType: true,
          onClick: onClick,
          onCancel: onCancel,
          onError: print,
          onValidate: print,
          onChange: ((files, type) => onValueChanged(files6, files, type)),
        ));
  }</pre>

</td-code-block>
                                  

多选上传
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _uploadMultiple(BuildContext context) {
    return wrapDemoContainer('多选上传',
        child: TDUpload(
          files: files2,
          multiple: true,
          max: 9,
          onClick: onClick,
          onCancel: onCancel,
          onError: print,
          onValidate: print,
          onChange: ((files, type) => onValueChanged(files2, files, type)),
        ));
  }</pre>

</td-code-block>
                                  
### 1 组件状态

加载状态
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _uploadLoading(BuildContext context) {
    return wrapDemoContainer('上传图片',
        child: TDUpload(
          files: files3,
          multiple: true,
          max: 9,
          onClick: onClick,
          onCancel: onCancel,
          onError: print,
          onValidate: print,
          onChange: ((files, type) => onValueChanged(files3, files, type)),
        ));
  }</pre>

</td-code-block>
                                  

重新上传
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _uploadRetry(BuildContext context) {
    return wrapDemoContainer('上传图片',
        child: TDUpload(
          files: files4,
          multiple: true,
          max: 9,
          onClick: onClick,
          onCancel: onCancel,
          onError: print,
          onValidate: print,
          onChange: ((files, type) => onValueChanged(files4, files, type)),
        ));
  }</pre>

</td-code-block>
                                  

上传失败
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _uploadError(BuildContext context) {
    return wrapDemoContainer('上传图片',
        child: TDUpload(
          files: files5,
          multiple: true,
          max: 9,
          onClick: onClick,
          onCancel: onCancel,
          onError: print,
          onValidate: print,
          onChange: ((files, type) => onValueChanged(files5, files, type)),
        ));
  }</pre>

</td-code-block>
                                  


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
| onMaxLimitReached | VoidCallback? | - | 监听文件超过最大数量 |
| files | List<TDUploadFile> | - | 控制展示的文件列表 |
| onChange | TDUploadValueChangedEvent? | - | 监听添加, 删除和替换media事件 |
| multiple | bool | false | 是否多选上传，默认false |
| width | double? | 80.0 | 图片宽度 |
| height | double? | 80.0 | 图片高度 |
| type | TDUploadBoxType | TDUploadBoxType.roundedSquare | Box类型 |
| disabled | bool? | false | 是否禁用 |
| enabledReplaceType | bool? | false | 是否启用replace功能 |


  