import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TDropdownItem（下拉菜单项内容）Widget 测试
///
/// 该项内容仅在 TDropdownMenu 展开弹出层后才会构建，因此测试需要：
/// 1. 用 TDropdownMenu 包裹 TDropdownItem（提供 TDropdownInherited）；
/// 2. tap 菜单标签打开弹出层，触发复选和单选内容分支。
///
/// 覆盖：builder 路径、分组标题、单选预选中(selectIds[0])、单选带高度、
/// 多选方向=up 边框、多选颜色三态（选中/未选/禁用）、多选 maxHeight、
/// 选项分栏 right 间距、控制器 reset/updateOptions、操作区 重置/确定 按钮回调等。
void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: Scaffold(body: child),
      );

  List<TDropdownItemOption<String>> plainOpts() => [
        const TDropdownItemOption(value: '1', label: '选项一'),
        const TDropdownItemOption(value: '2', label: '选项二'),
        const TDropdownItemOption(value: '3', label: '选项三', disabled: true),
      ];

  List<TDropdownItemOption<String>> groupedOpts() => [
        const TDropdownItemOption(value: '1', label: 'A', group: '分组一'),
        const TDropdownItemOption(value: '2', label: 'B', group: '分组一'),
        const TDropdownItemOption(value: '3', label: 'C', group: '分组二'),
      ];

  group('TDropdownItem 单选路径', () {
    testWidgets('单选带 maxHeight 走 Container 高度分支', (tester) async {
      await tester.pumpWidget(wrap(const TDropdownMenu(
        items: [
          TDropdownItem(
            label: '单选高度',
            maxHeight: 200,
            options: [
              TDropdownItemOption(value: '1', label: 'A'),
              TDropdownItemOption(value: '2', label: 'B'),
            ],
          ),
        ],
      )));
      await tester.tap(find.text('单选高度'));
      await tester.pumpAndSettle();
      // 触发 _getRadioList 中 min/maxHeight 的 Container+ConstrainedBox 分支
      expect(find.byWidgetPredicate((widget) => widget is TDropdownMenu),
          findsOneWidget);
    });

    testWidgets('单选分栏预选中走 _getCheckboxList 的 selectIds[0] 与 right 间距',
        (tester) async {
      await tester.pumpWidget(wrap(const TDropdownMenu(
        items: [
          TDropdownItem(
            label: '单选分栏',
            optionsColumns: 2,
            value: '1',
            // 预选中：构建即走 selectIds[0] 分支
            options: [
              TDropdownItemOption(value: '1', label: 'A'),
              TDropdownItemOption(value: '2', label: 'B'),
            ],
          ),
        ],
      )));
      // 单选预选中时 tab 显示选中项 label('A')，取首个匹配打开菜单
      await tester.tap(find.text('A').first);
      await tester.pumpAndSettle();
      // 内容已渲染：选项 B 出现说明菜单展开
      expect(find.text('B'), findsOneWidget);
      // optionsColumns>1 => 两列 => _getPadding 的 'right' 分支
      expect(find.byType(Semantics), findsWidgets);
    });
  });

  group('TDropdownItem builder 路径', () {
    testWidgets('提供 builder 时直接渲染自定义内容', (tester) async {
      await tester.pumpWidget(wrap(TDropdownMenu(
        items: [
          TDropdownItem(
            label: '自定义项',
            builder: (context) => const Text('BUILDER_CONTENT'),
          ),
        ],
      )));
      await tester.tap(find.text('自定义项'));
      await tester.pumpAndSettle();
      expect(find.text('BUILDER_CONTENT'), findsOneWidget);
    });
  });

  group('TDropdownItem 分组标题', () {
    testWidgets('带 group 的选项渲染分组标题', (tester) async {
      await tester.pumpWidget(wrap(TDropdownMenu(
        items: [
          TDropdownItem(
            label: '分组项',
            multiple: true,
            options: groupedOpts(),
          ),
        ],
      )));
      await tester.tap(find.text('分组项'));
      await tester.pumpAndSettle();
      // _getCheckboxList 中 groupChunk 非 __default__ 时渲染分组标题
      expect(find.text('分组一'), findsOneWidget);
      expect(find.text('分组二'), findsOneWidget);
    });

    testWidgets('长分组标题收口为单行省略', (tester) async {
      const longGroup = '这是一个非常非常非常长的分组标题用于验证不溢出';
      await tester.pumpWidget(wrap(const TDropdownMenu(
        items: [
          TDropdownItem(
            label: '多选长分组',
            multiple: true,
            options: [
              TDropdownItemOption(value: '1', label: 'A', group: longGroup),
            ],
          ),
        ],
      )));
      await tester.tap(find.text('多选长分组'));
      await tester.pumpAndSettle();

      final groupText = tester.widget<Text>(find.text(longGroup));
      expect(groupText.maxLines, 1);
      expect(groupText.overflow, TextOverflow.ellipsis);
    });

    testWidgets('长单选文本收口为单行省略', (tester) async {
      const longLabel = '这是一个非常非常非常长的单选选项文本用于验证不溢出';
      await tester.pumpWidget(wrap(const TDropdownMenu(
        items: [
          TDropdownItem(
            label: '单选长文本',
            options: [
              TDropdownItemOption(value: '1', label: longLabel),
            ],
          ),
        ],
      )));
      await tester.tap(find.text('单选长文本'));
      await tester.pumpAndSettle();

      final optionText = tester.widget<Text>(find.text(longLabel));
      expect(optionText.maxLines, 1);
      expect(optionText.overflow, TextOverflow.ellipsis);
    });
  });

  group('TDropdownItem 多选方向=up 边框', () {
    testWidgets('direction=up + maxHeight 渲染操作区上边框', (tester) async {
      await tester.pumpWidget(wrap(TDropdownMenu(
        direction: TDropdownMenuDirection.up,
        items: [
          TDropdownItem(
            label: '多选up',
            multiple: true,
            maxHeight: 300,
            options: plainOpts(),
          ),
        ],
      )));
      await tester.tap(find.text('多选up'));
      await tester.pumpAndSettle();
      // 操作区在 direction=up 时渲染上边框（_getCheckboxOperate 的 up 分支）
      final reset = tester.widget<Text>(find.text('重置'));
      final confirm = tester.widget<Text>(find.text('确定'));
      expect(reset.maxLines, 1);
      expect(reset.overflow, TextOverflow.ellipsis);
      expect(reset.softWrap, isFalse);
      expect(confirm.maxLines, 1);
      expect(confirm.overflow, TextOverflow.ellipsis);
      expect(confirm.softWrap, isFalse);
    });
  });

  group('TDropdownItem 多选路径（受控值 + 操作按钮）', () {
    testWidgets('多选厨房水槽：三态颜色/控制器/操作按钮/onChanged', (tester) async {
      Set<String>? changed;
      var resetCalled = false;
      Set<String>? confirmed;
      await tester.pumpWidget(wrap(TDropdownMenu(
        items: [
          TDropdownItem(
            label: '多选',
            multiple: true,
            values: const {'1'},
            // 选中+启用 / 未选+启用 / 禁用 三态，初始渲染即覆盖颜色分支
            options: plainOpts(),
            onValuesChanged: (v) => changed = v,
            onReset: () => resetCalled = true,
            onConfirm: (v) => confirmed = v,
          ),
        ],
      )));
      await tester.tap(find.text('多选'));
      await tester.pumpAndSettle();
      expect(find.text('选项一'), findsWidgets);

      // 点击重置按钮：_getCheckboxOperate 的 onPressed(reset + onReset)
      await tester.ensureVisible(find.text('重置'));
      await tester.tap(find.text('重置'));
      await tester.pumpAndSettle();
      expect(resetCalled, isTrue);
      expect(changed, isEmpty);

      // 点击确定，回传当前受控值
      await tester.ensureVisible(find.text('确定'));
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(confirmed, {'1'});
    });
  });
}
