import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/picker/picker_normalize.dart';
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
              onChange: (_, __) {},
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
              onChange: (_, __) {},
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
              onChange: (_, __) {},
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
              onChange: (_, __) {},
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
              onChange: (_, __) {},
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
              onChange: (_, __) {},
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
              onChange: (_, __) {},
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
              onChange: (_, __) {},
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
              onChange: (_, __) {},
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
              onChange: (_, __) {},
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
              onChange: (_, __) {},
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
              onChange: (_, __) {},
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
              onChange: (_, __) {},
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
              onChange: (_, v) => captured = v,
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
              onChange: (_, v) => captured = v,
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
              onChange: (_, v) => captured = v,
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

    testWidgets('disabled 项修正 - 可滑过连续禁用区到达后方 enabled', (WidgetTester tester) async {
      TPickerValue? captured;
      const testData = [
        [
          TPickerOption(label: 'A5', value: 'A5'),
          TPickerOption(label: 'A6', value: 'A6', disabled: true),
          TPickerOption(label: 'A7', value: 'A7', disabled: true),
          TPickerOption(label: 'A8', value: 'A8', disabled: true),
          TPickerOption(label: 'A9', value: 'A9'),
        ],
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: const TPickerColumns(testData),
              initialValue: const ['A5'],
              onChange: (_, v) => captured = v,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.drag(
        find.byType(ListWheelScrollView),
        const Offset(0, -320),
      );
      await tester.pumpAndSettle();

      expect(captured, isNotNull);
      expect(captured!.values[0], 'A9');
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
              onChange: (_, __) {},
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
              onChange: (_, __) {},
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
              onChange: (_, __) {},
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
              onChange: (_, __) {},
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
              onChange: (_, __) {},
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
              onChange: (_, __) {},
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
              onChange: (_, __) {},
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

    testWidgets('联动模式 - 5级切换第1级后下游列全部换新并重置首项',
        (WidgetTester tester) async {
      TPickerValue? captured;

      dynamic fiveLevelNode(int depth, [String codePrefix = '']) {
        if (depth == 5) {
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
            ): fiveLevelNode(
                depth + 1, codePrefix.isEmpty ? '$i' : '$codePrefix.$i'),
        };
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: TPickerLinked(fiveLevelNode(1)),
              initialValue: const [
                '1',
                '1.1',
                '1.1.1',
                '1.1.1.1',
                '1.1.1.1.1',
              ],
              onChange: (_, v) => captured = v,
            ),
          ),
        ),
      );

      expect(find.byType(ListWheelScrollView), findsNWidgets(5));

      await tester.drag(
        find.byType(ListWheelScrollView).first,
        const Offset(0, -40), // 第 1 级切换到 2
      );
      await tester.pumpAndSettle();

      expect(find.byType(ListWheelScrollView), findsNWidgets(5));
      expect(captured, isNotNull);
      expect(captured!.values[0], '2');
      expect(captured!.values[1], '2.1');
      expect(captured!.values[2], '2.1.1');
      expect(captured!.values[3], '2.1.1.1');
      expect(captured!.values[4], '2.1.1.1.1');
      expect(captured!.indexes, const [1, 0, 0, 0, 0]);
    });

    testWidgets('联动模式 - mount 后不触发 onChange', (WidgetTester tester) async {
      var changeCount = 0;
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
              initialValue: const ['GD', 'SZ', 'NS'],
              onChange: (_, __) => changeCount++,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(changeCount, 0);
    });

    testWidgets('联动模式 - onChange 的 col 仅来自用户滚动的列',
        (WidgetTester tester) async {
      final notifyCols = <int>[];
      final linkedData = {
        const TPickerOption(label: '广东省', value: 'GD'): {
          const TPickerOption(label: '深圳市', value: 'SZ'): const [
            TPickerOption(label: '南山区', value: 'NS'),
            TPickerOption(label: '福田区', value: 'FT'),
          ],
          const TPickerOption(label: '广州市', value: 'GZ'): const [
            TPickerOption(label: '天河区', value: 'TH'),
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
              initialValue: const ['GD', 'SZ', 'NS'],
              onChange: (col, _) => notifyCols.add(col),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      notifyCols.clear();

      await tester.drag(
        find.byType(ListWheelScrollView).first,
        const Offset(0, -80), // 第 1 级切换到 浙江省
      );
      await tester.pumpAndSettle();

      expect(notifyCols, isNotEmpty);
      expect(notifyCols.every((c) => c == 0), isTrue,
          reason: '切换第 1 级时 onChange 的 col 应均为 0，'
              '不应出现下游列 attach 触发的 col');
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
              onChange: (_, v) => captured = v,
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
              onChange: (_, __) {},
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
              onChange: (_, v) => captured = v,
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
              onChange: (_, v) => captured = v,
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
                      onChange: (_, v) =>
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

    testWidgets(
        '回归 - setState 改 initialValue 等值元素不应让 controller 重建（滚轮卡死）',
        (WidgetTester tester) async {
      // 反向 case：initialValue 随 onChange 变化（即便值最终等价）会触发
      // _disposeAllControllers + _initState，惯性滚动每帧都中招，表现为
      // "每次手势只能前进 1 项"。本测试验证：保持 initialValue 引用稳定时，
      // 单次 fling 后滚轮应跨越多个 item。
      const testData = [
        [
          TPickerOption(label: '项0', value: 'v0'),
          TPickerOption(label: '项1', value: 'v1'),
          TPickerOption(label: '项2', value: 'v2'),
          TPickerOption(label: '项3', value: 'v3'),
          TPickerOption(label: '项4', value: 'v4'),
          TPickerOption(label: '项5', value: 'v5'),
          TPickerOption(label: '项6', value: 'v6'),
        ],
      ];
      var currentValue = 'v0';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                // 关键：initialValue 始终是 const 引用，不随 onChange 变化
                return Column(
                  children: [
                    Text('value: $currentValue'),
                    TPicker(
                      items: const TPickerColumns(testData),
                      initialValue: const ['v0'],
                      onChange: (_, v) => setState(
                          () => currentValue = v.values.first as String),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('value: v0'), findsOneWidget);

      // 一次大距离 fling，惯性滚动后应跨越多个 item
      await tester.fling(
        find.byType(ListWheelScrollView),
        const Offset(0, -120),
        2000,
      );
      await tester.pumpAndSettle();

      // 不应卡在 v1 —— 证明 controller 没有被中途 dispose
      expect(currentValue, isNot('v0'));
      expect(currentValue, isNot('v1'),
          reason:
              '惯性滚动后应跨越多个 item；若卡在 v1 说明 controller 被 onChange 触发的 setState 重建了');
    });

    testWidgets(
        '契约 - initialValue 在首次构建后被忽略（不拨动滚轮、不重建 controller）',
        (WidgetTester tester) async {
      // 验证 TPicker 内部契约：initialValue 是 initState-only 的种子。
      // 即便父级重建传了一个**完全不同**的 initialValue，TPicker 也应保持
      // 内部 controller 位置不变，**不**做 jumpTo 也不 dispose+reinit。
      //
      // 行为对比（旧 vs 新）：
      // - 旧行为：父级 setState 改 initialValue → didUpdateWidget 检测到
      //   initChanged → dispose 旧 controller + 重新建一个 + jumpToItem
      //   → 滚轮被强拉到新 initialValue
      // - 新行为：parent setState 改 initialValue → didUpdateWidget 忽略
      //   → controller 不动，滚轮位置完全保留
      //
      // 关键：用 Semantics 读 wheel 实际的显示值（不是 onChange draft），
      // 因为旧实现下 jumpToItem 不会触发 onChange，必须从 a11y 节点读。
      const testData = [
        [
          TPickerOption(label: '项0', value: 'v0'),
          TPickerOption(label: '项1', value: 'v1'),
          TPickerOption(label: '项2', value: 'v2'),
          TPickerOption(label: '项3', value: 'v3'),
          TPickerOption(label: '项4', value: 'v4'),
        ],
      ];

      final semanticsHandle = tester.ensureSemantics();
      var currentInitial = const <dynamic>['v0'];
      late StateSetter outerSetState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                outerSetState = setState;
                return TPicker(
                  items: const TPickerColumns(testData),
                  initialValue: currentInitial,
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 从 a11y 节点读 wheel 当前的 label（TPicker 把当前选中项的 label 放上去）
      String readWheelLabel() {
        final node = tester.getSemantics(find.bySemanticsLabel('第 1 列'));
        return node.getSemanticsData().value;
      }

      // 初始：v0
      expect(readWheelLabel(), '项0');

      // 第一步：把滚轮拖到中间项（v2 附近）
      await tester.drag(
        find.byType(ListWheelScrollView),
        const Offset(0, -80),
      );
      await tester.pumpAndSettle();
      final labelAfterDrag = readWheelLabel();
      expect(labelAfterDrag, isNot('项0'),
          reason: '拖动后 wheel label 应离开项0');

      // 第二步：父级 setState 改 initialValue 到一个**完全不同**的值 v4。
      // 旧实现：controller 被 dispose + 重建 + 跳到 v4，wheel 显示"项4"
      // 新实现：initialValue 被忽略，wheel 仍显示拖动后的位置
      outerSetState(() {
        currentInitial = const <dynamic>['v4'];
      });
      await tester.pumpAndSettle();

      final labelAfterSetState = readWheelLabel();
      expect(labelAfterSetState, isNot('项4'),
          reason: 'TPicker 应当忽略父级后续的 initialValue 变更，'
              'wheel 不应被拨到"项4"');
      expect(labelAfterSetState, labelAfterDrag,
          reason: 'wheel 位置应保持拖动后的 label 不变（initialValue 严格 initState-only）');

      semanticsHandle.dispose();
    });

    testWidgets('回归 - 列尾分页追加不重置 ScrollController', (WidgetTester tester) async {
      final col0 = [
        for (var i = 1; i <= 10; i++)
          TPickerOption(label: '项$i', value: 'v$i'),
      ];
      var selected = 'v1';
      late StateSetter outerSetState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                outerSetState = setState;
                return Column(
                  children: [
                    Text('selected: $selected'),
                    TPicker(
                      items: TPickerColumns([col0]),
                      onChange: (_, v) =>
                          setState(() => selected = v.values.first as String),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // 滚到接近列底，模拟按需加载触发点
      await tester.drag(find.byType(ListWheelScrollView), const Offset(0, -160));
      await tester.pumpAndSettle();
      expect(find.text('selected: v5'), findsOneWidget);

      // 模拟按需加载：原地 append，同一 List 引用（LinkedLazyPickerScope 行为）
      col0.addAll([
        for (var i = 11; i <= 20; i++)
          TPickerOption(label: '项$i', value: 'v$i'),
      ]);
      outerSetState(() {});
      await tester.pumpAndSettle();

      expect(find.text('selected: v5'), findsOneWidget);

      // 必须能继续滚入追加区域，而非 childCount 卡在 10
      await tester.drag(find.byType(ListWheelScrollView), const Offset(0, -160));
      await tester.pumpAndSettle();
      expect(find.text('selected: v9'), findsOneWidget);
    });

    testWidgets('onColumnScrollEnd 在滚动结束时触发', (WidgetTester tester) async {
      final col0 = [
        for (var i = 1; i <= 10; i++)
          TPickerOption(label: '项$i', value: 'v$i'),
      ];
      int? scrollEndCol;
      int? scrollEndIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: TPickerColumns([col0]),
              onColumnScrollEnd: (col, value) {
                scrollEndCol = col;
                scrollEndIndex = value.indexes[col];
              },
            ),
          ),
        ),
      );

      await tester.drag(find.byType(ListWheelScrollView), const Offset(0, -80));
      await tester.pumpAndSettle();

      expect(scrollEndCol, 0);
      expect(scrollEndIndex, greaterThan(0));
    });

    testWidgets('回归 - 双列仅子列替换时保留主列滚动位置', (WidgetTester tester) async {
      final col0 = [
        for (var i = 1; i <= 10; i++)
          TPickerOption(label: '分类$i', value: 'cat_$i'),
      ];
      var col1 = [
        for (var i = 1; i <= 5; i++)
          TPickerOption(label: '分类1·$i', value: 'cat_1_item_$i'),
      ];
      var primary = 'cat_1';
      var linked = 'cat_1_item_1';
      var pickerInitial = <dynamic>['cat_1', 'cat_1_item_1'];
      late StateSetter outerSetState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                outerSetState = setState;
                return Column(
                  children: [
                    Text('p:$primary l:$linked'),
                    TPicker(
                      items: TPickerColumns([col0, col1]),
                      initialValue: pickerInitial,
                      onChange: (_, v) => setState(() {
                        primary = v.values[0] as String;
                        linked = v.values[1] as String;
                      }),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      final wheels = find.byType(ListWheelScrollView);
      await tester.drag(wheels.at(0), const Offset(0, -120));
      await tester.pumpAndSettle();
      expect(find.textContaining('p:cat_4'), findsOneWidget);

      // 模拟切换分类：仅替换子列；initialValue 故意指向 cat_1（全量重建会跳回首项）
      col1 = [
        for (var i = 1; i <= 5; i++)
          TPickerOption(label: '分类4·$i', value: 'cat_4_item_$i'),
      ];
      outerSetState(() {
        pickerInitial = ['cat_1', 'cat_4_item_1'];
      });
      await tester.pumpAndSettle();

      // 主列应仍停在 cat_4，而非被 initialValue 拉回 cat_1
      expect(find.textContaining('p:cat_4'), findsOneWidget);
      expect(find.textContaining('p:cat_1'), findsNothing);
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
                      onChange: (_, v) =>
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
              onChange: (_, __) {},
            ),
          ),
        ),
      );

      expect(find.text('取消'), findsNothing);
      expect(find.text('确认'), findsNothing);
    });

    // ========== 无障碍（Semantics）==========
    group('TPicker 无障碍', () {
      // 触发指定列的 increase / decrease 语义动作。
      //
      // 注：这里使用 [TestWidgetsFlutterBinding.pipelineOwner]（已弃用）来
      // 派发语义动作。deprecation 建议的替代路径
      // (`RendererBinding.rootPipelineOwner`) 在测试场景下不可行：
      //   - `rootPipelineOwner` 是一个不挂 `RenderView` 的 `_DefaultRootPipelineOwner`，
      //     其 `PipelineOwner.rootNode == null`，`ensureSemantics` 不会为它
      //     创建 `SemanticsOwner`，因此无法持有本次 `pumpWidget` 生成的语义节点。
      //   - `SemanticsBinding.instance` 仅暴露
      //     `performSemanticsAction(ui.SemanticsActionEvent)`（基于引擎层事件）
      //     而非 `performAction(int, SemanticsAction)`（按 nodeId 派发）。
      //   - Flutter 自身的 `test/cupertino/date_picker_test.dart`（处理同一类
      //     "CupertinoDatePicker 增加/减少列选中"测试）目前也仍然使用
      //     `tester.binding.pipelineOwner.semanticsOwner!.performAction(...)`，
      //     等待 framework 给出非弃用替代 API。
      // 因此这里显式 `ignore_for_file: deprecated_member_use` 跟随上游测试。
      // ignore: deprecated_member_use
      void performNudge(WidgetTester tester, int nodeId, bool increase) {
        // ignore: deprecated_member_use
        tester.binding.pipelineOwner.semanticsOwner!.performAction(
              nodeId,
              increase ? SemanticsAction.increase : SemanticsAction.decrease,
            );
      }

      testWidgets('外层 Semantics 容器 + 每列 Semantics 节点',
          (tester) async {
        final h = tester.ensureSemantics();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TPicker(
                items: const TPickerColumns([
                  [
                    TPickerOption(label: '北京', value: 'BJ'),
                    TPickerOption(label: '上海', value: 'SH'),
                    TPickerOption(label: '广州', value: 'GZ'),
                  ],
                  [
                    TPickerOption(label: 'A 区', value: 'A'),
                    TPickerOption(label: 'B 区', value: 'B'),
                  ],
                ]),
                onChange: (_, __) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.bySemanticsLabel('选择器'), findsOneWidget);
        expect(find.bySemanticsLabel('第 1 列'), findsOneWidget);
        expect(find.bySemanticsLabel('第 2 列'), findsOneWidget);
        // 默认初始值就是第一项
        final node1 = tester.getSemantics(find.bySemanticsLabel('第 1 列'));
        expect(node1.value, '北京');
        final node2 = tester.getSemantics(find.bySemanticsLabel('第 2 列'));
        expect(node2.value, 'A 区');
        h.dispose();
      });

      testWidgets('全局 disabled 时列级 a11y 动作不可用', (tester) async {
        final h = tester.ensureSemantics();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TPicker(
                items: const TPickerColumns([
                  [
                    TPickerOption(label: '北京', value: 'BJ'),
                    TPickerOption(label: '上海', value: 'SH'),
                  ],
                ]),
                disabled: true,
                onChange: (_, __) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final node = tester.getSemantics(find.bySemanticsLabel('第 1 列'));
        final data = node.getSemanticsData();
        expect(data.hasAction(SemanticsAction.increase), isFalse);
        expect(data.hasAction(SemanticsAction.decrease), isFalse);
        h.dispose();
      });

      testWidgets('全局 disabled 时列级 Semantics 不可聚焦', (tester) async {
        final h = tester.ensureSemantics();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TPicker(
                items: const TPickerColumns([
                  [
                    TPickerOption(label: '北京', value: 'BJ'),
                    TPickerOption(label: '上海', value: 'SH'),
                  ],
                ]),
                disabled: true,
                onChange: (_, __) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final node = tester.getSemantics(find.bySemanticsLabel('第 1 列'));
        final data = node.getSemanticsData();
        expect(data.hasFlag(SemanticsFlag.isEnabled), isFalse);
        h.dispose();
      });

      testWidgets('onIncrease / onDecrease 在边界处被禁用', (tester) async {
        final h = tester.ensureSemantics();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TPicker(
                items: const TPickerColumns([
                  [
                    TPickerOption(label: '北京', value: 'BJ'),
                  ],
                ]),
                onChange: (_, __) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // 单项：increase / decrease 都不可用
        final node = tester.getSemantics(find.bySemanticsLabel('第 1 列'));
        final data = node.getSemanticsData();
        expect(data.hasAction(SemanticsAction.increase), isFalse);
        expect(data.hasAction(SemanticsAction.decrease), isFalse);
        expect(data.increasedValue, '');
        expect(data.decreasedValue, '');
        h.dispose();
      });

      testWidgets('onIncrease 在最底端被禁用', (tester) async {
        final h = tester.ensureSemantics();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TPicker(
                items: const TPickerColumns([
                  [
                    TPickerOption(label: '北京', value: 'BJ'),
                    TPickerOption(label: '上海', value: 'SH'),
                  ],
                ]),
                onChange: (_, __) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // 先 nudge 到底（'上海'），increase 不可用
        final node = tester.getSemantics(find.bySemanticsLabel('第 1 列'));
        performNudge(tester, node.id, true);
        await tester.pumpAndSettle();

        final node2 = tester.getSemantics(find.bySemanticsLabel('第 1 列'));
        final data = node2.getSemanticsData();
        expect(node2.value, '上海');
        expect(data.hasAction(SemanticsAction.increase), isFalse);
        expect(data.increasedValue, '');
        expect(data.hasAction(SemanticsAction.decrease), isTrue);
        expect(data.decreasedValue, '北京');
        h.dispose();
      });

      testWidgets('触发 onIncrease 会变更列选中并触发 onChange',
          (tester) async {
        final h = tester.ensureSemantics();
        var lastCol = -1;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TPicker(
                items: const TPickerColumns([
                  [
                    TPickerOption(label: '北京', value: 'BJ'),
                    TPickerOption(label: '上海', value: 'SH'),
                    TPickerOption(label: '广州', value: 'GZ'),
                  ],
                ]),
                onChange: (col, v) {
                  lastCol = col;
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final node = tester.getSemantics(find.bySemanticsLabel('第 1 列'));
        expect(node.getSemanticsData().hasAction(SemanticsAction.increase),
            isTrue);
        performNudge(tester, node.id, true);
        await tester.pumpAndSettle();

        expect(lastCol, 0);
        final node2 = tester.getSemantics(find.bySemanticsLabel('第 1 列'));
        expect(node2.value, '上海');
        h.dispose();
      });

      testWidgets('nudge 严格 +1/-1（与 Flutter CupertinoPicker 同款契约）：'
          'a11y 文案是严格下一格，物理落点会被 _handleScrollEnd '
          '回弹到最近 enabled', (tester) async {
        // 数据：[enabled, disabled, disabled, enabled]
        // 旧实现：nudge(1) 会跳到 启用2（跨过 disabled）
        // 新实现：nudge(1) 跳到 禁用1（严格 +1，不跨 disabled），
        //        落点由 _handleScrollEnd 触发的 _animateToNearestEnabled
        //        回弹到 启用1
        final h = tester.ensureSemantics();
        var lastCol = -1;
        var lastIndex = -1;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TPicker(
                items: const TPickerColumns([
                  [
                    TPickerOption(label: '启用1', value: 'e1'),
                    TPickerOption(label: '禁用1', value: 'd1', disabled: true),
                    TPickerOption(label: '禁用2', value: 'd2', disabled: true),
                    TPickerOption(label: '启用2', value: 'e2'),
                  ],
                ]),
                onChange: (col, v) {
                  lastCol = col;
                  lastIndex = v.indexes[0];
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final node = tester.getSemantics(find.bySemanticsLabel('第 1 列'));
        final data = node.getSemanticsData();
        // 关键断言：a11y 预览文案是严格 +1 后的项（即使它是 disabled）
        expect(data.increasedValue, '禁用1');
        // 反向同理：越界时 decrease action 不存在，decreasedValue 为空串
        expect(data.hasAction(SemanticsAction.decrease), isFalse);
        expect(data.decreasedValue, '');
        performNudge(tester, node.id, true);
        await tester.pumpAndSettle();

        // 落点回弹到 启用1（index 0），不是 禁用1
        expect(lastCol, 0);
        expect(lastIndex, 0);
        final node2 = tester.getSemantics(find.bySemanticsLabel('第 1 列'));
        expect(node2.value, '启用1');
        // 此时 increasedValue 仍是严格 +1（指向 禁用1）
        final data2 = node2.getSemanticsData();
        expect(data2.increasedValue, '禁用1');
        h.dispose();
      });

      // H1 修复回归：nudge 落到 disabled 后到 _animateToNearestEnabled
      // 完成前的中间帧，a11y `value` 必须回退到最近 enabled 标签。
      // 旧实现：value 直接显示 disabled 标签（"禁用1"），对屏读用户是误导。
      testWidgets('H1 修复：disabled 落点瞬间 a11y value 回退到最近 enabled',
          (tester) async {
        final h = tester.ensureSemantics();
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TPicker(
                items: TPickerColumns([
                  [
                    TPickerOption(label: '启用1', value: 'e1'),
                    TPickerOption(label: '禁用1', value: 'd1', disabled: true),
                    TPickerOption(label: '启用2', value: 'e2'),
                  ],
                ]),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // 初始位置：index 0 (启用1)
        final node = tester.getSemantics(find.bySemanticsLabel('第 1 列'));
        expect(node.value, '启用1');

        // 触发 a11y increase：nudge(1) → 跳到 禁用1
        // 用 pump()（不 settle）抓取动画起点：controller 此时在 1 上，
        // _animateToNearestEnabled 正在 200ms 动画途中。
        performNudge(tester, node.id, true);
        // 一帧 ≈ 16ms，远小于 200ms 修正动画，中间帧可观测。
        await tester.pump();

        // 关键断言：a11y value 不是 "禁用1"，而是回退到最近 enabled。
        // nearestEnabledIndex 在等距时偏向前向：start=1 (禁用1) → forward=2 (启用2)
        // 胜出于 backward=0 (启用1)。这里我们只断言"非 disabled 标签"，
        // 不绑定到具体的回退方向（H1 修复的核心契约是"不暴露 disabled"）。
        final midNode = tester.getSemantics(find.bySemanticsLabel('第 1 列'));
        final midData = midNode.getSemanticsData();
        expect(midData.value, isNot('禁用1'),
            reason: 'H1 修复：当前为 disabled 时 a11y value 必须回退，'
                '不应暴露 disabled 标签给屏读');
        expect(midData.value, anyOf('启用1', '启用2'),
            reason: '最近 enabled 标签，应为 启用1 或 启用2');

        // settle 后的状态：auto-correction 落点 = nearestEnabledIndex
        // (start=1, 等距时偏 forward 启用2)。证明 H1 修复的"非 disabled"契约
        // 不仅在中间帧成立，settle 后也保持不回退到 disabled。
        await tester.pumpAndSettle();
        final settled = tester.getSemantics(find.bySemanticsLabel('第 1 列'));
        expect(settled.value, isNot('禁用1'));
        expect(settled.value, anyOf('启用1', '启用2'));
        h.dispose();
      });

      // H2 修复回归：a11y nudge 落到 disabled 后，auto-correction 动画
      // 完成时的 onAnimationComplete 必须 dedup 跳过，否则会触发
      // 重复的 onChange（同 index 出现两次）。
      //
      // 实际事件链（实测）：
      //   1. nudge(1) → onItemSelected(idx=1) → _onColumnItemSelected 早退
      //      （idx 1 是 disabled，TPicker 故意不报 onChange 避免"误报 disabled
      //      被选中"的中间态）。【changeCount=0】
      //   2. auto-correction 动画过程中 wheel.onSelectedItemChanged(target=2)
      //      触发 → _handleSelectedItemChange(2) → onItemSelected(idx=2) →
      //      _onColumnItemSelected 走通 → _notifyChange → onChange(idx=2)。
      //      【changeCount=1】（这是用户视角的"实际选中"，必须发出）
      //   3. 动画 .then 回调检查 _lastNotifiedIndex==target==2 → 命中 dedup，
      //      不再调 onAnimationComplete，changeCount 不会涨到 2。
      //
      // 旧实现（无 H2 dedup）下第 3 步会重复触发 onChange(idx=2)，导致
      // changeCount=2，对外表现为"一次 nudge，onChange 收到两次相同 index"。
      testWidgets('H2 修复：a11y nudge 后 onAnimationComplete 不重复触发 onChange',
          (tester) async {
        final h = tester.ensureSemantics();
        var changeCount = 0;
        var lastCol = -1;
        var lastIndex = -1;
        final indexes = <int>[];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TPicker(
                items: const TPickerColumns([
                  [
                    TPickerOption(label: '启用1', value: 'e1'),
                    TPickerOption(label: '禁用1', value: 'd1', disabled: true),
                    TPickerOption(label: '启用2', value: 'e2'),
                  ],
                ]),
                onChange: (col, v) {
                  changeCount++;
                  lastCol = col;
                  lastIndex = v.indexes[0];
                  indexes.add(v.indexes[0]);
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        // 注：初始 pumpAndSettle 期间 wheel.onSelectedItemChanged 可能
        // 因首次 build 触发 1~N 次（取决于 ListWheelScrollView 内部实现），
        // 与本测试关注点无关。这里"归零"计数器，从首次 a11y 交互开始记录。
        changeCount = 0;
        indexes.clear();
        lastIndex = -1;

        // 触发 a11y increase：nudge(1) → 跳到 禁用1 → onItemSelected(1) 在
        // TPicker 早退（disabled 防御）→ 0 次 onChange。
        // auto-correction 动画 → 落点 启用2 → wheel.onSelectedItemChanged(2)
        // 触发 → onItemSelected(2) 走通 → 1 次 onChange(idx=2)。
        // 动画 .then 命中 H2 dedup，不再调 onAnimationComplete。
        // 总计 1 次 onChange，index=2。
        final node = tester.getSemantics(find.bySemanticsLabel('第 1 列'));
        performNudge(tester, node.id, true);
        await tester.pumpAndSettle();

        expect(changeCount, 1,
            reason: 'H2 修复：auto-correction 落点 1 次 onChange(idx=2)。'
                '第 2 次（onAnimationComplete 回调）必须被 dedup 跳过，'
                '不能涨到 2。');
        expect(lastCol, 0);
        expect(indexes, <int>[2],
            reason: '序列：仅含 auto-correction 落点 idx=2。如果第 3 步未 '
                'dedup，序列会是 [2, 2]，重复出现 index=2。');
        expect(lastIndex, 2);
        h.dispose();
      });

      testWidgets('onDecrease 越界时不触发 onChange', (tester) async {
        final h = tester.ensureSemantics();
        var lastCol = -1;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TPicker(
                items: const TPickerColumns([
                  [
                    TPickerOption(label: '北京', value: 'BJ'),
                    TPickerOption(label: '上海', value: 'SH'),
                  ],
                ]),
                onChange: (col, v) {
                  lastCol = col;
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final node = tester.getSemantics(find.bySemanticsLabel('第 1 列'));
        // 默认 '北京' 已经最顶，decrease 不可用
        expect(node.getSemanticsData().hasAction(SemanticsAction.decrease),
            isFalse);
        // performAction 不应抛错也不应触发 onChange
        performNudge(tester, node.id, false);
        await tester.pumpAndSettle();
        expect(lastCol, -1);
        h.dispose();
      });

      testWidgets('联动模式下的列也获得 Semantics', (tester) async {
        final h = tester.ensureSemantics();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TPicker(
                items: TPickerLinked({
                  const TPickerOption(label: '广东省', value: 'GD'): const [
                    TPickerOption(label: '深圳', value: 'SZ'),
                    TPickerOption(label: '广州', value: 'GZ'),
                  ],
                  const TPickerOption(label: '浙江省', value: 'ZJ'): const [
                    TPickerOption(label: '杭州', value: 'HZ'),
                  ],
                }),
                onChange: (_, __) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.bySemanticsLabel('选择器'), findsOneWidget);
        expect(find.bySemanticsLabel('第 1 列'), findsOneWidget);
        expect(find.bySemanticsLabel('第 2 列'), findsOneWidget);
        h.dispose();
      });
    });
  });
}
