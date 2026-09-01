import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart';

import '../../theme/basic.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../button/t_button.dart';
import '../button/t_button_types.dart';
import '../popup/t_popup.dart';
import 't_dialog_theme_data.dart';

export 't_confirm_dialog.dart';

/// Dialog 操作的语义角色。
enum TDialogActionRole {
  /// 次要操作。
  normal,

  /// 主要操作。
  primary,

  /// 危险操作。
  destructive,
}

/// Dialog 操作项。
class TDialogAction {
  const TDialogAction({
    required this.child,
    this.result,
    this.onPressed,
    this.role = TDialogActionRole.normal,
    this.closeOnPressed = true,
    this.disabled = false,
    this.variant,
    this.colorScheme,
    this.style,
  });

  /// 按钮内容。
  final Widget child;

  /// 关闭 Dialog 时返回的结果。
  final Object? result;

  /// 点击回调，在自动关闭前执行。
  final VoidCallback? onPressed;

  /// 操作语义角色。
  final TDialogActionRole role;

  /// 点击后是否自动关闭。
  final bool closeOnPressed;

  /// 是否禁用。
  final bool disabled;

  /// 显式按钮变体。
  final TButtonVariant? variant;

  /// 显式按钮配色。
  final TButtonColorScheme? colorScheme;

  /// 显式按钮样式。
  final ButtonStyle? style;
}

/// 通用居中模态对话框。
///
/// 组件负责面板内容和操作区；使用 [show] 时，路由、蒙层、动画和安全区
/// 复用 [TPopup] 的居中浮层能力。
class TDialog extends StatelessWidget {
  static const _defaultActionsPadding = EdgeInsets.fromLTRB(24, 24, 24, 24);
  static const _textActionsPadding = EdgeInsets.only(top: 32);

  const TDialog({
    super.key,
    this.title,
    this.content,
    this.actions = const <TDialogAction>[],
    this.actionsWidget,
    this.showCloseButton = false,
    this.semanticLabel,
    this.backgroundColor,
    this.shape,
    this.elevation,
    this.width,
    this.maxHeight,
    this.contentPadding,
    this.actionsPadding = _defaultActionsPadding,
    this.actionSpacing = 12,
  }) : assert(
         actionsWidget == null || actions.length == 0,
         'actions and actionsWidget cannot be used together.',
       );

  /// 标题槽位。
  final Widget? title;

  /// 内容槽位。
  final Widget? content;

  /// 操作列表；1～2 个横向排列，更多操作纵向排列。
  final List<TDialogAction> actions;

  /// 完全自定义操作区。
  final Widget? actionsWidget;

  /// 是否显示右上角关闭按钮。
  final bool showCloseButton;

  /// 无障碍语义标签。
  final String? semanticLabel;

  /// 面板背景色。
  final Color? backgroundColor;

  /// 面板形状。
  final ShapeBorder? shape;

  /// 面板阴影高度。
  final double? elevation;

  /// 面板宽度。
  final double? width;

  /// 面板最大高度。
  final double? maxHeight;

  /// 标题和内容区域内边距。
  final EdgeInsetsGeometry? contentPadding;

  /// 操作区内边距。
  ///
  /// 全部操作显式使用 [TButtonVariant.text] 且未覆盖本字段时，自动使用
  /// 官方文字按钮 Footer 的 32dp 顶部间距，并保持按钮横向贴边。
  final EdgeInsetsGeometry actionsPadding;

  /// 操作之间的间距。
  final double actionSpacing;

  /// 使用 Popup 的居中模态路由展示 Dialog。
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget dialog,
    bool barrierDismissible = false,
    Color? barrierColor,
    bool useRootNavigator = true,
    bool useSafeArea = true,
  }) async {
    final materialBarrierColor = Theme.of(context).dialogTheme.barrierColor;
    final handle = TPopup.show(
      context,
      useRootNavigator: useRootNavigator,
      options: TPopupOptions.center(
        child: dialog,
        shrinkWrap: true,
        radius: 0,
        backgroundColor: Colors.transparent,
        overlay: TPopupOverlayConfig(
          showOverlay: true,
          closeOnClick: barrierDismissible,
          color: barrierColor ?? materialBarrierColor,
        ),
        useSafeArea: useSafeArea,
      ),
    );
    return (await handle.result) as T?;
  }

  @override
  Widget build(BuildContext context) {
    assert(title != null || content != null);
    final theme = Theme.of(context);
    final extension = theme.extension<TDialogThemeData>();
    final material = theme.dialogTheme;
    final token = context.tTheme;
    final effectiveBackground =
        backgroundColor ??
        extension?.backgroundColor ??
        material.backgroundColor ??
        token.bgColorContainer;
    final effectiveShape =
        shape ??
        extension?.shape ??
        material.shape ??
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
    final effectiveElevation =
        elevation ?? extension?.elevation ?? material.elevation ?? 0;
    final effectiveWidth = width ?? extension?.width ?? 311;
    final viewportHeight = MediaQuery.sizeOf(context).height;
    final effectiveMaxHeight = math.min(
      maxHeight ?? extension?.maxHeight ?? viewportHeight * 0.8,
      viewportHeight - 32,
    );
    final dialogWidth = math.min(
      effectiveWidth,
      MediaQuery.sizeOf(context).width - 32,
    );
    final effectiveContentPadding =
        contentPadding ??
        extension?.contentPadding ??
        const EdgeInsets.fromLTRB(24, 24, 24, 0);
    final resolvedTitleStyle =
        extension?.titleTextStyle ??
        material.titleTextStyle ??
        TextStyle(
          color: token.textColorPrimary,
          fontSize: token.fontTitleLarge?.size ?? 18,
          height: token.fontTitleLarge?.height ?? 26 / 18,
          fontWeight: token.fontTitleLarge?.fontWeight ?? FontWeight.w600,
        );
    final resolvedContentStyle =
        extension?.contentTextStyle ??
        material.contentTextStyle ??
        TextStyle(
          color: token.textColorSecondary,
          fontSize: token.fontBodyLarge?.size ?? 16,
          height: token.fontBodyLarge?.height ?? 24 / 16,
          fontWeight: token.fontBodyLarge?.fontWeight ?? FontWeight.w400,
        );
    final inheritedTextStyle = theme.textTheme.bodyMedium;
    final titleStyle = resolvedTitleStyle.copyWith(
      fontFamily:
          resolvedTitleStyle.fontFamily ?? inheritedTextStyle?.fontFamily,
      fontFamilyFallback:
          resolvedTitleStyle.fontFamilyFallback ??
          inheritedTextStyle?.fontFamilyFallback,
    );
    final contentStyle = resolvedContentStyle.copyWith(
      fontFamily:
          resolvedContentStyle.fontFamily ?? inheritedTextStyle?.fontFamily,
      fontFamilyFallback:
          resolvedContentStyle.fontFamilyFallback ??
          inheritedTextStyle?.fontFamilyFallback,
    );
    final useTextActionLayout =
        actions.isNotEmpty &&
        actions.every((action) => action.variant == TButtonVariant.text);
    final effectiveActionsPadding =
        useTextActionLayout && actionsPadding == _defaultActionsPadding
        ? _textActionsPadding
        : actionsPadding;

    return Semantics(
      namesRoute: true,
      scopesRoute: true,
      label: semanticLabel,
      explicitChildNodes: true,
      child: Material(
        color: effectiveBackground,
        shape: effectiveShape,
        elevation: effectiveElevation,
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: dialogWidth,
            maxWidth: dialogWidth,
            maxHeight: effectiveMaxHeight,
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: SingleChildScrollView(
                      padding: effectiveContentPadding,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (title != null)
                            DefaultTextStyle(
                              style: titleStyle,
                              textAlign: TextAlign.center,
                              child: title!,
                            ),
                          if (title != null && content != null)
                            const SizedBox(height: 8),
                          if (content != null)
                            DefaultTextStyle(
                              style: contentStyle,
                              textAlign: TextAlign.center,
                              child: content!,
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (actionsWidget != null)
                    actionsWidget!
                  else if (actions.isNotEmpty)
                    Padding(
                      padding: effectiveActionsPadding,
                      child: _DialogActions(
                        actions: actions,
                        spacing: actionSpacing,
                        textLayout: useTextActionLayout,
                        defaultStyle: extension?.actionButtonStyle,
                      ),
                    ),
                ],
              ),
              if (showCloseButton)
                PositionedDirectional(
                  top: 8,
                  end: 8,
                  child: IconButton(
                    tooltip: context.resource.close,
                    icon: Icon(TIcons.close, color: token.textColorPlaceholder),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogActions extends StatelessWidget {
  const _DialogActions({
    required this.actions,
    required this.spacing,
    required this.textLayout,
    this.defaultStyle,
  });

  final List<TDialogAction> actions;
  final double spacing;
  final bool textLayout;
  final ButtonStyle? defaultStyle;

  @override
  Widget build(BuildContext context) {
    final buttons = actions
        .map((action) {
          final (variant, colorScheme) = _resolveStyle(action);
          return TButton(
            variant: action.variant ?? variant,
            colorScheme: action.colorScheme ?? colorScheme,
            style: action.style ?? defaultStyle,
            onPressed: action.disabled
                ? null
                : () {
                    action.onPressed?.call();
                    final route = ModalRoute.of(context);
                    if (action.closeOnPressed &&
                        context.mounted &&
                        route?.isCurrent == true) {
                      Navigator.pop(context, action.result);
                    }
                  },
            child: action.child,
          );
        })
        .toList(growable: false);

    if (textLayout && buttons.length <= 2) {
      final divider = BorderSide(
        color: context.tTheme.componentBorderColor,
        width: 0.5,
      );
      return DecoratedBox(
        decoration: BoxDecoration(border: Border(top: divider)),
        child: SizedBox(
          height: 56,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var index = 0; index < buttons.length; index++) ...[
                if (index > 0)
                  VerticalDivider(
                    width: 0.5,
                    thickness: 0.5,
                    color: divider.color,
                  ),
                Expanded(child: buttons[index]),
              ],
            ],
          ),
        ),
      );
    }
    if (buttons.length <= 2) {
      return Row(
        children: [
          for (var index = 0; index < buttons.length; index++) ...[
            if (index > 0) SizedBox(width: spacing),
            Expanded(child: buttons[index]),
          ],
        ],
      );
    }
    final verticalButtons = buttons.reversed.toList(growable: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < verticalButtons.length; index++) ...[
          if (index > 0) SizedBox(height: spacing),
          verticalButtons[index],
        ],
      ],
    );
  }

  (TButtonVariant, TButtonColorScheme) _resolveStyle(TDialogAction action) {
    return switch (action.role) {
      TDialogActionRole.normal => (
        TButtonVariant.outline,
        TButtonColorScheme.defaultTheme,
      ),
      TDialogActionRole.primary => (
        TButtonVariant.fill,
        TButtonColorScheme.primary,
      ),
      TDialogActionRole.destructive => (
        TButtonVariant.fill,
        TButtonColorScheme.danger,
      ),
    };
  }
}
