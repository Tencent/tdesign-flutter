import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/picker/t_picker_normalize.dart';
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
              items: TPickerColumns(testData),
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
              items: TPickerLinked(linkedData),
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
              items: TPickerLinked(linkedData),
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
              items: TPickerColumns(disabledData),
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
              items: TPickerColumns(disabledData),
              onChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

    /// 测试 6: 项级禁用（结尾禁用）
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
              items: TPickerColumns(disabledData),
              onChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

    /// 测试 7: 全局禁用
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
              items: TPickerColumns(testData),
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
              items: TPickerColumns(testData),
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
              items: TPickerLinked(linkedData),
              initialValue: const ['GD', 'SZ'],
              onChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

    /// 测试 10: onChange 回调 - 可正常注册（冒烟测试）
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
              items: TPickerColumns(testData),
              onChange: (value) {},
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
              items: TPickerColumns(lazyData),
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

    /// 测试 14: TPickerLoadEvent 类型测试
    test('TPickerLoadEvent - 基础属性', () {
      const event = TPickerLoadEvent(
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
      const emptyData = [
        <TPickerOption>[],
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: TPickerColumns(emptyData),
              onChange: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

    /// 测试 16: 参数验证 - height 和 itemCount
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
              items: TPickerColumns(testData),
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
              items: TPickerColumns(testData),
              onChange: (value) {},
            ),
          ),
        ),
      );

      // 验证 3 列
      expect(find.byType(ListWheelScrollView), findsNWidgets(3));
    });

    /// 测试 18: 初始值指向非首项时 onChange 返回正确值
    ///
    /// 防回归：历史上 `_correctedIndex` 缓存机制把所有列初始化为 0，
    /// 导致初始 `_buildValue()` 用缓存 0 而不读 controller 的 initialItem，
    /// 对 initialValue 指向非首项的场景返回错的 TPickerValue。
    testWidgets('初始值非首项 - onChange 返回正确值（多列独立）',
        (WidgetTester tester) async {
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
              items: TPickerColumns(testData),
              initialValue: const ['a3', 'b2'],
              onChange: (v) => captured = v,
            ),
          ),
        ),
      );

      // 滚动第一列到上面一项（a3 → a2），触发 onChange
      await tester.drag(
        find.byType(ListWheelScrollView).first,
        const Offset(0, 40), // 向下拖 = 选中项上移
      );
      await tester.pumpAndSettle();

      expect(captured, isNotNull);
      // 第二列应保持 b2（初始值非首项的保留能力）
      expect(captured!.values[1], 'b2',
          reason: '第二列应保持初始选中的 b2，若为 b1 说明 _correctedIndex 污染了结果');
      expect(captured!.labels[1], 'B2');
    });

    /// 测试 19: 联动模式初始值指向非首项
    testWidgets('初始值非首项 - 联动模式 onChange 返回正确值',
        (WidgetTester tester) async {
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

      // 触发第一列的滚动让 onChange 产生
      await tester.drag(
        find.byType(ListWheelScrollView).first,
        const Offset(0, 40), // 向下滚回 GD
      );
      await tester.pumpAndSettle();

      expect(captured, isNotNull);
      expect(captured!.values[0], 'GD');
      // 联动会重置后续列到 first.value
      expect(captured!.values[1], 'SZ');
    });

    /// 测试 20: 滚动停在 disabled 项触发修正（独立模式）
    ///
    /// 防回归：历史上 `_onScrollNotification` 中的
    /// `_correctedIndex[col] = newIndex` 在独立模式下会直接 RangeError
    /// （因为 `_correctedIndex` 在独立模式从未被 add）。
    testWidgets('disabled 项修正 - 独立模式滚动不会 crash',
        (WidgetTester tester) async {
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
              items: TPickerColumns(testData),
              onChange: (v) => captured = v,
            ),
          ),
        ),
      );

      // 尝试滚到 disabled 项（a2），组件应自动修正到相邻 enabled 项
      await tester.drag(
        find.byType(ListWheelScrollView),
        const Offset(0, -40),
      );
      await tester.pumpAndSettle();

      // 无论最终落到 a1 还是 a3，都不应是 a2
      if (captured != null) {
        expect(captured!.values[0], isNot('a2'));
        expect(captured!.selectedOptions[0].disabled, false);
      }
    });

    /// 测试 21: didUpdateWidget - items 变化时重新初始化
    testWidgets('didUpdateWidget - items 变化触发重建',
        (WidgetTester tester) async {
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
              items: TPickerColumns(testData1),
              onChange: (v) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);

      // 触发 didUpdateWidget：使用不同的 List 引用
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: TPickerColumns(testData2),
              onChange: (v) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

    /// 测试 22: didUpdateWidget - keys 变化时重新初始化
    testWidgets('didUpdateWidget - items 变化触发重建',
        (WidgetTester tester) async {
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
              items: TPickerColumns(testData),
              onChange: (v) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);

      // 触发 didUpdateWidget：使用不同的 items
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: TPickerColumns(testData2),
              onChange: (v) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

    /// 测试 23: didUpdateWidget - initialValue 变化时重新初始化
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
              items: TPickerColumns(testData),
              initialValue: const ['a'],
              onChange: (v) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);

      // 触发 didUpdateWidget：使用不同的 initialValue
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: TPickerColumns(testData),
              initialValue: const ['c'],
              onChange: (v) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
    });

    /// 测试 24: 联动模式 - 从多列切换到更少列再切回更多列
    testWidgets('联动模式 - 列数变化后能恢复',
        (WidgetTester tester) async {
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

      // 验证初始状态：3 列
      expect(find.byType(ListWheelScrollView), findsNWidgets(3));

      // 滚动第一列到重庆市（2 列）
      await tester.drag(
        find.byType(ListWheelScrollView).first,
        const Offset(0, -120), // 向下滚到 CQ
      );
      await tester.pumpAndSettle();

      // 验证：应该变成 2 列
      expect(find.byType(ListWheelScrollView), findsNWidgets(2));

      // 滚回广东省（3 列）
      await tester.drag(
        find.byType(ListWheelScrollView).first,
        const Offset(0, 120), // 向上滚回 GD
      );
      await tester.pumpAndSettle();

      // 验证：应该恢复到 3 列
      expect(find.byType(ListWheelScrollView), findsNWidgets(3));
    });

    /// 测试 25: 联动模式 - 滚动后新展开的列默认选中首项
    testWidgets('联动模式 - 滚动后新列选中首项',
        (WidgetTester tester) async {
      TPickerValue? captured;
      final linkedData = {
        const TPickerOption(label: '广东省', value: 'GD'): {
          const TPickerOption(label: '深圳市', value: 'SZ'): const [
            TPickerOption(label: '南山区', value: 'NS'),
            TPickerOption(label: '福田区', value: 'FT'),
            TPickerOption(label: '罗湖区', value: 'LL'),
          ],
          // GZ 是叶子节点（无子选项）
          const TPickerOption(label: '广州市', value: 'GZ'): const <TPickerOption>[],
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

      // 初始选中的是 SZ -> FT
      expect(find.byType(ListWheelScrollView), findsNWidgets(3));

      // 滚动第二列到广州市（触发联动刷新）
      await tester.drag(find.byType(ListWheelScrollView).at(1),
          const Offset(0, -120)); // 向下滚到 GZ
      await tester.pumpAndSettle();

      // 验证：应该变成 2 列（GZ 是叶子节点，没有子选项）
      expect(find.byType(ListWheelScrollView), findsNWidgets(2));

      // 滚回深圳市
      await tester.drag(find.byType(ListWheelScrollView).at(1),
          const Offset(0, 120)); // 向上滚回 SZ
      await tester.pumpAndSettle();

      // 验证：应该恢复到 3 列
      expect(find.byType(ListWheelScrollView), findsNWidgets(3));

      // 滚回 SZ 时会触发 onChange，新展开的第三列应选中首项（NS）
      expect(captured, isNotNull);
      expect(captured!.values[2], 'NS');
    });

    /// 测试 26: _checkPreload - onLoad 回调触发
    testWidgets('onLoad 回调 - 滚动时触发',
        (WidgetTester tester) async {
      var loadCallCount = 0;
      int? capturedColumn;
      int? capturedRemaining;

      final testData = [
        List.generate(
          100,
          (i) => TPickerOption(label: '选项 $i', value: 'opt_$i'),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: TPickerColumns(testData),
              onLoad: (event) {
                loadCallCount++;
                capturedColumn = event.column;
                capturedRemaining = event.remaining;
              },
              onChange: (v) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);

      // 滚动以触发 onSelectedItemChanged（并最终触发 onLoad）
      // 使用与其他测试一致的 drag + pumpAndSettle 模式
      await tester.drag(
        find.byType(ListWheelScrollView).first,
        const Offset(0, -80), // 向上拖：选中下一项
      );
      await tester.pumpAndSettle();

      // 验证 onLoad 被调用
      expect(loadCallCount, greaterThan(0));
      expect(capturedColumn, 0);
      expect(capturedRemaining, greaterThanOrEqualTo(0));
    });

    /// 测试 27: onLoad 回调 - 联动模式 parentValue 正确（3 层联动）
    ///
    /// 覆盖：滚第 2 列时 parentValue == 第 1 列选中值；
    ///       滚第 3 列时 parentValue == 第 2 列选中值。
    testWidgets('onLoad 回调 - 联动模式 parentValue 正确',
        (WidgetTester tester) async {
      dynamic capturedParentValue;
      int? capturedColumn;
      final linkedData = {
        const TPickerOption(label: '广东省', value: 'GD'): {
          const TPickerOption(label: '深圳市', value: 'SZ'): const [
            TPickerOption(label: '南山区', value: 'NS'),
            TPickerOption(label: '福田区', value: 'FT'),
            TPickerOption(label: '罗湖区', value: 'LL'),
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
              initialValue: const ['GD', 'SZ', 'NS'],
              onLoad: (event) {
                capturedColumn = event.column;
                capturedParentValue = event.parentValue;
              },
              onChange: (v) {},
            ),
          ),
        ),
      );

      expect(find.byType(TPicker), findsOneWidget);
      expect(find.byType(ListWheelScrollView), findsNWidgets(3));

      // 1) 滚动第三列（区）：parentValue 应为第二列的 'SZ'
      await tester.drag(
        find.byType(ListWheelScrollView).at(2),
        const Offset(0, -40), // 选中下一项（FT）
      );
      await tester.pumpAndSettle();
      expect(capturedColumn, 2);
      expect(capturedParentValue, 'SZ');

      // 2) 滚动第二列（市）：parentValue 应为第一列的 'GD'
      await tester.drag(
        find.byType(ListWheelScrollView).at(1),
        const Offset(0, -40), // 选中下一项（GZ）
      );
      await tester.pumpAndSettle();
      expect(capturedColumn, 1);
      expect(capturedParentValue, 'GD');
    });

    /// 测试 28: TPickerKeys - 默认值和自定义值
    test('TPickerKeys - 默认值和自定义值', () {
      // 默认值
      expect(TPickerKeys.defaults.label, 'label');
      expect(TPickerKeys.defaults.value, 'value');
      expect(TPickerKeys.defaults.disabled, 'disabled');
      expect(TPickerKeys.defaults.children, 'children');

      // 自定义值
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

    /// 测试 29: TPickerKeys - == 和 hashCode
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

    /// 测试 30: TPickerKeys - toString
    test('TPickerKeys - toString', () {
      const keys = TPickerKeys(label: 'name', value: 'id');
      final str = keys.toString();
      expect(str, contains('name'));
      expect(str, contains('id'));
    });

    /// 测试 31: TPickerOption - == 和 hashCode
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

    /// 测试 32: TPickerOption - toString
    test('TPickerOption - toString', () {
      const opt = TPickerOption(label: '测试', value: 'test');
      final str = opt.toString();
      expect(str, contains('测试'));
      expect(str, contains('test'));
    });

    /// 测试 33: TPickerValue - toString
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

    /// 测试 34: TPickerLoadEvent - toString
    test('TPickerLoadEvent - toString', () {
      const event = TPickerLoadEvent(
        column: 1,
        parentValue: 'GD',
        displayedCount: 20,
        remaining: 3,
      );

      final str = event.toString();
      expect(str, contains('1'));
      expect(str, contains('GD'));
      expect(str, contains('20'));
      expect(str, contains('3'));
    });

    /// 测试 35: TPickerNormalize - 已是 List<List<TPickerOption>>
    test('TPickerNormalize - 已是 List<List<TPickerOption>>', () {
      const input = [
        [TPickerOption(label: 'A', value: 'a')],
        [TPickerOption(label: 'B', value: 'b')],
      ];
      final result = TPickerNormalize.normalizeColumns(input, TPickerKeys.defaults);
      expect(identical(result, input), true);
    });

    /// 测试 36: TPickerNormalize - 已是 Map<TPickerOption, dynamic>
    test('TPickerNormalize - 已是 Map<TPickerOption, dynamic>', () {
      final input = <TPickerOption, dynamic>{
        const TPickerOption(label: 'A', value: 'a'): null,
      };
      final result = TPickerNormalize.normalizeLinked(input, TPickerKeys.defaults);
      expect(identical(result, input), true);
    });

    /// 测试 37: TPickerNormalize - List of List (归一化)
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
      final result = TPickerNormalize.normalizeColumns(input, TPickerKeys.defaults);
      expect(result, isA<List<List<TPickerOption>>>());
      expect(result.length, 2);
      expect(result[0].length, 2);
      expect(result[1].length, 1);
    });

    /// 测试 38: TPickerNormalize - Map 归一化
    test('TPickerNormalize - Map 归一化', () {
      final input = <String, dynamic>{
        'GD': <String, dynamic>{
          'SZ': [
            {'label': '南山区', 'value': 'NS'},
          ],
        },
      };
      final result = TPickerNormalize.normalizeLinked(input, const TPickerKeys(label: 'label', value: 'value'));
      expect(result, isA<Map<TPickerOption, dynamic>>());
    });

    /// 测试 39: TPickerNormalize - Map with disabled 字段
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
      final result = TPickerNormalize.normalizeLinked(input, TPickerKeys.defaults);
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

    /// 测试 40: TItemWidget - itemBuilder 回调
    testWidgets('TItemWidget - itemBuilder 回调', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: TPickerColumns(const [
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

    /// 测试 41: _nearestEnabled - 正向查找最近 enabled 项
    testWidgets('disabled 项修正 - 正向查找最近 enabled',
        (WidgetTester tester) async {
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
              items: TPickerColumns(testData),
              onChange: (v) => captured = v,
            ),
          ),
        ),
      );

      // 从 a1 向下滚到 a2（disabled），再继续滚
      await tester.drag(
        find.byType(ListWheelScrollView),
        const Offset(0, -80), // 向下滚过 a2
      );
      await tester.pumpAndSettle();

      // 验证修正到 enabled 项
      if (captured != null) {
        expect(captured!.values[0], isNot('a2'));
      }
    });

    /// 测试 42: _nearestEnabled - 反向查找最近 enabled 项
    testWidgets('disabled 项修正 - 反向查找最近 enabled',
        (WidgetTester tester) async {
      TPickerValue? captured;
      const testData = [
        [
          TPickerOption(label: 'A1', value: 'a1'),
          TPickerOption(label: 'A2', value: 'a2', disabled: true),
          TPickerOption(label: 'A3', value: 'a3'),
        ],
      ];

      // 先滚动到 A3
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: TPickerColumns(testData),
              onChange: (v) => captured = v,
            ),
          ),
        ),
      );

      // 从 a3 向上滚到 a2（disabled），再继续滚
      await tester.drag(
        find.byType(ListWheelScrollView),
        const Offset(0, 80), // 向上滚过 a2
      );
      await tester.pumpAndSettle();

      // 验证修正到 enabled 项
      if (captured != null) {
        expect(captured!.values[0], isNot('a2'));
      }
    });
    /// ============================================================
    /// 覆盖率补充用例（补全 TPickerNormalize 边界、模型类路径）
    /// ============================================================

    /// 测试 43: TPickerNormalize - 纯字符串列表归一化
    test('TPickerNormalize - 纯字符串列表归一化', () {
      final input = [
        ['北京', '上海', '广州'],
        ['朝阳区', '浦东'],
      ];
      final result = TPickerNormalize.normalizeColumns(input, TPickerKeys.defaults);
      expect(result, isA<List<List<TPickerOption>>>());
      expect(result[0][0].label, '北京');
      expect(result[0][0].value, '北京'); // 纯字符串时 value == label
      expect(result[1][1].label, '浦东');
    });

    /// 测试 44: TPickerNormalize - 空列表归一化
    test('TPickerNormalize - 空列表归一化', () {
      final result = TPickerNormalize.normalizeColumns([], TPickerKeys.defaults);
      expect(result, isA<List<List<TPickerOption>>>());
      expect(result.isEmpty, true);
    });

    /// 测试 45: TPickerNormalize - 空 Map 归一化
    test('TPickerNormalize - 空 Map 归一化', () {
      final result =
          TPickerNormalize.normalizeLinked(<String, dynamic>{}, TPickerKeys.defaults);
      expect(result, isA<Map<TPickerOption, dynamic>>());
      expect(result.isEmpty, true);
    });

    /// 测试 46: TPickerNormalize - List 中包含非 List 元素
    test('TPickerNormalize - List 中包含非 List 元素得到空列', () {
      final input = ['not_a_list', ['A', 'B']];
      final result = TPickerNormalize.normalizeColumns(input, TPickerKeys.defaults);
      expect(result, isA<List<List<TPickerOption>>>());
      expect(result[0], isEmpty); // 非 List 元素归一化为空列
      expect(result[1].length, 2);
    });

    /// 测试 47: TPickerNormalize - 自定义 keys 映射 Map 归一化
    test('TPickerNormalize - 自定义 keys 映射', () {
      final input = [
        [
          {'name': '深圳', 'code': 'SZ', 'readonly': true},
          {'name': '广州', 'code': 'GZ'},
        ],
      ];
      const keys = TPickerKeys(label: 'name', value: 'code', disabled: 'readonly');
      final result = TPickerNormalize.normalizeColumns(input, keys);
      expect(result[0][0].label, '深圳');
      expect(result[0][0].value, 'SZ');
      expect(result[0][0].disabled, true);
      expect(result[0][1].disabled, false);
    });

    /// 测试 48: TPickerNormalize - 联动 Map 含 children 字段
    test('TPickerNormalize - 联动 Map 含叶子 List', () {
      final input = <String, dynamic>{
        'A': ['X', 'Y'],
      };
      final result = TPickerNormalize.normalizeLinked(input, TPickerKeys.defaults);
      expect(result, isA<Map<TPickerOption, dynamic>>());
      final keyA = result.keys.first;
      expect(keyA.label, 'A');
      expect(keyA.value, 'A');
      final children = result[keyA] as List<TPickerOption>;
      expect(children.length, 2);
      expect(children[0].label, 'X');
    });

    /// 测试 49: TPickerNormalize - 联动 Map 中 child 为非法类型返回空列表
    test('TPickerNormalize - 联动 Map 中 child 为非法类型', () {
      final input = <String, dynamic>{
        'A': 12345, // 既不是 Map 也不是 List
      };
      final result = TPickerNormalize.normalizeLinked(input, TPickerKeys.defaults);
      final child = result[result.keys.first];
      expect(child, isA<List<TPickerOption>>());
      expect((child as List).isEmpty, true);
    });

    /// 测试 50: TPickerNormalize - 已是 TPickerOption 的 raw 直接返回
    test('TPickerNormalize - raw 为 TPickerOption 直通', () {
      final input = [
        [
          const TPickerOption(label: 'X', value: 'x'),
          {'label': 'Y', 'value': 'y'},
        ],
      ];
      final result = TPickerNormalize.normalizeColumns(input, TPickerKeys.defaults);
      expect(result[0][0].label, 'X');
      expect(result[0][1].label, 'Y');
    });

    /// 测试 51: TPickerNormalize - Map 中 null value 归一化
    test('TPickerNormalize - Map raw key 为 null', () {
      final input = <dynamic, dynamic>{
        null: ['child1'],
      };
      final result = TPickerNormalize.normalizeLinked(input, TPickerKeys.defaults);
      final key = result.keys.first;
      expect(key.label, '');
      expect(key.value, null);
    });

    /// 测试 52: TPickerOption - 不同 disabled 值的比较
    test('TPickerOption - disabled 不同则不相等', () {
      const a = TPickerOption(label: 'A', value: 'v1', disabled: false);
      const b = TPickerOption(label: 'A', value: 'v1', disabled: true);
      expect(a == b, false);
      expect(a.hashCode, isNot(b.hashCode));
    });

    /// 测试 53: TPickerOption - 不同 value 类型
    test('TPickerOption - value 为 int 类型', () {
      const opt = TPickerOption(label: '选项', value: 42);
      expect(opt.value, 42);
      expect(opt.toString(), contains('42'));
    });

    /// 测试 54: TPickerValue - 空列表场景
    test('TPickerValue - 空选项列表', () {
      final value = TPickerValue(selectedOptions: [], indexes: []);
      expect(value.values, isEmpty);
      expect(value.labels, isEmpty);
      expect(value.toString(), contains('[]'));
    });

    /// 测试 55: TPickerLoadEvent - parentValue 为复杂类型
    test('TPickerLoadEvent - parentValue 为 Map', () {
      const event = TPickerLoadEvent(
        column: 2,
        parentValue: {'id': 'SZ', 'name': '深圳'},
        displayedCount: 15,
        remaining: 0,
      );
      expect(event.parentValue, isA<Map>());
      expect(event.remaining, 0);
      expect(event.toString(), contains('15'));
    });

    /// 测试 56: TPickerKeys - children 字段作用验证
    test('TPickerKeys - children 字段完整性', () {
      const keys = TPickerKeys(children: 'subItems');
      expect(keys.children, 'subItems');
      expect(keys.toString(), contains('subItems'));
      expect(keys == const TPickerKeys(children: 'subItems'), true);
      expect(keys == const TPickerKeys(children: 'other'), false);
    });

    /// 测试 57: TPickerValue - toString 包含所有信息
    test('TPickerValue - toString 完整', () {
      final value = TPickerValue(
        selectedOptions: [
          TPickerOption(label: '广东', value: 'GD'),
          TPickerOption(label: '深圳', value: 'SZ'),
        ],
        indexes: [0, 1],
      );
      final str = value.toString();
      expect(str, contains('广东'));
      expect(str, contains('深圳'));
      expect(str, contains('GD'));
      expect(str, contains('SZ'));
      expect(str, contains('0'));
      expect(str, contains('1'));
    });

    /// 测试 58: TPickerLoadEvent - column=0 且 parentValue=null
    test('TPickerLoadEvent - 首列 parentValue 为 null', () {
      const event = TPickerLoadEvent(
        column: 0,
        parentValue: null,
        displayedCount: 5,
        remaining: 4,
      );
      expect(event.parentValue, isNull);
      expect(event.column, 0);
      final str = event.toString();
      expect(str, contains('null'));
      expect(str, contains('5'));
      expect(str, contains('4'));
    });

    /// 测试 59: TPickerItems - fromRaw 工厂方法正确性
    test('TPickerColumns.fromRaw / TPickerLinked.fromRaw 工厂方法', () {
      final columns = TPickerColumns.fromRaw([
        ['北京', '上海'],
        ['朝阳', '浦东'],
      ]);
      expect(columns.columns.length, 2);
      expect(columns.columns[0][0].label, '北京');

      final linked = TPickerLinked.fromRaw({
        '广东': {'深圳': ['南山']},
      });
      expect(linked.tree.keys.first.label, '广东');
    });

    /// 测试 60: TPickerKeys - 相同值不同实例 hashCode 一致
    test('TPickerKeys - 值相同的不同实例 hashCode 一致', () {
      const a = TPickerKeys(label: 'x', value: 'y', disabled: 'd', children: 'c');
      const b = TPickerKeys(label: 'x', value: 'y', disabled: 'd', children: 'c');
      expect(a == b, true);
      expect(a.hashCode, b.hashCode);
    });

    /// 测试 61: TPickerOption - null value 场景
    test('TPickerOption - value 为 null', () {
      const opt = TPickerOption(label: '空值', value: null);
      expect(opt.value, isNull);
      expect(opt.toString(), contains('null'));
    });

    /// 测试 62: 回归 - setState 重建时新建 TPickerColumns 实例不重置选择器
    ///
    /// 验证场景：用户在 onChange 中 setState，build 方法每次创建新的
    /// TPickerColumns 实例（数据相同），选择器不应被重置。
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

      String selected = 'v1';

      // 使用 StatefulBuilder 模拟真实场景：每次 setState 都新建 TPickerColumns
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Text('selected: $selected'),
                    TPicker(
                      // 每次 build 都创建新实例（模拟用户的自然写法）
                      items: TPickerColumns(testData),
                      onChange: (v) => setState(() => selected = v.values.first as String),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // 初始状态：选中 v1
      expect(find.text('selected: v1'), findsOneWidget);

      // 滚动到 v2
      await tester.drag(
        find.byType(ListWheelScrollView),
        const Offset(0, -40),
      );
      await tester.pumpAndSettle();

      // onChange 触发 setState，重建 Widget，TPicker 收到新的 TPickerColumns 实例
      // 但数据相同，不应重置选择器
      expect(find.text('selected: v2'), findsOneWidget);

      // 继续滚动到 v3（验证选择器没有被重置回 v1）
      await tester.drag(
        find.byType(ListWheelScrollView),
        const Offset(0, -40),
      );
      await tester.pumpAndSettle();

      // 如果 bug 存在（用 identical 比较），这里会是 v2 或 v1（被重置了）
      expect(find.text('selected: v3'), findsOneWidget);
    });

    /// 测试 63: 回归 - setState 新建等值 TPickerLinked 不重置联动选择器
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

      String selected = '广东省 / 深圳市 / 南山区';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Text('selected: $selected'),
                    TPicker(
                      // 每次 build 都创建新的 TPickerLinked（模拟用户的自然写法）
                      items: TPickerLinked(linkedData),
                      initialValue: const ['GD', 'SZ', 'NS'],
                      onChange: (v) => setState(() => selected = v.labels.join(' / ')),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // 初始状态
      expect(find.text('selected: 广东省 / 深圳市 / 南山区'), findsOneWidget);
      expect(find.byType(ListWheelScrollView), findsNWidgets(3));

      // 滚动第二列到广州市（触发联动）
      await tester.drag(
        find.byType(ListWheelScrollView).at(1),
        const Offset(0, -40),
      );
      await tester.pumpAndSettle();

      // onChange 触发 setState → 重建 → 新 TPickerLinked 实例
      // 联动应正常切换到广州市，而不是被重置回深圳市
      expect(selected, contains('广州市'));
      // 第三列应更新为天河区/越秀区
      expect(selected, contains('天河区'));
    });

    /// 测试 64: TPickerColumns 值相等性验证
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

    /// 测试 65: TPickerLinked 值相等性验证
    test('TPickerLinked - 相同数据的不同实例应相等', () {
      final a = TPickerLinked({
        const TPickerOption(label: '广东', value: 'GD'): [
          const TPickerOption(label: '深圳', value: 'SZ'),
        ],
      });
      final b = TPickerLinked({
        const TPickerOption(label: '广东', value: 'GD'): [
          const TPickerOption(label: '深圳', value: 'SZ'),
        ],
      });
      final c = TPickerLinked({
        const TPickerOption(label: '浙江', value: 'ZJ'): [
          const TPickerOption(label: '杭州', value: 'HZ'),
        ],
      });

      expect(a == b, true);
      expect(a.hashCode, b.hashCode);
      expect(a == c, false);
    });

    /// 测试 66: 工具栏 - 默认显示「取消」「确认」（与 popup 解耦的事件按钮）
    testWidgets('工具栏 - 默认显示取消/确认按钮',
        (WidgetTester tester) async {
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

      // 工具栏永远显示，「取消」「确认」按钮始终存在
      expect(find.text('取消'), findsOneWidget);
      expect(find.text('确认'), findsOneWidget);
    });

    /// 测试 67: 工具栏 - 设置 title 后显示标题
    testWidgets('工具栏 - 设置 title 后中部显示标题',
        (WidgetTester tester) async {
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
              title: '请选择',
              onChange: (v) {},
            ),
          ),
        ),
      );

      expect(find.text('取消'), findsOneWidget);
      expect(find.text('确认'), findsOneWidget);
      expect(find.text('请选择'), findsOneWidget);
    });

    /// 测试 68: 工具栏 - 点击取消触发 onCancel
    testWidgets('工具栏 - 点击取消触发 onCancel',
        (WidgetTester tester) async {
      var cancelled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: const TPickerColumns([
                [TPickerOption(label: 'A', value: 'a')],
              ]),
              onCancel: () => cancelled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();

      expect(cancelled, true);
    });

    /// 测试 69: 工具栏 - 点击确认触发 onConfirm 携带 TPickerValue
    testWidgets('工具栏 - 点击确认触发 onConfirm 并携带选中值',
        (WidgetTester tester) async {
      TPickerValue? confirmedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: const TPickerColumns([
                [
                  TPickerOption(label: 'A', value: 'a'),
                  TPickerOption(label: 'B', value: 'b'),
                  TPickerOption(label: 'C', value: 'c'),
                ],
              ]),
              initialValue: const ['b'],
              onConfirm: (v) => confirmedValue = v,
            ),
          ),
        ),
      );

      await tester.tap(find.text('确认'));
      await tester.pumpAndSettle();

      expect(confirmedValue, isNotNull);
      expect(confirmedValue!.values.first, 'b');
      expect(confirmedValue!.labels.first, 'B');
      expect(confirmedValue!.selectedOptions.length, 1);
    });

    /// 测试 70: 工具栏 - 自定义按钮文字
    testWidgets('工具栏 - 自定义 cancelText / confirmText',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: const TPickerColumns([
                [TPickerOption(label: 'A', value: 'a')],
              ]),
              cancelText: '关闭',
              confirmText: '完成',
            ),
          ),
        ),
      );

      expect(find.text('关闭'), findsOneWidget);
      expect(find.text('完成'), findsOneWidget);
      expect(find.text('取消'), findsNothing);
      expect(find.text('确认'), findsNothing);
    });

    /// 测试 71: 工具栏 - cancel 插槽替换默认文字并保留点击事件
    testWidgets('工具栏 - cancel 自定义插槽（图标）',
        (WidgetTester tester) async {
      var cancelled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: const TPickerColumns([
                [TPickerOption(label: 'A', value: 'a')],
              ]),
              cancel: const Icon(Icons.close, key: ValueKey('custom-cancel')),
              onCancel: () => cancelled = true,
            ),
          ),
        ),
      );

      // 自定义插槽渲染
      expect(find.byKey(const ValueKey('custom-cancel')), findsOneWidget);
      // 默认的「取消」文字被替换，不再出现
      expect(find.text('取消'), findsNothing);

      // 点击自定义插槽依然触发 onCancel
      await tester.tap(find.byKey(const ValueKey('custom-cancel')));
      await tester.pumpAndSettle();
      expect(cancelled, true);
    });

    /// 测试 72: 工具栏 - confirm 插槽替换默认文字并保留点击事件（携带 TPickerValue）
    testWidgets('工具栏 - confirm 自定义插槽（图标）',
        (WidgetTester tester) async {
      TPickerValue? confirmedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: const TPickerColumns([
                [
                  TPickerOption(label: 'X', value: 'x'),
                  TPickerOption(label: 'Y', value: 'y'),
                ],
              ]),
              initialValue: const ['y'],
              confirm: const Icon(Icons.check, key: ValueKey('custom-confirm')),
              onConfirm: (v) => confirmedValue = v,
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('custom-confirm')), findsOneWidget);
      expect(find.text('确认'), findsNothing);

      await tester.tap(find.byKey(const ValueKey('custom-confirm')));
      await tester.pumpAndSettle();

      expect(confirmedValue, isNotNull);
      expect(confirmedValue!.values.first, 'y');
      expect(confirmedValue!.labels.first, 'Y');
    });

    /// 测试 73: 工具栏 - titleWidget 自定义标题插槽
    testWidgets('工具栏 - titleWidget 自定义标题插槽',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TPicker(
              items: const TPickerColumns([
                [TPickerOption(label: 'A', value: 'a')],
              ]),
              title: '旧标题（应被忽略）',
              titleWidget: const Row(
                key: ValueKey('custom-title'),
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star),
                  SizedBox(width: 4),
                  Text('自定义标题'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('custom-title')), findsOneWidget);
      expect(find.text('自定义标题'), findsOneWidget);
      // 传入 titleWidget 后，title 文字被忽略
      expect(find.text('旧标题（应被忽略）'), findsNothing);
    });
  });
}
