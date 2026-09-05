import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../../util/iterable_ext.dart';
import '../text/t_text.dart';
import 'sticky_header/sticky_header_widget.dart';
import 't_indexes_anchor.dart';
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

  /// 索引字符列表。不传默认 A-Z
  final List<String> indexList;

  /// 索引列表最大高度（父容器高度的百分比，默认0.8）
  final double indexListMaxHeight;

  /// 选中索引
  final ValueNotifier<String> activeIndex;

  /// 点击侧边栏时触发事件
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
  var _showTip = false;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context).extension<TIndexesThemeData>() ??
        const TIndexesThemeData();
    final indexSize = theme.indexItemSize ?? 20;
    final indexSpacing = theme.indexItemSpacing ?? 2;
    final tipSize = theme.tipSize ?? context.tTheme.spacer48;
    final tipMaxWidth = theme.tipMaxWidth ?? 99;
    final tipGap = theme.tipGap ?? context.tTheme.spacer16;
    return Positioned(
      right: theme.sidebarRight ?? context.tTheme.spacer8,
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
                  return Column(
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
                              width: indexSize + context.tTheme.spacer8,
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
                                      context.tTheme.spacer8 +
                                      tipGap,
                                  child: Container(
                                    height: tipSize,
                                    constraints: BoxConstraints(
                                      minWidth: tipSize,
                                      maxWidth: tipMaxWidth,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.tTheme.spacer16,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        context.tTheme.radiusCircle,
                                      ),
                                      color:
                                          theme.tipBackgroundColor ??
                                          context.tTheme.brandLightColor,
                                    ),
                                    child: Center(
                                      child: TText(
                                        e,
                                        font:
                                            theme.tipFont ??
                                            context.tTheme.fontTitleExtraLarge,
                                        textColor:
                                            theme.tipColor ??
                                            context.tTheme.brandNormalColor,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              Container(
                                key: _containerKeys[e],
                                width: indexSize + context.tTheme.spacer8,
                                height: indexSize,
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: indexSize,
                                  height: indexSize,
                                  child: DecoratedBox(
                                    decoration: isActive
                                        ? BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              context.tTheme.radiusCircle,
                                            ),
                                            color:
                                                theme
                                                    .activeIndexBackgroundColor ??
                                                context.tTheme.brandNormalColor,
                                          )
                                        : const BoxDecoration(),
                                    child: Center(
                                      child: TText(
                                        e,
                                        font: isActive
                                            ? theme.activeIndexFont ??
                                                  context.tTheme.fontBodySmall
                                            : theme.indexFont ??
                                                  context.tTheme.fontBodySmall,
                                        textColor: isActive
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
                            ],
                          ),
                        ),
                      );
                    }).toList(),
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
