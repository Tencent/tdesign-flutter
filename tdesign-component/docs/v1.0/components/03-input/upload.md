# TUpload

> 状态：已完成 | 控制类型：严格受控 | Sprint：S3

`TUpload` 负责文件选择和上传状态展示。实际网络上传由业务完成，组件只通过受控 `files` 显示结果。

## 架构

| 项 | v1.0 方案 |
|---|---|
| 状态 | `files` + `onChanged` 严格受控 |
| 禁用 | `onChanged == null` |
| 默认选择器 | `image_picker` |
| 自定义选择 | `TUploadPicker` |
| 文件模型 | 不可变 `TUploadFile` |
| 主题 | `TUploadThemeData` |

## TUpload

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `files` | `List<TUploadFile>` | 必填 | 受控文件列表 |
| `onChanged` | `ValueChanged<List<TUploadFile>>?` | `null` | 完整新列表；为 null 时禁用 |
| `mediaType` | `TUploadMediaType` | `image` | 图片或视频 |
| `maxFiles` | `int?` | `1` | 最大文件数；null 表示不限制 |
| `maxFileSize` | `int?` | `null` | 单文件最大字节数 |
| `picker` | `TUploadPicker?` | `null` | 自定义文件选择器 |
| `onPreview` | `ValueChanged<TUploadFile>?` | `null` | 点击文件预览 |
| `onRetry` | `ValueChanged<TUploadFile>?` | `null` | 点击失败状态重试 |
| `onValidationError` | `ValueChanged<TUploadValidationError>?` | `null` | 数量或大小校验失败 |
| `onError` | `ValueChanged<Object>?` | `null` | 选择器异常 |

视频选择只支持单文件。图片在 `maxFiles != 1` 时使用多选选择器。

## 数据类型

### TUploadFile

不可变字段包括 `id`、`name`、`url`、`bytes`、`size`、`status`、`progress`、`errorText` 和 `canRemove`。业务上传状态通过 `copyWith` 产生新对象并更新受控列表。

`TUploadFileStatus`：

- `ready`：已选择，等待业务上传。
- `uploading`：上传中，可用 `progress` 表示 0 到 1 的进度。
- `success`：上传成功。
- `error`：上传失败，可显示 `errorText`。

`TUploadValidationError` 包含 `maxFiles` 与 `fileSize`。

## Theme

`TUploadThemeData` 提供 `variant`、`itemSize`、`spacing`、`runSpacing`、`alignment`、`backgroundColor`、`foregroundColor`、`overlayColor`、`statusTextStyle`、`borderRadius`、`addIconSize`、`statusIconSize`、`removeButtonSize`、`removeButtonColor` 和 `removeIconSize`。

`TUploadVariant` 包含 `square` 与 `circle`。

## 示例

```dart
TUpload(
  files: files,
  maxFiles: 4,
  maxFileSize: 5 * 1024 * 1024,
  onChanged: (next) => setState(() => files = next),
  onRetry: retryUpload,
  onValidationError: showValidationError,
)
```

业务上传进度更新：

```dart
final next = file.copyWith(
  status: TUploadFileStatus.uploading,
  progress: 0.5,
);
```

## 验收

- 添加与删除均返回完整不可变新列表。
- 数量、字节大小、选择异常和取消均有测试。
- 图片单选、多选和视频默认 picker 分支均有平台替身测试。
- ready、uploading、success、error 状态及 Theme 均有测试。
- Upload 源码每文件覆盖率均高于 95%，定向 analyze 为 0 issue。
