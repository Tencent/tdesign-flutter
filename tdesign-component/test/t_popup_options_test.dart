import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  group('TPopupOptions', () {
    test('默认 placement 为 bottom', () {
      final options = TPopupOptions(child: const SizedBox()).normalized();
      expect(options.placement, TPopupPlacement.bottom);
    });

    test('bottom 默认渲染操作栏', () {
      final options = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.bottom,
      ).normalized();
      expect(options.useActionHeader, isTrue);
      expect(options.showCancelSlot, isTrue);
      expect(options.showConfirmSlot, isTrue);
      expect(options.hasBuiltInHeader, isTrue);
    });

    test('cancel 与 confirm 均为 null 时不渲染操作栏', () {
      final options = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.bottom,
        cancel: null,
        confirm: null,
      ).normalized();
      expect(options.useActionHeader, isFalse);
      expect(options.showCancelSlot, isFalse);
      expect(options.showConfirmSlot, isFalse);
    });

    test('normalized 忽略 bottom 的 closeBuilder', () {
      final options = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.bottom,
        closeBuilder: (_, __) => const Text('x'),
        onCancel: () {},
      ).normalized();
      expect(options.closeBuilder, isNull);
      expect(options.useActionHeader, isTrue);
    });

    test('center 默认 closeBuilder', () {
      final options = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.center,
      ).normalized();
      expect(isPopupDefaultClose(options.closeBuilder), isTrue);
    });

    test('center closeBuilder null 无关闭区', () {
      final options = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.center,
        closeBuilder: null,
      ).normalized();
      expect(options.closeBuilder, isNull);
    });

    test('top 剥离 title 与 headerBuilder', () {
      final options = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.top,
        title: '标题',
        headerBuilder: (_, __) => const Text('h'),
        onCancel: () {},
      ).normalized();
      expect(options.title, isNull);
      expect(options.headerBuilder, isNull);
      expect(options.useActionHeader, isFalse);
      expect(options.hasBuiltInHeader, isFalse);
    });

    test('headerBuilder null 表示无头部', () {
      final options = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.bottom,
        title: '标题',
        headerBuilder: null,
      ).normalized();
      expect(options.hasNoHeader, isTrue);
      expect(options.hasBuiltInHeader, isFalse);
    });

    test('hasBuiltInHeader 识别 title 与 headerBuilder', () {
      expect(
        TPopupOptions(
          child: const SizedBox(),
          placement: TPopupPlacement.bottom,
          title: '标题',
          cancel: null,
          confirm: null,
        ).normalized().hasBuiltInHeader,
        isTrue,
      );
      expect(
        TPopupOptions(
          child: const SizedBox(),
          placement: TPopupPlacement.bottom,
          title: '标题',
        ).normalized().useActionHeader,
        isTrue,
      );
      expect(
        TPopupOptions(
          child: const SizedBox(),
          placement: TPopupPlacement.bottom,
          headerBuilder: (_, __) => const Text('h'),
        ).normalized().hasBuiltInHeader,
        isTrue,
      );
      expect(
        TPopupOptions(
          child: const SizedBox(),
          placement: TPopupPlacement.top,
        ).normalized().hasBuiltInHeader,
        isFalse,
      );
    });

    test('left/right 剥离 closeBuilder 与 onCloseBtn', () {
      final left = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.left,
        closeBuilder: (_, __) => const Text('x'),
        onCloseBtn: () {},
      ).normalized();
      expect(left.closeBuilder, isNull);
      expect(left.onCloseBtn, isNull);
    });

    test('useCustomHeader 为 true 时 hasBuiltInHeader', () {
      final options = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.bottom,
        headerBuilder: (_, __) => const SizedBox(),
      ).normalized();
      expect(options.useCustomHeader, isTrue);
      expect(options.hasBuiltInHeader, isTrue);
    });

    test('assertPlacementParams 非 bottom 带 cancel 槽位提示', () {
      final options = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.center,
        cancel: kPopupActionDefault,
        confirm: kPopupActionDefault,
      );
      expect(() => options.assertPlacementParams(), returnsNormally);
    });

    test('assertPlacementParams 在 debug 模式不抛错', () {
      final options = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.left,
        height: 100,
        width: 200,
      ).normalized();
      expect(() => options.assertPlacementParams(), returnsNormally);
    });
  });
}
