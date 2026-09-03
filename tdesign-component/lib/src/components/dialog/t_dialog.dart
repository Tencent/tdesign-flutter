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

  /// 操作语义角色，默认为 [TDialogActionRole.normal]。
  ///
  /// 未指定变体时使用填充按钮：普通操作采用浅色配色，主要操作采用品牌配色，
  /// 危险操作采用危险配色。显式变体、配色和样式优先于角色默认值。
  final TDialogActionRole role;

  /// 点击后是否自动关闭。
  final bool closeOnPressed;

  /// 是否禁用。
  final bool disabled;

  /// 显式按钮变体；未指定时使用 [TButtonVariant.fill]。
  final TButtonVariant? variant;

  /// 显式按钮配色；未指定时由角色和最终变体解析。
  ///
  /// 普通操作的填充变体使用 [TButtonColorScheme.light]，其他变体使用
  /// [TButtonColorScheme.defaultTheme]；主要和危险操作分别使用
  /// [TButtonColorScheme.primary]、[TButtonColorScheme.danger]。
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
    this.closeButtonResult,
    this.semanticLabel,
    this.backgroundColor,
    this.shape,
    this.elevation,
    this.width,
    this.maxHeight,
    this.contentPadding,

    /// 操作区内边距。未设置时使用主题 token 默认值。
    EdgeInsetsGeometry? actionsPadding,

    /// 操作之间的间距。未设置时使用主题 token 默认值。
    double? actionSpacing,
  }) : _actionsPadding = actionsPadding,
       _actionSpacing = actionSpacing,
       assert(
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

  /// 点击内置关闭按钮并成功关闭时的返回值，默认为 null。
  ///
  /// 类型应与 [show] 的泛型一致。可与 [TDialogAction.result] 和
  /// [show] 的 `barrierResult` 配合，通过同一个 Future 区分关闭来源。
  /// 不影响系统返回或业务调用 Navigator.pop 的返回值。
  final Object? closeButtonResult;

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
  /// 1～2 个操作全部显式使用 [TButtonVariant.text] 且未覆盖本字段时，自动使用
  /// 官方文字按钮 Footer 的 32dp 顶部间距，并保持按钮横向贴边。
  EdgeInsetsGeometry get actionsPadding =>
      _actionsPadding ?? _defaultActionsPadding;

  final EdgeInsetsGeometry? _actionsPadding;

  /// 操作之间的间距。
  double get actionSpacing => _actionSpacing ?? 12;

  final double? _actionSpacing;

  /// 使用居中模态路由展示 Dialog。
  ///
  /// [barrierDismissible] 默认为 false，点击蒙层不会关闭。
  /// 显式开启后，蒙层关闭成功时返回 [barrierResult]（默认 null）；
  /// 操作按钮与内置关闭按钮分别返回各自配置的结果。
  /// 蒙层与内置关闭按钮通过 Navigator.maybePop 关闭，遵守 PopScope。
  /// 系统返回及未携带结果的 Navigator.pop 仍返回 null，不使用 [barrierResult]。
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget dialog,
    bool barrierDismissible = false,
    T? barrierResult,
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
    return navigator.push<T>(
      _DialogRoute<T>(
        barrierDismissible: barrierDismissible,
        barrierResult: barrierResult,
        barrierLabel: MaterialLocalizations.of(
          context,
        ).modalBarrierDismissLabel,
        barrierColor: barrierColor ?? materialBarrierColor ?? Colors.black54,
        transitionDuration: const Duration(milliseconds: 240),
        pageBuilder: (routeContext, animation, secondaryAnimation) {
          final centered = Center(child: dialog);
          final content = useSafeArea ? SafeArea(child: centered) : centered;
          return capturedThemes.wrap(content);
        },
        transitionBuilder:
            (routeContext, animation, secondaryAnimation, child) {
              final progress = animation.status == AnimationStatus.reverse
                  ? Curves.easeOut.transform(animation.value)
                  : Curves.decelerate.transform(animation.value);
              return Transform.scale(scale: progress, child: child);
            },
      ),
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
        actions.length <= 2 &&
        actions.isNotEmpty &&
        actions.every((action) => action.variant == TButtonVariant.text);
    final effectiveActionsPadding =
        _actionsPadding ??
        (useTextActionLayout
            ? EdgeInsets.only(top: token.spacer32)
            : EdgeInsets.all(token.spacer24));
    final effectiveActionSpacing = _actionSpacing ?? token.spacer12;

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
                    onPressed: () =>
                        Navigator.maybePop(context, closeButtonResult),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// 保留标准模态路由的动画、命中测试和无障碍行为，仅为蒙层提供返回值。
class _DialogRoute<T> extends RawDialogRoute<T> {
  _DialogRoute({
    required super.pageBuilder,
    required super.barrierDismissible,
    required super.barrierColor,
    required super.barrierLabel,
    required super.transitionDuration,
    required super.transitionBuilder,
    required this.barrierResult,
  });

  final T? barrierResult;

  void _dismissBarrier() {
    if (isCurrent) {
      navigator?.maybePop<T>(barrierResult);
    }
  }

  @override
  Widget buildModalBarrier() {
    final color = barrierColor;
    if (color != null && color.a != 0 && !offstage) {
      return AnimatedModalBarrier(
        color: animation!.drive(
          ColorTween(
            begin: color.withValues(alpha: 0),
            end: color,
          ).chain(CurveTween(curve: barrierCurve)),
        ),
        dismissible: barrierDismissible,
        onDismiss: _dismissBarrier,
        semanticsLabel: barrierLabel,
        barrierSemanticsDismissible: semanticsDismissible,
      );
    }
    return ModalBarrier(
      dismissible: barrierDismissible,
      onDismiss: _dismissBarrier,
      semanticsLabel: barrierLabel,
      barrierSemanticsDismissible: semanticsDismissible,
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
        TButtonVariant.fill,
        action.variant == null || action.variant == TButtonVariant.fill
            ? TButtonColorScheme.light
            : TButtonColorScheme.defaultTheme,
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
