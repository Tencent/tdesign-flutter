import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_theme.dart';
import 't_tab_bar_theme_data.dart';

/// Tab 组件
///
/// TDesign 选项卡标签，通常作为 `TTabsBar.tabs` 的子项使用。
class TTab extends Tab {
  /// 文字内容
  @override
  final String? text;

  /// 子widget
  @override
  final Widget? child;

  /// 图标
  @override
  final Widget? icon;

  /// 是否可用，默认 true。
  ///
  /// 设为 `false` 时使用禁用样式，并由 `TTabsBar` 阻止该项被选择。
  /// Material [TabBar] 不识别此扩展字段；直接将 [TTab] 用作 Material
  /// [TabBar.tabs] 时只会呈现禁用样式，不会阻止其切换。
  final bool enabled;

  const TTab({Key? key, this.text, this.child, this.icon, this.enabled = true})
    : assert(
        text == null || child == null,
        'text and child cannot be provided together.',
      ),
      assert(
        text != null || child != null || icon != null,
        'Provide text, child, or icon.',
      ),
      super(key: key, text: text, child: child, icon: icon);

  @override
  Size get preferredSize => const Size.fromHeight(46);

  @override
  Widget build(BuildContext context) {
    var label = text != null || child != null ? _buildLabelContent() : null;
    if (icon != null) {
      label = label == null
          ? icon!
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[icon!, const SizedBox(width: 4), label],
            );
    }
    Widget content = Center(widthFactor: 1.0, child: label);
    if (!enabled) {
      final disabledStyle = DefaultTextStyle.of(context).style
          .copyWith(color: context.tTheme.textDisabledColor)
          .merge(
            Theme.of(
              context,
            ).extension<TTabsBarThemeData>()?.disabledLabelStyle,
          );
      content = DefaultTextStyle.merge(
        style: disabledStyle,
        child: IconTheme.merge(
          data: IconThemeData(color: disabledStyle.color),
          child: content,
        ),
      );
    }
    return content;
  }

  Widget _buildLabelContent() {
    if (child != null) {
      return child!;
    }
    return Text(text!, softWrap: false, overflow: TextOverflow.fade);
  }
}
