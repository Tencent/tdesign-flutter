part of 't_popup.dart';

/// Popup 标准头部布局。
///
/// 本组件只负责取消按钮、标题和确认按钮的布局，不注入默认内容或业务行为。
/// 需要关闭 Popup 时，在 [TPopupOptions.headerBuilder] 中构建按钮并调用其 `close` 参数。
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
            padding: EdgeInsets.only(left: theme.spacer8),
            child: cancelButton,
          )
        else
          SizedBox(width: theme.spacer16),
        Expanded(
          child: title == null
              ? const SizedBox.shrink()
              : Center(child: _titleWrap(theme, title!)),
        ),
        if (confirmButton != null)
          Padding(
            padding: EdgeInsets.only(right: theme.spacer8),
            child: confirmButton,
          )
        else
          SizedBox(width: theme.spacer16),
      ],
    );
  }

  Widget _titleWrap(TThemeData theme, Widget child) {
    // 标题内容由用户插槽决定样式，这里只做布局约束。
    return DefaultTextStyle.merge(
      style: TextStyle(
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
