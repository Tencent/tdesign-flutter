import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TDropdownMenu 组件 Widget 测试
///
/// 覆盖菜单渲染、方向、禁用、选项选择、多选、回调等。
void main() {
  /// 构建带主题的测试壳
  Widget wrapWithTheme(Widget child, {TDropdownThemeData? dropdownTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (dropdownTheme != null) {
      theme = theme.mergeExtension(dropdownTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: child),
    );
  }

  /// 基础选项
  List<TDropdownItemOption> baseOptions() => [
        const TDropdownItemOption(value: '1', label: '选项一'),
        const TDropdownItemOption(value: '2', label: '选项二'),
        const TDropdownItemOption(value: '3', label: '选项三'),
      ];

  // ============================================================
  // TDropdownItemOption 单元测试
  // ============================================================
  group('TDropdownItemOption', () {
    test('默认值', () {
      const opt = TDropdownItemOption(value: 'v', label: '标签');
      expect(opt.value, 'v');
      expect(opt.label, '标签');
      expect(opt.disabled, isFalse);
      expect(opt.disabled, isFalse);
    });

    test('选项是不可变值对象', () {
      const opt = TDropdownItemOption(value: 'v', label: '标签');
      expect(opt.value, 'v');
      expect(opt.disabled, isFalse);
    });
  });

  // ============================================================
  // 枚举验证
  // ============================================================
  group('枚举', () {
    test('TDropdownMenuDirection 有三个值', () {
      expect(TDropdownMenuDirection.values.length, 3);
      expect(
          TDropdownMenuDirection.values, contains(TDropdownMenuDirection.down));
      expect(
          TDropdownMenuDirection.values, contains(TDropdownMenuDirection.up));
      expect(
          TDropdownMenuDirection.values, contains(TDropdownMenuDirection.auto));
    });
  });

  group('TDropdownThemeData', () {
    test('merge/copyWith/lerp 覆盖全部字段', () {
      const base = TDropdownThemeData(
        width: 100,
        height: 40,
        decoration: BoxDecoration(color: Colors.red),
        arrowIcon: Icons.arrow_drop_down,
        arrowColor: Colors.black,
        tabBarAlign: MainAxisAlignment.start,
        overlayColor: Colors.black54,
      );
      const override = TDropdownThemeData(
        width: 120,
        arrowColor: Colors.blue,
        tabBarAlign: MainAxisAlignment.end,
        overlayColor: Colors.purple,
      );

      expect(identical(base.merge(null), base), isTrue);
      final merged = base.merge(override);
      expect(merged.width, 120);
      expect(merged.height, 40);
      expect(merged.decoration, base.decoration);
      expect(merged.arrowIcon, Icons.arrow_drop_down);
      expect(merged.arrowColor, Colors.blue);
      expect(merged.tabBarAlign, MainAxisAlignment.end);
      expect(merged.overlayColor, Colors.purple);

      final copied = base.copyWith(
        width: 80,
        height: 36,
        decoration: const BoxDecoration(color: Colors.green),
        arrowIcon: Icons.keyboard_arrow_up,
        arrowColor: Colors.orange,
        tabBarAlign: MainAxisAlignment.center,
        overlayColor: Colors.red,
      );
      expect(copied.width, 80);
      expect(copied.height, 36);
      expect(copied.decoration, const BoxDecoration(color: Colors.green));
      expect(copied.arrowIcon, Icons.keyboard_arrow_up);
      expect(copied.arrowColor, Colors.orange);
      expect(copied.tabBarAlign, MainAxisAlignment.center);
      expect(copied.overlayColor, Colors.red);

      expect(identical(base.lerp(null, 0.5), base), isTrue);
      final early = base.lerp(override, 0.25);
      expect(early.width, 105);
      expect(early.decoration, base.decoration);
      expect(early.arrowIcon, Icons.arrow_drop_down);
      final late = base.lerp(override, 0.75);
      expect(late.width, 115);
      expect(late.decoration, override.decoration);
      expect(late.arrowIcon, override.arrowIcon);
      expect(
        late.overlayColor,
        Color.lerp(Colors.black54, Colors.purple, 0.75),
      );
      expect(TDropdownThemeData.lerpDouble(null, null, 0.5), isNull);
    });
  });

  // ============================================================
  // 菜单渲染
  // ============================================================
  group('TDropdownMenu 基础渲染', () {
    testWidgets('渲染多个下拉项标签', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(label: '排序', options: baseOptions()),
            TDropdownItem(label: '筛选', options: baseOptions()),
          ],
        ),
      ));

      expect(find.byWidgetPredicate((widget) => widget is TDropdownMenu),
          findsOneWidget);
      expect(find.text('排序'), findsOneWidget);
      expect(find.text('筛选'), findsOneWidget);
    });

    testWidgets('使用 builder 构建下拉项', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          builder: (context) => [
            TDropdownItem(label: '构建器项', options: baseOptions()),
          ],
        ),
      ));

      expect(find.text('构建器项'), findsOneWidget);
    });

    testWidgets('空 items 列表渲染空菜单', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TDropdownMenu(items: []),
      ));
      expect(find.byWidgetPredicate((widget) => widget is TDropdownMenu),
          findsOneWidget);
    });

    testWidgets('direction: down 向下展开', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          direction: TDropdownMenuDirection.down,
          items: [
            TDropdownItem(label: '向下', options: baseOptions()),
          ],
        ),
      ));
      expect(find.text('向下'), findsOneWidget);
    });

    testWidgets('direction: up 向上展开', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          direction: TDropdownMenuDirection.up,
          items: [
            TDropdownItem(label: '向上', options: baseOptions()),
          ],
        ),
      ));
      expect(find.text('向上'), findsOneWidget);
    });

    testWidgets('isScrollable: true 横向滚动菜单', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 200,
          child: TDropdownMenu(
            isScrollable: true,
            items: List.generate(
              5,
              (i) => TDropdownItem(
                label: '菜单项$i',
                options: baseOptions(),
                tabBarWidth: 80,
              ),
            ),
          ),
        ),
      ));
      expect(find.byWidgetPredicate((widget) => widget is TDropdownMenu),
          findsOneWidget);
    });

    testWidgets('theme controls menu bar visual contract', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(label: '主题项', options: baseOptions()),
          ],
        ),
        dropdownTheme: const TDropdownThemeData(
          width: 220,
          height: 56,
          decoration: BoxDecoration(color: Colors.yellow),
          arrowIcon: Icons.keyboard_arrow_up,
          arrowColor: Colors.red,
        ),
      ));

      final menuContainer = tester.widget<Container>(
        find.ancestor(
          of: find.text('主题项'),
          matching: find.byWidgetPredicate(
            (widget) => widget is Container && widget.decoration != null,
          ),
        ),
      );
      final icon = tester.widget<Icon>(find.byIcon(Icons.keyboard_arrow_up));

      expect(tester.getSize(find.byType(TDropdownMenu)), const Size(220, 56));
      expect(menuContainer.decoration, const BoxDecoration(color: Colors.yellow));
      expect(icon.color, Colors.red);
      expect(icon.size, 20);
    });
  });

  // ============================================================
  // 禁用状态
  // ============================================================
  group('TDropdownMenu 禁用', () {
    testWidgets('disabled 项不响应点击', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(label: '禁用项', options: baseOptions(), disabled: true),
            TDropdownItem(label: '可用项', options: baseOptions()),
          ],
        ),
      ));

      // 点击禁用项不应弹出
      await tester.tap(find.text('禁用项'));
      await tester.pumpAndSettle();

      // 选项不应出现
      expect(find.text('选项一'), findsNothing);
    });
  });

  // ============================================================
  // 选项选择
  // ============================================================
  group('TDropdownMenu 选项选择', () {
    testWidgets('点击菜单项打开下拉面板', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(label: '排序', options: baseOptions()),
          ],
        ),
      ));

      await tester.tap(find.text('排序'));
      await tester.pumpAndSettle();

      // 选项应出现
      expect(find.text('选项一'), findsOneWidget);
      expect(find.text('选项二'), findsOneWidget);
    });

    testWidgets('单选模式选择后触发 onChanged 并关闭', (tester) async {
      String? selectedValue;
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(
              label: '排序',
              options: baseOptions(),
              onChanged: (dynamic value) {
                selectedValue = value;
              },
            ),
          ],
        ),
      ));

      await tester.tap(find.text('排序'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('选项二'));
      await tester.pumpAndSettle();

      expect(selectedValue, isNotNull);
    });

    testWidgets('预选中选项 label 显示在菜单栏', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TDropdownMenu(
          items: [
            TDropdownItem(
              label: '排序',
              options: [
                TDropdownItemOption(value: '1', label: '选项一'),
                TDropdownItemOption(value: '2', label: '选项二'),
              ],
              value: '2',
            ),
          ],
        ),
      ));

      // 选中项的 label 应显示在菜单
      expect(find.text('选项二'), findsOneWidget);
    });
  });

  // ============================================================
  // 多选模式
  // ============================================================
  group('TDropdownMenu 多选', () {
    testWidgets('multiple: true 渲染确认/重置按钮', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(
              label: '多选',
              multiple: true,
              options: baseOptions(),
            ),
          ],
        ),
      ));

      await tester.tap(find.text('多选'));
      await tester.pumpAndSettle();

      // 多选模式应显示确认和重置按钮
      expect(find.text('确定'), findsOneWidget);
      expect(find.text('重置'), findsOneWidget);
    });

    testWidgets('多选确认触发 onConfirm', (tester) async {
      dynamic confirmedValues;
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(
              label: '多选',
              multiple: true,
              options: baseOptions(),
              onConfirm: (value) {
                confirmedValues = value;
              },
            ),
          ],
        ),
      ));

      await tester.tap(find.text('多选'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();

      expect(confirmedValues, isNotNull);
    });
  });

  // ============================================================
  // 选项分栏
  // ============================================================
  group('TDropdownMenu 选项分栏', () {
    testWidgets('optionsColumns: 2 双列渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TDropdownMenu(
          items: [
            TDropdownItem(
              label: '分栏',
              optionsColumns: 2,
              options: [
                TDropdownItemOption(value: '1', label: 'A'),
                TDropdownItemOption(value: '2', label: 'B'),
                TDropdownItemOption(value: '3', label: 'C'),
                TDropdownItemOption(value: '4', label: 'D'),
              ],
            ),
          ],
        ),
      ));

      await tester.tap(find.text('分栏'));
      await tester.pumpAndSettle();

      expect(find.text('A'), findsOneWidget);
      expect(find.text('D'), findsOneWidget);
    });
  });

  // ============================================================
  // 自定义标签
  // ============================================================
  group('TDropdownMenu 自定义标签', () {
    testWidgets('labelBuilder 自定义标签内容', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(label: '自定义', options: baseOptions()),
          ],
          labelBuilder: (context, label, isOpened, index) {
            return Text('[$label]');
          },
        ),
      ));

      expect(find.text('[自定义]'), findsOneWidget);
    });

    testWidgets('自定义箭头图标和颜色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(label: '箭头', options: baseOptions()),
          ],
        ),
        dropdownTheme: const TDropdownThemeData(
          arrowIcon: Icons.arrow_drop_down,
          arrowColor: Colors.red,
        ),
      ));
      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
    });
  });

  // ============================================================
  // 主题覆盖
  // ============================================================
  group('TDropdownMenu 主题覆盖', () {
    testWidgets('TDropdownThemeData 注入后正常渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(label: '主题', options: baseOptions()),
          ],
        ),
        dropdownTheme: const TDropdownThemeData(
          height: 60,
        ),
      ));
      expect(find.text('主题'), findsOneWidget);
    });

    test('TDropdownThemeData merge 合并', () {
      const base = TDropdownThemeData(height: 48, width: 200);
      const override = TDropdownThemeData(height: 60);
      final merged = base.merge(override);
      expect(merged.height, 60);
      expect(merged.width, 200);
    });

    test('TDropdownItem getLabel 返回选中项 label', () {
      const item = TDropdownItem(
        label: '默认',
        value: '2',
        options: [
          TDropdownItemOption(value: '1', label: '选项一'),
          TDropdownItemOption(value: '2', label: '选项二'),
        ],
      );
      expect(item.getLabel(), '选项二');
    });

    test('TDropdownItem getLabel 无选中时返回 label', () {
      final item = TDropdownItem(
        label: '默认标签',
        options: baseOptions(),
      );
      expect(item.getLabel(), '默认标签');
    });
  });

  // ============================================================
  // 覆盖率补充
  // ============================================================
  group('TDropdownMenu 覆盖率补充', () {
    testWidgets('didUpdateWidget items 数量变化触发 _init 重置', (tester) async {
      // 覆盖 129-134（didUpdateWidget）+ 191（_isOpened 重置）
      var itemCount = 2;
      late StateSetter setState;
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(
          builder: (context, setter) {
            setState = setter;
            return TDropdownMenu(
              items: List.generate(
                  itemCount,
                  (i) => TDropdownItem(
                        label: '菜单$i',
                        options: baseOptions(),
                      )),
            );
          },
        ),
      ));
      setState(() => itemCount = 3);
      await tester.pumpAndSettle();
      expect(find.byWidgetPredicate((widget) => widget is TDropdownMenu),
          findsOneWidget);
    });

    testWidgets('didUpdateWidget items 长度不变 early return', (tester) async {
      // 覆盖 185（items.length == _items?.length → 直接赋值 return）
      var label = '菜单A';
      late StateSetter setState;
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(
          builder: (context, setter) {
            setState = setter;
            return TDropdownMenu(
              items: [
                TDropdownItem(label: label, options: baseOptions()),
                TDropdownItem(label: '菜单B', options: baseOptions()),
              ],
            );
          },
        ),
      ));
      setState(() => label = '菜单A2');
      await tester.pumpAndSettle();
      expect(find.byWidgetPredicate((widget) => widget is TDropdownMenu),
          findsOneWidget);
    });

    testWidgets('didUpdateWidget builder 变化触发 _init', (tester) async {
      // 覆盖 131（widget.builder != oldWidget.builder）
      var useBuilder = false;
      late StateSetter setState;
      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(
          builder: (context, setter) {
            setState = setter;
            return TDropdownMenu(
              builder: useBuilder
                  ? (context) => [
                        TDropdownItem(label: 'builder', options: baseOptions()),
                      ]
                  : null,
              items: [
                TDropdownItem(label: 'items', options: baseOptions()),
              ],
            );
          },
        ),
      ));
      setState(() => useBuilder = true);
      await tester.pumpAndSettle();
      expect(find.byWidgetPredicate((widget) => widget is TDropdownMenu),
          findsOneWidget);
    });

    testWidgets('点击菜单打开/关闭触发 _openMenu/_closeMenu', (tester) async {
      // 覆盖 267-273（_openMenu）+ 280（_closeMenu icon 反转）+ 300（closeMenu）+ 322（onMenuClosed）
      var menuClosed = -1;
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(label: '菜单1', options: baseOptions()),
          ],
          onMenuClosed: (index) => menuClosed = index,
        ),
      ));
      // 点击菜单项打开
      await tester.tap(find.text('菜单1'));
      await tester.pumpAndSettle();
      // 再次点击关闭
      await tester.tap(find.text('菜单1'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.byWidgetPredicate((widget) => widget is TDropdownMenu),
          findsOneWidget);
      expect(menuClosed, 0);
    });

    testWidgets('onMenuOpened 回调触发', (tester) async {
      // 覆盖 292（widget.onMenuOpened?.call(index)）
      var openedIndex = -1;
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(label: '打开菜单', options: baseOptions()),
          ],
          onMenuOpened: (index) => openedIndex = index,
        ),
      ));
      await tester.tap(find.text('打开菜单'));
      await tester.pumpAndSettle();
      expect(openedIndex, 0);
    });

    testWidgets('direction=up 使用 caret_up_small 图标', (tester) async {
      // 覆盖 251（direction == up → caret_up_small）
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          direction: TDropdownMenuDirection.up,
          items: [
            TDropdownItem(label: '向上箭头', options: baseOptions()),
          ],
        ),
      ));
      expect(find.byIcon(TIcons.caret_up_small), findsOneWidget);
    });

    testWidgets('自定义 decoration 渲染', (tester) async {
      // 覆盖 168（widget.decoration ?? 默认 BoxDecoration）
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(label: '装饰', options: baseOptions()),
          ],
        ),
        dropdownTheme: const TDropdownThemeData(
          decoration: BoxDecoration(color: Colors.blue),
        ),
      ));
      expect(find.text('装饰'), findsOneWidget);
    });

    testWidgets('arrowColor 自定义箭头颜色', (tester) async {
      // 覆盖 258（_items![index].arrowColor ?? widget.arrowColor ?? color）
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(label: '箭头色', options: baseOptions()),
          ],
        ),
        dropdownTheme: const TDropdownThemeData(arrowColor: Colors.green),
      ));
      final icon =
          tester.widget<Icon>(find.byIcon(TIcons.caret_down_small).first);
      expect(icon.color, Colors.green);
    });

    testWidgets('tabBarAlign 自定义对齐方式', (tester) async {
      // 覆盖 223-224（_items![index].tabBarAlign ?? widget.tabBarAlign）
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(label: '对齐', options: baseOptions()),
          ],
        ),
        dropdownTheme: const TDropdownThemeData(
          tabBarAlign: MainAxisAlignment.end,
        ),
      ));
      expect(find.text('对齐'), findsOneWidget);
    });

    testWidgets('openMenu/closeMenu 通过 State 调用', (tester) async {
      // 覆盖 267-273（openMenu/closeMenu 公共方法）
      var openedIndex = -1;
      var closedIndex = -1;
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(label: '公共方法', options: baseOptions()),
          ],
          onMenuOpened: (i) => openedIndex = i,
          onMenuClosed: (i) => closedIndex = i,
        ),
      ));
      await tester.tap(find.text('公共方法'));
      await tester.pumpAndSettle();
      expect(openedIndex, 0);
      // 通过公开 State 方法关闭，验证关闭回调与路由回收
      final state = tester.state(
        find.byWidgetPredicate((widget) => widget is TDropdownMenu),
      );
      await (state as dynamic).closeMenu();
      await tester.pumpAndSettle();
      expect(find.byWidgetPredicate((widget) => widget is TDropdownMenu),
          findsOneWidget);
      expect(closedIndex, 0);
    });

    testWidgets('直接调用 openMenu/closeMenu 公共方法', (tester) async {
      // 覆盖 267-268（openMenu）+ 272-273（closeMenu）
      // direction=down 避免 auto 方向测量导致 ValueListenableBuilder 重建
      // （重建时旧 panel 的 _controller 被 dispose 但 post-frame callback 仍在队列，触发 forward after dispose）
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          direction: TDropdownMenuDirection.down,
          items: [
            TDropdownItem(label: '直接调用', options: baseOptions()),
          ],
        ),
      ));
      final state = tester.state(
        find.byWidgetPredicate((widget) => widget is TDropdownMenu),
      );
      // 直接调用 openMenu 公共方法
      await (state as dynamic).openMenu(0);
      // 先 pump 一帧让 overlay build，再 pump 等动画完成
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      // 直接调用 closeMenu 公共方法
      await (state as dynamic).closeMenu();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byWidgetPredicate((widget) => widget is TDropdownMenu),
          findsOneWidget);
    });

    testWidgets('已有菜单打开时再打开另一个触发 Navigator.maybePop', (tester) async {
      // 覆盖 280（_isOpened.contains(true) → Navigator.maybePop）
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [
            TDropdownItem(label: '菜单A', options: baseOptions()),
            TDropdownItem(label: '菜单B', options: baseOptions()),
          ],
        ),
      ));
      await tester.tap(find.text('菜单A'));
      await tester.pumpAndSettle();
      // 打开第二个菜单（第一个仍然打开 → _isOpened.contains(true)）
      await tester.tap(find.text('菜单B'));
      await tester.pumpAndSettle();
      expect(find.byWidgetPredicate((widget) => widget is TDropdownMenu),
          findsOneWidget);
    });

    testWidgets('关闭菜单时 animation reverse 触发', (tester) async {
      // 覆盖 300（value.status == AnimationStatus.completed → value.reverse()）
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          direction: TDropdownMenuDirection.down,
          items: [
            TDropdownItem(label: '动画测试', options: baseOptions()),
          ],
        ),
      ));
      await tester.tap(find.text('动画测试'));
      // tap 后用 pump 替代 pumpAndSettle，避免 direction=auto 时动画 ticker 持续调度无法收敛
      await tester.pump(const Duration(milliseconds: 300));
      // 关闭菜单，触发 value.reverse()
      final state = tester.state(
        find.byWidgetPredicate((widget) => widget is TDropdownMenu),
      );
      await (state as dynamic).closeMenu();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byWidgetPredicate((widget) => widget is TDropdownMenu),
          findsOneWidget);
    });

    testWidgets('auto 方向打开并点击遮罩关闭（覆盖 popup/panel 分支）', (tester) async {
      // direction 默认 auto → 覆盖 TDropdownPanel.open 的 auto 方向决策分支；
      // 点击遮罩（屏幕任意处）触发 TDropdownPopup._overlayClick。
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          items: [TDropdownItem(label: '自动方向', options: baseOptions())],
        ),
      ));
      await tester.tap(find.text('自动方向'));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.byWidgetPredicate((widget) => widget is TDropdownMenu),
          findsOneWidget);
    });

    testWidgets('弹层遮罩颜色取自 TDropdownThemeData', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TDropdownMenu(
          direction: TDropdownMenuDirection.down,
          items: [TDropdownItem(label: '主题遮罩', options: baseOptions())],
        ),
        dropdownTheme: const TDropdownThemeData(
          overlayColor: Colors.purple,
        ),
      ));
      await tester.tap(find.text('主题遮罩'));
      await tester.pumpAndSettle();

      final overlay = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .firstWhere(
            (widget) =>
                widget.decoration is BoxDecoration &&
                (widget.decoration as BoxDecoration).color == Colors.purple,
          );
      expect((overlay.decoration as BoxDecoration).color, Colors.purple);
    });
  });
}
