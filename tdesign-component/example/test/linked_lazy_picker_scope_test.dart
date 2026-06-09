import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/linked_lazy_picker_policy.dart';
import 'package:tdesign_flutter_example/page/linked_lazy_picker_scope.dart';

void main() {
  group('LinkedLazyPickerScope', () {
    testWidgets('向下滚近列底触发加载，向上滚不显示 loading', (tester) async {
      var linkedLoadCount = 0;
      String? lastHint;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LinkedLazyPickerScope(
              threshold: 3,
              primaryLabel: '分类',
              linkedLabel: '条目',
              initialPrimary: [
                for (var i = 1; i <= 10; i++)
                  TPickerOption(label: '分类$i', value: 'cat_$i'),
              ],
              initialPrimaryValue: 'cat_1',
              initialLinked: [
                for (var i = 1; i <= 10; i++)
                  TPickerOption(
                    label: '条目$i',
                    value: 'cat_1_item_$i',
                  ),
              ],
              initialPrimaryHasMore: false,
              initialLinkedHasMore: true,
              onLoadPrimary: (_) async =>
                  const LazyLoadPage(items: [], hasMore: false),
              onLoadLinked: (primaryValue, nextStart) async {
                linkedLoadCount++;
                return LazyLoadPage(
                  items: [
                    for (var i = nextStart; i < nextStart + 5; i++)
                      TPickerOption(
                        label: '条目$i',
                        value: '${primaryValue}_item_$i',
                      ),
                  ],
                  hasMore: nextStart + 5 <= 20,
                );
              },
              builder: (context, vm) {
                lastHint = vm.loadingHint;
                return Column(
                  children: [
                    Text('hint:${vm.loadingHint ?? ''}'),
                    Text('linked:${vm.linkedOptions.length}'),
                    SizedBox(
                      height: 220,
                      child: vm.buildPicker(),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final wheels = find.byType(ListWheelScrollView);

      // 子列向下滚近底部（10 项、threshold=3 时 index≥7 触发）
      await tester.drag(wheels.at(1), const Offset(0, -320));
      await tester.pumpAndSettle();
      expect(linkedLoadCount, greaterThanOrEqualTo(1));

      // 向上滚：loading 结束且不应长期显示「条目」加载提示
      await tester.drag(wheels.at(1), const Offset(0, 160));
      await tester.pumpAndSettle();
      expect(lastHint, isNull);

      final loadsBefore = linkedLoadCount;
      await tester.drag(wheels.at(1), const Offset(0, 120));
      await tester.pumpAndSettle();
      expect(linkedLoadCount, loadsBefore);
    });

    testWidgets('切换分类后恢复上次子列选中', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LinkedLazyPickerScope(
              threshold: 5,
              initialPrimary: [
                for (var i = 1; i <= 5; i++)
                  TPickerOption(label: '分类$i', value: 'cat_$i'),
              ],
              initialPrimaryValue: 'cat_1',
              initialLinked: [
                for (var i = 1; i <= 5; i++)
                  TPickerOption(
                    label: 'A$i',
                    value: 'cat_1_item_$i',
                  ),
              ],
              onLoadPrimary: (_) async => const LazyLoadPage(items: []),
              onLoadLinked: (primaryValue, nextStart) async {
                return LazyLoadPage(
                  items: [
                    for (var i = 1; i <= 5; i++)
                      TPickerOption(
                        label: '${primaryValue}_$i',
                        value: '${primaryValue}_item_$i',
                      ),
                  ],
                  hasMore: false,
                );
              },
              builder: (context, vm) {
                return SizedBox(
                  height: 220,
                  child: vm.buildPicker(),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final wheels = find.byType(ListWheelScrollView);

      // 子列滚到第 3 项
      await tester.drag(wheels.at(1), const Offset(0, -80));
      await tester.pumpAndSettle();

      // 主列切到 cat_2（触发子列加载）
      await tester.drag(wheels.at(0), const Offset(0, -40));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      // 主列切回 cat_1
      await tester.drag(wheels.at(0), const Offset(0, 40));
      await tester.pumpAndSettle();

      // 子列应恢复为 A3
      expect(find.text('A3'), findsOneWidget);
    });
  });
}
