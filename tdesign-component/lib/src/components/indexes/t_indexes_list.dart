import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../theme/basic.dart' show Font;
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_internal_material.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../text/t_text_styled.dart';
import 't_indexes_theme_data.dart';

/// 索引
class TIndexesList extends StatefulWidget {
  const TIndexesList({
    Key? key,
    required this.indexList,
    this.indexListMaxHeight = 0.8,
    required this.activeIndex,
    required this.onSelect,
    this.builderIndex,
  }) : assert(
         indexListMaxHeight > 0 && indexListMaxHeight <= 1,
         'indexListMaxHeight must be greater than 0 and no greater than 1.',
       ),
       super(key: key);

  /// 索引字符列表，需显式传入实际展示的索引序列。本组件不自带默认值；通常由 TIndexes 装配并透传（TIndexes 未指定时默认使用 A-Z）
  final List<String> indexList;

  /// 索引列表最大高度（父容器高度的百分比，默认0.8）。
  /// 超过该高度时竖向滚动；点击仍选中，未溢出时可拖动选中。
  final double indexListMaxHeight;

  /// 选中索引
  final ValueNotifier<String> activeIndex;

  /// 用户点击或在未溢出时拖动侧边栏、激活索引发生变化时触发。
  /// 溢出索引条的滚动不会触发选择回调。
  final void Function(String newIndex, String oldIndex) onSelect;

  /// 索引文本自定义构建，包括索引激活左侧提示
  final Widget Function(BuildContext context, String index, bool isActive)?
  builderIndex;

  @override
  State<TIndexesList> createState() => _TIndexesListState();
}

class _TIndexesListState extends State<TIndexesList> {
  late Map<String, GlobalKey> _containerKeys;
  Timer? _hideTipTimer;
  final _indexScrollController = ScrollController();
  var _showTip = false;
  String? _lastActiveIndex;
  double? _lastIndexExtent;
  double? _lastViewportHeight;
  int? _lastActivePosition;

  @override
  void initState() {
    super.initState();
    assert(
      widget.indexList.toSet().length == widget.indexList.length,
      'indexList values must be unique.',
    );
    _initContainerKeys();
  }

  void _initContainerKeys() {
    _containerKeys = widget.indexList.asMap().map(
      (index, e) => MapEntry(e, GlobalKey()),
    );
  }

  @override
  void didUpdateWidget(TIndexesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.indexList != oldWidget.indexList) {
      assert(
        widget.indexList.toSet().length == widget.indexList.length,
        'indexList values must be unique.',
      );
      _initContainerKeys();
    }
  }

  @override
  void dispose() {
    _hideTipTimer?.cancel();
    _indexScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context).extension<TIndexesThemeData>() ??
        const TIndexesThemeData();
    double lineHeight(Font? font) => TTextStyled(
      'Ag',
      centerLeading: true,
      font: font,
      style: null,
    ).naturalSize(context).height;
    final indexSize =
        theme.indexItemSize ??
        (widget.builderIndex != null
            ? 20
            : max(
                20,
                max(
                  lineHeight(theme.indexFont ?? context.tTheme.fontBodySmall),
                  lineHeight(
                    theme.activeIndexFont ?? context.tTheme.fontBodySmall,
                  ),
                ),
              ));
    final indexSpacing = theme.indexItemSpacing ?? 2;
    final tipSize =
        theme.tipSize ??
        max(
          context.tTheme.spacer5,
          lineHeight(theme.tipFont ?? context.tTheme.fontTitleExtraLarge),
        );
    final tipMaxWidth = max(theme.tipMaxWidth ?? 99, tipSize);
    final tipGap = theme.tipGap ?? context.tTheme.spacer2;
    return Positioned(
      right: theme.sidebarRight ?? context.tTheme.spacer,
      top: 0,
      bottom: 0,
      child: Align(
        child: FractionallySizedBox(
          heightFactor: widget.indexListMaxHeight,
          child: Align(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragUpdate: (details) {
                _changeSelect(details.globalPosition);
              },
              onTapUp: (details) {
                _changeSelect(details.globalPosition);
                _hideTip();
              },
              onVerticalDragEnd: (details) {
                _hideTip();
              },
              child: ValueListenableBuilder(
                valueListenable: widget.activeIndex,
                builder: (context, value, child) {
                  final strip = Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.indexList.map((e) {
                      final isActive = value == e;
                      if (widget.builderIndex != null) {
                        return Semantics(
                          button: true,
                          selected: isActive,
                          label: e,
                          onTap: () => _selectIndex(e),
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: e == widget.indexList.last
                                  ? 0
                                  : indexSpacing,
                            ),
                            child: SizedBox(
                              key: _containerKeys[e],
                              width: indexSize + context.tTheme.spacer,
                              height: indexSize,
                              child: OverflowBox(
                                alignment: Alignment.centerRight,
                                maxWidth: double.infinity,
                                child: widget.builderIndex!(
                                  context,
                                  e,
                                  isActive,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return Semantics(
                        button: true,
                        selected: isActive,
                        label: e,
                        onTap: () => _selectIndex(e),
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: e == widget.indexList.last
                                ? 0
                                : indexSpacing,
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              if (_showTip && value == e)
                                Positioned(
                                  top: -tipSize / 2 + indexSize / 2,
                                  right:
                                      indexSize +
                                      context.tTheme.spacer +
                                      tipGap,
                                  child: Container(
                                    height: tipSize,
                                    constraints: BoxConstraints(
                                      minWidth: tipSize,
                                      maxWidth: tipMaxWidth,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.tTheme.spacer2,
                                    ),
                                    decoration: ShapeDecoration(
                                      // 提示气泡以自身高度作为圆角。
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          tipSize,
                                        ),
                                      ),
                                      color:
                                          theme.tipBackgroundColor ??
                                          context.tTheme.brandColorLight,
                                    ),
                                    child: Center(
                                      child: TTextStyled(
                                        e,
                                        centerLeading: true,
                                        font:
                                            theme.tipFont ??
                                            context.tTheme.fontTitleExtraLarge,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color:
                                              theme.tipColor ??
                                              context.tTheme.brandColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              Container(
                                key: _containerKeys[e],
                                width: indexSize + context.tTheme.spacer,
                                height: indexSize,
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: indexSize,
                                  height: indexSize,
                                  child: DecoratedBox(
                                    decoration: isActive
                                        ? ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    indexSize,
                                                  ),
                                            ),
                                            color:
                                                theme
                                                    .activeIndexBackgroundColor ??
                                                context.tTheme.brandColor,
                                          )
                                        : const BoxDecoration(),
                                    child: Center(
                                      child: TTextStyled(
                                        e,
                                        centerLeading: true,
                                        font: isActive
                                            ? theme.activeIndexFont ??
                                                  context.tTheme.fontBodySmall
                                            : theme.indexFont ??
                                                  context.tTheme.fontBodySmall,
                                        style: TextStyle(
                                          color: isActive
                                              ? theme.activeIndexColor ??
                                                    context.tTheme.textColorAnti
                                              : theme.indexColor ??
                                                    context
                                                        .tTheme
                                                        .textColorPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final contentHeight =
                          widget.indexList.length * indexSize +
                          max(0, widget.indexList.length - 1) * indexSpacing;
                      if (!constraints.hasBoundedHeight ||
                          contentHeight <= constraints.maxHeight) {
                        _lastViewportHeight = null;
                        return strip;
                      }
                      final activePosition = widget.indexList.indexOf(value);
                      final extent = indexSize + indexSpacing;
                      if (_lastActiveIndex != value ||
                          _lastActivePosition != activePosition ||
                          _lastIndexExtent != extent ||
                          _lastViewportHeight != constraints.maxHeight) {
                        _lastActiveIndex = value;
                        _lastActivePosition = activePosition;
                        _lastIndexExtent = extent;
                        _lastViewportHeight = constraints.maxHeight;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!mounted ||
                              !_indexScrollController.hasClients ||
                              activePosition < 0 ||
                              widget.activeIndex.value != value) {
                            return;
                          }
                          final position = _indexScrollController.position;
                          final start = activePosition * extent;
                          final end = start + indexSize;
                          final target = start < position.pixels
                              ? start
                              : end >
                                    position.pixels + position.viewportDimension
                              ? end - position.viewportDimension
                              : position.pixels;
                          if (target != position.pixels) {
                            _indexScrollController.jumpTo(
                              target.clamp(
                                position.minScrollExtent,
                                position.maxScrollExtent,
                              ),
                            );
                          }
                        });
                      }
                      final scroll = TInternalScrollScope(
                        child: SingleChildScrollView(
                          controller: _indexScrollController,
                          primary: false,
                          clipBehavior: Clip.none,
                          child: strip,
                        ),
                      );
                      return widget.builderIndex != null
                          ? ClipRect(
                              clipper: _IndexStripClipper(tipMaxWidth + tipGap),
                              child: scroll,
                            )
                          : ClipPath(
                              clipBehavior: Clip.hardEdge,
                              clipper: _BuiltinIndexStripClipper(
                                tipMaxWidth + tipGap,
                                tipSize,
                              ),
                              child: scroll,
                            );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _changeSelect(Offset globalPosition) {
    final newIndex = _fingerInsideContainer(globalPosition);
    if (newIndex != null) {
      _selectIndex(newIndex);
    }
  }

  void _selectIndex(String newIndex) {
    if (newIndex == widget.activeIndex.value) {
      return;
    }
    final oldIndex = widget.activeIndex.value;
    widget.activeIndex.value = newIndex;
    _showTip = true;
    widget.onSelect.call(newIndex, oldIndex);
  }

  String? _fingerInsideContainer(Offset globalPosition) {
    for (var entry in _containerKeys.entries) {
      final renderBox =
          entry.value.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final localPosition = renderBox.globalToLocal(globalPosition);
        final isIn = renderBox.hitTest(
          BoxHitTestResult(),
          position: localPosition,
        );
        if (isIn) {
          return entry.key;
        }
      }
    }
    return null;
  }

  void _hideTip() {
    _hideTipTimer?.cancel();
    _hideTipTimer = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _showTip = false;
      });
    });
  }
}

// 保留左侧提示气泡，只裁切滚动条上、下边界外的索引。
class _IndexStripClipper extends CustomClipper<Rect> {
  const _IndexStripClipper(this.tipWidth);
  final double tipWidth;
  @override
  Rect getClip(Size size) =>
      Rect.fromLTRB(-tipWidth, 0, size.width, size.height);
  @override
  bool shouldReclip(_IndexStripClipper oldClipper) =>
      oldClipper.tipWidth != tipWidth;
}

// 内置气泡位于 x < 0，允许它越过滚动条上下边界；索引本身仍裁切。
class _BuiltinIndexStripClipper extends CustomClipper<Path> {
  const _BuiltinIndexStripClipper(this.tipWidth, this.tipHeight);
  final double tipWidth;
  final double tipHeight;
  @override
  Path getClip(Size size) => Path()
    ..addRect(Offset.zero & size)
    ..addRect(Rect.fromLTRB(-tipWidth, -tipHeight, 0, size.height + tipHeight));
  @override
  bool shouldReclip(_BuiltinIndexStripClipper old) =>
      old.tipWidth != tipWidth || old.tipHeight != tipHeight;
}
