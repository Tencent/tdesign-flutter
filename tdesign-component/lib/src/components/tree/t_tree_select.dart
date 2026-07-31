import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../text/t_text.dart';
import 't_tree_select_theme_data.dart';

const _kTreeSelectHeight = 336.0;
const _kRootColumnWidth = 106.0;
const _kIntermediateColumnWidth = 103.0;
const _kLeafColumnMinWidth = 184.0;
const _kItemHeight = 56.0;
const _kOutwardCornerRadius = 9.0;

/// 不可变的树形选择选项。
@immutable
class TTreeSelectOption {
  const TTreeSelectOption({
    /// 展示文案。
    required this.label,

    /// 业务值。
    required this.value,

    /// 子选项。
    this.children = const [],

    /// 是否禁用。
    this.disabled = false,
  });

  /// 展示文案。
  final String label;

  /// 业务值。
  final Object? value;

  /// 子选项。
  final List<TTreeSelectOption> children;

  /// 是否禁用。
  final bool disabled;
}

/// 严格受控的树形选择器。
///
/// [value] 中每一项都是从根到叶子的完整路径。单选模式最多保留一条路径，
/// 多选模式可同时保留多条路径。
class TTreeSelect extends StatefulWidget {
  const TTreeSelect({
    super.key,

    /// 根选项。
    required this.options,

    /// 受控选中路径。
    required this.value,

    /// 选中路径变化回调；为 null 时禁用。
    this.onChanged,

    /// 是否允许选择多个叶子节点。
    this.multiple = false,
  });

  /// 根选项。
  final List<TTreeSelectOption> options;

  /// 受控选中路径。
  final List<List<Object?>> value;

  /// 选中路径变化回调；为 null 时禁用。
  final ValueChanged<List<List<Object?>>>? onChanged;

  /// 是否允许选择多个叶子节点。
  final bool multiple;

  @override
  State<TTreeSelect> createState() => _TTreeSelectState();
}

class _TTreeSelectState extends State<TTreeSelect> {
  late List<Object?> _activePath;
  List<List<Object?>>? _lastEmittedValue;

  bool get _enabled => widget.onChanged != null;

  List<Object?> get _effectiveActivePath =>
      _activePath.isEmpty && widget.value.isEmpty
          ? _defaultActivePath()
          : _activePath;

  @override
  void initState() {
    super.initState();
    _activePath = _initialActivePath();
  }

  @override
  void didUpdateWidget(covariant TTreeSelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    final valueChanged = !_pathsEqual(oldWidget.value, widget.value);
    if (valueChanged) {
      final reflectsLocalSelection = _lastEmittedValue != null &&
          _pathsEqual(_lastEmittedValue!, widget.value);
      _lastEmittedValue = null;
      if (!reflectsLocalSelection) {
        _activePath = _initialActivePath();
        return;
      }
    } else {
      _lastEmittedValue = null;
    }
    if (!_isActivePathValid()) {
      _activePath = _initialActivePath();
    }
  }

  List<Object?> _initialActivePath() {
    if (widget.value.isEmpty) {
      return _defaultActivePath();
    }
    final active = <Object?>[];
    var options = widget.options;
    var matched = false;
    for (final value in widget.value.first) {
      final index = options.indexWhere((option) => option.value == value);
      if (index < 0) {
        break;
      }
      matched = true;
      final option = options[index];
      if (option.children.isEmpty) {
        break;
      }
      active.add(option.value);
      options = option.children;
    }
    return matched ? active : _defaultActivePath();
  }

  List<Object?> _defaultActivePath() {
    for (final option in widget.options) {
      if (!option.disabled && option.children.isNotEmpty) {
        return List<Object?>.unmodifiable([option.value]);
      }
    }
    return const [];
  }

  bool _isActivePathValid() {
    var options = widget.options;
    for (final value in _activePath) {
      final index = options.indexWhere((option) => option.value == value);
      if (index < 0) {
        return false;
      }
      final option = options[index];
      if (option.disabled || option.children.isEmpty) {
        return false;
      }
      options = option.children;
    }
    return true;
  }

  List<List<TTreeSelectOption>> _visibleColumns() {
    final columns = <List<TTreeSelectOption>>[];
    final activePath = _effectiveActivePath;
    var options = widget.options;
    var level = 0;
    while (options.isNotEmpty) {
      columns.add(options);
      if (level >= activePath.length) {
        break;
      }
      final index = options.indexWhere(
        (option) => option.value == activePath[level],
      );
      if (index < 0 || options[index].children.isEmpty) {
        break;
      }
      options = options[index].children;
      level += 1;
    }
    return columns;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TTreeSelectThemeData>();
    final columns = _visibleColumns();
    final panel = LayoutBuilder(
      builder: (context, constraints) {
        final widths = _resolveColumnWidths(
          columns.length,
          constraints.maxWidth,
          theme,
        );
        return Container(
          height: theme?.height ?? _kTreeSelectHeight,
          color: theme?.backgroundColor ?? context.tTheme.bgColorContainer,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var level = 0; level < columns.length; level++)
                  _buildColumn(
                    context,
                    columns[level],
                    level,
                    widths[level],
                    theme,
                  ),
              ],
            ),
          ),
        );
      },
    );
    return Semantics(
      enabled: _enabled,
      child: AnimatedOpacity(
        opacity: _enabled ? 1 : 0.5,
        duration: const Duration(milliseconds: 150),
        child: AbsorbPointer(absorbing: !_enabled, child: panel),
      ),
    );
  }

  List<double> _resolveColumnWidths(
    int columnCount,
    double availableWidth,
    TTreeSelectThemeData? theme,
  ) {
    final rootWidth = theme?.rootColumnWidth ?? _kRootColumnWidth;
    final explicitColumnWidth = theme?.columnWidth;
    if (columnCount <= 0) {
      return const [];
    }
    if (columnCount == 1) {
      return [rootWidth];
    }
    if (explicitColumnWidth != null) {
      return [
        rootWidth,
        for (var index = 1; index < columnCount; index++) explicitColumnWidth,
      ];
    }

    final widths = <double>[rootWidth];
    final intermediateCount = columnCount - 2;
    for (var index = 0; index < intermediateCount; index++) {
      widths.add(_kIntermediateColumnWidth);
    }
    final usedWidth = widths.fold<double>(0, (sum, width) => sum + width);
    final remainingWidth = availableWidth.isFinite
        ? availableWidth - usedWidth
        : _kLeafColumnMinWidth;
    widths.add(
      remainingWidth >= _kLeafColumnMinWidth
          ? remainingWidth
          : _kLeafColumnMinWidth,
    );
    return widths;
  }

  Widget _buildColumn(
    BuildContext context,
    List<TTreeSelectOption> options,
    int level,
    double width,
    TTreeSelectThemeData? theme,
  ) {
    final activePath = _effectiveActivePath;
    final backgroundColor = level == 0
        ? theme?.rootBackgroundColor ?? context.tTheme.bgColorSecondaryContainer
        : theme?.backgroundColor ?? context.tTheme.bgColorContainer;
    return Container(
      width: width,
      color: backgroundColor,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          final path = <Object?>[
            ...activePath.take(level),
            option.value,
          ];
          final isBranch = option.children.isNotEmpty;
          final selected = isBranch
              ? level < activePath.length && activePath[level] == option.value
              : widget.value.any((value) => listEquals(value, path));
          final previousSelected = level == 0 &&
              index > 0 &&
              _isColumnOptionSelected(
                options[index - 1],
                [
                  ...activePath.take(level),
                  options[index - 1].value,
                ],
                level,
                activePath,
              );
          final nextSelected = level == 0 &&
              index < options.length - 1 &&
              _isColumnOptionSelected(
                options[index + 1],
                [
                  ...activePath.take(level),
                  options[index + 1].value,
                ],
                level,
                activePath,
              );
          return _buildOption(
            context,
            option: option,
            path: path,
            level: level,
            selected: selected,
            isBranch: isBranch,
            previousSelected: previousSelected,
            nextSelected: nextSelected,
            theme: theme,
          );
        },
      ),
    );
  }

  bool _isColumnOptionSelected(
    TTreeSelectOption option,
    List<Object?> path,
    int level,
    List<Object?> activePath,
  ) {
    final isBranch = option.children.isNotEmpty;
    return isBranch
        ? level < activePath.length && activePath[level] == option.value
        : widget.value.any((value) => listEquals(value, path));
  }

  Widget _buildOption(
    BuildContext context, {
    required TTreeSelectOption option,
    required List<Object?> path,
    required int level,
    required bool selected,
    required bool isBranch,
    required bool previousSelected,
    required bool nextSelected,
    required TTreeSelectThemeData? theme,
  }) {
    final isRoot = level == 0;
    final itemHeight = theme?.itemHeight ?? _kItemHeight;
    final selectedBackgroundColor =
        theme?.selectedBackgroundColor ?? context.tTheme.bgColorContainer;
    final indicatorColor =
        theme?.indicatorColor ?? context.tTheme.brandNormalColor;
    final defaultStyle = TextStyle(
      color: context.tTheme.textColorPrimary,
      fontSize: context.tTheme.fontBodyLarge?.size ?? 16,
      fontWeight: FontWeight.w400,
    );
    final selectedStyle = defaultStyle.copyWith(
      color: context.tTheme.brandNormalColor,
      fontWeight: FontWeight.w600,
    );
    final effectiveTextStyle = option.disabled
        ? theme?.disabledTextStyle ??
            defaultStyle.copyWith(
              color: context.tTheme.textDisabledColor,
            )
        : selected && theme?.selectedTextStyle != null
            ? theme!.selectedTextStyle!
            : selected && (isRoot || isBranch)
                ? selectedStyle
                : theme?.textStyle ?? defaultStyle;
    final showIndicator = selected && !isBranch;
    return Semantics(
      selected: selected,
      enabled: !option.disabled,
      child: Opacity(
        opacity: option.disabled ? 0.4 : 1,
        child: _TreeOptionTile(
          key: ValueKey((level, option.value)),
          label: option.label,
          height: itemHeight,
          textStyle: effectiveTextStyle,
          selected: selected,
          root: isRoot,
          selectedBackgroundColor: selectedBackgroundColor,
          indicatorColor: indicatorColor,
          showIndicator: showIndicator,
          previousSelected: previousSelected,
          nextSelected: nextSelected,
          onTap: option.disabled
              ? null
              : () => isBranch
                  ? _openBranch(path)
                  : _toggleLeaf(List.unmodifiable(path)),
        ),
      ),
    );
  }

  void _openBranch(List<Object?> path) {
    setState(() => _activePath = List.unmodifiable(path));
  }

  void _toggleLeaf(List<Object?> path) {
    if (!widget.multiple) {
      _emitSelection(List.unmodifiable([path]));
      return;
    }
    final next = [
      for (final selected in widget.value)
        if (!listEquals(selected, path)) selected,
    ];
    if (next.length == widget.value.length) {
      next.add(path);
    }
    _emitSelection(
      List.unmodifiable(
        next.map(List<Object?>.unmodifiable),
      ),
    );
  }

  void _emitSelection(List<List<Object?>> value) {
    _lastEmittedValue = value;
    widget.onChanged?.call(value);
  }

  static bool _pathsEqual(
    List<List<Object?>> first,
    List<List<Object?>> second,
  ) {
    if (first.length != second.length) {
      return false;
    }
    for (var index = 0; index < first.length; index++) {
      if (!listEquals(first[index], second[index])) {
        return false;
      }
    }
    return true;
  }
}

class _TreeOptionTile extends StatelessWidget {
  const _TreeOptionTile({
    super.key,
    required this.label,
    required this.height,
    required this.textStyle,
    required this.selected,
    required this.root,
    required this.selectedBackgroundColor,
    required this.indicatorColor,
    required this.showIndicator,
    required this.previousSelected,
    required this.nextSelected,
    required this.onTap,
  });

  final String label;
  final double height;
  final TextStyle textStyle;
  final bool selected;
  final bool root;
  final Color selectedBackgroundColor;
  final Color indicatorColor;
  final bool showIndicator;
  final bool previousSelected;
  final bool nextSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tile = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (selected && root)
            Positioned.fill(
              child: ColoredBox(color: selectedBackgroundColor),
            ),
          if (!selected && previousSelected)
            Positioned(
              top: 0,
              right: 0,
              child: CustomPaint(
                size: const Size(
                  _kOutwardCornerRadius,
                  _kOutwardCornerRadius,
                ),
                painter: _OutwardCornerPainter(
                  color: selectedBackgroundColor,
                  corner: _Corner.topRight,
                ),
              ),
            ),
          if (!selected && nextSelected)
            Positioned(
              right: 0,
              bottom: 0,
              child: CustomPaint(
                size: const Size(
                  _kOutwardCornerRadius,
                  _kOutwardCornerRadius,
                ),
                painter: _OutwardCornerPainter(
                  color: selectedBackgroundColor,
                  corner: _Corner.bottomRight,
                ),
              ),
            ),
          SizedBox(
            height: height,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 12),
                    child: TText(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle,
                    ),
                  ),
                ),
                if (showIndicator)
                  SizedBox(
                    width: 56,
                    height: height,
                    child: Icon(
                      TIcons.check,
                      size: 24,
                      color: indicatorColor,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
    return SizedBox(height: height, child: tile);
  }
}

enum _Corner {
  topRight,
  bottomRight,
}

class _OutwardCornerPainter extends CustomPainter {
  const _OutwardCornerPainter({
    required this.color,
    required this.corner,
  });

  final Color color;
  final _Corner corner;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final radius = size.width;
    final path = Path();

    switch (corner) {
      case _Corner.topRight:
        path
          ..moveTo(0, 0)
          ..lineTo(radius, 0)
          ..lineTo(radius, radius)
          ..arcToPoint(
            const Offset(0, 0),
            radius: Radius.circular(radius),
            clockwise: false,
          )
          ..close();
        break;
      case _Corner.bottomRight:
        path
          ..moveTo(radius, 0)
          ..lineTo(radius, radius)
          ..lineTo(0, radius)
          ..arcToPoint(
            Offset(radius, 0),
            radius: Radius.circular(radius),
            clockwise: false,
          )
          ..close();
        break;
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _OutwardCornerPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.corner != corner;
  }
}
