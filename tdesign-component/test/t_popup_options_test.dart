import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  group('TPopupOptions', () {
    test('默认 placement 为 bottom，内容 builder 默认均为空', () {
      final options = const TPopupOptions(child: SizedBox()).normalized();
      expect(options.placement, TPopupPlacement.bottom);
      expect(options.overlayConfig.showOverlay, isTrue);
      expect(options.overlayConfig.preventTap, isTrue);
      expect(options.useSafeArea, isTrue);
      expect(options.overlayConfig.effectiveCloseOnClick, isTrue);
      expect(options.headerBuilder, isNull);
      expect(options.closeBuilder, isNull);
    });

    test('showOverlay=false 且省略 closeOnClick 时默认按 false 解析', () {
      final options = const TPopupOptions(
        child: SizedBox(),
        overlay: TPopupOverlayConfig(showOverlay: false),
      ).normalized();
      expect(options.overlayConfig.effectiveCloseOnClick, isFalse);
    });

    test('蒙层组合矩阵均可通过校验并解析默认关闭行为', () {
      void expectValid(
        String reason,
        TPopupOptions options, {
        required bool expectedCloseOnClick,
      }) {
        expect(
          () => options.assertPlacementParams(),
          returnsNormally,
          reason: reason,
        );
        expect(
          options.overlayConfig.effectiveCloseOnClick,
          expectedCloseOnClick,
          reason: reason,
        );
      }

      expectValid(
        '标准模态 + 默认蒙层关闭',
        const TPopupOptions(
          child: SizedBox(),
          overlay: TPopupOverlayConfig(showOverlay: true, preventTap: true),
        ),
        expectedCloseOnClick: true,
      );
      expectValid(
        '标准模态 + 显式禁止蒙层关闭',
        const TPopupOptions(
          child: SizedBox(),
          overlay: TPopupOverlayConfig(
            showOverlay: true,
            preventTap: true,
            closeOnClick: false,
          ),
        ),
        expectedCloseOnClick: false,
      );
      expectValid(
        '透明模态 + 默认不允许蒙层关闭',
        const TPopupOptions(
          child: SizedBox(),
          overlay: TPopupOverlayConfig(showOverlay: false, preventTap: true),
        ),
        expectedCloseOnClick: false,
      );
      expectValid(
        '透明模态 + 显式 false 仍合法',
        const TPopupOptions(
          child: SizedBox(),
          overlay: TPopupOverlayConfig(
            showOverlay: false,
            preventTap: true,
            closeOnClick: false,
          ),
        ),
        expectedCloseOnClick: false,
      );
      expectValid(
        '非模态浮层 + 默认不允许蒙层关闭',
        const TPopupOptions(
          child: SizedBox(),
          overlay: TPopupOverlayConfig(showOverlay: false, preventTap: false),
        ),
        expectedCloseOnClick: false,
      );
      expectValid(
        '显示蒙层但不拦截交互',
        const TPopupOptions(
          child: SizedBox(),
          overlay: TPopupOverlayConfig(showOverlay: true, preventTap: false),
        ),
        expectedCloseOnClick: false,
      );
      expectValid(
        '显示蒙层但不拦截交互时显式关闭仍不生效',
        const TPopupOptions(
          child: SizedBox(),
          overlay: TPopupOverlayConfig(
            showOverlay: true,
            preventTap: false,
            closeOnClick: true,
          ),
        ),
        expectedCloseOnClick: false,
      );
      expectValid(
        '透明模态显式关闭仍不生效',
        const TPopupOptions(
          child: SizedBox(),
          overlay: TPopupOverlayConfig(
            showOverlay: false,
            preventTap: true,
            closeOnClick: true,
          ),
        ),
        expectedCloseOnClick: false,
      );
    });

    test('bottom 默认不显示头部', () {
      final options = const TPopupOptions(
        child: SizedBox(),
        placement: TPopupPlacement.bottom,
      ).normalized();
      expect(options.headerBuilder, isNull);
    });

    test('headerBuilder null 不显示头部', () {
      final options = const TPopupOptions(
        child: SizedBox(),
        placement: TPopupPlacement.bottom,
        headerBuilder: null,
      ).normalized();
      expect(options.headerBuilder, isNull);
    });

    test('headerBuilder 可显式提供整块头部', () {
      final options = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.bottom,
        headerBuilder: (_, __) => const SizedBox(),
      ).normalized();
      expect(options.headerBuilder, isNotNull);
    });

    test('normalized 忽略 bottom 的 closeBuilder', () {
      final options = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.bottom,
        closeBuilder: (_, __) => const Text('x'),
      ).normalized();
      expect(options.closeBuilder, isNull);
    });

    test('center 默认不显示关闭区', () {
      final options = const TPopupOptions(
        child: SizedBox(),
        placement: TPopupPlacement.center,
      ).normalized();
      expect(options.closeBuilder, isNull);
    });

    test('center closeBuilder=null 不显示关闭区', () {
      final options = const TPopupOptions(
        child: SizedBox(),
        placement: TPopupPlacement.center,
        closeBuilder: null,
      ).normalized();
      expect(options.closeBuilder, isNull);
    });

    test('top 剥离 headerBuilder', () {
      final options = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.top,
        headerBuilder: (_, __) => const Text('h'),
      ).normalized();
      expect(options.headerBuilder, isNull);
    });

    test('left/right 剥离 closeBuilder', () {
      final left = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.left,
        closeBuilder: (_, __) => const Text('x'),
      ).normalized();
      expect(left.closeBuilder, isNull);
    });

    test('assertPlacementParams debug 期对错位字段抛 FlutterError', () {
      // left 不该有 height
      expect(
        () => const TPopupOptions(
          child: SizedBox(),
          placement: TPopupPlacement.left,
          height: 100,
        ).assertPlacementParams(),
        throwsA(isA<FlutterError>()),
      );
      // center 不该有 bottom headerBuilder
      expect(
        () => TPopupOptions(
          child: const SizedBox(),
          placement: TPopupPlacement.center,
          headerBuilder: (_, __) => const Text('x'),
        ).assertPlacementParams(),
        throwsA(isA<FlutterError>()),
      );
    });

    test('assertPlacementParams 各 placement 的 inset 类型错位也抛错', () {
      expect(
        () => const TPopupOptions(
          child: SizedBox(),
          placement: TPopupPlacement.top,
          inset: TPopupBottomInset(left: 10),
        ).assertPlacementParams(),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => const TPopupOptions(
          child: SizedBox(),
          placement: TPopupPlacement.right,
          inset: TPopupLeftInset(top: 10),
        ).assertPlacementParams(),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => const TPopupOptions(
          child: SizedBox(),
          placement: TPopupPlacement.center,
          inset: TPopupTopInset(left: 10),
        ).assertPlacementParams(),
        throwsA(isA<FlutterError>()),
      );
    });

    test('assertPlacementParams 合法配置不抛错', () {
      // 各 placement 用对应合法字段
      expect(
        () => const TPopupOptions(child: SizedBox()).assertPlacementParams(),
        returnsNormally,
      );
      expect(
        () => const TPopupOptions(
          child: SizedBox(),
          placement: TPopupPlacement.center,
          width: 200,
          height: 200,
        ).assertPlacementParams(),
        returnsNormally,
      );
      expect(
        () => const TPopupOptions(
          child: SizedBox(),
          placement: TPopupPlacement.left,
          width: 280,
          inset: TPopupLeftInset(top: 10, bottom: 10),
        ).assertPlacementParams(),
        returnsNormally,
      );
      expect(
        () => const TPopupOptions(
          child: SizedBox(),
          overlay: TPopupOverlayConfig(showOverlay: false, preventTap: false),
        ).assertPlacementParams(),
        returnsNormally,
      );
    });

    test('copyWith 可更新 useSafeArea', () {
      final options = const TPopupOptions(
        child: SizedBox(),
      ).copyWith(useSafeArea: false);
      expect(options.useSafeArea, isFalse);
    });

    test('normalized 保留 useSafeArea', () {
      final options = const TPopupOptions(
        child: SizedBox(),
        useSafeArea: false,
      ).normalized();
      expect(options.useSafeArea, isFalse);
    });

    test('bottom 工厂可关闭 useSafeArea', () {
      final options = TPopupOptions.bottom(
        child: const SizedBox(),
        useSafeArea: false,
      );
      expect(options.useSafeArea, isFalse);
    });

    group('useSafeArea 边界', () {
      test('各命名工厂默认 useSafeArea 为 true', () {
        const child = SizedBox();
        expect(TPopupOptions.bottom(child: child).useSafeArea, isTrue);
        expect(TPopupOptions.top(child: child).useSafeArea, isTrue);
        expect(TPopupOptions.left(child: child).useSafeArea, isTrue);
        expect(TPopupOptions.right(child: child).useSafeArea, isTrue);
        expect(TPopupOptions.center(child: child).useSafeArea, isTrue);
      });

      test('各命名工厂可显式关闭 useSafeArea', () {
        const child = SizedBox();
        expect(
          TPopupOptions.top(child: child, useSafeArea: false).useSafeArea,
          isFalse,
        );
        expect(
          TPopupOptions.left(child: child, useSafeArea: false).useSafeArea,
          isFalse,
        );
        expect(
          TPopupOptions.right(child: child, useSafeArea: false).useSafeArea,
          isFalse,
        );
        expect(
          TPopupOptions.center(child: child, useSafeArea: false).useSafeArea,
          isFalse,
        );
      });

      test('copyWith 未传 useSafeArea 时保留原值', () {
        const original = TPopupOptions(child: SizedBox(), useSafeArea: false);
        final copied = original.copyWith(height: 100);
        expect(copied.useSafeArea, isFalse);
        expect(copied.height, 100);
      });

      test('copyWith 变更 placement 时仍保留 useSafeArea', () {
        final options = const TPopupOptions(
          child: SizedBox(),
          placement: TPopupPlacement.bottom,
          useSafeArea: false,
        ).copyWith(placement: TPopupPlacement.top);
        expect(options.placement, TPopupPlacement.top);
        expect(options.useSafeArea, isFalse);
      });
    });

    test('TPopupOverlayConfig.effectiveCloseOnClick 跟随 showOverlay', () {
      const config = TPopupOverlayConfig(showOverlay: true);
      expect(config.effectiveCloseOnClick, isTrue);
      const config2 = TPopupOverlayConfig(showOverlay: false);
      expect(config2.effectiveCloseOnClick, isFalse);
    });

    test('TPopupOverlayConfig 默认值与字段', () {
      const config = TPopupOverlayConfig();
      expect(config.showOverlay, isTrue);
      expect(config.color, isNull);
      expect(config.opacity, isNull);
      expect(config.preventTap, isTrue);
      expect(config.closeOnClick, isNull);
      expect(config.onClick, isNull);
      expect(config.effectiveCloseOnClick, isTrue);
    });

    test('overlay 为 null 时 overlayConfig 返回默认配置', () {
      const options = TPopupOptions(child: SizedBox());
      expect(options.overlay, isNull);
      expect(options.overlayConfig.showOverlay, isTrue);
      expect(options.overlayConfig.preventTap, isTrue);
    });
  });
}
