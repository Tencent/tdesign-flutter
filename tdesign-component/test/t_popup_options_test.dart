import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  group('TPopupOptions', () {
    test('默认 placement 为 bottom，4 个 builder 默认 sentinel', () {
      final options = const TPopupOptions(child: SizedBox()).normalized();
      expect(options.placement, TPopupPlacement.bottom);
      expect(options.modal, isTrue);
      expect(options.useSafeArea, isTrue);
      expect(options.closeOnOverlayClick, isTrue);
      expect(options.usesDefaultHeader, isTrue);
      expect(options.usesDefaultCancel, isTrue);
      expect(options.usesDefaultConfirm, isTrue);
      expect(options.titleWidget, isNull);
    });

    test('showOverlay=false 且省略 closeOnOverlayClick 时默认按 false 解析', () {
      final options = const TPopupOptions(
        child: SizedBox(),
        showOverlay: false,
      ).normalized();
      expect(options.closeOnOverlayClick, isFalse);
    });

    test('模态与蒙层合法组合矩阵可通过校验并解析默认关闭行为', () {
      void expectValid(
        String reason,
        TPopupOptions options, {
        required bool expectedCloseOnOverlayClick,
      }) {
        expect(
          () => options.assertPlacementParams(),
          returnsNormally,
          reason: reason,
        );
        expect(
          options.closeOnOverlayClick,
          expectedCloseOnOverlayClick,
          reason: reason,
        );
      }

      expectValid(
        '标准模态 + 默认蒙层关闭',
        const TPopupOptions(
          child: SizedBox(),
          showOverlay: true,
          modal: true,
        ),
        expectedCloseOnOverlayClick: true,
      );
      expectValid(
        '标准模态 + 显式禁止蒙层关闭',
        const TPopupOptions(
          child: SizedBox(),
          showOverlay: true,
          modal: true,
          closeOnOverlayClick: false,
        ),
        expectedCloseOnOverlayClick: false,
      );
      expectValid(
        '透明模态 + 默认不允许蒙层关闭',
        const TPopupOptions(
          child: SizedBox(),
          showOverlay: false,
          modal: true,
        ),
        expectedCloseOnOverlayClick: false,
      );
      expectValid(
        '透明模态 + 显式 false 仍合法',
        const TPopupOptions(
          child: SizedBox(),
          showOverlay: false,
          modal: true,
          closeOnOverlayClick: false,
        ),
        expectedCloseOnOverlayClick: false,
      );
      expectValid(
        '非模态浮层 + 默认不允许蒙层关闭',
        const TPopupOptions(
          child: SizedBox(),
          showOverlay: false,
          modal: false,
        ),
        expectedCloseOnOverlayClick: false,
      );
      expectValid(
        '非模态浮层 + 显式 false 仍合法',
        const TPopupOptions(
          child: SizedBox(),
          showOverlay: false,
          modal: false,
          closeOnOverlayClick: false,
        ),
        expectedCloseOnOverlayClick: false,
      );
    });

    test('bottom 默认走内置三段式（useDefaultHeader）', () {
      final options = const TPopupOptions(
        child: SizedBox(),
        placement: TPopupPlacement.bottom,
      ).normalized();
      expect(options.useDefaultHeader, isTrue);
      expect(options.useCustomHeader, isFalse);
      expect(options.showCancelSlot, isTrue);
      expect(options.showConfirmSlot, isTrue);
      expect(options.hasBuiltInHeader, isTrue);
    });

    test('cancelBuilder / confirmBuilder 均为 null 时槽位隐藏', () {
      final options = const TPopupOptions(
        child: SizedBox(),
        placement: TPopupPlacement.bottom,
        cancelBuilder: null,
        confirmBuilder: null,
      ).normalized();
      expect(options.showCancelSlot, isFalse);
      expect(options.showConfirmSlot, isFalse);
      expect(options.hasBuiltInHeader, isFalse); // titleWidget 也为 null
    });

    test('headerBuilder null 不显示头部', () {
      final options = const TPopupOptions(
        child: SizedBox(),
        placement: TPopupPlacement.bottom,
        headerBuilder: null,
      ).normalized();
      expect(options.useDefaultHeader, isFalse);
      expect(options.useCustomHeader, isFalse);
      expect(options.hasBuiltInHeader, isFalse);
    });

    test('headerBuilder 自定义 → useCustomHeader 为 true', () {
      final options = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.bottom,
        headerBuilder: (_, __) => const SizedBox(),
      ).normalized();
      expect(options.useCustomHeader, isTrue);
      expect(options.hasBuiltInHeader, isTrue);
    });

    test('normalized 忽略 bottom 的 closeBuilder（非 sentinel 也置 null）', () {
      final options = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.bottom,
        closeBuilder: (_, __) => const Text('x'),
      ).normalized();
      expect(options.closeBuilder, isNull);
    });

    test('center 默认 closeBuilder 为 sentinel（内置图标）', () {
      final options = const TPopupOptions(
        child: SizedBox(),
        placement: TPopupPlacement.center,
      ).normalized();
      expect(options.usesDefaultClose, isTrue);
    });

    test('center closeBuilder=null 不显示关闭区', () {
      final options = const TPopupOptions(
        child: SizedBox(),
        placement: TPopupPlacement.center,
        closeBuilder: null,
      ).normalized();
      expect(options.closeBuilder, isNull);
    });

    test('top 剥离 header 与三槽，重置为 null', () {
      final options = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.top,
        titleWidget: const Text('x'),
        headerBuilder: (_, __) => const Text('h'),
      ).normalized();
      expect(options.headerBuilder, isNull);
      expect(options.titleWidget, isNull);
      expect(options.cancelBuilder, isNull);
      expect(options.confirmBuilder, isNull);
      expect(options.hasBuiltInHeader, isFalse);
    });

    test('left/right 剥离 closeBuilder', () {
      final left = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.left,
        closeBuilder: (_, __) => const Text('x'),
      ).normalized();
      expect(left.closeBuilder, isNull);
    });

    test('hasBuiltInHeader 内置三段中任一槽非 null 即 true', () {
      // titleWidget 单独存在
      expect(
        const TPopupOptions(
          child: SizedBox(),
          placement: TPopupPlacement.bottom,
          titleWidget: Text('x'),
          cancelBuilder: null,
          confirmBuilder: null,
        ).normalized().hasBuiltInHeader,
        isTrue,
      );
      // 仅 cancel 默认（其它 null）
      expect(
        const TPopupOptions(
          child: SizedBox(),
          placement: TPopupPlacement.bottom,
          confirmBuilder: null,
        ).normalized().hasBuiltInHeader,
        isTrue,
      );
      // 完全无头部
      expect(
        const TPopupOptions(
          child: SizedBox(),
          placement: TPopupPlacement.bottom,
          headerBuilder: null,
        ).normalized().hasBuiltInHeader,
        isFalse,
      );
      // 非 bottom 永远 false
      expect(
        const TPopupOptions(
          child: SizedBox(),
          placement: TPopupPlacement.top,
        ).normalized().hasBuiltInHeader,
        isFalse,
      );
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
      // center 不该有 titleWidget（属于 bottom 头部字段）
      expect(
        () => const TPopupOptions(
          child: SizedBox(),
          placement: TPopupPlacement.center,
          titleWidget: Text('x'),
        ).assertPlacementParams(),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => const TPopupOptions(
          child: SizedBox(),
          showOverlay: true,
          modal: false,
        ).assertPlacementParams(),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => const TPopupOptions(
          child: SizedBox(),
          showOverlay: false,
          closeOnOverlayClick: true,
        ).assertPlacementParams(),
        throwsA(isA<FlutterError>()),
      );
    });

    test('模态与蒙层非法组合矩阵全部抛 FlutterError', () {
      void expectInvalid(String reason, TPopupOptions options) {
        expect(
          () => options.assertPlacementParams(),
          throwsA(isA<FlutterError>()),
          reason: reason,
        );
      }

      expectInvalid(
        '有蒙层但非模态（默认蒙层关闭值）',
        const TPopupOptions(
          child: SizedBox(),
          showOverlay: true,
          modal: false,
        ),
      );
      expectInvalid(
        '有蒙层但非模态（显式 false）',
        const TPopupOptions(
          child: SizedBox(),
          showOverlay: true,
          modal: false,
          closeOnOverlayClick: false,
        ),
      );
      expectInvalid(
        '透明模态下显式要求蒙层关闭',
        const TPopupOptions(
          child: SizedBox(),
          showOverlay: false,
          modal: true,
          closeOnOverlayClick: true,
        ),
      );
      expectInvalid(
        '非模态浮层下显式要求蒙层关闭',
        const TPopupOptions(
          child: SizedBox(),
          showOverlay: false,
          modal: false,
          closeOnOverlayClick: true,
        ),
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
          returnsNormally);
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
          showOverlay: false,
          modal: false,
        ).assertPlacementParams(),
        returnsNormally,
      );
    });

    test('copyWith 可更新 useSafeArea', () {
      final options = const TPopupOptions(child: SizedBox())
          .copyWith(useSafeArea: false);
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
        const original = TPopupOptions(
          child: SizedBox(),
          useSafeArea: false,
        );
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

    test('copyWith(closeOnOverlayClick: null) 可恢复为跟随 showOverlay 的默认值', () {
      final options = const TPopupOptions(
        child: SizedBox(),
        showOverlay: false,
        closeOnOverlayClick: false,
      ).copyWith(closeOnOverlayClick: null);
      expect(options.closeOnOverlayClick, isFalse);
    });
  });
}
