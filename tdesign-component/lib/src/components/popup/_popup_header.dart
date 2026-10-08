part of 't_popup.dart';

/// 底部头部布局，提供取消按钮、标题和确认按钮三个插槽；按钮行为由调用方设置。
class TPopupHeader extends StatelessWidget {
  const TPopupHeader({
    super.key,
    this.cancelButton,
    this.title,
    this.confirmButton,
  });

  /// 左侧取消操作；为 null 时不显示。
  final Widget? cancelButton;

  /// 中间标题；为 null 时不显示。
  final Widget? title;

  /// 右侧确认操作；为 null 时不显示。
  final Widget? confirmButton;

  /// 标准头部高度。
  static const double headerHeight = 58;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: headerHeight, child: _buildHeader(context));
  }

  Widget _buildHeader(BuildContext context) {
    final theme = context.tTheme;

    return Row(
      children: [
        if (cancelButton != null)
          Padding(
            padding: EdgeInsets.only(left: theme.spacer),
            child: cancelButton,
          )
        else
          SizedBox(width: theme.spacer2),
        Expanded(
          child: title == null
              ? const SizedBox.shrink()
              : Center(child: _titleWrap(theme, title!)),
        ),
        if (confirmButton != null)
          Padding(
            padding: EdgeInsets.only(right: theme.spacer),
            child: confirmButton,
          )
        else
          SizedBox(width: theme.spacer2),
      ],
    );
  }

  Widget _titleWrap(TThemeData theme, Widget child) {
    // 标题内容由用户插槽决定样式，这里只做布局约束。
    return TTextStyleScope(
      style: TextStyle(
        // 浮层可能没有 Material 祖先，标题不继承路由诊断下划线。
        // 子标题 Widget 的显式 decoration 仍可覆盖此默认值。
        decoration: TextDecoration.none,
        color: theme.textColorPrimary,
        fontSize: theme.fontTitleLarge?.size,
        fontWeight: FontWeight.w700,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      child: child,
    );
  }
}
