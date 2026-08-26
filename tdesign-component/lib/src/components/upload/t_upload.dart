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
import '../button/t_button.dart';
import '../button/t_button_types.dart';
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

    /// 是否支持长按拖拽排序；禁用时不生效。
    this.draggable = false,

    /// 最大文件数量；null 表示不限制。
    this.maxFiles = 1,

    /// 单个文件最大字节数；null 表示不限制。
    this.maxFileSize,

    /// 自定义文件选择器；为空时使用 image_picker。
    this.picker,

    /// 点击任意状态的已有文件时触发；组件不会自动预览或重新上传。
    this.onFileTap,

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

  /// 是否支持长按拖拽排序，默认为 false。
  ///
  /// 排序完成后通过 [onChanged] 返回新的不可变文件列表；当 [onChanged]
  /// 为 null 时组件禁用，不会开始拖拽。
  final bool draggable;

  /// 最大文件数量；null 表示不限制。
  final int? maxFiles;

  /// 单个文件最大字节数；null 表示不限制。
  final int? maxFileSize;

  /// 自定义文件选择器。
  final TUploadPicker? picker;

  /// 点击任意状态的已有文件时触发。
  ///
  /// 组件不会自动预览或重新上传；调用方应根据 [TUploadFile.status]
  /// 决定后续行为。组件禁用时不会触发。
  final ValueChanged<TUploadFile>? onFileTap;

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
          for (var index = 0; index < files.length; index++)
            _buildDraggableFile(
              context,
              index: index,
              feedbackWidth: size,
              child: _buildFile(context, files[index], size, theme),
            ),
          if (_canAdd) _buildAdd(context, size, theme),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, TUploadThemeData? theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final children = <Widget>[
          if (_canAdd) _buildListAdd(context),
          for (var index = 0; index < files.length; index++)
            _buildDraggableFile(
              context,
              index: index,
              feedbackWidth: constraints.hasBoundedWidth
                  ? constraints.maxWidth
                  : MediaQuery.sizeOf(context).width,
              child: _buildListFile(context, files[index], theme),
            ),
        ];
        return Column(
          children: [
            for (var index = 0; index < children.length; index++) ...[
              if (index > 0) SizedBox(height: context.tTheme.spacer12),
              children[index],
            ],
          ],
        );
      },
    );
  }

  Widget _buildDraggableFile(
    BuildContext context, {
    required int index,
    required double feedbackWidth,
    required Widget child,
  }) {
    if (!_enabled || !draggable) {
      return child;
    }
    return DragTarget<int>(
      key: ValueKey('upload-drop-${files[index].id}'),
      onWillAcceptWithDetails: (details) => details.data != index,
      onAcceptWithDetails: (details) => _reorder(details.data, index),
      builder: (context, candidates, rejected) => LongPressDraggable<int>(
        key: ValueKey('upload-drag-${files[index].id}'),
        data: index,
        feedback: Material(
          color: Colors.transparent,
          child: SizedBox(width: feedbackWidth, child: child),
        ),
        childWhenDragging: Opacity(opacity: 0.32, child: child),
        child: child,
      ),
    );
  }

  void _reorder(int oldIndex, int newIndex) {
    if (!_enabled || !draggable || oldIndex == newIndex) {
      return;
    }
    final reordered = [...files];
    final file = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, file);
    onChanged!(List.unmodifiable(reordered));
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
              onTap: _enabled && onFileTap != null
                  ? () => onFileTap!(file)
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
    return _filePreview(context, file, theme);
  }

  Widget _filePreview(
    BuildContext context,
    TUploadFile file,
    TUploadThemeData? theme,
  ) {
    return ColoredBox(
      color: theme?.backgroundColor ?? context.tTheme.bgColorSecondaryContainer,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.tTheme.spacer8,
          horizontal: context.tTheme.spacer4,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _fileIcon(file.name),
              size: 24,
              color: _fileIconColor(context, file.name),
            ),
            SizedBox(height: context.tTheme.spacer4),
            Text(
              file.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: _fontStyle(
                context.tTheme.fontBodySmall,
                _enabled
                    ? context.tTheme.textColorSecondary
                    : context.tTheme.textDisabledColor,
              ),
            ),
          ],
        ),
      ),
    );
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
    final resource = TResourceManager.instance.delegate(context);
    final label = isUploading
        ? file.progress == null
              ? resource.uploading
              : '${(file.progress! * 100).round()}%'
        : file.errorText ??
              (isRetryableError ? resource.uploadRetry : resource.uploadFailed);
    final foregroundColor = context.tTheme.textColorAnti;
    return GestureDetector(
      key: ValueKey('upload-status-${file.id}'),
      onTap: _enabled && onFileTap != null ? () => onFileTap!(file) : null,
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
                isRetryableError ? TIcons.refresh : TIcons.close_circle,
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

  Widget _buildListAdd(BuildContext context) {
    return TButton(
      key: const ValueKey('upload-add'),
      size: TButtonSize.medium,
      colorScheme: TButtonColorScheme.primary,
      icon: const Icon(TIcons.upload),
      onPressed: _enabled ? () => _pickFiles(context) : null,
      child: const Text('Upload'),
    );
  }

  Widget _buildListFile(
    BuildContext context,
    TUploadFile file,
    TUploadThemeData? theme,
  ) {
    return _listRow(
      context,
      leading: _listLeading(context, file, theme),
      title: file.name,
      subtitle: _listSubtitle(context, file),
      onTap: _enabled && onFileTap != null ? () => onFileTap!(file) : null,
      key: ValueKey('upload-list-file-${file.id}'),
      isFailure:
          file.status == TUploadFileStatus.error ||
          file.status == TUploadFileStatus.retryableError,
      trailing: _enabled && file.canRemove
          ? GestureDetector(
              key: ValueKey('upload-remove-${file.id}'),
              onTap: () => onChanged!(
                List.unmodifiable(files.where((item) => item.id != file.id)),
              ),
              child: Icon(
                TIcons.delete,
                size: 18,
                color: context.tTheme.textColorPlaceholder,
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
        dimension: 24,
        child: CircularProgressIndicator(
          value: file.progress,
          strokeWidth: 2,
          color: _enabled
              ? context.tTheme.brandNormalColor
              : context.tTheme.brandDisabledColor,
        ),
      );
    }
    if (file.status == TUploadFileStatus.error ||
        file.status == TUploadFileStatus.retryableError) {
      return Icon(
        TIcons.error_circle_filled,
        size: 24,
        color: _enabled
            ? context.tTheme.errorNormalColor
            : context.tTheme.errorDisabledColor,
      );
    }
    if (file.bytes != null || file.url != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(context.tTheme.radiusSmall),
        child: SizedBox.square(
          dimension: 24,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _preview(context, file, theme),
              if (!_enabled)
                ColoredBox(color: _disabledMaskColor(context, theme)),
            ],
          ),
        ),
      );
    }
    return Icon(
      _fileIcon(file.name),
      size: 24,
      color: _fileIconColor(context, file.name),
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
      return file.errorText ??
          TResourceManager.instance.delegate(context).uploadFailed;
    }
    if (file.size != null) {
      return _formatSize(file.size!);
    }
    final resource = TResourceManager.instance.delegate(context);
    return file.status == TUploadFileStatus.success
        ? resource.uploadSuccess
        : resource.uploadPending;
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
    bool isFailure = false,
  }) {
    final token = context.tTheme;
    final titleColor = !_enabled
        ? token.textDisabledColor
        : isFailure
        ? token.errorNormalColor
        : token.textColorPrimary;
    final subtitleColor = _enabled
        ? token.textColorPlaceholder
        : token.textDisabledColor;
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: token.bgColorSecondaryContainer,
          borderRadius: BorderRadius.circular(token.radiusDefault),
        ),
        padding: EdgeInsets.symmetric(
          vertical: token.spacer8,
          horizontal: token.spacer12,
        ),
        child: Row(
          children: [
            SizedBox.square(dimension: 24, child: Center(child: leading)),
            SizedBox(width: token.spacer12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _fontStyle(token.fontBodyMedium, titleColor),
                  ),
                  SizedBox(height: token.spacer4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _fontStyle(token.fontBodySmall, subtitleColor),
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

  IconData _fileIcon(String name) {
    final extension = name.split('.').last.toLowerCase();
    return switch (extension) {
      'pdf' => TIcons.file_pdf,
      'xls' || 'xlsx' || 'csv' => TIcons.file_excel,
      'doc' || 'docx' => TIcons.file_word,
      'ppt' || 'pptx' => TIcons.file_powerpoint,
      _ => TIcons.file,
    };
  }

  Color _fileIconColor(BuildContext context, String name) {
    final extension = name.split('.').last.toLowerCase();
    final token = context.tTheme;
    if (!_enabled) {
      return switch (extension) {
        'pdf' || 'mp4' || 'mov' => token.errorDisabledColor,
        'xls' || 'xlsx' || 'csv' => token.successDisabledColor,
        'doc' || 'docx' => token.brandDisabledColor,
        'ppt' || 'pptx' => token.warningDisabledColor,
        _ => token.textDisabledColor,
      };
    }
    return switch (extension) {
      'pdf' || 'mp4' || 'mov' => token.errorNormalColor,
      'xls' || 'xlsx' || 'csv' => token.successNormalColor,
      'doc' || 'docx' => token.brandNormalColor,
      'ppt' || 'pptx' => token.warningNormalColor,
      _ => token.textColorPrimary,
    };
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
