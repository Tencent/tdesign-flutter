import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart';

import '../../theme/basic.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../button/t_button.dart';
import '../button/t_button_types.dart';
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
/// 组件负责面板内容和操作区；使用 [show] 时，通过 Flutter 模态路由处理
/// 蒙层、动画和安全区。
class TDialog extends StatelessWidget {
  static const _defaultActionsPadding = EdgeInsets.fromLTRB(24, 24, 24, 24);
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
  ///
  /// 纵向排列时，[TDialogAction.role] 为 [TDialogActionRole.primary] 或
  /// [TDialogActionRole.destructive] 的强调操作优先展示，同类操作保持声明顺序。
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

  /// 使用居中模态路由展示 Dialog。
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget dialog,
    bool barrierDismissible = false,
    Color? barrierColor,
    bool useRootNavigator = true,
    bool useSafeArea = true,
  }) {
    final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
    final capturedThemes = InheritedTheme.capture(
      from: context,
      to: navigator.context,
    );
    final materialBarrierColor = Theme.of(context).dialogTheme.barrierColor;
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: barrierColor ?? materialBarrierColor ?? Colors.black54,
      useRootNavigator: useRootNavigator,
      transitionDuration: const Duration(milliseconds: 240),
      pageBuilder: (routeContext, animation, secondaryAnimation) {
        final centered = Center(child: dialog);
        final content = useSafeArea ? SafeArea(child: centered) : centered;
        return capturedThemes.wrap(content);
      },
      transitionBuilder: (routeContext, animation, secondaryAnimation, child) {
        final progress = animation.status == AnimationStatus.reverse
            ? Curves.easeOut.transform(animation.value)
            : Curves.decelerate.transform(animation.value);
        return Transform.scale(scale: progress, child: child);
      },
    );
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
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(token.radiusExtraLarge),
        );
    final effectiveElevation =
        elevation ?? extension?.elevation ?? material.elevation ?? 0;
    final effectiveWidth = width ?? extension?.width ?? 311;
    final viewportHeight = MediaQuery.sizeOf(context).height;
    final effectiveMaxHeight = math.max(
      0.0,
      math.min(
        maxHeight ?? extension?.maxHeight ?? viewportHeight * 0.8,
        viewportHeight - token.spacer32,
      ),
    );
    final dialogWidth = math.max(
      0.0,
      math.min(
        effectiveWidth,
        MediaQuery.sizeOf(context).width - token.spacer32,
      ),
    );
    final effectiveContentPadding =
        contentPadding ??
        extension?.contentPadding ??
        EdgeInsets.fromLTRB(token.spacer24, token.spacer24, token.spacer24, 0);
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
        ? EdgeInsets.only(top: token.spacer32)
        : actionsPadding == _defaultActionsPadding
        ? EdgeInsets.all(token.spacer24)
        : actionsPadding;
    final effectiveActionSpacing = actionSpacing == 12
        ? token.spacer12
        : actionSpacing;

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
                            SizedBox(height: token.spacer8),
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
                        spacing: effectiveActionSpacing,
                        textLayout: useTextActionLayout,
                        defaultStyle: extension?.actionButtonStyle,
                      ),
                    ),
                ],
              ),
              if (showCloseButton)
                PositionedDirectional(
                  top: token.spacer8,
                  end: token.spacer8,
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
    final orderedActions = actions.length > 2
        ? <TDialogAction>[
            ...actions.where(
              (action) => action.role == TDialogActionRole.primary,
            ),
            ...actions.where(
              (action) => action.role == TDialogActionRole.destructive,
            ),
            ...actions.where(
              (action) => action.role == TDialogActionRole.normal,
            ),
          ]
        : actions;
    final buttons = orderedActions
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < buttons.length; index++) ...[
          if (index > 0) SizedBox(height: spacing),
          buttons[index],
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
