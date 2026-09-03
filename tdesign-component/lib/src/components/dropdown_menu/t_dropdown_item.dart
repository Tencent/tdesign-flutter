import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../button/t_button.dart';
import '../button/t_button_types.dart';
import 't_dropdown_menu.dart';
import 't_dropdown_theme_data.dart';

/// 下拉筛选面板中的不可变选项。
class TDropdownMenuOption<T> {
  const TDropdownMenuOption({
    required this.value,
    required this.label,
    this.disabled = false,
    this.group,
  });

  final T value;
  final String label;
  final bool disabled;
  final String? group;
}

/// 单选筛选面板。选择有效选项后立即提交并关闭。
class TDropdownSingleSelectPanel<T> extends StatelessWidget {
  const TDropdownSingleSelectPanel({
    super.key,
    required this.controller,
    required this.options,
    required this.value,
    required this.onChanged,
    this.maxHeight,
  });

  final TDropdownMenuPanelController controller;
  final List<TDropdownMenuOption<T>> options;
  final T? value;
  final ValueChanged<T> onChanged;
  final double? maxHeight;

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context).extension<TDropdownThemeData>() ??
        const TDropdownThemeData();
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? MediaQuery.sizeOf(context).height,
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          final selected = option.value == value;
          return _DropdownOptionRow(
            label: option.label,
            selected: selected,
            disabled: option.disabled,
            height: theme.optionHeight ?? 56,
            padding:
                theme.optionPadding ??
                EdgeInsets.symmetric(horizontal: context.tTheme.spacer16),
            onTap: option.disabled
                ? null
                : () {
                    onChanged(option.value);
                    unawaited(
                      controller.close(TDropdownMenuCloseReason.selection),
                    );
                  },
          );
        },
      ),
    );
  }
}

/// 多选筛选面板。
///
/// [values] 表示已提交值，每次打开时用于初始化草稿。选项点击只更新面板内部草稿，
/// 点击确认后才通过 [onConfirm] 提交。
/// 打开期间 [values] 变化时，尚未修改的草稿会同步；已有修改的草稿保留用户编辑。
/// 未确认即关闭会丢弃草稿，再次打开时使用最新的 [values]。
class TDropdownMultiSelectPanel<T> extends StatefulWidget {
  const TDropdownMultiSelectPanel({
    super.key,
    required this.controller,
    required this.options,
    required this.values,
    required this.onConfirm,
    this.columns = 1,
    this.maxHeight,
  }) : assert(columns >= 1 && columns <= 3);

  final TDropdownMenuPanelController controller;
  final List<TDropdownMenuOption<T>> options;
  final Set<T> values;
  final ValueChanged<Set<T>> onConfirm;
  final int columns;
  final double? maxHeight;

  @override
  State<TDropdownMultiSelectPanel<T>> createState() =>
      _TDropdownMultiSelectPanelState<T>();
}

class _TDropdownMultiSelectPanelState<T>
    extends State<TDropdownMultiSelectPanel<T>> {
  late Set<T> _draft;
  late Set<T> _sourceValues;

  int get _safeColumns => widget.columns.clamp(1, 3);

  @override
  void initState() {
    super.initState();
    _sourceValues = Set<T>.of(widget.values);
    _draft = Set<T>.of(widget.values);
  }

  @override
  void didUpdateWidget(TDropdownMultiSelectPanel<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final changed = !_setEquals(widget.values, _sourceValues);
    final dirty = !_setEquals(_draft, _sourceValues);
    if (changed) {
      _sourceValues = Set<T>.of(widget.values);
      if (!dirty) {
        _draft = Set<T>.of(widget.values);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context).extension<TDropdownThemeData>() ??
        const TDropdownThemeData();
    final groups = _groupedOptions();
    final availableHeight =
        widget.maxHeight ?? MediaQuery.sizeOf(context).height;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: availableHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  context.tTheme.spacer16,
                  context.tTheme.spacer12,
                  context.tTheme.spacer16,
                  context.tTheme.spacer16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final entry in groups.entries) ...[
                      if (entry.key != null)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: context.tTheme.spacer12,
                          ),
                          child: Text(
                            entry.key!,
                            style:
                                theme.optionTextStyle ??
                                TextStyle(
                                  color: context.tTheme.textColorPrimary,
                                  fontSize: context.tTheme.fontBodyMedium?.size,
                                  height: context.tTheme.fontBodyMedium?.height,
                                  fontWeight:
                                      context.tTheme.fontBodyMedium?.fontWeight,
                                ).merge(
                                  Theme.of(
                                    context,
                                  ).tExplicitTextTheme?.bodyMedium,
                                ),
                          ),
                        ),
                      ..._buildRows(context, entry.value, theme),
                      if (entry.key != groups.keys.last)
                        SizedBox(height: context.tTheme.spacer16),
                    ],
                  ],
                ),
              ),
            ),
          ),
          _buildOperations(context, theme),
        ],
      ),
    );
  }

  List<Widget> _buildRows(
    BuildContext context,
    List<TDropdownMenuOption<T>> options,
    TDropdownThemeData theme,
  ) {
    final rows = <Widget>[];
    final columns = _safeColumns;
    for (var start = 0; start < options.length; start += columns) {
      final rowOptions = options.skip(start).take(columns).toList();
      rows.add(
        Padding(
          padding: EdgeInsets.only(
            bottom: start + columns >= options.length
                ? 0
                : context.tTheme.spacer12,
          ),
          child: Row(
            children: List<Widget>.generate(columns * 2 - 1, (slot) {
              if (slot.isOdd) {
                return SizedBox(width: context.tTheme.spacer12);
              }
              final column = slot ~/ 2;
              if (column >= rowOptions.length) {
                return const Expanded(child: SizedBox.shrink());
              }
              final option = rowOptions[column];
              final selected = _draft.contains(option.value);
              return Expanded(
                child: _DropdownOptionChip(
                  label: option.label,
                  selected: selected,
                  disabled: option.disabled,
                  theme: theme,
                  onTap: option.disabled ? null : () => _toggle(option.value),
                ),
              );
            }),
          ),
        ),
      );
    }
    return rows;
  }

  Widget _buildOperations(BuildContext context, TDropdownThemeData theme) {
    final material = Theme.of(context);
    final colorScheme = material.tExplicitColorScheme;
    return Container(
      padding:
          theme.actionAreaPadding ?? EdgeInsets.all(context.tTheme.spacer16),
      decoration: BoxDecoration(
        color:
            theme.panelBackgroundColor ??
            colorScheme?.surface ??
            context.tTheme.bgColorContainer,
        border: Border(
          top: BorderSide(
            color:
                theme.dividerColor ??
                material.tExplicitDividerColor ??
                context.tTheme.componentStrokeColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TButton(
              colorScheme: TButtonColorScheme.light,
              onPressed: () => setState(_draft.clear),
              child: Text(context.resource.reset),
            ),
          ),
          SizedBox(width: theme.actionGap ?? context.tTheme.spacer16),
          Expanded(
            child: TButton(
              colorScheme: TButtonColorScheme.primary,
              onPressed: () {
                widget.onConfirm(Set<T>.unmodifiable(_draft));
                unawaited(
                  widget.controller.close(TDropdownMenuCloseReason.confirm),
                );
              },
              child: Text(context.resource.confirm),
            ),
          ),
        ],
      ),
    );
  }

  Map<String?, List<TDropdownMenuOption<T>>> _groupedOptions() {
    final groups = <String?, List<TDropdownMenuOption<T>>>{};
    for (final option in widget.options) {
      groups
          .putIfAbsent(option.group, () => <TDropdownMenuOption<T>>[])
          .add(option);
    }
    return groups;
  }

  void _toggle(T value) {
    setState(() {
      if (!_draft.add(value)) {
        _draft.remove(value);
      }
    });
  }

  bool _setEquals(Set<T> left, Set<T> right) =>
      left.length == right.length && left.containsAll(right);
}

class _DropdownOptionRow extends StatelessWidget {
  const _DropdownOptionRow({
    required this.label,
    required this.selected,
    required this.disabled,
    required this.height,
    required this.padding,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool disabled;
  final double height;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final material = Theme.of(context);
    final colorScheme = material.tExplicitColorScheme;
    final theme =
        Theme.of(context).extension<TDropdownThemeData>() ??
        const TDropdownThemeData();
    final tokenFont = context.tTheme.fontBodyLarge;
    final base =
        theme.optionTextStyle ??
        material.tExplicitTextTheme?.bodyLarge ??
        TextStyle(
          color: context.tTheme.textColorPrimary,
          fontSize: tokenFont?.size,
          height: tokenFont?.height,
          fontWeight: tokenFont?.fontWeight,
        );
    final style = disabled
        ? theme.disabledOptionTextStyle ??
              base.copyWith(
                color:
                    material.tExplicitDisabledColor ??
                    context.tTheme.textDisabledColor,
              )
        : selected
        ? theme.selectedOptionTextStyle ??
              base.copyWith(
                color: colorScheme?.primary ?? context.tTheme.brandNormalColor,
              )
        : base;
    return Semantics(
      selected: selected,
      enabled: !disabled,
      button: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color:
                  theme.dividerColor ??
                  material.tExplicitDividerColor ??
                  context.tTheme.componentStrokeColor,
              width: 0.5,
            ),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: height,
            child: Padding(
              padding: padding,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: style,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (selected)
                    Icon(
                      TIcons.check,
                      size: 24,
                      color:
                          colorScheme?.primary ??
                          context.tTheme.brandNormalColor,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DropdownOptionChip extends StatelessWidget {
  const _DropdownOptionChip({
    required this.label,
    required this.selected,
    required this.disabled,
    required this.theme,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool disabled;
  final TDropdownThemeData theme;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final material = Theme.of(context);
    final colorScheme = material.tExplicitColorScheme;
    final backgroundColor = disabled
        ? theme.disabledOptionColor ??
              (material.tExplicitDisabledColor ??
                      context.tTheme.textDisabledColor)
                  .withValues(alpha: 0.12)
        : selected
        ? theme.selectedOptionColor ??
              colorScheme?.primaryContainer ??
              context.tTheme.brandLightColor
        : theme.optionColor ??
              colorScheme?.surfaceContainerHighest ??
              context.tTheme.bgColorSecondaryContainer;
    final tokenFont = context.tTheme.fontBodyMedium;
    final base =
        theme.optionTextStyle ??
        material.tExplicitTextTheme?.bodyMedium ??
        TextStyle(
          color: context.tTheme.textColorPrimary,
          fontSize: tokenFont?.size,
          height: tokenFont?.height,
          fontWeight: tokenFont?.fontWeight,
        );
    final style = disabled
        ? theme.disabledOptionTextStyle ??
              base.copyWith(
                color:
                    material.tExplicitDisabledColor ??
                    context.tTheme.textDisabledColor,
              )
        : selected
        ? theme.selectedOptionTextStyle ??
              base.copyWith(
                color:
                    colorScheme?.onPrimaryContainer ??
                    context.tTheme.brandNormalColor,
              )
        : base;
    return Semantics(
      selected: selected,
      enabled: !disabled,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            theme.optionBorderRadius ??
            BorderRadius.circular(context.tTheme.radiusDefault),
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius:
                theme.optionBorderRadius ??
                BorderRadius.circular(context.tTheme.radiusDefault),
          ),
          padding:
              theme.optionPadding ??
              EdgeInsets.symmetric(horizontal: context.tTheme.spacer16),
          child: Text(
            label,
            style: style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
