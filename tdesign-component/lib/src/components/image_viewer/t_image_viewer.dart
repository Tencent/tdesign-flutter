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
  /// 调用方需要主动关闭时，可通过持有的 [NavigatorState] 调用
  /// [NavigatorState.pop]；返回的 Future 会在路由关闭后完成一次。
  /// [images] 是待预览的图片列表，不能为空。
  /// [labels] 是与图片一一对应的标签文案。
  /// [initialIndex] 设置初始展示的图片索引。
  /// [showClose] 控制关闭按钮是否显示。
  /// [showDelete] 控制删除按钮是否显示。
  /// [showIndex] 控制当前页码是否显示。
  /// [loop] 控制是否循环切换图片。
  /// [autoplay] 控制是否自动切换图片；图片放大时暂停，还原后恢复。
  /// [autoplayInterval] 设置自动切换图片的时间间隔。
  /// [onIndexChanged] 在当前图片索引变化时触发。
  /// [onDelete] 在点击删除按钮时触发，仅通知当前索引。
  /// [onTap] 在点击当前全屏预览区、关闭预览前触发。
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
    ValueChanged<int>? onIndexChanged,
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
    final navigator = Navigator.of(context, rootNavigator: true);
    late final _TImageViewerRoute route;
    route = _TImageViewerRoute(
      context: context,
      themes: InheritedTheme.capture(from: context, to: navigator.context),
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      useSafeArea: false,
      animationStyle: const AnimationStyle(
        duration: _TImageViewerViewState._motionDuration,
        reverseDuration: _TImageViewerViewState._motionDuration,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
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
        onDragDismiss: route.dismissFromDrag,
        leadingBuilder: leadingBuilder,
        trailingBuilder: trailingBuilder,
      ),
    );
    return navigator.push<void>(route);
  }
}

class _TImageViewerRoute extends DialogRoute<void> {
  static const _dismissScale = 0.96;

  _TImageViewerRoute({
    required super.context,
    required super.builder,
    required super.themes,
    required super.barrierColor,
    required super.barrierDismissible,
    required super.useSafeArea,
    required super.animationStyle,
  });

  @override
  bool get allowSnapshotting => false;

  double? _dragDismissOffset;

  void dismissFromDrag(double offset) {
    _dragDismissOffset = offset;
    navigator?.pop();
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final transitioned = super.buildTransitions(
      context,
      animation,
      secondaryAnimation,
      child,
    );
    Widget result = ScaleTransition(
      key: const ValueKey('image-viewer-dismiss-scale'),
      scale: Tween<double>(begin: _dismissScale, end: 1).animate(animation),
      child: transitioned,
    );
    final dragDismissOffset = _dragDismissOffset;
    if (dragDismissOffset != null) {
      final height = MediaQuery.sizeOf(context).height;
      result = SlideTransition(
        key: const ValueKey('image-viewer-dismiss-transform'),
        position: Tween<Offset>(
          begin: Offset(0, (height - dragDismissOffset) / height),
          end: Offset.zero,
        ).animate(animation),
        child: result,
      );
    }
    return result;
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
    required this.onDragDismiss,
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
  final ValueChanged<double> onDragDismiss;
  final ValueChanged<int>? onIndexChanged;
  final ValueChanged<int>? onDelete;
  final ValueChanged<int>? onTap;
  final ValueChanged<int>? onLongPress;
  final TImageViewerItemBuilder? leadingBuilder;
  final TImageViewerItemBuilder? trailingBuilder;

  @override
  State<_TImageViewerView> createState() => _TImageViewerViewState();
}

class _TImageViewerViewState extends State<_TImageViewerView>
    with SingleTickerProviderStateMixin {
  static const _dismissThreshold = 96.0;
  static const _motionDuration = Duration(milliseconds: 100);

  late int _index = widget.initialIndex;
  var _dragOffset = 0.0;
  var _isZoomed = false;
  late final AnimationController _dragController;
  Animation<double>? _dragAnimation;
  late final TSwiperController _swiperController = TSwiperController(
    initialIndex: widget.initialIndex,
  );

  @override
  void initState() {
    super.initState();
    _dragController = AnimationController(
      vsync: this,
      duration: _motionDuration,
    )..addListener(_updateDragOffset);
  }

  @override
  void dispose() {
    _dragController.dispose();
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TImageViewerThemeData>();
    final appBarHeight = context.tTheme.spacer48;
    final actionSize = context.tTheme.spacer40;
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
              key: const ValueKey('image-viewer-drag-transform'),
              offset: Offset(0, _dragOffset),
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.paddingOf(context).top + appBarHeight,
                ),
                child: TSwiper(
                  controller: _swiperController,
                  onChanged: _changeIndex,
                  loop: widget.loop,
                  autoplay: widget.autoplay && !_isZoomed,
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
                  color:
                      theme?.appBarBackgroundColor ??
                      context.tTheme.fontGyColor1.withValues(alpha: 1),
                  child: Row(
                    children: [
                      SizedBox(
                        width: actionSize,
                        child:
                            widget.leadingBuilder?.call(context, _index) ??
                            _buildClose(context, theme),
                      ),
                      Expanded(child: _buildTitle(context, theme)),
                      SizedBox(
                        width: actionSize,
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
    _dragController.stop();
    setState(() {
      _dragOffset = (_dragOffset + details.delta.dy).clamp(0, 240);
    });
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    if (_isZoomed) {
      return;
    }
    if (_dragOffset >= _dismissThreshold ||
        details.primaryVelocity != null && details.primaryVelocity! > 700) {
      widget.onDragDismiss(_dragOffset);
      return;
    }
    _dragAnimation = Tween<double>(begin: _dragOffset, end: 0).animate(
      CurvedAnimation(parent: _dragController, curve: Curves.easeOutCubic),
    );
    _dragController.forward(from: 0);
  }

  void _updateDragOffset() {
    final value = _dragAnimation?.value;
    if (value != null) {
      setState(() => _dragOffset = value);
    }
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
      style: _actionStyle(context, theme, enabled: true),
      icon: const Icon(TIcons.close),
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
      style: _actionStyle(context, theme, enabled: widget.onDelete != null),
      icon: const Icon(TIcons.delete),
    );
  }

  ButtonStyle _actionStyle(
    BuildContext context,
    TImageViewerThemeData? theme, {
    required bool enabled,
  }) {
    final color = theme?.iconColor ?? context.tTheme.textColorAnti;
    final disabledColor =
        theme?.iconColor?.withValues(alpha: 0.38) ??
        context.tTheme.fontWhColor4;
    return ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(enabled ? color : disabledColor),
      backgroundColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return context.tTheme.fontWhColor4;
        }
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return context.tTheme.fontWhColor3;
        }
        return Colors.transparent;
      }),
      surfaceTintColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      shadowColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      elevation: const WidgetStatePropertyAll<double>(0),
      minimumSize: WidgetStatePropertyAll(Size.square(context.tTheme.spacer40)),
      maximumSize: WidgetStatePropertyAll(Size.square(context.tTheme.spacer40)),
      padding: WidgetStatePropertyAll(EdgeInsets.all(context.tTheme.spacer8)),
      iconSize: WidgetStatePropertyAll(context.tTheme.spacer24),
      shape: const WidgetStatePropertyAll(CircleBorder()),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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

class _TImageViewerPageState extends State<_TImageViewerPage>
    with SingleTickerProviderStateMixin {
  static const _doubleTapScale = 2.0;
  static const _maxScale = 3.0;
  static const _motionDuration = Duration(milliseconds: 200);

  final _transformationController = TransformationController();
  late final AnimationController _animationController;
  Animation<Matrix4>? _transformAnimation;
  Offset? _doubleTapPosition;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _motionDuration,
    )..addListener(_updateTransform);
  }

  @override
  void dispose() {
    _animationController.dispose();
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
              errorBuilder: (_, __, ___) => Icon(
                TIcons.close,
                key: const ValueKey('image-viewer-error-placeholder'),
                size: context.tTheme.spacer24,
                color: context.tTheme.textColorAnti,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool get _isZoomed =>
      _transformationController.value.getMaxScaleOnAxis() > 1.001;

  void _handleDoubleTap() {
    final target = _isZoomed
        ? Matrix4.identity()
        : _scaledTransform(_doubleTapPosition ?? Offset.zero);
    _transformAnimation =
        Matrix4Tween(
          begin: _transformationController.value,
          end: target,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
    _animationController.forward(from: 0);
  }

  Matrix4 _scaledTransform(Offset position) => Matrix4(
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

  void _updateTransform() {
    final value = _transformAnimation?.value;
    if (value == null) {
      return;
    }
    _transformationController.value = value;
    _notifyZoomChanged();
    setState(() {});
  }

  void _notifyZoomChanged() => widget.onZoomChanged(_isZoomed);
}
