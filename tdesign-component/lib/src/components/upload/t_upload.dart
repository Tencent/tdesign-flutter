import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tdesign_icons/tdesign_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import 't_upload_theme_data.dart';
import 't_upload_types.dart';

export 't_upload_types.dart';

/// 严格受控的文件选择与上传状态展示组件。
class TUpload extends StatelessWidget {
  const TUpload({
    super.key,

    /// 受控文件列表。
    required this.files,

    /// 文件列表变化回调；为 null 时禁用。
    this.onChanged,

    /// 允许选择的媒体类型。
    this.mediaType = TUploadMediaType.image,

    /// 最大文件数量；null 表示不限制。
    this.maxFiles = 1,

    /// 单个文件最大字节数；null 表示不限制。
    this.maxFileSize,

    /// 自定义文件选择器；为空时使用 image_picker。
    this.picker,

    /// 点击已有文件时触发。
    this.onPreview,

    /// 点击错误文件的重试操作时触发。
    this.onRetry,

    /// 文件校验失败时触发。
    this.onValidationError,

    /// 文件选择失败时触发。
    this.onError,
  })  : assert(maxFiles == null || maxFiles > 0),
        assert(maxFiles == null || files.length <= maxFiles),
        assert(mediaType == TUploadMediaType.image || maxFiles == 1);

  /// 受控文件列表。
  final List<TUploadFile> files;

  /// 文件列表变化回调；为 null 时禁用。
  final ValueChanged<List<TUploadFile>>? onChanged;

  /// 允许选择的媒体类型。
  final TUploadMediaType mediaType;

  /// 最大文件数量；null 表示不限制。
  final int? maxFiles;

  /// 单个文件最大字节数；null 表示不限制。
  final int? maxFileSize;

  /// 自定义文件选择器。
  final TUploadPicker? picker;

  /// 点击已有文件时触发。
  final ValueChanged<TUploadFile>? onPreview;

  /// 点击错误文件的重试操作时触发。
  final ValueChanged<TUploadFile>? onRetry;

  /// 文件校验失败时触发。
  final ValueChanged<TUploadValidationError>? onValidationError;

  /// 文件选择失败时触发。
  final ValueChanged<Object>? onError;

  bool get _enabled => onChanged != null;

  bool get _canAdd => maxFiles == null || files.length < maxFiles!;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TUploadThemeData>();
    final size = theme?.itemSize ?? 80;
    return Semantics(
      enabled: _enabled,
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          spacing: theme?.spacing ?? 8,
          runSpacing: theme?.runSpacing ?? 8,
          alignment: theme?.alignment ?? WrapAlignment.start,
          children: [
            for (final file in files) _buildFile(context, file, size, theme),
            if (_canAdd) _buildAdd(context, size, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildAdd(
    BuildContext context,
    double size,
    TUploadThemeData? theme,
  ) {
    final backgroundColor = _enabled
        ? (theme?.backgroundColor ?? context.tTheme.bgColorSecondaryContainer)
        : (theme?.disabledBackgroundColor ??
            context.tTheme.bgColorComponentDisabled);
    final foregroundColor = _enabled
        ? (theme?.foregroundColor ?? context.tTheme.textColorPlaceholder)
        : (theme?.disabledForegroundColor ?? context.tTheme.textDisabledColor);
    return Semantics(
      button: true,
      enabled: _enabled,
      label: '选择文件',
      child: GestureDetector(
        key: const ValueKey('upload-add'),
        onTap: _enabled ? () => _pickFiles(context) : null,
        child: Container(
          width: size,
          height: size,
          decoration: _decoration(context, backgroundColor, theme),
          alignment: Alignment.center,
          child: Icon(TIcons.add,
              size: theme?.addIconSize ?? 28, color: foregroundColor),
        ),
      ),
    );
  }

  Widget _buildFile(
    BuildContext context,
    TUploadFile file,
    double size,
    TUploadThemeData? theme,
  ) {
    return SizedBox.square(
      dimension: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            key: ValueKey('upload-file-${file.id}'),
            onTap:
                _enabled && onPreview != null ? () => onPreview!(file) : null,
            child: ClipRRect(
              borderRadius: _borderRadius(context, theme),
              child: _preview(context, file, theme),
            ),
          ),
          if (file.status != TUploadFileStatus.ready &&
              file.status != TUploadFileStatus.success)
            _statusOverlay(context, file, theme),
          if (_enabled && file.canRemove)
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                key: ValueKey('upload-remove-${file.id}'),
                onTap: () => onChanged!(
                  List.unmodifiable(files.where((item) => item.id != file.id)),
                ),
                child: Container(
                  width: theme?.removeButtonSize ?? 22,
                  height: theme?.removeButtonSize ?? 22,
                  decoration: BoxDecoration(
                    color: theme?.removeButtonColor ??
                        context.tTheme.textDisabledColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    TIcons.close,
                    size: theme?.removeIconSize ?? 14,
                    color: context.tTheme.textColorAnti,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _preview(
    BuildContext context,
    TUploadFile file,
    TUploadThemeData? theme,
  ) {
    if (file.bytes != null) {
      return Image.memory(file.bytes!, fit: BoxFit.cover);
    }
    if (file.url != null) {
      return Image.network(
        file.url!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(context, theme),
      );
    }
    return _placeholder(context, theme);
  }

  Widget _placeholder(BuildContext context, TUploadThemeData? theme) {
    return ColoredBox(
      color: theme?.backgroundColor ?? context.tTheme.bgColorSecondaryContainer,
      child: Icon(
        TIcons.file,
        color: theme?.foregroundColor ?? context.tTheme.textColorPlaceholder,
      ),
    );
  }

  Widget _statusOverlay(
    BuildContext context,
    TUploadFile file,
    TUploadThemeData? theme,
  ) {
    final isUploading = file.status == TUploadFileStatus.uploading;
    final label = isUploading
        ? file.progress == null
            ? '上传中'
            : '${(file.progress! * 100).round()}%'
        : file.errorText ?? '上传失败';
    final foregroundColor = context.tTheme.textColorAnti;
    return GestureDetector(
      key: ValueKey('upload-status-${file.id}'),
      onTap: _enabled && !isUploading && onRetry != null
          ? () => onRetry!(file)
          : null,
      child: ColoredBox(
        color: theme?.overlayColor ?? Colors.black54,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isUploading)
              SizedBox.square(
                dimension: theme?.statusIconSize ?? 24,
                child: CircularProgressIndicator(
                  value: file.progress,
                  strokeWidth: 2,
                  color: foregroundColor,
                ),
              )
            else
              Icon(
                TIcons.refresh,
                size: theme?.statusIconSize ?? 24,
                color: foregroundColor,
              ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme?.statusTextStyle ??
                  TextStyle(
                    color: foregroundColor,
                    fontSize: context.tTheme.fontBodySmall?.size ?? 12,
                    height: context.tTheme.fontBodySmall?.height,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFiles(BuildContext context) async {
    try {
      final selected = await (picker?.call() ?? _pickWithImagePicker());
      if (!context.mounted || selected.isEmpty) {
        return;
      }
      final limit = maxFiles;
      if (limit != null && files.length + selected.length > limit) {
        onValidationError?.call(TUploadValidationError.maxFiles);
        return;
      }
      if (maxFileSize != null &&
          selected.any(
            (file) => file.size != null && file.size! > maxFileSize!,
          )) {
        onValidationError?.call(TUploadValidationError.fileSize);
        return;
      }
      onChanged?.call(List.unmodifiable([...files, ...selected]));
    } catch (error) {
      if (context.mounted) {
        onError?.call(error);
      }
    }
  }

  Future<List<TUploadFile>> _pickWithImagePicker() async {
    final imagePicker = ImagePicker();
    final picked = <XFile>[];
    if (mediaType == TUploadMediaType.video) {
      final file = await imagePicker.pickVideo(source: ImageSource.gallery);
      if (file != null) {
        picked.add(file);
      }
    } else if (maxFiles == 1) {
      final file = await imagePicker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        picked.add(file);
      }
    } else {
      picked.addAll(await imagePicker.pickMultiImage());
    }
    return Future.wait(picked.map((file) async {
      final bytes = await file.readAsBytes();
      return TUploadFile(
        id: '${DateTime.now().microsecondsSinceEpoch}-${file.name}',
        name: file.name,
        bytes: bytes,
        size: bytes.length,
      );
    }));
  }

  BoxDecoration _decoration(
    BuildContext context,
    Color color,
    TUploadThemeData? theme,
  ) {
    if (theme?.variant == TUploadVariant.circle) {
      return BoxDecoration(color: color, shape: BoxShape.circle);
    }
    return BoxDecoration(
      color: color,
      borderRadius: _borderRadius(context, theme),
    );
  }

  BorderRadius _borderRadius(
    BuildContext context,
    TUploadThemeData? theme,
  ) {
    final radius = theme?.borderRadius ?? context.tTheme.radiusDefault;
    return theme?.variant == TUploadVariant.circle
        ? BorderRadius.circular(999)
        : BorderRadius.circular(radius);
  }
}
