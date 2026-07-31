import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import 't_cascader_theme_data.dart';

/// 不可变的级联选项。
class TCascaderOption {
  const TCascaderOption({
    /// 展示文案。
    required this.label,

    /// 选项值。
    required this.value,

    /// 子选项。
    this.children = const [],

    /// 是否禁用。
    this.disabled = false,
  });

  /// 展示文案。
  final String label;

  /// 选项值。
  final Object? value;

  /// 子选项。
  final List<TCascaderOption> children;

  /// 是否禁用。
  final bool disabled;
}

/// 严格受控的级联选择器。
class TCascader extends StatefulWidget {
  const TCascader({
    super.key,

    /// 根选项列表。
    required this.options,

    /// 受控选中路径。
    required this.value,

    /// 选中路径变化回调；为 null 时禁用。
    this.onChanged,

    /// 导航展示形态。
    this.variant = TCascaderVariant.tab,

    /// 未选择层级的占位文案。
    this.placeholder = '请选择',
  });

  /// 根选项列表。
  final List<TCascaderOption> options;

  /// 受控选中路径。
  final List<Object?> value;

  /// 选中路径变化回调；为 null 时禁用。
  final ValueChanged<List<Object?>>? onChanged;

  /// 导航展示形态。
  final TCascaderVariant variant;

  /// 未选择层级的占位文案。
  final String placeholder;

  @override
  State<TCascader> createState() => _TCascaderState();
}

class _TCascaderState extends State<TCascader> {
  late int _activeLevel;

  bool get _enabled => widget.onChanged != null;

  @override
  void initState() {
    super.initState();
    _activeLevel = _initialActiveLevel();
  }

  @override
  void didUpdateWidget(covariant TCascader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.value, widget.value) ||
        oldWidget.options != widget.options) {
      final maxLevel = _availableDepth();
      if (_activeLevel > maxLevel) {
        _activeLevel = maxLevel;
      }
    }
  }

  int _initialActiveLevel() {
    if (widget.value.isEmpty) {
      return 0;
    }
    final selected = _selectedOptions();
    if (selected.isEmpty) {
      return 0;
    }
    return selected.isNotEmpty && selected.last.children.isNotEmpty
        ? selected.length
        : selected.length - 1;
  }

  int _availableDepth() => _selectedOptions().length;

  List<TCascaderOption> _selectedOptions() {
    var options = widget.options;
    final selected = <TCascaderOption>[];
    for (final value in widget.value) {
      final index = options.indexWhere((option) => option.value == value);
      if (index < 0) {
        break;
      }
      final option = options[index];
      selected.add(option);
      options = option.children;
    }
    return selected;
  }

  List<TCascaderOption> _optionsAt(int level) {
    var options = widget.options;
    for (var index = 0; index < level; index++) {
      if (index >= widget.value.length) {
        return const [];
      }
      final selected = options.where(
        (option) => option.value == widget.value[index],
      );
      if (selected.isEmpty) {
        return const [];
      }
      options = selected.first.children;
    }
    return options;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TCascaderThemeData>();
    final selected = _selectedOptions();
    final options = _optionsAt(_activeLevel);
    final backgroundColor =
        theme?.backgroundColor ?? context.tTheme.bgColorContainer;
    final borderRadius = BorderRadius.circular(
      theme?.borderRadius ?? context.tTheme.radiusDefault,
    );
    return Semantics(
      enabled: _enabled,
      child: AnimatedOpacity(
        opacity: _enabled ? 1 : 0.5,
        duration: const Duration(milliseconds: 150),
        child: AbsorbPointer(
          absorbing: !_enabled,
          child: SizedBox(
            height: theme?.height ?? 360,
            child: Material(
              color: backgroundColor,
              borderRadius: borderRadius,
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNavigation(context, selected, theme),
                  Divider(height: 1, color: theme?.dividerColor),
                  Expanded(
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, index) =>
                          _buildOption(context, options[index], theme),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigation(
    BuildContext context,
    List<TCascaderOption> selected,
    TCascaderThemeData? theme,
  ) {
    final styles = _resolveTextStyles(context, theme);
    final entries = <Widget>[
      for (var index = 0; index < selected.length; index++)
        TextButton(
          onPressed: () => setState(() => _activeLevel = index),
          child: Text(
            selected[index].label,
            style: index == _activeLevel ? styles.active : styles.normal,
          ),
        ),
      if (selected.isEmpty || selected.last.children.isNotEmpty)
        TextButton(
          onPressed: () => setState(() => _activeLevel = selected.length),
          child: Text(
            widget.placeholder,
            style: selected.length == _activeLevel
                ? styles.active
                : styles.normal,
          ),
        ),
    ];
    if (widget.variant == TCascaderVariant.step) {
      return Padding(
        padding: theme?.navigationPadding ?? const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: entries,
        ),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: theme?.navigationPadding,
      child: Row(children: entries),
    );
  }

  Widget _buildOption(
    BuildContext context,
    TCascaderOption option,
    TCascaderThemeData? theme,
  ) {
    final styles = _resolveTextStyles(context, theme);
    final selected =
        _activeLevel < widget.value.length &&
        widget.value[_activeLevel] == option.value;
    final isLeaf = option.children.isEmpty;
    final material = Theme.of(context);
    final indicatorColor =
        theme?.indicatorColor ??
        material.listTileTheme.selectedColor ??
        material.tExplicitColorScheme?.primary ??
        context.tTheme.brandNormalColor;
    return ListTile(
      key: ValueKey('cascader-${option.value}'),
      enabled: !option.disabled,
      selected: selected,
      title: Text(
        option.label,
        style: option.disabled
            ? styles.disabled
            : selected
            ? styles.active
            : styles.normal,
      ),
      trailing: isLeaf
          ? selected
                ? Icon(TIcons.check, size: 24, color: indicatorColor)
                : null
          : const Icon(TIcons.chevron_right),
      onTap: option.disabled
          ? null
          : () {
              final next = <Object?>[
                ...widget.value.take(_activeLevel),
                option.value,
              ];
              if (option.children.isNotEmpty) {
                setState(() => _activeLevel += 1);
              }
              widget.onChanged?.call(List.unmodifiable(next));
            },
    );
  }

  _CascaderTextStyles _resolveTextStyles(
    BuildContext context,
    TCascaderThemeData? theme,
  ) {
    final material = Theme.of(context);
    final tokenFont = context.tTheme.fontBodyLarge;
    final normal =
        TextStyle(
              color:
                  material.listTileTheme.textColor ??
                  context.tTheme.textColorPrimary,
              fontSize: tokenFont?.size,
              height: tokenFont?.height,
              fontWeight: tokenFont?.fontWeight,
            )
            .merge(material.tExplicitTextTheme?.bodyLarge)
            .merge(context.tExplicitDefaultTextStyle)
            .merge(theme?.textStyle);
    final active = normal
        .copyWith(
          color: material.listTileTheme.selectedColor ?? normal.color,
          fontWeight: FontWeight.w600,
        )
        .merge(theme?.activeTextStyle);
    final disabled = normal
        .copyWith(color: context.tTheme.textDisabledColor)
        .merge(theme?.disabledTextStyle);
    return _CascaderTextStyles(
      normal: normal,
      active: active,
      disabled: disabled,
    );
  }
}

class _CascaderTextStyles {
  const _CascaderTextStyles({
    required this.normal,
    required this.active,
    required this.disabled,
  });

  final TextStyle normal;
  final TextStyle active;
  final TextStyle disabled;
}
