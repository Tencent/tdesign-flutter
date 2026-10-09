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

const double _defaultBodyMaxHeight = 280;

/// 下拉筛选面板中的不可变选项。
class TDropdownMenuOption<T> {
  const TDropdownMenuOption({
    required this.value,
    required this.label,
    this.disabled = false,
    this.group,
  });

  /// 选项对应的业务值，用于选中判断和提交回调。
  final T value;

  /// 选项显示文案。
  final String label;

  /// 是否禁用该选项，默认 false；禁用选项不能通过点击提交。
  final bool disabled;

  /// 多选面板中的分组标题；为空时归入无标题分组。
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

  /// 当前面板的局部控制器；选择后用它关闭面板。
  final TDropdownMenuPanelController controller;

  /// 按显示顺序排列的选项。
  final List<TDropdownMenuOption<T>> options;

  /// 受控选中值；为空时不主动指定选中项。
  final T? value;

  /// 点击启用选项时提交其业务值，然后请求关闭面板；由使用方更新 [value]。
  final ValueChanged<T> onChanged;

  /// 滚动主体的最大高度；默认 280dp。
  final double? maxHeight;

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context).extension<TDropdownThemeData>() ??
        const TDropdownThemeData();
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? _defaultBodyMaxHeight,
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
                EdgeInsets.symmetric(horizontal: context.tTheme.spacer2),
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

  /// 当前面板的局部控制器，用于确认或取消时关闭面板。
  final TDropdownMenuPanelController controller;

  /// 可选择的选项；[TDropdownMenuOption.group] 决定显示分组。
  final List<TDropdownMenuOption<T>> options;

  /// 已提交的受控值集合；打开时初始化草稿，未确认关闭不会提交草稿。
  final Set<T> values;

  /// 点击确认时提交草稿集合，再请求关闭面板；由使用方更新 [values]。
  final ValueChanged<Set<T>> onConfirm;

  /// 每行选项列数，默认 1；支持 1 至 3 列。
  final int columns;

  /// 面板最大高度；默认滚动主体最多 280dp，底部操作区另计。
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
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: widget.maxHeight ?? _defaultBodyMaxHeight,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.tTheme.spacer2,
                    context.tTheme.spacer1,
                    context.tTheme.spacer2,
                    context.tTheme.spacer2,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final entry in groups.entries) ...[
                        if (entry.key != null)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: context.tTheme.spacer1,
                            ),
                            child: Text(
                              entry.key!,
                              style:
                                  theme.optionTextStyle ??
                                  TextStyle(
                                    color: context.tTheme.textColorPrimary,
                                    fontSize:
                                        context.tTheme.fontBodyMedium?.size,
                                    height:
                                        context.tTheme.fontBodyMedium?.height,
                                    fontWeight: context
                                        .tTheme
                                        .fontBodyMedium
                                        ?.fontWeight,
                                  ),
                            ),
                          ),
                        ..._buildRows(context, entry.value, theme),
                        if (entry.key != groups.keys.last)
                          SizedBox(height: context.tTheme.spacer2),
                      ],
                    ],
                  ),
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
                : context.tTheme.spacer1,
          ),
          child: Row(
            children: List<Widget>.generate(columns * 2 - 1, (slot) {
              if (slot.isOdd) {
                return SizedBox(width: context.tTheme.spacer1);
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
    return Container(
      padding:
          theme.actionAreaPadding ?? EdgeInsets.all(context.tTheme.spacer2),
      decoration: BoxDecoration(
        color: theme.panelBackgroundColor ?? context.tTheme.bgColorContainer,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor ?? context.tTheme.componentStroke,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TButton(
              colorPreset: TButtonColorPreset.light,
              onPressed: () => setState(_draft.clear),
              child: Text(context.resource.reset),
            ),
          ),
          SizedBox(width: theme.actionGap ?? context.tTheme.spacer2),
          Expanded(
            child: TButton(
              colorPreset: TButtonColorPreset.primary,
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
    final theme =
        Theme.of(context).extension<TDropdownThemeData>() ??
        const TDropdownThemeData();
    final tokenFont = context.tTheme.fontBodyLarge;
    final base =
        theme.optionTextStyle ??
        TextStyle(
          color: context.tTheme.textColorPrimary,
          fontSize: tokenFont?.size,
          height: tokenFont?.height,
          fontWeight: tokenFont?.fontWeight,
        );
    final style = disabled
        ? theme.disabledOptionTextStyle ??
              base.copyWith(color: context.tTheme.textColorDisabled)
        : selected
        ? theme.selectedOptionTextStyle ?? base
        : base;
    return Semantics(
      selected: selected,
      enabled: !disabled,
      button: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor ?? context.tTheme.componentStroke,
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
                      color: context.tTheme.brandColor,
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
    final backgroundColor = disabled
        ? theme.disabledOptionColor ?? context.tTheme.bgColorComponentDisabled
        : selected
        ? theme.selectedOptionColor ?? context.tTheme.brandColorLight
        : theme.optionColor ?? context.tTheme.bgColorSecondaryContainer;
    final tokenFont = context.tTheme.fontBodyMedium;
    final base =
        theme.optionTextStyle ??
        TextStyle(
          color: context.tTheme.textColorPrimary,
          fontSize: tokenFont?.size,
          height: tokenFont?.height,
          fontWeight: tokenFont?.fontWeight,
        );
    final style = disabled
        ? theme.disabledOptionTextStyle ??
              base.copyWith(color: context.tTheme.textColorDisabled)
        : selected
        ? theme.selectedOptionTextStyle ??
              base.copyWith(color: context.tTheme.brandColor)
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
              EdgeInsets.symmetric(horizontal: context.tTheme.spacer2),
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
