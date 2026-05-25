import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  group('TPopupOptions', () {
    test('默认 placement 为 bottom，4 个 builder 默认 sentinel', () {
      final options = TPopupOptions(child: const SizedBox()).normalized();
      expect(options.placement, TPopupPlacement.bottom);
      expect(options.usesDefaultHeader, isTrue);
      expect(options.usesDefaultCancel, isTrue);
      expect(options.usesDefaultConfirm, isTrue);
      expect(options.titleWidget, isNull);
    });

    test('bottom 默认走内置三段式（useDefaultHeader）', () {
      final options = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.bottom,
      ).normalized();
      expect(options.useDefaultHeader, isTrue);
      expect(options.useCustomHeader, isFalse);
      expect(options.showCancelSlot, isTrue);
      expect(options.showConfirmSlot, isTrue);
      expect(options.hasBuiltInHeader, isTrue);
    });

    test('cancelBuilder / confirmBuilder 均为 null 时槽位隐藏', () {
      final options = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.bottom,
        cancelBuilder: null,
        confirmBuilder: null,
      ).normalized();
      expect(options.showCancelSlot, isFalse);
      expect(options.showConfirmSlot, isFalse);
      expect(options.hasBuiltInHeader, isFalse); // titleWidget 也为 null
    });

    test('headerBuilder null 不显示头部', () {
      final options = TPopupOptions(
        child: const SizedBox(),
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
      final options = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.center,
      ).normalized();
      expect(options.usesDefaultClose, isTrue);
    });

    test('center closeBuilder=null 不显示关闭区', () {
      final options = TPopupOptions(
        child: const SizedBox(),
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
        TPopupOptions(
          child: const SizedBox(),
          placement: TPopupPlacement.bottom,
          titleWidget: const Text('x'),
          cancelBuilder: null,
          confirmBuilder: null,
        ).normalized().hasBuiltInHeader,
        isTrue,
      );
      // 仅 cancel 默认（其它 null）
      expect(
        TPopupOptions(
          child: const SizedBox(),
          placement: TPopupPlacement.bottom,
          confirmBuilder: null,
        ).normalized().hasBuiltInHeader,
        isTrue,
      );
      // 完全无头部
      expect(
        TPopupOptions(
          child: const SizedBox(),
          placement: TPopupPlacement.bottom,
          headerBuilder: null,
        ).normalized().hasBuiltInHeader,
        isFalse,
      );
      // 非 bottom 永远 false
      expect(
        TPopupOptions(
          child: const SizedBox(),
          placement: TPopupPlacement.top,
        ).normalized().hasBuiltInHeader,
        isFalse,
      );
    });

    test('assertPlacementParams debug 期对错位字段抛 FlutterError', () {
      // left 不该有 height
      expect(
        () => TPopupOptions(
          child: const SizedBox(),
          placement: TPopupPlacement.left,
          height: 100,
        ).assertPlacementParams(),
        throwsA(isA<FlutterError>()),
      );
      // center 不该有 titleWidget（属于 bottom 头部字段）
      expect(
        () => TPopupOptions(
          child: const SizedBox(),
          placement: TPopupPlacement.center,
          titleWidget: const Text('x'),
        ).assertPlacementParams(),
        throwsA(isA<FlutterError>()),
      );
    });

    test('assertPlacementParams 各 placement 的 margin 越界项也抛错', () {
      expect(
        () => TPopupOptions(
          child: const SizedBox(),
          placement: TPopupPlacement.top,
          margin: const EdgeInsets.only(bottom: 10),
        ).assertPlacementParams(),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => TPopupOptions(
          child: const SizedBox(),
          placement: TPopupPlacement.right,
          margin: const EdgeInsets.only(left: 10),
        ).assertPlacementParams(),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => TPopupOptions(
          child: const SizedBox(),
          placement: TPopupPlacement.center,
          margin: const EdgeInsets.all(10),
        ).assertPlacementParams(),
        throwsA(isA<FlutterError>()),
      );
    });

    test('assertPlacementParams 合法配置不抛错', () {
      // 各 placement 用对应合法字段
      expect(() => TPopupOptions(child: const SizedBox()).assertPlacementParams(),
          returnsNormally);
      expect(
        () => TPopupOptions(
          child: const SizedBox(),
          placement: TPopupPlacement.center,
          width: 200,
          height: 200,
        ).assertPlacementParams(),
        returnsNormally,
      );
      expect(
        () => TPopupOptions(
          child: const SizedBox(),
          placement: TPopupPlacement.left,
          width: 280,
          margin: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
        ).assertPlacementParams(),
        returnsNormally,
      );
    });
  });
}
