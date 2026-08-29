import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  testWidgets('文字缩放后面板重新按实际布局测量', (tester) async {
    final controller = TSwipeCellController();
    final childKey = GlobalKey();

    Widget app(double scale) {
      return MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(scale)),
          child: SizedBox(
            width: 320,
            height: 64,
            child: TSwipeCell(
              controller: controller,
              end: TSwipeCellPanel(
                children: [
                  const TSwipeCellAction(icon: Icons.delete, label: '非常长的操作'),
                ],
              ),
              child: SizedBox.expand(key: childKey),
            ),
          ),
        ),
      );
    }

    await tester.pumpWidget(app(1));
    await tester.pump();
    final normalWidth = tester.getSize(find.byType(TSwipeCellAction)).width;
    await tester.pumpWidget(app(1.5));
    await tester.pump();
    final scaledWidth = tester.getSize(find.byType(TSwipeCellAction)).width;
    expect(scaledWidth, greaterThan(normalWidth));

    unawaited(controller.open(TSwipeCellSide.end));
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.byKey(childKey)).dx,
      closeTo(-scaledWidth, 0.1),
    );
    expect(
      tester
          .renderObject<RenderParagraph>(find.text('非常长的操作'))
          .didExceedMaxLines,
      isFalse,
    );
  });

  testWidgets('超出单元格宽度的面板仍按内容完整展开', (tester) async {
    final controller = TSwipeCellController();
    final childKey = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: SizedBox(
          width: 40,
          height: 64,
          child: TSwipeCell(
            controller: controller,
            end: TSwipeCellPanel(
              children: [const TSwipeCellAction(label: '非常长的操作文案')],
            ),
            child: SizedBox.expand(key: childKey),
          ),
        ),
      ),
    );
    await tester.pump();
    final width = tester.getSize(find.byType(TSwipeCellAction)).width;
    expect(width, greaterThan(40));
    unawaited(controller.open(TSwipeCellSide.end));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.byKey(childKey)).dx, closeTo(-width, 0.1));
  });
}
