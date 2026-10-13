import 'package:flutter/cupertino.dart'
    show
        CupertinoTheme,
        CupertinoThemeData,
        CupertinoTextSelectionToolbarButton,
        CupertinoDesktopTextSelectionToolbarButton;
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../components/icon/t_icon.dart';
import '../components/text/t_text.dart';
import '../components/text/t_text_resolve.dart';
import '../components/text/t_text_theme_data.dart';
import 'basic.dart';
import 't_colors.dart';
import 't_fonts.dart';
import 't_spacers.dart';
import 't_theme.dart';

/// TD owns internal visuals and behavior; caller content retains its themes.
@internal
class TInternalMaterialTheme {
  TInternalMaterialTheme._();

  static CapturedThemes capture(BuildContext context) {
    context.visitAncestorElements((element) {
      if (element is InheritedElement && element.widget is InheritedTheme) {
        context.dependOnInheritedElement(element);
      }
      return true;
    });
    return InheritedTheme.capture(from: context, to: null);
  }

  static Widget restore(
    CapturedThemes captured,
    BuildContext context,
    Widget child, {
    bool retainIconDefaults = false,
  }) {
    final text = DefaultTextStyle.of(context);
    final icon = IconTheme.of(context);
    final content = retainIconDefaults
        ? IconTheme.merge(
            data: IconThemeData(color: icon.color, size: icon.size),
            child: TIconStyleScope(
              color: icon.color,
              size: icon.size,
              child: child,
            ),
          )
        : child;
    return captured.wrap(
      DefaultTextStyle(
        style: text.style,
        textAlign: text.textAlign,
        softWrap: text.softWrap,
        overflow: text.overflow,
        maxLines: text.maxLines,
        textWidthBasis: text.textWidthBasis,
        textHeightBehavior: text.textHeightBehavior,
        child: content,
      ),
    );
  }

  // Both visual and behavioral defaults belong to TD, not ambient TooltipTheme.
  static TooltipThemeData tooltipDefaults(BuildContext context) {
    final token = context.tTheme;
    final desktop = switch (Theme.of(context).platform) {
      TargetPlatform.linux ||
      TargetPlatform.macOS ||
      TargetPlatform.windows => true,
      _ => false,
    };
    final fontSize = desktop ? 12.0 : 14.0;
    return TooltipThemeData(
      constraints: BoxConstraints(minHeight: desktop ? 24 : 32),
      padding: EdgeInsets.symmetric(horizontal: desktop ? 8 : 16, vertical: 4),
      margin: EdgeInsets.zero,
      verticalOffset: 24,
      preferBelow: true,
      textAlign: TextAlign.start,
      textStyle: TTextResolve.resolve(
        context: context,
        defaults: TextStyle(
          fontSize: fontSize,
          height: (desktop ? 20 : 22) / fontSize,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).brightness == Brightness.dark
              ? token.fontGray1
              : token.textColorAnti,
        ),
      ),
      decoration: BoxDecoration(
        color: token.textColorPrimary.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4),
      ),
      waitDuration: Duration.zero,
      showDuration: const Duration(milliseconds: 1500),
      exitDuration: const Duration(milliseconds: 100),
      triggerMode: TooltipTriggerMode.longPress,
      enableFeedback: true,
      excludeFromSemantics: false,
    );
  }

  // Only the default native editing menu is isolated; menu actions stay native.
  static Widget editorMenu(BuildContext context, EditableTextState state) =>
      Theme(
        data: resolve(context),
        child: TextButtonTheme(
          data: TextButtonThemeData(style: _menuButtonStyle(context)),
          child: IconButtonTheme(
            data: IconButtonThemeData(style: _menuButtonStyle(context)),
            child: TooltipTheme(
              data: tooltipDefaults(context),
              child: AdaptiveTextSelectionToolbar(
                anchors: state.contextMenuAnchors,
                children: _menuButtons(context, state.contextMenuButtonItems),
              ),
            ),
          ),
        ),
      );

  // Native button/layout/action implementations remain; only owned labels use TD text.
  static List<Widget> _menuButtons(
    BuildContext context,
    List<ContextMenuButtonItem> items,
  ) => [
    for (var i = 0; i < items.length; i++)
      switch (Theme.of(context).platform) {
        TargetPlatform.android ||
        TargetPlatform.fuchsia => TextSelectionToolbarTextButton(
          onPressed: items[i].onPressed,
          padding: TextSelectionToolbarTextButton.getPadding(i, items.length),
          alignment: AlignmentDirectional.centerStart,
          child: _TInternalMenuLabel(
            AdaptiveTextSelectionToolbar.getButtonLabel(context, items[i]),
          ),
        ),
        TargetPlatform.linux ||
        TargetPlatform.windows => DesktopTextSelectionToolbarButton(
          onPressed: items[i].onPressed,
          child: _TInternalMenuLabel(
            AdaptiveTextSelectionToolbar.getButtonLabel(context, items[i]),
          ),
        ),
        TargetPlatform.iOS =>
          items[i].type == ContextMenuButtonType.liveTextInput
              ? CupertinoTextSelectionToolbarButton.buttonItem(
                  buttonItem: items[i],
                )
              : CupertinoTextSelectionToolbarButton(
                  onPressed: items[i].onPressed,
                  child: _TInternalMenuLabel(
                    AdaptiveTextSelectionToolbar.getButtonLabel(
                      context,
                      items[i],
                    ),
                  ),
                ),
        TargetPlatform.macOS => _TInternalCupertinoMenuButton(
          onPressed: items[i].onPressed,
          label: AdaptiveTextSelectionToolbar.getButtonLabel(context, items[i]),
        ),
      },
  ];

  static ButtonStyle _menuButtonStyle(BuildContext context) => ButtonStyle(
    textStyle: WidgetStatePropertyAll(TTextResolve.resolve(context: context)),
    backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
    foregroundColor: WidgetStatePropertyAll(context.tTheme.textColorPrimary),
    elevation: const WidgetStatePropertyAll(0),
    shadowColor: const WidgetStatePropertyAll(Colors.transparent),
    surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
    shape: const WidgetStatePropertyAll(RoundedRectangleBorder()),
    side: const WidgetStatePropertyAll(BorderSide.none),
    minimumSize: const WidgetStatePropertyAll(Size.square(48)),
    maximumSize: const WidgetStatePropertyAll(Size.infinite),
    padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
    iconSize: const WidgetStatePropertyAll(24),
    alignment: Alignment.center,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    visualDensity: VisualDensity.standard,
    animationDuration: kThemeChangeDuration,
    enableFeedback: true,
    mouseCursor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.disabled)
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
    ),
    splashFactory: InkRipple.splashFactory,
    overlayColor: WidgetStateProperty.resolveWith(
      (states) => context.tTheme.textColorPrimary.withValues(
        alpha: states.contains(WidgetState.pressed)
            ? 0.12
            : states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.focused)
            ? 0.08
            : 0,
      ),
    ),
  );

  // Instance properties returning null retain the owner's default for that state.
  static ButtonStyle mergeButtonStyle(ButtonStyle defaults, ButtonStyle style) {
    return style
        .merge(defaults)
        .copyWith(
          textStyle: _stateFallback(style.textStyle, defaults.textStyle),
          backgroundColor: _stateFallback(
            style.backgroundColor,
            defaults.backgroundColor,
          ),
          foregroundColor: _stateFallback(
            style.foregroundColor,
            defaults.foregroundColor,
          ),
          overlayColor: _stateFallback(
            style.overlayColor,
            defaults.overlayColor,
          ),
          shadowColor: _stateFallback(style.shadowColor, defaults.shadowColor),
          surfaceTintColor: _stateFallback(
            style.surfaceTintColor,
            defaults.surfaceTintColor,
          ),
          elevation: _stateFallback(style.elevation, defaults.elevation),
          padding: _stateFallback(style.padding, defaults.padding),
          minimumSize: _stateFallback(style.minimumSize, defaults.minimumSize),
          fixedSize: _stateFallback(style.fixedSize, defaults.fixedSize),
          maximumSize: _stateFallback(style.maximumSize, defaults.maximumSize),
          iconColor: _stateFallback(style.iconColor, defaults.iconColor),
          iconSize: _stateFallback(style.iconSize, defaults.iconSize),
          side: _stateFallback(style.side, defaults.side),
          shape: _stateFallback(style.shape, defaults.shape),
          mouseCursor: _stateFallback(style.mouseCursor, defaults.mouseCursor),
        );
  }

  static WidgetStateProperty<MouseCursor?>? resolveMouseCursor(
    WidgetStateProperty<MouseCursor?>? instance,
    WidgetStateProperty<MouseCursor?>? inherited,
  ) => _stateFallback(instance, inherited);

  static WidgetStateProperty<T?>? _stateFallback<T>(
    WidgetStateProperty<T?>? preferred,
    WidgetStateProperty<T?>? fallback,
  ) {
    if (preferred == null) {
      return fallback;
    }
    if (fallback == null) {
      return preferred;
    }
    return WidgetStateProperty.resolveWith(
      (states) => preferred.resolve(states) ?? fallback.resolve(states),
    );
  }

  static ThemeData resolve(BuildContext context) {
    final inherited = Theme.of(context);
    final token = context.tTheme;
    final base = inherited.brightness == Brightness.dark
        ? TThemeBuilder.dark(token)
        : TThemeBuilder.light(token);
    TextStyle owned(Font? font) => TTextResolve.resolve(
      context: context,
      defaults: TextStyle(
        fontSize: font?.size,
        height: font?.height,
        fontWeight: font?.fontWeight,
        color: token.textColorPrimary,
      ),
    );
    return base.copyWith(
      textTheme: TextTheme(
        displayLarge: owned(token.fontDisplayLarge),
        displayMedium: owned(token.fontDisplayMedium),
        displaySmall: owned(token.fontDisplayMedium),
        headlineLarge: owned(token.fontHeadlineLarge),
        headlineMedium: owned(token.fontHeadlineMedium),
        headlineSmall: owned(token.fontHeadlineSmall),
        titleLarge: owned(token.fontTitleLarge),
        titleMedium: owned(token.fontTitleMedium),
        titleSmall: owned(token.fontTitleSmall),
        bodyLarge: owned(token.fontBodyLarge),
        bodyMedium: owned(token.fontBodyMedium),
        bodySmall: owned(token.fontBodySmall),
        labelLarge: owned(token.fontLinkLarge),
        labelMedium: owned(token.fontLinkMedium),
        labelSmall: owned(token.fontLinkSmall),
      ),
      extensions: inherited.extensions.values,
      platform: inherited.platform,
      visualDensity: VisualDensity.standard,
      applyElevationOverlayColor: false,
      canvasColor: token.bgColorContainer,
      cardColor: token.bgColorContainer,
      splashFactory: InkRipple.splashFactory,
      iconButtonTheme: const IconButtonThemeData(),
      listTileTheme: const ListTileThemeData(),
      inputDecorationTheme: const InputDecorationTheme(),
    );
  }
}

/// Internal icon actions retain their explicit style and caller content theme.
@internal
class TInternalIconButton extends StatelessWidget {
  const TInternalIconButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.padding,
    this.constraints,
    this.iconSize,
    this.style,
    super.key,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final EdgeInsetsGeometry? padding;
  final BoxConstraints? constraints;
  final double? iconSize;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    final captured = TInternalMaterialTheme.capture(context);
    final token = context.tTheme;
    final defaults = ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled)
            ? token.textColorDisabled
            : token.textColorPrimary,
      ),
      backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
      elevation: const WidgetStatePropertyAll(0),
      surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
      shadowColor: const WidgetStatePropertyAll(Colors.transparent),
      side: const WidgetStatePropertyAll(BorderSide.none),
      shape: const WidgetStatePropertyAll(CircleBorder()),
      padding: WidgetStatePropertyAll(padding ?? const EdgeInsets.all(8)),
      minimumSize: WidgetStatePropertyAll(
        constraints == null ? const Size.square(40) : constraints!.smallest,
      ),
      maximumSize: WidgetStatePropertyAll(
        constraints == null ? Size.infinite : constraints!.biggest,
      ),
      iconSize: WidgetStatePropertyAll(iconSize ?? 24),
      alignment: Alignment.center,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      animationDuration: kThemeChangeDuration,
      enableFeedback: true,
      mouseCursor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled)
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
      ),
      splashFactory: InkRipple.splashFactory,
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return token.textColorPrimary.withValues(alpha: 0.12);
        }
        if (states.contains(WidgetState.focused)) {
          return token.textColorPrimary.withValues(alpha: 0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return token.textColorPrimary.withValues(alpha: 0.08);
        }
        return Colors.transparent;
      }),
    );
    final resolved =
        (style == null
                ? defaults
                : TInternalMaterialTheme.mergeButtonStyle(defaults, style!))
            .copyWith(visualDensity: VisualDensity.standard);
    return Theme(
      data: TInternalMaterialTheme.resolve(context),
      child: TooltipTheme(
        data: TInternalMaterialTheme.tooltipDefaults(context),
        child: IconButtonTheme(
          data: const IconButtonThemeData(),
          child: IconButton(
            onPressed: onPressed,
            tooltip: tooltip,
            iconSize: iconSize,
            padding: padding,
            constraints: constraints,
            visualDensity: VisualDensity.standard,
            style: resolved,
            icon: Builder(
              builder: (context) => TInternalMaterialTheme.restore(
                captured,
                context,
                icon,
                retainIconDefaults: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// TD state feedback is independent of ambient Material ink settings.
@internal
class TInternalInkWell extends StatelessWidget {
  const TInternalInkWell({
    this.child,
    this.onTap,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.onHighlightChanged,
    this.borderRadius,
    this.customBorder,
    this.overlayColor,
    this.splashColor,
    this.highlightColor,
    this.splashFactory,
    this.mouseCursor,
    this.focusNode,
    this.statesController,
    this.enableFeedback = true,
    this.excludeFromSemantics = false,
    super.key,
  });

  final Widget? child;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final ValueChanged<bool>? onHighlightChanged;
  final BorderRadius? borderRadius;
  final ShapeBorder? customBorder;
  final WidgetStateProperty<Color?>? overlayColor;
  final Color? splashColor;
  final Color? highlightColor;
  final InteractiveInkFeatureFactory? splashFactory;
  final MouseCursor? mouseCursor;
  final FocusNode? focusNode;
  final WidgetStatesController? statesController;
  final bool enableFeedback;
  final bool excludeFromSemantics;

  @override
  Widget build(BuildContext context) {
    final color = context.tTheme.textColorPrimary;
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      onHighlightChanged: onHighlightChanged,
      borderRadius: borderRadius,
      customBorder: customBorder,
      overlayColor: overlayColor,
      splashColor: splashColor ?? color.withValues(alpha: 0.12),
      highlightColor: highlightColor ?? color.withValues(alpha: 0.08),
      hoverColor: color.withValues(alpha: 0.08),
      focusColor: color.withValues(alpha: 0.1),
      splashFactory: splashFactory ?? InkRipple.splashFactory,
      mouseCursor: mouseCursor,
      focusNode: focusNode,
      statesController: statesController,
      enableFeedback: enableFeedback,
      excludeFromSemantics: excludeFromSemantics,
      child: child,
    );
  }
}

/// A TD surface retains caller content themes without Material visual defaults.
@internal
class TInternalMaterial extends StatelessWidget {
  const TInternalMaterial({
    this.child,
    this.type = MaterialType.canvas,
    this.color,
    this.elevation = 0,
    this.shadowColor = Colors.black,
    this.surfaceTintColor = Colors.transparent,
    this.textStyle,
    this.shape,
    this.borderRadius,
    this.clipBehavior = Clip.none,
    this.animationDuration = kThemeChangeDuration,
    super.key,
  });

  final Widget? child;
  final MaterialType type;
  final Color? color;
  final double elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final TextStyle? textStyle;
  final ShapeBorder? shape;
  final BorderRadiusGeometry? borderRadius;
  final Clip clipBehavior;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    final captured = TInternalMaterialTheme.capture(context);
    return Theme(
      data: TInternalMaterialTheme.resolve(context),
      child: Material(
        type: type,
        color:
            color ??
            (type == MaterialType.transparency
                ? null
                : context.tTheme.bgColorContainer),
        elevation: elevation,
        shadowColor: shadowColor,
        surfaceTintColor: surfaceTintColor,
        textStyle: textStyle ?? Theme.of(context).textTheme.bodyMedium,
        shape: shape,
        borderRadius: borderRadius,
        clipBehavior: clipBehavior,
        animationDuration: animationDuration,
        child: child == null
            ? null
            : Builder(
                builder: (context) =>
                    TInternalMaterialTheme.restore(captured, context, child!),
              ),
      ),
    );
  }
}

/// Tooltip visuals belong to the TD hint; wrapped caller content keeps its theme.
@internal
class TInternalTooltip extends StatelessWidget {
  const TInternalTooltip({
    required this.message,
    required this.child,
    super.key,
  });

  final String message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final captured = TInternalMaterialTheme.capture(context);
    return Theme(
      data: TInternalMaterialTheme.resolve(context),
      child: TooltipTheme(
        data: TInternalMaterialTheme.tooltipDefaults(context),
        child: Tooltip(
          message: message,
          child: Builder(
            builder: (context) =>
                TInternalMaterialTheme.restore(captured, context, child),
          ),
        ),
      ),
    );
  }
}

/// Component defaults reach TD icons; caller native icons retain merge semantics.
@internal
class TInternalIconTheme extends StatelessWidget {
  const TInternalIconTheme({required this.data, required this.child, super.key})
    : merge = false;
  const TInternalIconTheme.merge({
    required this.data,
    required this.child,
    super.key,
  }) : merge = true;
  final IconThemeData data;
  final Widget child;
  final bool merge;

  @override
  Widget build(BuildContext context) {
    final scoped = TIconStyleScope(
      color: data.color,
      size: data.size,
      style: data,
      child: child,
    );
    return merge
        ? IconTheme.merge(data: data, child: scoped)
        : IconTheme(data: data, child: scoped);
  }
}

/// Internal separators do not consume ambient DividerTheme fields.
@internal
class TInternalDivider extends StatelessWidget {
  const TInternalDivider({
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
    super.key,
  });
  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;

  @override
  Widget build(BuildContext context) => Theme(
    data: Theme.of(context).copyWith(dividerTheme: const DividerThemeData()),
    child: DividerTheme(
      data: const DividerThemeData(),
      child: Divider(
        height: height ?? 16,
        thickness: thickness ?? 0.5,
        indent: indent ?? 0,
        endIndent: endIndent ?? 0,
        color: color ?? context.tTheme.componentStroke,
      ),
    ),
  );
}

@internal
class TInternalVerticalDivider extends StatelessWidget {
  const TInternalVerticalDivider({
    this.width,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
    super.key,
  });
  final double? width;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;

  @override
  Widget build(BuildContext context) => Theme(
    data: Theme.of(context).copyWith(dividerTheme: const DividerThemeData()),
    child: DividerTheme(
      data: const DividerThemeData(),
      child: VerticalDivider(
        width: width ?? 16,
        thickness: thickness ?? 0.5,
        indent: indent ?? 0,
        endIndent: endIndent ?? 0,
        color: color ?? context.tTheme.componentStroke,
      ),
    ),
  );
}

/// Native internal icon data can be nullable without opening ambient icon styles.
@internal
class TInternalIcon extends StatelessWidget {
  const TInternalIcon(
    this.icon, {
    this.size,
    this.color,
    this.semanticLabel,
    super.key,
  });
  final IconData? icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => icon == null
      ? SizedBox.square(dimension: size ?? 24)
      : TIcon(icon!, size: size, color: color, semanticLabel: semanticLabel);
}

/// Collapse owns tile geometry; header and leading builders retain host themes.
@internal
class TInternalListTile extends StatelessWidget {
  const TInternalListTile({this.leading, required this.title, super.key});
  final Widget? leading;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    final captured = TInternalMaterialTheme.capture(context);
    final token = context.tTheme;
    return Theme(
      data: TInternalMaterialTheme.resolve(context),
      child: ListTileTheme(
        data: const ListTileThemeData(),
        child: ListTile(
          dense: false,
          isThreeLine: false,
          titleAlignment: ListTileTitleAlignment.center,
          visualDensity: VisualDensity.standard,
          minTileHeight: 56,
          minVerticalPadding: 8,
          minLeadingWidth: token.spacer3,
          horizontalTitleGap: token.spacer2,
          contentPadding: EdgeInsetsDirectional.only(
            start: token.spacer2,
            end: token.spacer3,
          ),
          leading: leading == null
              ? null
              : Builder(
                  builder: (context) => TInternalMaterialTheme.restore(
                    captured,
                    context,
                    leading!,
                  ),
                ),
          title: Builder(
            builder: (context) =>
                TInternalMaterialTheme.restore(captured, context, title),
          ),
        ),
      ),
    );
  }
}

/// Upload progress uses a fixed TD ring rather than theme-selected M3 variants.
@internal
class TInternalCircularProgressIndicator extends StatelessWidget {
  const TInternalCircularProgressIndicator({
    this.value,
    this.strokeWidth = 4,
    this.color,
    super.key,
  });
  final double? value;
  final double strokeWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) => Theme(
    data: TInternalMaterialTheme.resolve(context),
    child: ProgressIndicatorTheme(
      data: const ProgressIndicatorThemeData(),
      child: CircularProgressIndicator(
        value: value,
        constraints: const BoxConstraints(),
        padding: EdgeInsets.zero,
        strokeWidth: strokeWidth,
        color: color ?? context.tTheme.brandColor,
        backgroundColor: Colors.transparent,
        strokeAlign: CircularProgressIndicator.strokeAlignCenter,
        strokeCap: StrokeCap.butt,
        trackGap: 0,
        // The common API pins the original ring on both supported Flutter SDKs.
        // ignore: deprecated_member_use
        year2023: true,
      ),
    ),
  );
}

/// TD supplies its own placeholder; the editor has no Material InputDecorator.
@internal
class TInternalInputHint extends StatelessWidget {
  const TInternalInputHint({
    required this.controller,
    required this.child,
    this.hintText,
    this.hintStyle,
    this.textAlign = TextAlign.start,
    this.multiline = false,
    super.key,
  });
  final TextEditingController controller;
  final Widget child;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextAlign textAlign;
  final bool multiline;

  @override
  Widget build(
    BuildContext context,
  ) => ValueListenableBuilder<TextEditingValue>(
    valueListenable: controller,
    child: child,
    builder: (context, value, editor) {
      final visible = value.text.isEmpty && (hintText?.isNotEmpty ?? false);
      final alignment = switch (textAlign) {
        TextAlign.center => multiline ? Alignment.topCenter : Alignment.center,
        TextAlign.end =>
          multiline
              ? AlignmentDirectional.topEnd
              : AlignmentDirectional.centerEnd,
        TextAlign.right =>
          multiline ? Alignment.topRight : Alignment.centerRight,
        TextAlign.left => multiline ? Alignment.topLeft : Alignment.centerLeft,
        TextAlign.start || TextAlign.justify =>
          multiline
              ? AlignmentDirectional.topStart
              : AlignmentDirectional.centerStart,
      };
      return MergeSemantics(
        child: Semantics(
          label: visible ? hintText : null,
          child: Stack(
            children: [
              if (hintText != null)
                Positioned.fill(
                  child: Offstage(
                    offstage: !visible,
                    child: IgnorePointer(
                      child: ExcludeSemantics(
                        child: Align(
                          alignment: alignment,
                          child: Text(
                            hintText!,
                            selectionColor: context.tTheme.brandColor
                                .withValues(alpha: 0.4),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TTextResolve.resolve(
                              context: context,
                              style: hintStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              editor!,
            ],
          ),
        ),
      );
    },
  );
}

/// An editor owns selection visuals; its slots remain outside this boundary.
@internal
class TInternalEditor extends StatelessWidget {
  const TInternalEditor({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final token = context.tTheme;
    return Theme(
      data: TInternalMaterialTheme.resolve(context),
      child: DefaultSelectionStyle(
        selectionColor: token.brandColor.withValues(alpha: 0.4),
        cursorColor: token.brandColor,
        child: TextSelectionTheme(
          data: TextSelectionThemeData(
            selectionColor: token.brandColor.withValues(alpha: 0.4),
            cursorColor: token.brandColor,
            selectionHandleColor: token.brandColor,
          ),
          child: CupertinoTheme(
            data: CupertinoThemeData(
              brightness: Theme.of(context).brightness,
              primaryColor: token.brandColor,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Only this scrollable uses TD chrome. Descendant custom scrollables keep theirs.
@internal
class TInternalScrollBehavior extends MaterialScrollBehavior {
  const TInternalScrollBehavior({this.callerBehavior});
  final ScrollBehavior? callerBehavior;
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => callerBehavior == null
      ? child
      : ScrollConfiguration(behavior: callerBehavior!, child: child);
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    if (axisDirectionToAxis(details.direction) == Axis.horizontal) {
      return child;
    }
    switch (getPlatform(context)) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
        return child;
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return RawScrollbar(
          controller: details.controller,
          thumbVisibility: false,
          trackVisibility: false,
          interactive: true,
          thickness: 6,
          radius: const Radius.circular(8),
          minThumbLength: 18,
          thumbColor: context.tTheme.textColorPlaceholder,
          fadeDuration: const Duration(milliseconds: 300),
          timeToFade: const Duration(milliseconds: 600),
          pressDuration: Duration.zero,
          child: child,
        );
    }
  }
}

/// Scope only the owner Scrollable, restoring caller configuration below its viewport.
@internal
class TInternalScrollScope extends StatelessWidget {
  const TInternalScrollScope({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) => ScrollConfiguration(
    behavior: TInternalScrollBehavior(
      callerBehavior: ScrollConfiguration.of(context),
    ),
    child: child,
  );
}

// TD owns typography; the isolated native control supplies its state foreground.
class _TInternalMenuLabel extends StatelessWidget {
  const _TInternalMenuLabel(this.label, {this.hovered = false});
  final String label;
  final bool hovered;
  @override
  Widget build(BuildContext context) {
    final nativeStyle = DefaultTextStyle.of(context).style;
    final explicit = Theme.of(
      context,
    ).extension<TTextThemeData>()?.textStyle?.color;
    final nativeColor = switch (Theme.of(context).platform) {
      TargetPlatform.macOS =>
        hovered
            ? CupertinoTheme.of(context).primaryContrastingColor
            : context.tTheme.textColorPrimary,
      TargetPlatform.iOS => context.tTheme.textColorPrimary,
      _ => nativeStyle.color ?? context.tTheme.textColorPrimary,
    };
    return TText(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: explicit ?? nativeColor),
    );
  }
}

// A supplied child bypasses Cupertino's private label hover color. Mirror only
// that visual state; the native button still owns layout, press and its action.
class _TInternalCupertinoMenuButton extends StatefulWidget {
  const _TInternalCupertinoMenuButton({
    required this.label,
    required this.onPressed,
  });
  final String label;
  final VoidCallback? onPressed;
  @override
  State<_TInternalCupertinoMenuButton> createState() =>
      _TInternalCupertinoMenuButtonState();
}

class _TInternalCupertinoMenuButtonState
    extends State<_TInternalCupertinoMenuButton> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hovered = true),
    onExit: (_) => setState(() => _hovered = false),
    child: CupertinoDesktopTextSelectionToolbarButton(
      onPressed: widget.onPressed,
      child: _TInternalMenuLabel(widget.label, hovered: _hovered),
    ),
  );
}
