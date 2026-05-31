import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/picker/t_picker_normalize.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  group('TPicker 组件测试', () {
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
              items: const TPickerColumns(testData),
              onChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(ListWheelScrollView), findsNWidgets(2));
    });

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
              items: TPickerLinked(linkedData),
              onChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(ListWheelScrollView), findsAtLeast(1));
    });

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
              items: TPickerLinked(linkedData),
              initialValue: const ['GD'],
              onChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(ListWheelScrollView), findsAtLeast(2));
    });

    testWidgets('项级禁用 - 开头禁用', (WidgetTester tester) async {
      const disabledData = [
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
              items: const TPickerColumns(disabledData),
              onChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

    testWidgets('项级禁用 - 中间禁用', (WidgetTester tester) async {
      const disabledData = [
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
              items: const TPickerColumns(disabledData),
              onChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

    testWidgets('项级禁用 - 结尾禁用', (WidgetTester tester) async {
      const disabledData = [
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
              items: const TPickerColumns(disabledData),
              onChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

    testWidgets('全局禁用 - disabled=true', (WidgetTester tester) async {
      const testData = [
        [
          TPickerOption(label: '选项1', value: 'v1'),
          TPickerOption(label: '选项2', value: 'v2'),
        ],
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: const TPickerColumns(testData),
              disabled: true,
              onChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
      expect(find.byType(AbsorbPointer), findsAtLeast(1));
    });

    testWidgets('初始值设置 - 单列', (WidgetTester tester) async {
      const testData = [
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
              items: const TPickerColumns(testData),
              initialValue: const ['v2'],
              onChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

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
              items: TPickerLinked(linkedData),
              initialValue: const ['GD', 'SZ'],
              onChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

    testWidgets('onChange 回调 - 触发验证', (WidgetTester tester) async {
      const testData = [
        [
          TPickerOption(label: '选项1', value: 'v1'),
          TPickerOption(label: '选项2', value: 'v2'),
        ],
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: const TPickerColumns(testData),
              onChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

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

    test('TPickerValue - 便捷属性', () {
      const options = [
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

    testWidgets('空数据处理 - 单列空列表', (WidgetTester tester) async {
      const emptyData = [
        <TPickerOption>[],
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: const TPickerColumns(emptyData),
              onChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

    testWidgets('参数验证 - height 和 itemCount', (WidgetTester tester) async {
      const testData = [
        [
          TPickerOption(label: '选项1', value: 'v1'),
          TPickerOption(label: '选项2', value: 'v2'),
        ],
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: const TPickerColumns(testData),
              height: 300,
              itemCount: 3,
              onChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

    testWidgets('多列不同长度', (WidgetTester tester) async {
      const testData = [
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
              items: const TPickerColumns(testData),
              onChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(ListWheelScrollView), findsNWidgets(3));
    });

    testWidgets('初始值非首项 - onChange 返回正确值（多列独立）', (WidgetTester tester) async {
      TPickerValue? captured;
      const testData = [
        [
          TPickerOption(label: 'A1', value: 'a1'),
          TPickerOption(label: 'A2', value: 'a2'),
          TPickerOption(label: 'A3', value: 'a3'),
        ],
        [
          TPickerOption(label: 'B1', value: 'b1'),
          TPickerOption(label: 'B2', value: 'b2'),
        ],
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: const TPickerColumns(testData),
              initialValue: const ['a3', 'b2'],
              onChange: (v) => captured = v,
            ),
          ),
        ),
      );

      await tester.drag(
        find.byType(ListWheelScrollView).first,
        const Offset(0, 40), // 向下拖 = 选中项上移
      );
      await tester.pumpAndSettle();

      expect(captured, isNotNull);
      expect(captured!.values[1], 'b2',
          reason: '第二列应保持初始选中的 b2，若为 b1 说明 _correctedIndex 污染了结果');
      expect(captured!.labels[1], 'B2');
    });

    testWidgets('初始值非首项 - 联动模式 onChange 返回正确值', (WidgetTester tester) async {
      TPickerValue? captured;
      final linkedData = {
        const TPickerOption(label: '广东省', value: 'GD'): {
          const TPickerOption(label: '深圳市', value: 'SZ'): const [
            TPickerOption(label: '南山区', value: 'NS'),
            TPickerOption(label: '福田区', value: 'FT'),
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
              items: TPickerLinked(linkedData),
              initialValue: const ['ZJ', 'HZ', 'XH'],
              onChange: (v) => captured = v,
            ),
          ),
        ),
      );

      await tester.drag(
        find.byType(ListWheelScrollView).first,
        const Offset(0, 40), // 向下滚回 GD
      );
      await tester.pumpAndSettle();

      expect(captured, isNotNull);
      expect(captured!.values[0], 'GD');
      expect(captured!.values[1], 'SZ');
    });

    testWidgets('disabled 项修正 - 独立模式滚动不会 crash', (WidgetTester tester) async {
      TPickerValue? captured;
      const testData = [
        [
          TPickerOption(label: 'A1', value: 'a1'),
          TPickerOption(label: 'A2', value: 'a2', disabled: true),
          TPickerOption(label: 'A3', value: 'a3'),
        ],
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: const TPickerColumns(testData),
              onChange: (v) => captured = v,
            ),
          ),
        ),
      );

      await tester.drag(
        find.byType(ListWheelScrollView),
        const Offset(0, -40),
      );
      await tester.pumpAndSettle();

      if (captured != null) {
        expect(captured!.values[0], isNot('a2'));
        expect(captured!.selectedOptions[0].disabled, false);
      }
    });

    testWidgets('didUpdateWidget - items 变化触发重建', (WidgetTester tester) async {
      const testData1 = [
        [TPickerOption(label: 'A', value: 'a')],
      ];
      const testData2 = [
        [TPickerOption(label: 'B', value: 'b')],
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: const TPickerColumns(testData1),
              onChange: (v) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: const TPickerColumns(testData2),
              onChange: (v) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

    testWidgets('didUpdateWidget - items 变化触发重建', (WidgetTester tester) async {
      const testData = [
        [
          TPickerOption(label: 'A', value: 'a'),
          TPickerOption(label: 'B', value: 'b'),
        ],
      ];
      const testData2 = [
        [
          TPickerOption(label: 'X', value: 'x'),
          TPickerOption(label: 'Y', value: 'y'),
        ],
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: const TPickerColumns(testData),
              onChange: (v) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: const TPickerColumns(testData2),
              onChange: (v) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

    testWidgets('didUpdateWidget - initialValue 变化触发重建',
        (WidgetTester tester) async {
      const testData = [
        [
          TPickerOption(label: 'A', value: 'a'),
          TPickerOption(label: 'B', value: 'b'),
          TPickerOption(label: 'C', value: 'c'),
        ],
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: const TPickerColumns(testData),
              initialValue: const ['a'],
              onChange: (v) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: const TPickerColumns(testData),
              initialValue: const ['c'],
              onChange: (v) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

    testWidgets('联动模式 - 列数变化后能恢复', (WidgetTester tester) async {
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
        const TPickerOption(label: '重庆市', value: 'CQ'): const [
          TPickerOption(label: '渝中区', value: 'YZ'),
          TPickerOption(label: '江北区', value: 'JB'),
        ],
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: TPickerLinked(linkedData),
              initialValue: const ['GD', 'SZ', 'NS'],
              onChange: (v) {},
            ),
          ),
        ),
      );

      expect(find.byType(ListWheelScrollView), findsNWidgets(3));

      await tester.drag(
        find.byType(ListWheelScrollView).first,
        const Offset(0, -120), // 向下滚到 CQ
      );
      await tester.pumpAndSettle();

      expect(find.byType(ListWheelScrollView), findsNWidgets(2));

      await tester.drag(
        find.byType(ListWheelScrollView).first,
        const Offset(0, 120), // 向上滚回 GD
      );
      await tester.pumpAndSettle();

      expect(find.byType(ListWheelScrollView), findsNWidgets(3));
    });

    testWidgets('联动模式 - 6级切换第1级后下游列全部换新并重置首项',
        (WidgetTester tester) async {
      TPickerValue? captured;

      dynamic sixLevelNode(int depth, [String codePrefix = '']) {
        if (depth == 6) {
          return [
            for (int i = 1; i <= 2; i++)
              TPickerOption(
                label: '$codePrefix.$i',
                value: '$codePrefix.$i',
              ),
          ];
        }
        return {
          for (int i = 1; i <= 2; i++)
            TPickerOption(
              label: codePrefix.isEmpty ? '$i' : '$codePrefix.$i',
              value: codePrefix.isEmpty ? '$i' : '$codePrefix.$i',
            ): sixLevelNode(
                depth + 1, codePrefix.isEmpty ? '$i' : '$codePrefix.$i'),
        };
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: TPickerLinked(sixLevelNode(1)),
              initialValue: const [
                '1',
                '1.1',
                '1.1.1',
                '1.1.1.1',
                '1.1.1.1.1',
                '1.1.1.1.1.1',
              ],
              onChange: (v) => captured = v,
            ),
          ),
        ),
      );

      expect(find.byType(ListWheelScrollView), findsNWidgets(6));

      await tester.drag(
        find.byType(ListWheelScrollView).first,
        const Offset(0, -40), // 第 1 级切换到 2
      );
      await tester.pumpAndSettle();

      expect(find.byType(ListWheelScrollView), findsNWidgets(6));
      expect(captured, isNotNull);
      expect(captured!.values[0], '2');
      expect(captured!.values[1], '2.1');
      expect(captured!.values[2], '2.1.1');
      expect(captured!.values[3], '2.1.1.1');
      expect(captured!.values[4], '2.1.1.1.1');
      expect(captured!.values[5], '2.1.1.1.1.1');
      expect(captured!.indexes, const [1, 0, 0, 0, 0, 0]);
    });

    testWidgets('联动模式 - 滚动后新列选中首项', (WidgetTester tester) async {
      TPickerValue? captured;
      final linkedData = {
        const TPickerOption(label: '广东省', value: 'GD'): {
          const TPickerOption(label: '深圳市', value: 'SZ'): const [
            TPickerOption(label: '南山区', value: 'NS'),
            TPickerOption(label: '福田区', value: 'FT'),
            TPickerOption(label: '罗湖区', value: 'LL'),
          ],
          const TPickerOption(label: '广州市', value: 'GZ'):
              const <TPickerOption>[],
        },
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: TPickerLinked(linkedData),
              initialValue: const ['GD', 'SZ', 'FT'],
              onChange: (v) => captured = v,
            ),
          ),
        ),
      );

      expect(find.byType(ListWheelScrollView), findsNWidgets(3));

      await tester.drag(find.byType(ListWheelScrollView).at(1),
          const Offset(0, -120)); // 向下滚到 GZ
      await tester.pumpAndSettle();

      expect(find.byType(ListWheelScrollView), findsNWidgets(2));

      await tester.drag(find.byType(ListWheelScrollView).at(1),
          const Offset(0, 120)); // 向上滚回 SZ
      await tester.pumpAndSettle();

      expect(find.byType(ListWheelScrollView), findsNWidgets(3));

      expect(captured, isNotNull);
      expect(captured!.values[2], 'NS');
    });

    test('TPickerKeys - 默认值和自定义值', () {
      expect(TPickerKeys.defaults.label, 'label');
      expect(TPickerKeys.defaults.value, 'value');
      expect(TPickerKeys.defaults.disabled, 'disabled');
      expect(TPickerKeys.defaults.children, 'children');

      const custom = TPickerKeys(
        label: 'name',
        value: 'id',
        disabled: 'isDisabled',
        children: 'subItems',
      );
      expect(custom.label, 'name');
      expect(custom.value, 'id');
      expect(custom.disabled, 'isDisabled');
      expect(custom.children, 'subItems');
    });

    test('TPickerKeys - 等值比较和 hashCode', () {
      const a = TPickerKeys.defaults;
      const b = TPickerKeys.defaults;
      const c = TPickerKeys(label: 'name');

      expect(identical(a, b), true);
      expect(a == b, true);
      expect(a.hashCode, b.hashCode);
      expect(a == c, false);
      expect(a.hashCode, isNot(c.hashCode));
    });

    test('TPickerKeys - toString', () {
      const keys = TPickerKeys(label: 'name', value: 'id');
      final str = keys.toString();
      expect(str, contains('name'));
      expect(str, contains('id'));
    });

    test('TPickerOption - 等值比较和 hashCode', () {
      const a = TPickerOption(label: 'A', value: 'v1');
      const b = TPickerOption(label: 'A', value: 'v1');
      const c = TPickerOption(label: 'B', value: 'v1');

      expect(identical(a, b), true);
      expect(a == b, true);
      expect(a.hashCode, b.hashCode);
      expect(a == c, false);
      expect(a.hashCode, isNot(c.hashCode));
    });

    test('TPickerOption - toString', () {
      const opt = TPickerOption(label: '测试', value: 'test');
      final str = opt.toString();
      expect(str, contains('测试'));
      expect(str, contains('test'));
    });

    test('TPickerValue - toString', () {
      const options = [
        TPickerOption(label: 'A', value: 1),
        TPickerOption(label: 'B', value: 2),
      ];
      const indexes = [0, 1];
      final value = TPickerValue(selectedOptions: options, indexes: indexes);

      final str = value.toString();
      expect(str, contains('A'));
      expect(str, contains('B'));
      expect(str, contains('1'));
      expect(str, contains('2'));
    });

    test('TPickerNormalize - 已是 List<List<TPickerOption>>', () {
      const input = [
        [TPickerOption(label: 'A', value: 'a')],
        [TPickerOption(label: 'B', value: 'b')],
      ];
      final result =
          TPickerNormalize.normalizeColumns(input, TPickerKeys.defaults);
      expect(identical(result, input), true);
    });

    test('TPickerNormalize - 已是 Map<TPickerOption, dynamic>', () {
      final input = <TPickerOption, dynamic>{
        const TPickerOption(label: 'A', value: 'a'): null,
      };
      final result =
          TPickerNormalize.normalizeLinked(input, TPickerKeys.defaults);
      expect(identical(result, input), true);
    });

    test('TPickerNormalize - List of List 归一化', () {
      final input = [
        [
          {'label': 'A', 'value': 'a'},
          {'label': 'B', 'value': 'b'},
        ],
        [
          {'label': 'C', 'value': 'c'},
        ],
      ];
      final result =
          TPickerNormalize.normalizeColumns(input, TPickerKeys.defaults);
      expect(result, isA<List<List<TPickerOption>>>());
      expect(result.length, 2);
      expect(result[0].length, 2);
      expect(result[1].length, 1);
    });

    test('TPickerNormalize - Map 归一化', () {
      final input = <String, dynamic>{
        'GD': <String, dynamic>{
          'SZ': [
            {'label': '南山区', 'value': 'NS'},
          ],
        },
      };
      final result = TPickerNormalize.normalizeLinked(
          input, const TPickerKeys(label: 'label', value: 'value'));
      expect(result, isA<Map<TPickerOption, dynamic>>());
    });

    test('TPickerNormalize - Map with disabled 字段', () {
      final input = <String, dynamic>{
        'A': <String, dynamic>{
          'B': [
            {'label': '选项1', 'value': 'v1'},
            {'label': '选项2', 'value': 'v2', 'disabled': true},
            {'label': '选项3', 'value': 'v3'},
          ],
        },
      };
      final result =
          TPickerNormalize.normalizeLinked(input, TPickerKeys.defaults);
      expect(result, isA<Map<TPickerOption, dynamic>>());

      final keyA = result.keys.first;
      expect(keyA.value, 'A');
      final valueA = result[keyA];
      expect(valueA, isA<Map<TPickerOption, dynamic>>());

      final mapB = valueA as Map<TPickerOption, dynamic>;
      final keyB = mapB.keys.first;
      expect(keyB.value, 'B');
      final opts = mapB[keyB] as List<TPickerOption>;
      expect(opts[0].disabled, false);
      expect(opts[1].disabled, true);
      expect(opts[2].disabled, false);
    });

    testWidgets('TItemWidget - itemBuilder 回调', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: const TPickerColumns([
                [
                  TPickerOption(label: '选项1', value: 'v1'),
                  TPickerOption(label: '选项2', value: 'v2'),
                ],
              ]),
              itemBuilder: (context, content, colIndex, index, calc, distance) {
                return Container(
                  padding: const EdgeInsets.all(4),
                  child: Text(content),
                );
              },
              onChange: (v) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

    testWidgets('disabled 项修正 - 正向查找最近 enabled', (WidgetTester tester) async {
      TPickerValue? captured;
      const testData = [
        [
          TPickerOption(label: 'A1', value: 'a1'),
          TPickerOption(label: 'A2', value: 'a2', disabled: true),
          TPickerOption(label: 'A3', value: 'a3'),
        ],
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: const TPickerColumns(testData),
              onChange: (v) => captured = v,
            ),
          ),
        ),
      );

      await tester.drag(
        find.byType(ListWheelScrollView),
        const Offset(0, -80), // 向下滚过 a2
      );
      await tester.pumpAndSettle();

      if (captured != null) {
        expect(captured!.values[0], isNot('a2'));
      }
    });

    testWidgets('disabled 项修正 - 反向查找最近 enabled', (WidgetTester tester) async {
      TPickerValue? captured;
      const testData = [
        [
          TPickerOption(label: 'A1', value: 'a1'),
          TPickerOption(label: 'A2', value: 'a2', disabled: true),
          TPickerOption(label: 'A3', value: 'a3'),
        ],
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: const TPickerColumns(testData),
              onChange: (v) => captured = v,
            ),
          ),
        ),
      );

      await tester.drag(
        find.byType(ListWheelScrollView),
        const Offset(0, 80), // 向上滚过 a2
      );
      await tester.pumpAndSettle();

      if (captured != null) {
        expect(captured!.values[0], isNot('a2'));
      }
    });

    test('TPickerNormalize - 纯字符串列表归一化', () {
      final input = [
        ['北京', '上海', '广州'],
        ['朝阳区', '浦东'],
      ];
      final result =
          TPickerNormalize.normalizeColumns(input, TPickerKeys.defaults);
      expect(result, isA<List<List<TPickerOption>>>());
      expect(result[0][0].label, '北京');
      expect(result[0][0].value, '北京'); // 纯字符串时 value == label
      expect(result[1][1].label, '浦东');
    });

    test('TPickerNormalize - 空列表归一化', () {
      final result =
          TPickerNormalize.normalizeColumns([], TPickerKeys.defaults);
      expect(result, isA<List<List<TPickerOption>>>());
      expect(result.isEmpty, true);
    });

    test('TPickerNormalize - 空 Map 归一化', () {
      final result = TPickerNormalize.normalizeLinked(
          <String, dynamic>{}, TPickerKeys.defaults);
      expect(result, isA<Map<TPickerOption, dynamic>>());
      expect(result.isEmpty, true);
    });

    test('TPickerNormalize - List 中包含非 List 元素得到空列', () {
      final input = [
        'not_a_list',
        ['A', 'B']
      ];
      final result =
          TPickerNormalize.normalizeColumns(input, TPickerKeys.defaults);
      expect(result, isA<List<List<TPickerOption>>>());
      expect(result[0], isEmpty); // 非 List 元素归一化为空列
      expect(result[1].length, 2);
    });

    test('TPickerNormalize - 自定义 keys 映射', () {
      final input = [
        [
          {'name': '深圳', 'code': 'SZ', 'readonly': true},
          {'name': '广州', 'code': 'GZ'},
        ],
      ];
      const keys =
          TPickerKeys(label: 'name', value: 'code', disabled: 'readonly');
      final result = TPickerNormalize.normalizeColumns(input, keys);
      expect(result[0][0].label, '深圳');
      expect(result[0][0].value, 'SZ');
      expect(result[0][0].disabled, true);
      expect(result[0][1].disabled, false);
    });

    test('TPickerNormalize - 联动 Map 含叶子 List', () {
      final input = <String, dynamic>{
        'A': ['X', 'Y'],
      };
      final result =
          TPickerNormalize.normalizeLinked(input, TPickerKeys.defaults);
      expect(result, isA<Map<TPickerOption, dynamic>>());
      final keyA = result.keys.first;
      expect(keyA.label, 'A');
      expect(keyA.value, 'A');
      final children = result[keyA] as List<TPickerOption>;
      expect(children.length, 2);
      expect(children[0].label, 'X');
    });

    test('TPickerNormalize - 联动 Map 中 child 为非法类型', () {
      final input = <String, dynamic>{
        'A': 12345, // 既不是 Map 也不是 List
      };
      final result =
          TPickerNormalize.normalizeLinked(input, TPickerKeys.defaults);
      final child = result[result.keys.first];
      expect(child, isA<List<TPickerOption>>());
      expect((child as List).isEmpty, true);
    });

    test('TPickerNormalize - raw 为 TPickerOption 直通', () {
      final input = [
        [
          const TPickerOption(label: 'X', value: 'x'),
          {'label': 'Y', 'value': 'y'},
        ],
      ];
      final result =
          TPickerNormalize.normalizeColumns(input, TPickerKeys.defaults);
      expect(result[0][0].label, 'X');
      expect(result[0][1].label, 'Y');
    });

    test('TPickerNormalize - Map raw key 为 null', () {
      final input = <dynamic, dynamic>{
        null: ['child1'],
      };
      final result =
          TPickerNormalize.normalizeLinked(input, TPickerKeys.defaults);
      final key = result.keys.first;
      expect(key.label, '');
      expect(key.value, null);
    });

    test('TPickerOption - disabled 不同则不相等', () {
      const a = TPickerOption(label: 'A', value: 'v1', disabled: false);
      const b = TPickerOption(label: 'A', value: 'v1', disabled: true);
      expect(a == b, false);
      expect(a.hashCode, isNot(b.hashCode));
    });

    test('TPickerOption - value 为 int 类型', () {
      const opt = TPickerOption(label: '选项', value: 42);
      expect(opt.value, 42);
      expect(opt.toString(), contains('42'));
    });

    test('TPickerValue - 空选项列表', () {
      final value = TPickerValue(selectedOptions: const [], indexes: const []);
      expect(value.values, isEmpty);
      expect(value.labels, isEmpty);
      expect(value.toString(), contains('[]'));
    });

    test('TPickerKeys - children 字段完整性', () {
      const keys = TPickerKeys(children: 'subItems');
      expect(keys.children, 'subItems');
      expect(keys.toString(), contains('subItems'));
      expect(keys == const TPickerKeys(children: 'subItems'), true);
      expect(keys == const TPickerKeys(children: 'other'), false);
    });

    test('TPickerValue - toString 完整', () {
      final value = TPickerValue(
        selectedOptions: const [
          TPickerOption(label: '广东', value: 'GD'),
          TPickerOption(label: '深圳', value: 'SZ'),
        ],
        indexes: const [0, 1],
      );
      final str = value.toString();
      expect(str, contains('广东'));
      expect(str, contains('深圳'));
      expect(str, contains('GD'));
      expect(str, contains('SZ'));
      expect(str, contains('0'));
      expect(str, contains('1'));
    });

    test('TPickerColumns.fromRaw / TPickerLinked.fromRaw 工厂方法', () {
      final columns = TPickerColumns.fromRaw(const [
        ['北京', '上海'],
        ['朝阳', '浦东'],
      ]);
      expect(columns.columns.length, 2);
      expect(columns.columns[0][0].label, '北京');

      final linked = TPickerLinked.fromRaw(const {
        '广东': {
          '深圳': ['南山']
        },
      });
      expect(linked.tree.keys.first.label, '广东');
    });

    test('TPickerKeys - 值相同的不同实例 hashCode 一致', () {
      const a =
          TPickerKeys(label: 'x', value: 'y', disabled: 'd', children: 'c');
      const b =
          TPickerKeys(label: 'x', value: 'y', disabled: 'd', children: 'c');
      expect(a == b, true);
      expect(a.hashCode, b.hashCode);
    });

    test('TPickerOption - value 为 null', () {
      const opt = TPickerOption(label: '空值', value: null);
      expect(opt.value, isNull);
      expect(opt.toString(), contains('null'));
    });

    testWidgets('回归 - setState 新建等值 TPickerColumns 不重置选择器',
        (WidgetTester tester) async {
      const testData = [
        [
          TPickerOption(label: '选项1', value: 'v1'),
          TPickerOption(label: '选项2', value: 'v2'),
          TPickerOption(label: '选项3', value: 'v3'),
          TPickerOption(label: '选项4', value: 'v4'),
          TPickerOption(label: '选项5', value: 'v5'),
        ],
      ];

      var selected = 'v1';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Text('selected: $selected'),
                    TPicker(
                      items: const TPickerColumns(testData),
                      onChange: (v) =>
                          setState(() => selected = v.values.first as String),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('selected: v1'), findsOneWidget);

      await tester.drag(
        find.byType(ListWheelScrollView),
        const Offset(0, -40),
      );
      await tester.pumpAndSettle();

      expect(find.text('selected: v2'), findsOneWidget);

      await tester.drag(
        find.byType(ListWheelScrollView),
        const Offset(0, -40),
      );
      await tester.pumpAndSettle();

      expect(find.text('selected: v3'), findsOneWidget);
    });

    testWidgets('回归 - setState 新建等值 TPickerLinked 不重置联动选择器',
        (WidgetTester tester) async {
      final linkedData = <TPickerOption, dynamic>{
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
      };

      var selected = '广东省 / 深圳市 / 南山区';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Text('selected: $selected'),
                    TPicker(
                      items: TPickerLinked(linkedData),
                      initialValue: const ['GD', 'SZ', 'NS'],
                      onChange: (v) =>
                          setState(() => selected = v.labels.join(' / ')),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('selected: 广东省 / 深圳市 / 南山区'), findsOneWidget);
      expect(find.byType(ListWheelScrollView), findsNWidgets(3));

      await tester.drag(
        find.byType(ListWheelScrollView).at(1),
        const Offset(0, -40),
      );
      await tester.pumpAndSettle();

      expect(selected, contains('广州市'));
      expect(selected, contains('天河区'));
    });

    test('TPickerColumns - 相同数据的不同实例应相等', () {
      const a = TPickerColumns([
        [TPickerOption(label: 'A', value: 'a')],
        [TPickerOption(label: 'B', value: 'b')],
      ]);
      const b = TPickerColumns([
        [TPickerOption(label: 'A', value: 'a')],
        [TPickerOption(label: 'B', value: 'b')],
      ]);
      const c = TPickerColumns([
        [TPickerOption(label: 'A', value: 'a')],
        [TPickerOption(label: 'C', value: 'c')],
      ]);

      expect(a == b, true);
      expect(a.hashCode, b.hashCode);
      expect(a == c, false);
    });

    test('TPickerLinked - 相同数据的不同实例应相等', () {
      final a = TPickerLinked({
        const TPickerOption(label: '广东', value: 'GD'): const [
          TPickerOption(label: '深圳', value: 'SZ'),
        ],
      });
      final b = TPickerLinked({
        const TPickerOption(label: '广东', value: 'GD'): const [
          TPickerOption(label: '深圳', value: 'SZ'),
        ],
      });
      final c = TPickerLinked({
        const TPickerOption(label: '浙江', value: 'ZJ'): const [
          TPickerOption(label: '杭州', value: 'HZ'),
        ],
      });

      expect(a == b, true);
      expect(a.hashCode, b.hashCode);
      expect(a == c, false);
    });

    testWidgets('纯滚轮 - 不渲染工具栏按钮', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: const TPickerColumns([
                [
                  TPickerOption(label: 'A', value: 'a'),
                  TPickerOption(label: 'B', value: 'b'),
                ],
              ]),
              onChange: (v) {},
            ),
          ),
        ),
      );

      expect(find.text('取消'), findsNothing);
      expect(find.text('确认'), findsNothing);
    });
  });
}
