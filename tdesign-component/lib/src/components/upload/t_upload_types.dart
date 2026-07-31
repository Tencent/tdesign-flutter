import 'dart:typed_data';

/// 可选择的上传媒体类型。
enum TUploadMediaType {
  /// 图片。
  image,

  /// 视频。
  video,
}

/// 上传文件展示状态。
enum TUploadFileStatus {
  /// 已选择，等待业务上传。
  ready,

  /// 上传中。
  uploading,

  /// 上传成功。
  success,

  /// 上传失败。
  error,
}

/// 上传文件校验错误。
enum TUploadValidationError {
  /// 超出最大文件数量。
  maxFiles,

  /// 文件大小超出限制。
  fileSize,
}

/// 自定义文件选择器。
typedef TUploadPicker = Future<List<TUploadFile>> Function();

/// 不可变的上传文件数据。
class TUploadFile {
  const TUploadFile({
    /// 文件唯一标识。
    required this.id,

    /// 文件名。
    required this.name,

    /// 远程预览地址。
    this.url,

    /// 本地预览字节。
    this.bytes,

    /// 文件字节数。
    this.size,

    /// 上传状态。
    this.status = TUploadFileStatus.ready,

    /// 上传进度，范围为 0 到 1。
    this.progress,

    /// 失败状态文案。
    this.errorText,

    /// 是否允许移除。
    this.canRemove = true,
  }) : assert(progress == null || (progress >= 0 && progress <= 1));

  /// 文件唯一标识。
  final String id;

  /// 文件名。
  final String name;

  /// 远程预览地址。
  final String? url;

  /// 本地预览字节。
  final Uint8List? bytes;

  /// 文件字节数。
  final int? size;

  /// 上传状态。
  final TUploadFileStatus status;

  /// 上传进度，范围为 0 到 1。
  final double? progress;

  /// 失败状态文案。
  final String? errorText;

  /// 是否允许移除。
  final bool canRemove;

  /// 创建部分字段变化的新实例。
  TUploadFile copyWith({
    String? id,
    String? name,
    String? url,
    Uint8List? bytes,
    int? size,
    TUploadFileStatus? status,
    double? progress,
    String? errorText,
    bool? canRemove,
  }) {
    return TUploadFile(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      bytes: bytes ?? this.bytes,
      size: size ?? this.size,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      errorText: errorText ?? this.errorText,
      canRemove: canRemove ?? this.canRemove,
    );
  }
}
