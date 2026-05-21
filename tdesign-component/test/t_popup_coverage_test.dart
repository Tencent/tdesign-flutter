import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/popup/_popup_layout.dart';
import 'package:tdesign_flutter/src/components/popup/t_popup_config.dart';
import 'package:tdesign_flutter/src/components/popup/t_popup_types.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'helpers/popup_test_helpers.dart';
import 'helpers/popup_test_resource.dart';

void main() {
  tearDown(resetPopupTestResource);

  group('TPopup 覆盖率补充', () {
    testWidgets('bottom 仅标题行（无操作栏）', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            context: tester.element(find.text('open')),
            placement: TPopupPlacement.bottom,
            height: 160,
            title: '仅标题行',
            cancel: null,
            confirm: null,
            child: const SizedBox(height: 60),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('仅标题行'), findsOneWidget);
      expect(find.text('取消'), findsNothing);
      expect(find.text('确定'), findsNothing);
    });

    testWidgets('bottom 仅标题且 titleAlignLeft', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            context: tester.element(find.text('open')),
            placement: TPopupPlacement.bottom,
            height: 160,
            title: '左对齐标题',
            titleAlignLeft: true,
            cancel: null,
            confirm: null,
            child: const SizedBox(height: 60),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('左对齐标题'), findsOneWidget);
    });

    testWidgets('bottom 仅隐藏 confirm 槽位', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            context: tester.element(find.text('open')),
            placement: TPopupPlacement.bottom,
            height: 160,
            confirm: null,
            onCancel: () => TPopup.close(
              tester.element(find.text('open')),
            ),
            child: const SizedBox(height: 60),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('取消'), findsOneWidget);
      expect(find.text('确定'), findsNothing);
    });

    testWidgets('bottom 仅隐藏 cancel 槽位', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            context: tester.element(find.text('open')),
            placement: TPopupPlacement.bottom,
            height: 160,
            cancel: null,
            onConfirm: () => TPopup.close(
              tester.element(find.text('open')),
            ),
            child: const SizedBox(height: 60),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('取消'), findsNothing);
      expect(find.text('确定'), findsOneWidget);
    });

    testWidgets('center closeBuilder 自定义关闭区', (tester) async {
      late BuildContext hostContext;
      await openPopup(
        tester,
        onPressed: () {
          hostContext = tester.element(find.text('open'));
          TPopup.show(
            context: hostContext,
            placement: TPopupPlacement.center,
            width: 160,
            height: 120,
            closeBuilder: (ctx) => TextButton(
              onPressed: () => TPopup.close(ctx),
              child: const Text('builder关闭'),
            ),
            child: const SizedBox(height: 80, width: 120),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('builder关闭'), findsOneWidget);
      await tester.tap(find.text('builder关闭'));
      await tester.pumpAndSettle();
    });

    testWidgets('center 默认关闭按钮触发 onCloseBtn', (tester) async {
      var closeBtnCount = 0;
      late BuildContext hostContext;
      await openPopup(
        tester,
        onPressed: () {
          hostContext = tester.element(find.text('open'));
          TPopup.show(
            context: hostContext,
            placement: TPopupPlacement.center,
            width: 120,
            height: 120,
            onCloseBtn: () => closeBtnCount++,
            child: const SizedBox(height: 80, width: 80),
          );
        },
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(TIcons.close_circle));
      await tester.pumpAndSettle();
      expect(closeBtnCount, 1);
    });

    testWidgets('bottom 无固定 height 贴底布局', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            context: tester.element(find.text('open')),
            placement: TPopupPlacement.bottom,
            cancel: null,
            confirm: null,
            child: const SizedBox(height: 80, width: 200),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.byType(Positioned), findsWidgets);
    });

    testWidgets('top 无固定 height 可打开', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            context: tester.element(find.text('open')),
            placement: TPopupPlacement.top,
            child: const SizedBox(height: 60, width: 200),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.byType(Positioned), findsWidgets);
    });

    testWidgets('center closeBtn false 无下方关闭', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            context: tester.element(find.text('open')),
            placement: TPopupPlacement.center,
            width: 100,
            height: 100,
            closeBtn: false,
            child: const SizedBox(height: 80, width: 80),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(TIcons.close_circle), findsNothing);
      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('handle 重复 close 安全', (tester) async {
      TPopupHandle? handle;
      await openPopup(
        tester,
        onPressed: () {
          handle = TPopup.show(
            context: tester.element(find.text('open')),
            placement: TPopupPlacement.bottom,
            height: 80,
            cancel: null,
            confirm: null,
            child: const SizedBox(height: 40),
          );
        },
      );
      await tester.pumpAndSettle();
      handle!.close();
      handle!.close();
      await tester.pumpAndSettle();
      expect(handle!.isShowing, isFalse);
    });

    testWidgets('TPopupActionDefault 可构建', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: kPopupActionDefault,
          ),
        ),
      );
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('TToolbarPressable 按压与禁用', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: TTheme(
            data: TThemeData.defaultData(),
            child: Scaffold(
              body: TToolbarPressable(
                onTap: () => tapped = true,
                child: const Text('press'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('press'));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);

      await tester.pumpWidget(
        MaterialApp(
          home: TTheme(
            data: TThemeData.defaultData(),
            child: Scaffold(
              body: TToolbarPressable(
                onTap: null,
                mergeTextStyle: const TextStyle(color: Colors.red),
                mergeIconTheme: const IconThemeData(color: Colors.red),
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
    });
  });

  group('TPopupConfig 覆盖率补充', () {
    test('hasBuiltInHeader 识别 titleWidget', () {
      expect(
        TPopupConfig.create(
          child: const SizedBox(),
          placement: TPopupPlacement.bottom,
          titleWidget: const Text('w'),
          cancel: null,
          confirm: null,
        ).hasBuiltInHeader,
        isTrue,
      );
    });

    test('isActionDefault 识别占位 Widget', () {
      expect(TPopupConfig.isActionDefault(kPopupActionDefault), isTrue);
      expect(TPopupConfig.isActionDefault(const Text('x')), isFalse);
      expect(TPopupConfig.isActionDefault(null), isFalse);
    });

    test('assertPlacementParams 覆盖 width 与 top 操作栏提示', () {
      expect(
        () => TPopupConfig.create(
          child: const SizedBox(),
          placement: TPopupPlacement.bottom,
          width: 200,
        ).assertPlacementParams(),
        returnsNormally,
      );
      expect(
        () => TPopupConfig.create(
          child: const SizedBox(),
          placement: TPopupPlacement.top,
          onCancel: () {},
        ).assertPlacementParams(),
        returnsNormally,
      );
      expect(
        () => TPopupConfig.create(
          child: const SizedBox(),
          placement: TPopupPlacement.center,
          height: 100,
          closeBtn: false,
        ).assertPlacementParams(),
        returnsNormally,
      );
    });
  });

  group('PopupLayout 覆盖率补充', () {
    const screen = Size(400, 800);

    testWidgets('bottom 无 height 且无 margin.top 贴底', (tester) async {
      final layout = PopupLayout(
        placement: TPopupPlacement.bottom,
        screenSize: screen,
        margin: EdgeInsets.zero,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [layout.wrapPositioned(child: const SizedBox(height: 1))],
            ),
          ),
        ),
      );
      final positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.bottom, 0);
      expect(positioned.top, isNull);
      expect(positioned.height, isNull);
    });

    test('alignment center', () {
      expect(
        PopupLayout(
          placement: TPopupPlacement.center,
          screenSize: screen,
          margin: EdgeInsets.zero,
        ).alignment,
        Alignment.center,
      );
    });

    testWidgets('left 默认 drawer 宽度', (tester) async {
      final layout = PopupLayout(
        placement: TPopupPlacement.left,
        screenSize: screen,
        margin: EdgeInsets.zero,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [layout.wrapPositioned(child: const SizedBox())],
            ),
          ),
        ),
      );
      expect(
        tester.widget<Positioned>(find.byType(Positioned)).width,
        PopupLayout.defaultDrawerWidth,
      );
    });
  });
}
