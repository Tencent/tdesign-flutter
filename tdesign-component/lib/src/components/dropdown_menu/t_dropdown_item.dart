import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../../util/list_ext.dart';
import '../button/t_button.dart';
import '../button/t_button_types.dart';
import '../checkbox/t_check_box.dart' show TContentDirection;
import '../radio/t_radio.dart';
import '../text/t_text.dart';
import 't_dropdown_inherited.dart';
import 't_dropdown_menu.dart';
import 't_dropdown_popup.dart';

/// 下拉菜单自定义内容构建器
typedef TDropdownItemContentBuilder = Widget Function(BuildContext context);

/// 下拉菜单内容
class TDropdownItem<T> extends StatefulWidget {
  /// 创建下拉菜单内容
  const TDropdownItem({
    super.key,
    this.disabled = false,
    this.label,
    this.arrowIcon,
    this.arrowColor,
    this.multiple = false,
    this.options = const [],
    this.value,
    this.values = const {},
    this.builder,
    this.optionsColumns = 1,
    this.onChanged,
    this.onValuesChanged,
    this.onConfirm,
    this.onReset,
    this.minHeight,
    this.maxHeight,
    this.tabBarWidth,
    this.tabBarAlign,
    this.tabBarFlex = 1,
  })  : assert(optionsColumns >= 1 && optionsColumns <= 3),
        assert(tabBarFlex > 0);

  /// 是否禁用
  final bool disabled;

  /// 标题
  final String? label;

  /// 自定义箭头图标
  final IconData? arrowIcon;

  /// 自定义箭头颜色
  final Color? arrowColor;

  /// 是否多选
  final bool multiple;

  /// 不可变选项数据
  final List<TDropdownItemOption<T>> options;

  /// 单选值
  final T? value;

  /// 多选值
  final Set<T> values;

  /// 完全自定义展示内容
  final TDropdownItemContentBuilder? builder;

  /// 选项分栏数
  final int optionsColumns;

  /// 单选值变化
  final ValueChanged<T?>? onChanged;

  /// 多选值变化
  final ValueChanged<Set<T>>? onValuesChanged;

  /// 点击确认时触发
  final ValueChanged<Set<T>>? onConfirm;

  /// 点击重置时触发
  final VoidCallback? onReset;

  /// 内容最小高度
  final double? minHeight;

  /// 内容最大高度
  final double? maxHeight;

  /// item 在可滚动菜单栏中的宽度
  final double? tabBarWidth;

  /// 标签和箭头的对齐方式
  final MainAxisAlignment? tabBarAlign;

  /// item 在非滚动菜单栏中的宽度占比
  final int tabBarFlex;

  /// 多选模式下重置和确认操作区的固定高度。
  static const double operateHeight = 73;

  double? get minContentHeight =>
      multiple && minHeight != null ? minHeight! + operateHeight : minHeight;

  double? get maxContentHeight =>
      multiple && maxHeight != null ? maxHeight! + operateHeight : maxHeight;

  /// 菜单栏展示文案
  String getLabel() {
    if (multiple) {
      return label ?? '';
    }
    for (final option in options) {
      if (option.value == value) {
        return option.label;
      }
    }
    return label ?? '';
  }

  @override
  State<TDropdownItem<T>> createState() => _TDropdownItemState<T>();
}

class _TDropdownItemState<T> extends State<TDropdownItem<T>> {
  late TDropdownPopup<T> popup;
  late ValueNotifier<TDropdownMenuDirection> directionListenable;

  @override
  Widget build(BuildContext context) {
    final inherited = TDropdownInherited.of<T>(context)!;
    popup = inherited.popupState;
    directionListenable = inherited.directionListenable;
    if (widget.builder != null) {
      return widget.builder!(context);
    }
    return widget.multiple || widget.optionsColumns > 1
        ? _buildCheckboxList()
        : _buildRadioList();
  }

  Widget _buildCheckboxList() {
    final padding = context.tTheme.spacer16;
    final grouped = _groupedRows();
    final maxHeight = widget.maxContentHeight ??
        (directionListenable.value == TDropdownMenuDirection.auto
            ? double.infinity
            : max<double>(
                popup.maxContentHeight - TDropdownItem.operateHeight,
                0,
              ));
    return Column(
      children: [
        Container(
          color: context.tTheme.bgColorContainer,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: widget.minContentHeight ?? 0,
              maxHeight: maxHeight,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (final entry in grouped.entries) ...[
                    if (grouped.length > 1 || entry.key != null)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(
                          padding,
                          padding,
                          padding,
                          0,
                        ),
                        color: context.tTheme.bgColorContainer,
                        child: TText(
                          entry.key ?? context.resource.other,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.all(padding),
                      color: context.tTheme.bgColorContainer,
                      child: Column(
                        children: [
                          for (var rowIndex = 0;
                              rowIndex < entry.value.length;
                              rowIndex++)
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: rowIndex == entry.value.length - 1
                                    ? 0
                                    : context.tTheme.spacer12,
                              ),
                              child: _buildOptionRow(entry.value[rowIndex]),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (widget.multiple) _buildOperations(),
      ],
    );
  }

  Widget _buildOptionRow(List<TDropdownItemOption<T>> options) {
    return Row(
      children: [
        for (var index = 0; index < widget.optionsColumns; index++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == widget.optionsColumns - 1
                    ? 0
                    : context.tTheme.spacer12,
              ),
              child: index < options.length
                  ? _buildCheckboxOption(options[index])
                  : const SizedBox.shrink(),
            ),
          ),
      ],
    );
  }

  Widget _buildCheckboxOption(TDropdownItemOption<T> option) {
    final selected = widget.multiple
        ? widget.values.contains(option.value)
        : widget.value == option.value;
    final disabled = option.disabled;
    return Semantics(
      enabled: !disabled,
      checked: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: disabled ? null : () => _selectCheckbox(option),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: disabled
                ? context.tTheme.bgColorSecondaryContainerHover
                : selected
                    ? context.tTheme.brandLightColor
                    : context.tTheme.bgColorSecondaryContainer,
            borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
          ),
          alignment: Alignment.center,
          child: TText(
            option.label,
            textColor: disabled
                ? option.disabledColor ?? context.tTheme.textDisabledColor
                : selected
                    ? option.selectedColor ?? context.tTheme.brandColor7
                    : context.tTheme.textColorPrimary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildRadioList() {
    final radios = TRadioGroup<T>(
      value: widget.value,
      onChanged: _selectRadio,
      options: [
        for (final option in widget.options)
          TRadioOption<T>(
            value: option.value,
            label: option.label,
            disabled: option.disabled,
          ),
      ],
      contentDirection: TContentDirection.left,
      itemBuilder: (context, option, selected, disabled) {
        final source = widget.options.firstWhere(
          (item) => item.value == option.value,
        );
        return Container(
          height: 56,
          padding: EdgeInsets.symmetric(horizontal: context.tTheme.spacer16),
          color: context.tTheme.bgColorContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TText(
                  option.label,
                  textColor: disabled
                      ? context.tTheme.textDisabledColor
                      : context.tTheme.textColorPrimary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (selected)
                Icon(
                  Icons.check,
                  color: disabled
                      ? context.tTheme.textDisabledColor
                      : source.selectedColor ?? context.tTheme.brandNormalColor,
                ),
            ],
          ),
        );
      },
    );
    if (widget.minContentHeight == null && widget.maxContentHeight == null) {
      return radios;
    }
    return Container(
      color: context.tTheme.bgColorContainer,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: widget.minContentHeight ?? 0,
          maxHeight: widget.maxContentHeight ?? double.infinity,
        ),
        child: widget.maxContentHeight == null
            ? radios
            : SingleChildScrollView(child: radios),
      ),
    );
  }

  Widget _buildOperations() {
    return Container(
      height: TDropdownItem.operateHeight,
      padding: EdgeInsets.all(context.tTheme.spacer16),
      decoration: BoxDecoration(
        color: context.tTheme.bgColorContainer,
        border: Border(
          top:
              BorderSide(color: context.tTheme.componentStrokeColor, width: .5),
          bottom: directionListenable.value == TDropdownMenuDirection.up
              ? BorderSide(
                  color: context.tTheme.componentStrokeColor,
                  width: .5,
                )
              : BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TButton(
              colorScheme: TButtonColorScheme.light,
              onPressed: () {
                widget.onValuesChanged?.call(Set<T>.unmodifiable(<T>[]));
                widget.onReset?.call();
              },
              child: Text(
                context.resource.reset,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
          ),
          SizedBox(width: context.tTheme.spacer16),
          Expanded(
            child: TButton(
              colorScheme: TButtonColorScheme.primary,
              onPressed: () {
                widget.onConfirm?.call(Set<T>.unmodifiable(widget.values));
                unawaited(_close());
              },
              child: Text(
                context.resource.confirm,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String?, List<List<TDropdownItemOption<T>>>> _groupedRows() {
    final grouped = SplayTreeMap<String?, List<TDropdownItemOption<T>>>(
      (a, b) {
        if (a == b) {
          return 0;
        }
        if (a == null) {
          return 1;
        }
        if (b == null) {
          return -1;
        }
        return a.compareTo(b);
      },
    );
    for (final option in widget.options) {
      grouped.putIfAbsent(option.group, () => []).add(option);
    }
    return <String?, List<List<TDropdownItemOption<T>>>>{
      for (final entry in grouped.entries)
        entry.key: entry.value.chunk(widget.optionsColumns),
    };
  }

  void _selectRadio(T? value) {
    widget.onChanged?.call(value);
    if (value != null) {
      unawaited(_close());
    }
  }

  void _selectCheckbox(TDropdownItemOption<T> option) {
    if (!widget.multiple) {
      _selectRadio(option.value);
      return;
    }
    final next = Set<T>.of(widget.values);
    if (!next.add(option.value)) {
      next.remove(option.value);
    }
    widget.onValuesChanged?.call(Set<T>.unmodifiable(next));
  }

  Future<void> _close() async {
    if (!widget.multiple || widget.optionsColumns > 1) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    if (mounted) {
      await Navigator.maybePop(context);
    }
  }
}

/// 不可变下拉选项
class TDropdownItemOption<T> {
  /// 创建下拉选项
  const TDropdownItemOption({
    required this.value,
    required this.label,
    this.disabled = false,
    this.group,
    this.selectedColor,
    this.disabledColor,
  });

  /// 选项值
  final T value;

  /// 选项标题
  final String label;

  /// 是否禁用
  final bool disabled;

  /// 分组名
  final String? group;

  /// 选中颜色
  final Color? selectedColor;

  /// 禁用颜色
  final Color? disabledColor;
}
