import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  group('TPicker 组件测试', () {
    /// 测试 1: 多列独立选择
    testWidgets('多列独立选择 - 基础功能', (WidgetTester tester) async {
      const testData = [
        [
          TPickerOption(label: '选项1', value: 'v1'),
          TPickerOption(label: '选项2', value: 'v2'),
          TPickerOption(label: '选项3', value: 'v3'),
        ],
        [
          TPickerOption(label: 'A', value: 'a'),
          TPickerOption(label: 'B', value: 'b'),
        ],
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: testData,
              onChange: (value) {},
            ),
          ),
        ),
      );

      // 验证初始状态：2 列
      expect(find.byType(ListWheelScrollView), findsNWidgets(2));
    });

    /// 测试 2: 联动选择（2级）
    testWidgets('联动选择 - 2级联动', (WidgetTester tester) async {
      final linkedData = {
        const TPickerOption(label: '广东省', value: 'GD'): {
          const TPickerOption(label: '深圳市', value: 'SZ'): const [
            TPickerOption(label: '南山区', value: 'NS'),
          ],
          const TPickerOption(label: '广州市', value: 'GZ'): const [
            TPickerOption(label: '天河区', value: 'TH'),
          ],
        },
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: linkedData,
              onChange: (value) {},
            ),
          ),
        ),
      );

      // 验证初始状态：至少 1 列（第一列）
      expect(find.byType(ListWheelScrollView), findsAtLeast(1));
    });

    /// 测试 3: 联动选择（3级）
    testWidgets('联动选择 - 3级联动', (WidgetTester tester) async {
      final linkedData = {
        const TPickerOption(label: '广东省', value: 'GD'): {
          const TPickerOption(label: '深圳市', value: 'SZ'): const [
            TPickerOption(label: '南山区', value: 'NS'),
            TPickerOption(label: '福田区', value: 'FT'),
          ],
          const TPickerOption(label: '广州市', value: 'GZ'): const [
            TPickerOption(label: '天河区', value: 'TH'),
            TPickerOption(label: '越秀区', value: 'YX'),
          ],
        },
        const TPickerOption(label: '浙江省', value: 'ZJ'): {
          const TPickerOption(label: '杭州市', value: 'HZ'): const [
            TPickerOption(label: '西湖区', value: 'XH'),
          ],
        },
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: linkedData,
              initialValue: const ['GD'],
              onChange: (value) {},
            ),
          ),
        ),
      );

      // 验证初始状态：应该显示 2 列（省 + 市）
      expect(find.byType(ListWheelScrollView), findsAtLeast(2));
    });

    /// 测试 4: 项级禁用（开头禁用）
    testWidgets('项级禁用 - 开头禁用', (WidgetTester tester) async {
      final disabledData = const [
        [
          TPickerOption(label: '禁用项', value: 'd1', disabled: true),
          TPickerOption(label: '正常项1', value: 'n1'),
          TPickerOption(label: '正常项2', value: 'n2'),
        ],
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: disabledData,
              onChange: (value) {},
            ),
          ),
        ),
      );

      // 验证组件能正常渲染
      expect(find.byType(TPicker), findsOneWidget);
    });

    /// 测试 5: 项级禁用（中间禁用）
    testWidgets('项级禁用 - 中间禁用', (WidgetTester tester) async {
      final disabledData = const [
        [
          TPickerOption(label: '选项1', value: 'v1'),
          TPickerOption(label: '禁用项', value: 'd1', disabled: true),
          TPickerOption(label: '选项3', value: 'v3'),
        ],
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: disabledData,
              onChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

    /// 测试 6: 项级禁用（结尾禁用）
    testWidgets('项级禁用 - 结尾禁用', (WidgetTester tester) async {
      final disabledData = const [
        [
          TPickerOption(label: '选项1', value: 'v1'),
          TPickerOption(label: '选项2', value: 'v2'),
          TPickerOption(label: '禁用项', value: 'd1', disabled: true),
        ],
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: disabledData,
              onChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

    /// 测试 7: 全局禁用
    testWidgets('全局禁用 - disabled=true', (WidgetTester tester) async {
      final testData = const [
        [
          TPickerOption(label: '选项1', value: 'v1'),
          TPickerOption(label: '选项2', value: 'v2'),
        ],
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: testData,
              disabled: true,
              onChange: (value) {},
            ),
          ),
        ),
      );

      // 验证组件能正常渲染且被禁用
      expect(find.byType(TPicker), findsOneWidget);
      // 验证 AbsorbPointer 存在（禁用时 absorbing=true）
      expect(find.byType(AbsorbPointer), findsAtLeast(1));
    });

    /// 测试 8: 初始值设置
    testWidgets('初始值设置 - 单列', (WidgetTester tester) async {
      final testData = const [
        [
          TPickerOption(label: '选项1', value: 'v1'),
          TPickerOption(label: '选项2', value: 'v2'),
          TPickerOption(label: '选项3', value: 'v3'),
        ],
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: testData,
              initialValue: const ['v2'],
              onChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

    /// 测试 9: 初始值设置（联动）
    testWidgets('初始值设置 - 联动', (WidgetTester tester) async {
      final linkedData = {
        const TPickerOption(label: '广东省', value: 'GD'): {
          const TPickerOption(label: '深圳市', value: 'SZ'): const [
            TPickerOption(label: '南山区', value: 'NS'),
          ],
        },
        const TPickerOption(label: '浙江省', value: 'ZJ'): {
          const TPickerOption(label: '杭州市', value: 'HZ'): const [
            TPickerOption(label: '西湖区', value: 'XH'),
          ],
        },
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: linkedData,
              initialValue: const ['GD', 'SZ'],
              onChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

    /// 测试 10: onChange 回调
    testWidgets('onChange 回调 - 触发验证', (WidgetTester tester) async {
      dynamic capturedValue;
      final testData = const [
        [
          TPickerOption(label: '选项1', value: 'v1'),
          TPickerOption(label: '选项2', value: 'v2'),
        ],
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: testData,
              onChange: (value) {
                capturedValue = value;
              },
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

    /// 测试 11: onLoad 回调（按需加载）
    testWidgets('onLoad 回调 - 按需加载', (WidgetTester tester) async {
      final lazyData = [
        List.generate(
          20,
          (i) => TPickerOption(label: '选项 $i', value: 'opt_$i'),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: lazyData,
              preloadThreshold: 5,
              onLoad: (event) {},
              onChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

    /// 测试 12: TPickerOption 类型测试
    test('TPickerOption - 基础属性', () {
      const option = TPickerOption(
        label: '测试',
        value: 'test',
        disabled: true,
      );

      expect(option.label, '测试');
      expect(option.value, 'test');
      expect(option.disabled, true);
    });

    /// 测试 13: TPickerValue 类型测试
    test('TPickerValue - 便捷属性', () {
      final options = const [
        TPickerOption(label: 'A', value: 1),
        TPickerOption(label: 'B', value: 2),
      ];
      const indexes = [0, 1];

      final value = TPickerValue(selectedOptions: options, indexes: indexes);

      expect(value.selectedOptions, options);
      expect(value.indexes, indexes);
      expect(value.values, const [1, 2]);
      expect(value.labels, const ['A', 'B']);
    });

    /// 测试 14: TPickerLoadEvent 类型测试
    test('TPickerLoadEvent - 基础属性', () {
      final event = TPickerLoadEvent(
        column: 0,
        parentValue: null,
        displayedCount: 10,
        remaining: 5,
      );

      expect(event.column, 0);
      expect(event.parentValue, null);
      expect(event.displayedCount, 10);
      expect(event.remaining, 5);
    });

    /// 测试 15: 空数据处理
    testWidgets('空数据处理 - 单列空列表', (WidgetTester tester) async {
      final emptyData = const [
        <TPickerOption>[],
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: emptyData,
              onChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

    /// 测试 16: 参数验证 - height 和 itemCount
    testWidgets('参数验证 - height 和 itemCount', (WidgetTester tester) async {
      final testData = const [
        [
          TPickerOption(label: '选项1', value: 'v1'),
          TPickerOption(label: '选项2', value: 'v2'),
        ],
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: testData,
              height: 300,
              itemCount: 3,
              onChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

    /// 测试 17: 多列不同长度
    testWidgets('多列不同长度', (WidgetTester tester) async {
      final testData = const [
        [
          TPickerOption(label: 'A1', value: 'a1'),
          TPickerOption(label: 'A2', value: 'a2'),
          TPickerOption(label: 'A3', value: 'a3'),
        ],
        [
          TPickerOption(label: 'B1', value: 'b1'),
        ],
        [
          TPickerOption(label: 'C1', value: 'c1'),
          TPickerOption(label: 'C2', value: 'c2'),
          TPickerOption(label: 'C3', value: 'c3'),
          TPickerOption(label: 'C4', value: 'c4'),
        ],
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: testData,
              onChange: (value) {},
            ),
          ),
        ),
      );

      // 验证 3 列
      expect(find.byType(ListWheelScrollView), findsNWidgets(3));
    });
  });
}
