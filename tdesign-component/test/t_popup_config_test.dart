import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/popup/t_popup_config.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  group('TPopupConfig', () {
    test('create 默认 placement 为 bottom', () {
      final config = TPopupConfig.create(child: const SizedBox());
      expect(config.placement, TPopupPlacement.bottom);
    });

    test('bottom 默认渲染操作栏', () {
      final config = TPopupConfig.create(
        child: const SizedBox(),
        placement: TPopupPlacement.bottom,
      );
      expect(config.useActionHeader, isTrue);
      expect(config.showCancelSlot, isTrue);
      expect(config.showConfirmSlot, isTrue);
      expect(config.hasBuiltInHeader, isTrue);
    });

    test('cancel 与 confirm 均为 null 时不渲染操作栏', () {
      final config = TPopupConfig.create(
        child: const SizedBox(),
        placement: TPopupPlacement.bottom,
        cancel: null,
        confirm: null,
      );
      expect(config.useActionHeader, isFalse);
      expect(config.showCancelSlot, isFalse);
      expect(config.showConfirmSlot, isFalse);
    });

    test('create 忽略 bottom 的 closeBuilder', () {
      final config = TPopupConfig.create(
        child: const SizedBox(),
        placement: TPopupPlacement.bottom,
        closeBuilder: (_, __) => const Text('x'),
        onCancel: () {},
      );
      expect(config.closeBuilder, isNull);
      expect(config.useActionHeader, isTrue);
    });

    test('create center 默认 closeBuilder', () {
      final config = TPopupConfig.create(
        child: const SizedBox(),
        placement: TPopupPlacement.center,
      );
      expect(isPopupDefaultClose(config.closeBuilder), isTrue);
    });

    test('create center closeBuilder null 无关闭区', () {
      final config = TPopupConfig.create(
        child: const SizedBox(),
        placement: TPopupPlacement.center,
        closeBuilder: null,
      );
      expect(config.closeBuilder, isNull);
    });

    test('create top 剥离 title 与 headerBuilder', () {
      final config = TPopupConfig.create(
        child: const SizedBox(),
        placement: TPopupPlacement.top,
        title: '标题',
        headerBuilder: (_, __) => const Text('h'),
        onCancel: () {},
      );
      expect(config.title, isNull);
      expect(config.headerBuilder, isNull);
      expect(config.useActionHeader, isFalse);
      expect(config.hasBuiltInHeader, isFalse);
    });

    test('headerBuilder null 表示无头部', () {
      final config = TPopupConfig.create(
        child: const SizedBox(),
        placement: TPopupPlacement.bottom,
        title: '标题',
        headerBuilder: null,
      );
      expect(config.hasNoHeader, isTrue);
      expect(config.hasBuiltInHeader, isFalse);
    });

    test('hasBuiltInHeader 识别 title 与 headerBuilder', () {
      expect(
        TPopupConfig.create(
          child: const SizedBox(),
          placement: TPopupPlacement.bottom,
          title: '标题',
          cancel: null,
          confirm: null,
        ).hasBuiltInHeader,
        isTrue,
      );
      expect(
        TPopupConfig.create(
          child: const SizedBox(),
          placement: TPopupPlacement.bottom,
          title: '标题',
        ).useActionHeader,
        isTrue,
      );
      expect(
        TPopupConfig.create(
          child: const SizedBox(),
          placement: TPopupPlacement.bottom,
          headerBuilder: (_, __) => const Text('h'),
        ).hasBuiltInHeader,
        isTrue,
      );
      expect(
        TPopupConfig.create(
          child: const SizedBox(),
          placement: TPopupPlacement.top,
        ).hasBuiltInHeader,
        isFalse,
      );
    });

    test('left/right 剥离 closeBuilder 与 onCloseBtn', () {
      final left = TPopupConfig.create(
        child: const SizedBox(),
        placement: TPopupPlacement.left,
        closeBuilder: (_, __) => const Text('x'),
        onCloseBtn: () {},
      );
      expect(left.closeBuilder, isNull);
      expect(left.onCloseBtn, isNull);
    });

    test('useCustomHeader 为 true 时 hasBuiltInHeader', () {
      final config = TPopupConfig.create(
        child: const SizedBox(),
        placement: TPopupPlacement.bottom,
        headerBuilder: (_, __) => const SizedBox(),
      );
      expect(config.useCustomHeader, isTrue);
      expect(config.hasBuiltInHeader, isTrue);
    });

    test('assertPlacementParams 非 bottom 带 cancel 槽位提示', () {
      final config = TPopupConfig(
        child: const SizedBox(),
        placement: TPopupPlacement.center,
        cancel: kPopupActionDefault,
        confirm: kPopupActionDefault,
      );
      expect(() => config.assertPlacementParams(), returnsNormally);
    });

    test('assertPlacementParams 在 debug 模式不抛错', () {
      final config = TPopupConfig.create(
        child: const SizedBox(),
        placement: TPopupPlacement.left,
        height: 100,
        width: 200,
      );
      expect(() => config.assertPlacementParams(), returnsNormally);
    });
  });
}
