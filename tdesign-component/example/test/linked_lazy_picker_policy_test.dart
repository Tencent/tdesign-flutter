import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter_example/page/linked_lazy_picker_policy.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  group('LazyLoadPolicy', () {
    test('向下滚近列底且 hasMore 时应加载', () {
      expect(
        LazyLoadPolicy.shouldLoadAtScrollEnd(
          prevIndexAtScrollEnd: 10,
          indexAtScrollEnd: 14,
          loadedCount: 20,
          threshold: 8,
          hasMore: true,
          loading: false,
          source: LoadTriggerSource.userScroll,
        ),
        isTrue,
      );
    });

    test('向上滚经列底区域时不应加载', () {
      expect(
        LazyLoadPolicy.shouldLoadAtScrollEnd(
          prevIndexAtScrollEnd: 55,
          indexAtScrollEnd: 50,
          loadedCount: 60,
          threshold: 8,
          hasMore: true,
          loading: false,
          source: LoadTriggerSource.userScroll,
        ),
        isFalse,
      );
    });

    test('hasMore=false 时不应加载', () {
      expect(
        LazyLoadPolicy.shouldLoadAtScrollEnd(
          prevIndexAtScrollEnd: 58,
          indexAtScrollEnd: 59,
          loadedCount: 60,
          threshold: 8,
          hasMore: false,
          loading: false,
          source: LoadTriggerSource.userScroll,
        ),
        isFalse,
      );
    });

    test('programmaticRestore 来源不应加载', () {
      expect(
        LazyLoadPolicy.shouldLoadAtScrollEnd(
          prevIndexAtScrollEnd: 0,
          indexAtScrollEnd: 19,
          loadedCount: 20,
          threshold: 8,
          hasMore: true,
          loading: false,
          source: LoadTriggerSource.programmaticRestore,
        ),
        isFalse,
      );
    });
  });

  group('LinkedColumnCache', () {
    test('rememberLinkedSelection 与 resolveLinkedValue', () {
      final cache = LinkedColumnCache(
        initialPrimary: const [
          TPickerOption(label: '分类1', value: 'cat_1'),
        ],
        initialLinked: const [
          TPickerOption(label: '条目1', value: 'item_1'),
          TPickerOption(label: '条目2', value: 'item_2'),
        ],
        initialPrimaryValue: 'cat_1',
      );

      cache.rememberLinkedSelection('cat_1', 'item_2');
      expect(
        cache.resolveLinkedValue('cat_1', cache.linkedFor('cat_1')!.options),
        'item_2',
      );
    });

    test('appendPrimary 更新 hasMore', () {
      final cache = LinkedColumnCache(
        initialPrimary: const [
          TPickerOption(label: '分类1', value: 'cat_1'),
        ],
        initialLinked: const [
          TPickerOption(label: '条目1', value: 'item_1'),
        ],
        initialPrimaryValue: 'cat_1',
        primaryHasMore: true,
      );

      cache.appendPrimary(
        const LazyLoadPage(
          items: [TPickerOption(label: '分类2', value: 'cat_2')],
          hasMore: false,
        ),
      );

      expect(cache.primary.options.length, 2);
      expect(cache.primary.hasMore, isFalse);
    });
  });
}
