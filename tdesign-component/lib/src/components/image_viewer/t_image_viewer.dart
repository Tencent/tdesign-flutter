import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../swiper/t_swiper.dart';
import '../swiper/t_swiper_types.dart';
import 't_image_viewer_theme_data.dart';

/// 图片预览导航栏槽位构建器。
typedef TImageViewerItemBuilder =
    Widget Function(BuildContext context, int index);

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
  /// [onClose] 在预览通过按钮、点击图片、下拉手势、系统返回或蒙层关闭后触发一次。
  /// [onDelete] 在点击删除按钮时触发，仅通知当前索引。
  /// [onTap] 在点击当前图片、关闭预览前触发。
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
        onDelete: onDelete,
        onTap: onTap,
        onLongPress: onLongPress,
        leadingBuilder: leadingBuilder,
        trailingBuilder: trailingBuilder,
      ),
    ).whenComplete(() => onClose?.call());
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
  final ValueChanged<int>? onDelete;
  final ValueChanged<int>? onTap;
  final ValueChanged<int>? onLongPress;
  final TImageViewerItemBuilder? leadingBuilder;
  final TImageViewerItemBuilder? trailingBuilder;

  @override
  State<_TImageViewerView> createState() => _TImageViewerViewState();
}

class _TImageViewerViewState extends State<_TImageViewerView> {
  static const _dismissThreshold = 96.0;

  late int _index = widget.initialIndex;
  var _dragOffset = 0.0;
  var _isZoomed = false;
  late final TSwiperController _swiperController = TSwiperController(
    initialIndex: widget.initialIndex,
  );

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TImageViewerThemeData>();
    final appBarHeight = context.tTheme.spacer48;
    final backgroundColor =
        theme?.backgroundColor ??
        Color.alphaBlend(
          context.tTheme.fontGyColor1,
          context.tTheme.bgColorContainer,
        );
    return PopScope(
      child: Material(
        color: backgroundColor,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Transform.translate(
              offset: Offset(0, _dragOffset),
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.paddingOf(context).top + appBarHeight,
                ),
                child: TSwiper(
                  controller: _swiperController,
                  onChanged: _changeIndex,
                  loop: widget.loop,
                  autoplay: widget.autoplay,
                  autoplayInterval: widget.autoplayInterval,
                  pagination: TSwiperPaginationVariant.none,
                  physics: _isZoomed
                      ? const NeverScrollableScrollPhysics()
                      : const PageScrollPhysics(),
                  children: [
                    for (var index = 0; index < widget.images.length; index++)
                      _TImageViewerPage(
                        key: ValueKey('image-viewer-page-$index'),
                        image: widget.images[index],
                        maxWidth: theme?.viewerWidth ?? double.infinity,
                        maxHeight: theme?.viewerHeight ?? double.infinity,
                        onTap: () {
                          final route = ModalRoute.of(context);
                          widget.onTap?.call(index);
                          if (mounted && route?.isCurrent == true) {
                            Navigator.of(context).pop();
                          }
                        },
                        onLongPress: () => widget.onLongPress?.call(index),
                        onZoomChanged: (zoomed) {
                          if (_isZoomed != zoomed) {
                            setState(() => _isZoomed = zoomed);
                          }
                        },
                        onVerticalDragUpdate: _handleVerticalDragUpdate,
                        onVerticalDragEnd: _handleVerticalDragEnd,
                      ),
                  ],
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: appBarHeight,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.tTheme.spacer8,
                  ),
                  color: theme?.appBarBackgroundColor ?? Colors.black,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child:
                            widget.leadingBuilder?.call(context, _index) ??
                            _buildClose(context, theme),
                      ),
                      Expanded(child: _buildTitle(context, theme)),
                      SizedBox(
                        width: 40,
                        child:
                            widget.trailingBuilder?.call(context, _index) ??
                            _buildDelete(context, theme),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    if (_isZoomed || details.delta.dy <= 0 && _dragOffset <= 0) {
      return;
    }
    setState(
      () => _dragOffset = (_dragOffset + details.delta.dy).clamp(0, 240),
    );
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    if (_isZoomed) {
      return;
    }
    if (_dragOffset >= _dismissThreshold ||
        details.primaryVelocity != null && details.primaryVelocity! > 700) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _dragOffset = 0);
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
              style:
                  theme?.labelStyle ??
                  TextStyle(color: context.tTheme.textColorAnti),
            ),
          if (widget.showIndex)
            Text(
              '${_index + 1}/${widget.images.length}',
              style:
                  theme?.indexStyle ??
                  TextStyle(
                    color: context.tTheme.textColorAnti,
                    fontSize: context.tTheme.fontBodyMedium?.size ?? 14,
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
      onPressed: () => Navigator.of(context).pop(),
      constraints: const BoxConstraints.tightFor(width: 40, height: 40),
      padding: const EdgeInsets.all(8),
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
      onPressed: widget.onDelete == null
          ? null
          : () => widget.onDelete!(_index),
      constraints: const BoxConstraints.tightFor(width: 40, height: 40),
      padding: const EdgeInsets.all(8),
      icon: Icon(
        TIcons.delete,
        color: theme?.iconColor ?? context.tTheme.textColorAnti,
      ),
    );
  }
}

class _TImageViewerPage extends StatefulWidget {
  const _TImageViewerPage({
    required this.image,
    required this.maxWidth,
    required this.maxHeight,
    required this.onTap,
    required this.onLongPress,
    required this.onZoomChanged,
    required this.onVerticalDragUpdate,
    required this.onVerticalDragEnd,
    super.key,
  });

  final ImageProvider<Object> image;
  final double maxWidth;
  final double maxHeight;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final ValueChanged<bool> onZoomChanged;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;

  @override
  State<_TImageViewerPage> createState() => _TImageViewerPageState();
}

class _TImageViewerPageState extends State<_TImageViewerPage> {
  static const _doubleTapScale = 2.0;
  static const _maxScale = 3.0;

  final _transformationController = TransformationController();
  Offset? _doubleTapPosition;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onDoubleTapDown: (details) => _doubleTapPosition = details.localPosition,
      onDoubleTap: _handleDoubleTap,
      onVerticalDragUpdate: _isZoomed ? null : widget.onVerticalDragUpdate,
      onVerticalDragEnd: _isZoomed ? null : widget.onVerticalDragEnd,
      child: InteractiveViewer(
        transformationController: _transformationController,
        minScale: 1,
        maxScale: _maxScale,
        panEnabled: _isZoomed,
        onInteractionUpdate: (_) => _notifyZoomChanged(),
        onInteractionEnd: (_) => _notifyZoomChanged(),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: widget.maxWidth,
              maxHeight: widget.maxHeight,
            ),
            child: Image(
              image: widget.image,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }

  bool get _isZoomed =>
      _transformationController.value.getMaxScaleOnAxis() > 1.001;

  void _handleDoubleTap() {
    if (_isZoomed) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapPosition ?? Offset.zero;
      _transformationController.value = Matrix4(
        _doubleTapScale,
        0,
        0,
        0,
        0,
        _doubleTapScale,
        0,
        0,
        0,
        0,
        1,
        0,
        -position.dx * (_doubleTapScale - 1),
        -position.dy * (_doubleTapScale - 1),
        0,
        1,
      );
    }
    _notifyZoomChanged();
    setState(() {});
  }

  void _notifyZoomChanged() => widget.onZoomChanged(_isZoomed);
}
