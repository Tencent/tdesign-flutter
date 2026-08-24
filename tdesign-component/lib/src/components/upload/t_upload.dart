import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/basic.dart';
import '../../theme/resource_delegate.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
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

    /// 文件布局方式。
    this.layout = TUploadLayout.grid,

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
  }) : assert(maxFiles == null || maxFiles > 0),
       assert(maxFiles == null || files.length <= maxFiles),
       assert(mediaType == TUploadMediaType.image || maxFiles == 1);

  /// 受控文件列表。
  final List<TUploadFile> files;

  /// 文件列表变化回调；为 null 时禁用。
  final ValueChanged<List<TUploadFile>>? onChanged;

  /// 允许选择的媒体类型。
  final TUploadMediaType mediaType;

  /// 文件布局方式。
  final TUploadLayout layout;

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
    final content = layout == TUploadLayout.grid
        ? _buildGrid(context, size, theme)
        : _buildList(context, theme);
    return Semantics(enabled: _enabled, child: content);
  }

  Widget _buildGrid(
    BuildContext context,
    double size,
    TUploadThemeData? theme,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: theme?.spacing ?? context.tTheme.spacer8,
        runSpacing: theme?.runSpacing ?? context.tTheme.spacer8,
        alignment: theme?.alignment ?? WrapAlignment.start,
        children: [
          for (final file in files) _buildFile(context, file, size, theme),
          if (_canAdd) _buildAdd(context, size, theme),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, TUploadThemeData? theme) {
    return Column(
      children: [
        for (final file in files) _buildListFile(context, file, theme),
        if (_canAdd) _buildListAdd(context, theme),
      ],
    );
  }

  Widget _buildAdd(BuildContext context, double size, TUploadThemeData? theme) {
    final resource = TResourceManager.instance.delegate(context);
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
      label: resource.uploadSelect,
      child: GestureDetector(
        key: const ValueKey('upload-add'),
        onTap: _enabled ? () => _pickFiles(context) : null,
        child: Container(
          width: size,
          height: size,
          decoration: _decoration(context, backgroundColor, theme),
          alignment: Alignment.center,
          child: Icon(
            TIcons.add,
            size: theme?.addIconSize ?? 28,
            color: foregroundColor,
          ),
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
      child: ClipRRect(
        borderRadius: _borderRadius(context, theme),
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              key: ValueKey('upload-file-${file.id}'),
              onTap: _enabled && onPreview != null
                  ? () => onPreview!(file)
                  : null,
              child: _preview(context, file, theme),
            ),
            if (file.status != TUploadFileStatus.ready &&
                file.status != TUploadFileStatus.success)
              _statusOverlay(context, file, theme),
            if (!_enabled &&
                (file.status == TUploadFileStatus.ready ||
                    file.status == TUploadFileStatus.success) &&
                (file.bytes != null || file.url != null))
              Positioned.fill(
                child: ColoredBox(color: _disabledMaskColor(context, theme)),
              ),
            if (_enabled && file.canRemove)
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  key: ValueKey('upload-remove-${file.id}'),
                  onTap: () => onChanged!(
                    List.unmodifiable(
                      files.where((item) => item.id != file.id),
                    ),
                  ),
                  child: Container(
                    width: theme?.removeButtonSize ?? 20,
                    height: theme?.removeButtonSize ?? 20,
                    decoration: BoxDecoration(
                      color:
                          theme?.removeButtonColor ??
                          context.tTheme.textDisabledColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(
                          _borderRadius(context, theme).topRight.x,
                        ),
                        bottomLeft: Radius.circular(
                          _borderRadius(context, theme).bottomLeft.x,
                        ),
                      ),
                    ),
                    child: Icon(
                      TIcons.close,
                      size: theme?.removeIconSize ?? 16,
                      color: context.tTheme.textColorAnti,
                    ),
                  ),
                ),
              ),
          ],
        ),
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

  Color _disabledMaskColor(BuildContext context, TUploadThemeData? theme) {
    return theme?.disabledMaskColor ??
        (Theme.of(context).brightness == Brightness.light
            ? context.tTheme.textColorAnti.withValues(alpha: 0.6)
            : context.tTheme.fontGyColor1.withValues(alpha: 0.6));
  }

  Widget _statusOverlay(
    BuildContext context,
    TUploadFile file,
    TUploadThemeData? theme,
  ) {
    final isUploading = file.status == TUploadFileStatus.uploading;
    final isRetryableError = file.status == TUploadFileStatus.retryableError;
    final canRetry = _enabled && isRetryableError && onRetry != null;
    final resource = TResourceManager.instance.delegate(context);
    final label = isUploading
        ? file.progress == null
              ? resource.uploading
              : '${(file.progress! * 100).round()}%'
        : file.errorText ??
              (canRetry ? resource.uploadRetry : resource.uploadFailed);
    final foregroundColor = context.tTheme.textColorAnti;
    return GestureDetector(
      key: ValueKey('upload-status-${file.id}'),
      onTap: canRetry ? () => onRetry!(file) : null,
      child: ColoredBox(
        color: theme?.overlayColor ?? context.tTheme.fontGyColor3,
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
                canRetry ? TIcons.refresh : TIcons.close_circle,
                size: theme?.statusIconSize ?? 24,
                color: foregroundColor,
              ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  theme?.statusTextStyle ??
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

  Widget _buildListAdd(BuildContext context, TUploadThemeData? theme) {
    final resource = TResourceManager.instance.delegate(context);
    final foregroundColor = _enabled
        ? (theme?.foregroundColor ?? context.tTheme.textColorBrand)
        : (theme?.disabledForegroundColor ?? context.tTheme.textDisabledColor);
    return _listRow(
      context,
      leading: Icon(
        TIcons.add,
        size: theme?.addIconSize ?? 28,
        color: foregroundColor,
      ),
      title: resource.uploadFile,
      subtitle: resource.uploadFileHint,
      onTap: _enabled ? () => _pickFiles(context) : null,
      key: const ValueKey('upload-add'),
    );
  }

  Widget _buildListFile(
    BuildContext context,
    TUploadFile file,
    TUploadThemeData? theme,
  ) {
    final retryable = file.status == TUploadFileStatus.retryableError;
    return _listRow(
      context,
      leading: _listLeading(context, file, theme),
      title: file.name,
      subtitle: _listSubtitle(context, file),
      onTap: _enabled && retryable && onRetry != null
          ? () => onRetry!(file)
          : _enabled && onPreview != null
          ? () => onPreview!(file)
          : null,
      key: ValueKey('upload-list-file-${file.id}'),
      trailing: _enabled && file.canRemove
          ? GestureDetector(
              key: ValueKey('upload-remove-${file.id}'),
              onTap: () => onChanged!(
                List.unmodifiable(files.where((item) => item.id != file.id)),
              ),
              child: Icon(
                TIcons.delete,
                size: 24,
                color: context.tTheme.textColorSecondary,
              ),
            )
          : null,
    );
  }

  Widget _listLeading(
    BuildContext context,
    TUploadFile file,
    TUploadThemeData? theme,
  ) {
    if (file.status == TUploadFileStatus.uploading) {
      return SizedBox.square(
        dimension: 48,
        child: CircularProgressIndicator(
          value: file.progress,
          strokeWidth: 2,
          color: context.tTheme.brandNormalColor,
        ),
      );
    }
    if (file.status == TUploadFileStatus.error) {
      return Icon(
        TIcons.close_circle,
        size: 32,
        color: context.tTheme.errorNormalColor,
      );
    }
    if (file.status == TUploadFileStatus.retryableError) {
      if (!_enabled || onRetry == null) {
        return Icon(
          TIcons.close_circle,
          size: 32,
          color: context.tTheme.errorNormalColor,
        );
      }
      return Icon(
        TIcons.refresh,
        size: 32,
        color: context.tTheme.brandNormalColor,
      );
    }
    if (file.bytes != null || file.url != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(context.tTheme.radiusSmall),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _preview(context, file, theme),
            if (!_enabled)
              ColoredBox(color: _disabledMaskColor(context, theme)),
          ],
        ),
      );
    }
    return Icon(
      TIcons.file,
      size: 32,
      color: context.tTheme.textColorPlaceholder,
    );
  }

  String _listSubtitle(BuildContext context, TUploadFile file) {
    if (file.status == TUploadFileStatus.uploading) {
      return file.progress == null
          ? TResourceManager.instance.delegate(context).uploading
          : '${(file.progress! * 100).round()}%';
    }
    if (file.status == TUploadFileStatus.error) {
      return file.errorText ??
          TResourceManager.instance.delegate(context).uploadFailed;
    }
    if (file.status == TUploadFileStatus.retryableError) {
      final resource = TResourceManager.instance.delegate(context);
      return file.errorText ??
          (_enabled && onRetry != null
              ? resource.uploadRetry
              : resource.uploadFailed);
    }
    return file.size == null
        ? TResourceManager.instance.delegate(context).uploadPending
        : _formatSize(file.size!);
  }

  String _formatSize(int size) {
    if (size < 1024) {
      return '$size B';
    }
    if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(1)} KB';
    }
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Widget _listRow(
    BuildContext context, {
    required Widget leading,
    required String title,
    required String subtitle,
    required Key key,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    final token = context.tTheme;
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: token.spacer12,
          horizontal: token.spacer16,
        ),
        child: Row(
          children: [
            SizedBox.square(dimension: 48, child: Center(child: leading)),
            SizedBox(width: token.spacer12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _fontStyle(
                      token.fontBodyMedium,
                      token.textColorPrimary,
                    ),
                  ),
                  SizedBox(height: token.spacer4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _fontStyle(
                      token.fontBodySmall,
                      token.textColorSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              SizedBox(width: token.spacer12),
              trailing,
            ],
          ],
        ),
      ),
    );
  }

  TextStyle _fontStyle(Font? font, Color color) => TextStyle(
    color: color,
    fontSize: font?.size ?? 14,
    height: font?.height,
    fontWeight: font?.fontWeight,
  );

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
    return Future.wait(
      picked.map((file) async {
        final bytes = await file.readAsBytes();
        return TUploadFile(
          id: '${DateTime.now().microsecondsSinceEpoch}-${file.name}',
          name: file.name,
          bytes: bytes,
          size: bytes.length,
        );
      }),
    );
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

  BorderRadius _borderRadius(BuildContext context, TUploadThemeData? theme) {
    final radius = theme?.borderRadius ?? context.tTheme.radiusDefault;
    return theme?.variant == TUploadVariant.circle
        ? BorderRadius.circular(999)
        : BorderRadius.circular(radius);
  }
}
