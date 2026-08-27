import 'package:flutter/material.dart';

import 't_check_box.dart';
import 't_selection_card.dart';

@immutable

/// 复选框组的数据项。
class TCheckboxOption<T> {
  const TCheckboxOption({
    /// 选项值。
    required this.value,

    /// 主文案。
    required this.label,

    /// 副文案。
    this.subTitle,

    /// 是否禁用该项。
    this.disabled = false,
  });

  /// 选项值。
  final T value;

  /// 主文案。
  final String label;

  /// 副文案。
  final String? subTitle;

  /// 是否禁用该项。
  final bool disabled;
}

/// 自定义复选框组数据项构建器。
typedef TCheckboxOptionBuilder<T> = Widget Function(
  BuildContext context,
  TCheckboxOption<T> option,
  bool selected,
  bool disabled,
);

/// 数据驱动且严格受控的复选框组。
class TCheckboxGroup<T> extends StatelessWidget {
  const TCheckboxGroup({
    super.key,

    /// 受控选中项列表。
    required this.value,

    /// 复选框数据项。
    required this.options,

    /// 选中项列表变更回调；为 null 时整组禁用。
    this.onChanged,

    /// 排列方向。
    this.direction = Axis.vertical,

    /// 每行列数，必须大于 0。
    this.columns = 1,

    /// 是否使用卡片模式。
    this.cardMode = false,

    /// 普通模式是否显示项间分割线，默认显示；卡片模式不显示。
    this.showDivider = true,

    /// 控件与文案排列方向。
    this.contentDirection = TContentDirection.right,

    /// 复选框尺寸。
    this.size = TCheckboxSize.medium,

    /// 最多可选数量。
    this.maxSelected,

    /// 超过最多可选数量时触发。
    this.onMaxSelected,

    /// 自定义数据项视觉；交互仍由组接管。
    this.itemBuilder,
  }) : assert(columns > 0);

  /// 受控选中项列表。
  final List<T> value;

  /// 复选框数据项。
  final List<TCheckboxOption<T>> options;

  /// 选中项列表变更回调；为 null 时整组禁用。
  final ValueChanged<List<T>>? onChanged;

  /// 排列方向。
  final Axis direction;

  /// 每行列数。
  final int columns;

  /// 是否使用卡片模式。
  final bool cardMode;

  /// 普通模式是否显示项间分割线，默认显示；卡片模式不显示。
  final bool showDivider;

  /// 控件与文案排列方向。
  final TContentDirection contentDirection;

  /// 复选框尺寸。
  final TCheckboxSize size;

  /// 最多可选数量。
  final int? maxSelected;

  /// 超过最多可选数量时触发。
  final VoidCallback? onMaxSelected;

  /// 自定义数据项视觉；交互仍由组接管。
  final TCheckboxOptionBuilder<T>? itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (cardMode) {
      return TSelectionCardGroupLayout(
        direction: direction,
        columns: columns,
        children: List.generate(options.length, (index) {
          return _buildItem(context, options[index], index);
        }),
        itemHasSubtitles: [
          for (final option in options) option.subTitle?.isNotEmpty == true,
        ],
      );
    }
    if (direction == Axis.vertical && columns == 1) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(options.length, (index) {
          return _buildItem(context, options[index], index);
        }),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth / columns
            : null;
        return Wrap(
          children: List.generate(options.length, (index) {
            final child = _buildItem(context, options[index], index);
            return width == null ? child : SizedBox(width: width, child: child);
          }),
        );
      },
    );
  }

  Widget _buildItem(
      BuildContext context, TCheckboxOption<T> option, int index) {
    final selected = value.contains(option.value);
    final disabled = onChanged == null || option.disabled;
    if (itemBuilder != null) {
      final child = itemBuilder!(context, option, selected, disabled);
      return Semantics(
        enabled: !disabled,
        checked: selected,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: disabled ? null : () => _toggle(option, selected),
          child: child,
        ),
      );
    }
    return TCheckbox(
      value: selected,
      onChanged: disabled ? null : (_) => _toggle(option, selected),
      title: option.label,
      subTitle: option.subTitle,
      cardMode: cardMode,
      showDivider: showDivider && index < options.length - 1,
      contentDirection: contentDirection,
      size: size,
    );
  }

  void _toggle(TCheckboxOption<T> option, bool selected) {
    final next = value.toSet();
    if (selected) {
      next.remove(option.value);
    } else {
      if (maxSelected != null && next.length >= maxSelected!) {
        onMaxSelected?.call();
        return;
      }
      next.add(option.value);
    }
    onChanged?.call([
      for (final item in options)
        if (next.contains(item.value)) item.value,
    ]);
  }
}
