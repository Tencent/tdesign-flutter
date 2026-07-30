import 'package:flutter/material.dart';
import 'package:tdesign_icons/tdesign_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../swiper/t_swiper.dart';
import '../swiper/t_swiper_types.dart';
import 't_image_viewer_theme_data.dart';

/// 图片预览导航栏槽位构建器。
typedef TImageViewerItemBuilder = Widget Function(
  BuildContext context,
  int index,
);

/// 命令式图片预览工具。
class TImageViewer {
  const TImageViewer._();

  /// 显示全屏图片预览。
  ///
  /// [context] 用于展示预览弹窗。
  /// [images] 是待预览的图片列表，不能为空。
  /// [labels] 是与图片一一对应的标签文案。
  /// [initialIndex] 设置初始展示的图片索引。
  /// [showClose] 控制关闭按钮是否显示。
  /// [showDelete] 控制删除按钮是否显示。
  /// [showIndex] 控制当前页码是否显示。
  /// [loop] 控制是否循环切换图片。
  /// [autoplay] 控制是否自动切换图片。
  /// [autoplayInterval] 设置自动切换图片的时间间隔。
  /// [barrierDismissible] 控制点击弹窗外区域时是否关闭预览。
  /// [onIndexChanged] 在当前图片索引变化时触发。
  /// [onClose] 在预览关闭时触发。
  /// [onDelete] 在点击删除按钮时触发，仅通知当前索引。
  /// [onTap] 在点击当前图片时触发。
  /// [onLongPress] 在长按当前图片时触发。
  /// [leadingBuilder] 构建导航栏起始区域。
  /// [trailingBuilder] 构建导航栏末尾区域。
  static Future<void> show({
    required BuildContext context,
    required List<ImageProvider<Object>> images,
    List<String>? labels,
    int initialIndex = 0,
    bool showClose = true,
    bool showDelete = false,
    bool showIndex = true,
    bool loop = false,
    bool autoplay = false,
    Duration autoplayInterval = const Duration(seconds: 3),
    bool barrierDismissible = true,
    ValueChanged<int>? onIndexChanged,
    VoidCallback? onClose,
    ValueChanged<int>? onDelete,
    ValueChanged<int>? onTap,
    ValueChanged<int>? onLongPress,
    TImageViewerItemBuilder? leadingBuilder,
    TImageViewerItemBuilder? trailingBuilder,
  }) {
    if (images.isEmpty) {
      throw ArgumentError.value(images, 'images', 'must not be empty');
    }
    if (initialIndex < 0 || initialIndex >= images.length) {
      throw RangeError.range(
        initialIndex,
        0,
        images.length - 1,
        'initialIndex',
      );
    }
    if (labels != null && labels.length != images.length) {
      throw ArgumentError.value(
        labels,
        'labels',
        'must have the same length as images',
      );
    }
    if (autoplayInterval <= Duration.zero) {
      throw ArgumentError.value(
        autoplayInterval,
        'autoplayInterval',
        'must be positive',
      );
    }
    final theme = Theme.of(context).extension<TImageViewerThemeData>();
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: theme?.barrierColor ?? context.tTheme.fontGyColor1,
      useSafeArea: false,
      builder: (context) => _TImageViewerView(
        images: images,
        labels: labels,
        initialIndex: initialIndex,
        showClose: showClose,
        showDelete: showDelete,
        showIndex: showIndex,
        loop: loop,
        autoplay: autoplay,
        autoplayInterval: autoplayInterval,
        onIndexChanged: onIndexChanged,
        onClose: onClose,
        onDelete: onDelete,
        onTap: onTap,
        onLongPress: onLongPress,
        leadingBuilder: leadingBuilder,
        trailingBuilder: trailingBuilder,
      ),
    );
  }
}

class _TImageViewerView extends StatefulWidget {
  const _TImageViewerView({
    required this.images,
    required this.initialIndex,
    required this.showClose,
    required this.showDelete,
    required this.showIndex,
    required this.loop,
    required this.autoplay,
    required this.autoplayInterval,
    this.labels,
    this.onIndexChanged,
    this.onClose,
    this.onDelete,
    this.onTap,
    this.onLongPress,
    this.leadingBuilder,
    this.trailingBuilder,
  });

  final List<ImageProvider<Object>> images;
  final List<String>? labels;
  final int initialIndex;
  final bool showClose;
  final bool showDelete;
  final bool showIndex;
  final bool loop;
  final bool autoplay;
  final Duration autoplayInterval;
  final ValueChanged<int>? onIndexChanged;
  final VoidCallback? onClose;
  final ValueChanged<int>? onDelete;
  final ValueChanged<int>? onTap;
  final ValueChanged<int>? onLongPress;
  final TImageViewerItemBuilder? leadingBuilder;
  final TImageViewerItemBuilder? trailingBuilder;

  @override
  State<_TImageViewerView> createState() => _TImageViewerViewState();
}

class _TImageViewerViewState extends State<_TImageViewerView> {
  late int _index = widget.initialIndex;
  late final TSwiperController _swiperController =
      TSwiperController(initialIndex: widget.initialIndex);

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TImageViewerThemeData>();
    return Material(
      color: theme?.backgroundColor ?? context.tTheme.fontGyColor1,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.paddingOf(context).top + 44),
            child: TSwiper(
              controller: _swiperController,
              onChanged: _changeIndex,
              loop: widget.loop,
              autoplay: widget.autoplay,
              autoplayInterval: widget.autoplayInterval,
              pagination: TSwiperPaginationVariant.none,
              children: [
                for (var index = 0; index < widget.images.length; index++)
                  GestureDetector(
                    key: ValueKey('image-viewer-page-$index'),
                    behavior: HitTestBehavior.opaque,
                    onTap: () => widget.onTap?.call(index),
                    onLongPress: () => widget.onLongPress?.call(index),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: theme?.viewerWidth ?? double.infinity,
                          maxHeight: theme?.viewerHeight ?? double.infinity,
                        ),
                        child: Image(
                          image: widget.images[index],
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SafeArea(
            bottom: false,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                color: theme?.appBarBackgroundColor ??
                    context.tTheme.textColorPlaceholder,
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: widget.leadingBuilder?.call(context, _index) ??
                          _buildClose(context, theme),
                    ),
                    Expanded(child: _buildTitle(context, theme)),
                    SizedBox(
                      width: 40,
                      child: widget.trailingBuilder?.call(context, _index) ??
                          _buildDelete(context, theme),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _changeIndex(int index) {
    if (_index == index) {
      return;
    }
    setState(() => _index = index);
    widget.onIndexChanged?.call(index);
  }

  Widget _buildTitle(BuildContext context, TImageViewerThemeData? theme) {
    final label = widget.labels?[_index];
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null && label.isNotEmpty)
            Text(
              label,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: theme?.labelStyle ??
                  TextStyle(color: context.tTheme.textColorAnti),
            ),
          if (widget.showIndex)
            Text(
              '${_index + 1} / ${widget.images.length}',
              style: theme?.indexStyle ??
                  TextStyle(
                    color: context.tTheme.textColorAnti,
                    fontSize: context.tTheme.fontBodyExtraSmall?.size ?? 10,
                  ),
            ),
        ],
      ),
    );
  }

  Widget _buildClose(BuildContext context, TImageViewerThemeData? theme) {
    if (!widget.showClose) {
      return const SizedBox.shrink();
    }
    return IconButton(
      tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
      onPressed: () {
        widget.onClose?.call();
        Navigator.of(context).pop();
      },
      icon: Icon(
        TIcons.close,
        color: theme?.iconColor ?? context.tTheme.textColorAnti,
      ),
    );
  }

  Widget _buildDelete(BuildContext context, TImageViewerThemeData? theme) {
    if (!widget.showDelete) {
      return const SizedBox.shrink();
    }
    return IconButton(
      tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
      onPressed:
          widget.onDelete == null ? null : () => widget.onDelete!(_index),
      icon: Icon(
        TIcons.delete,
        color: theme?.iconColor ?? context.tTheme.textColorAnti,
      ),
    );
  }
}
