import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/basic.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';

double _fontLineHeight(
  Font? font,
  TextStyle? explicitStyle,
  TextStyle? materialFallback,
) {
  final style = TextStyle(
    fontSize: font?.size ?? materialFallback?.fontSize,
    height: font?.height ?? materialFallback?.height,
  ).merge(explicitStyle);
  return style.fontSize! * (style.height ?? 1);
}

double _selectionCardHeight(BuildContext context, bool hasSubtitle) {
  final materialTheme = Theme.of(context);
  final explicitTextTheme = materialTheme.tExplicitTextTheme;
  final titleHeight = _fontLineHeight(
    context.tTheme.fontBodyLarge,
    explicitTextTheme?.bodyLarge ?? explicitTextTheme?.bodyMedium,
    materialTheme.textTheme.bodyLarge,
  );
  final contentHeight = hasSubtitle
      ? titleHeight +
            context.tTheme.spacer4 +
            _fontLineHeight(
              context.tTheme.fontBodyMedium,
              explicitTextTheme?.bodyMedium ?? explicitTextTheme?.bodySmall,
              materialTheme.textTheme.bodyMedium,
            )
      : titleHeight;
  return contentHeight + context.tTheme.spacer16 * 2;
}

/// 复选框或单选框使用的卡片式选择容器。
class TSelectionCard extends StatelessWidget {
  const TSelectionCard({
    super.key,
    required this.selected,
    required this.disabled,
    required this.selectedColor,
    required this.disabledColor,
    required this.backgroundColor,
    required this.borderRadius,
    required this.minHeight,
    required this.child,
  });

  final bool selected;
  final bool disabled;
  final Color selectedColor;
  final Color disabledColor;
  final Color backgroundColor;
  final double borderRadius;
  final double minHeight;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final stateColor = disabled ? disabledColor : selectedColor;
    final markStyle = _SelectionCardMarkStyle.maybeOf(context);
    final defaultMarkSize = context.tTheme.spacer24 + context.tTheme.spacer4;
    final markSize = markStyle?.size ?? defaultMarkSize;
    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          width: context.tTheme.spacer4 * 3 / 8,
          color: selected ? stateColor : Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Stack(
        children: [
          child,
          if (selected)
            Positioned(
              top: 0,
              left: 0,
              child: _SelectionCardMark(
                color: stateColor,
                size: markSize,
                iconSize: markStyle?.iconSize ?? markSize / 2,
                iconOffset:
                    markStyle?.iconOffset ??
                    Offset(markSize / 14, markSize * 3 / 28),
              ),
            ),
        ],
      ),
    );
  }
}

/// 用于排列多个 [TSelectionCard] 的布局容器。
class TSelectionCardGroupLayout extends StatelessWidget {
  const TSelectionCardGroupLayout({
    super.key,
    required this.direction,
    required this.columns,
    required this.children,
    required this.itemHasSubtitles,
  }) : assert(children.length == itemHasSubtitles.length),
       assert(columns > 0);

  final Axis direction;
  final int columns;
  final List<Widget> children;
  final List<bool> itemHasSubtitles;

  @override
  Widget build(BuildContext context) {
    if (direction == Axis.vertical) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: context.tTheme.spacer16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var index = 0; index < children.length; index++) ...[
              SizedBox(
                height: _selectionCardHeight(context, itemHasSubtitles[index]),
                child: children[index],
              ),
              if (index < children.length - 1)
                SizedBox(height: context.tTheme.spacer12),
            ],
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = context.tTheme.spacer12;
        final horizontalPadding = context.tTheme.spacer16;
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth - horizontalPadding * 2
            : null;
        final itemWidth = availableWidth == null
            ? null
            : (availableWidth - spacing * (columns - 1)) / columns;
        final itemHeight = _selectionCardHeight(
          context,
          itemHasSubtitles.any((hasSubtitle) => hasSubtitle),
        );
        final markSize = context.tTheme.spacer24;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              for (final child in children)
                SizedBox(
                  width: itemWidth,
                  height: itemHeight,
                  child: _SelectionCardMarkStyle(
                    size: markSize,
                    iconSize: markSize / 2,
                    iconOffset: Offset(markSize / 16, markSize / 16),
                    child: child,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _SelectionCardMark extends StatelessWidget {
  const _SelectionCardMark({
    required this.color,
    required this.size,
    required this.iconSize,
    required this.iconOffset,
  });

  final Color color;
  final double size;
  final double iconSize;
  final Offset iconOffset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          CustomPaint(
            size: Size.square(size),
            painter: _SelectionCardMarkPainter(
              color,
              cornerRadius: context.tTheme.spacer4,
            ),
          ),
          Positioned(
            top: iconOffset.dy,
            left: iconOffset.dx,
            child: Icon(
              TIcons.check,
              size: iconSize,
              color: context.tTheme.textColorAnti,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectionCardMarkStyle extends InheritedWidget {
  const _SelectionCardMarkStyle({
    required this.size,
    required this.iconSize,
    required this.iconOffset,
    required super.child,
  });

  final double size;
  final double iconSize;
  final Offset iconOffset;

  static _SelectionCardMarkStyle? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_SelectionCardMarkStyle>();
  }

  @override
  bool updateShouldNotify(_SelectionCardMarkStyle oldWidget) {
    return size != oldWidget.size ||
        iconSize != oldWidget.iconSize ||
        iconOffset != oldWidget.iconOffset;
  }
}

class _SelectionCardMarkPainter extends CustomPainter {
  const _SelectionCardMarkPainter(this.color, {required this.cornerRadius});

  final Color color;
  final double cornerRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = true
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, cornerRadius)
      ..quadraticBezierTo(0, 0, cornerRadius, 0)
      ..lineTo(size.width, 0)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SelectionCardMarkPainter oldDelegate) {
    return color != oldDelegate.color ||
        cornerRadius != oldDelegate.cornerRadius;
  }
}
