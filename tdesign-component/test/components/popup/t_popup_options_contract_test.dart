import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/popup/t_popup.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart' as td;

void main() {
  test('TPopupOptions all placements normalize and copy', () {
    const child = SizedBox();
    final options = <TPopupOptions>[
      TPopupOptions.bottom(child: child, height: 100),
      TPopupOptions.center(child: child, width: 100, height: 100),
      TPopupOptions.top(child: child, height: 100),
      TPopupOptions.left(child: child, width: 100),
      TPopupOptions.right(child: child, width: 100),
    ];

    for (final option in options) {
      expect(option.normalized().placement, option.placement);
      expect(option.copyWith(), isA<TPopupOptions>());
      expect(option.copyWith(width: 120, height: 80).width, 120);
      expect(
        option.copyWith(backgroundColor: Colors.red).backgroundColor,
        Colors.red,
      );
      expect(
        option
            .copyWith(overlay: const TPopupOverlayConfig(showOverlay: false))
            .overlayConfig
            .showOverlay,
        isFalse,
      );
    }

    final bottom = TPopupOptions.bottom(
      child: child,
      headerBuilder: (context, close) => const td.TPopupHeader(
        cancelButton: Text('取消'),
        title: Text('标题'),
        confirmButton: Text('确定'),
      ),
    );
    expect(bottom.headerBuilder, isNotNull);

    final center = TPopupOptions.center(child: child);
    expect(center.closeBuilder, isNull);
  });

  test('PopupLayout covers each placement and safe area', () {
    const padding = EdgeInsets.fromLTRB(1, 2, 3, 4);
    for (final placement in TPopupPlacement.values) {
      final layout = PopupLayout(placement: placement, width: 100, height: 80);
      expect(layout.alignment, isA<Alignment>());
      expect(layout.slideOffset(0.5), isA<Offset>());
      expect(
        PopupLayout.safePaddingFor(placement, padding, true),
        isA<EdgeInsets>(),
      );
      expect(
        PopupLayout.safePaddingFor(placement, padding, false),
        EdgeInsets.zero,
      );
      final positioned = layout.wrapPositioned(
        child: const SizedBox(),
        safePadding: padding,
      );
      expect(positioned, isA<Widget>());
    }
  });

  testWidgets('TPopupHeader 组合取消、标题和确认内容', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: td.TThemeBuilder.light(td.TThemeData.defaultData()),
        home: const Scaffold(
          body: td.TPopupHeader(
            cancelButton: Text('取消'),
            title: Text('标题'),
            confirmButton: Text('确定'),
          ),
        ),
      ),
    );

    expect(find.text('取消'), findsOneWidget);
    expect(find.text('标题'), findsOneWidget);
    expect(find.text('确定'), findsOneWidget);
  });

  testWidgets('center 默认尺寸为 240 且不生成关闭区', (tester) async {
    const contentKey = ValueKey('center-default-content');
    await tester.pumpWidget(
      MaterialApp(
        theme: td.TThemeBuilder.light(td.TThemeData.defaultData()),
        home: Scaffold(
          body: Center(
            child: PopupShell(
              options: TPopupOptions.center(
                child: const SizedBox.expand(key: contentKey),
              ),
              onCloseWithTrigger: (_) {},
            ),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byKey(contentKey)), const Size(240, 240));
    expect(find.byType(IconButton), findsNothing);
  });

  testWidgets('center 显式尺寸覆盖默认值', (tester) async {
    const contentKey = ValueKey('center-custom-content');
    await tester.pumpWidget(
      MaterialApp(
        theme: td.TThemeBuilder.light(td.TThemeData.defaultData()),
        home: Scaffold(
          body: Center(
            child: PopupShell(
              options: TPopupOptions.center(
                width: 180,
                height: 160,
                child: const SizedBox.expand(key: contentKey),
              ),
              onCloseWithTrigger: (_) {},
            ),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byKey(contentKey)), const Size(180, 160));
  });
}
