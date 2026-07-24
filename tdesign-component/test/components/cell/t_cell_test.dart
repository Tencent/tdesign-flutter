import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget app(Widget child, {TCellThemeData? cellTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (cellTheme != null) {
      theme = theme.mergeExtension(cellTheme);
    }
    return MaterialApp(theme: theme, home: Scaffold(body: child));
  }

  group('TCell', () {
    testWidgets('单一 Widget 槽位完整渲染', (tester) async {
      await tester.pumpWidget(app(const TCell(
        image: Icon(Icons.image),
        prefix: Icon(Icons.star),
        title: Text('Title'),
        subtitle: Text('Subtitle'),
        note: Text('Note'),
        trailing: Icon(Icons.more_horiz),
        arrow: true,
        required: true,
      )));
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
      expect(find.text('Note'), findsOneWidget);
      expect(find.text(' *'), findsOneWidget);
      expect(find.byType(Icon), findsNWidgets(4));
    });

    testWidgets('无回调时不创建 GestureDetector', (tester) async {
      await tester.pumpWidget(app(const TCell(title: Text('Static'))));
      expect(find.byType(GestureDetector), findsNothing);
    });

    testWidgets('点击和长按回调', (tester) async {
      var taps = 0;
      var longPresses = 0;
      await tester.pumpWidget(app(TCell(
        title: const Text('Interactive'),
        onTap: () => taps++,
        onLongPress: () => longPresses++,
      )));
      await tester.tap(find.text('Interactive'));
      await tester.longPress(find.text('Interactive'));
      expect(taps, 1);
      expect(longPresses, 1);
    });

    testWidgets('按压反馈切换背景色', (tester) async {
      final gesture = await tester.startGesture(const Offset(20, 20));
      await tester.pumpWidget(app(
        TCell(title: const Text('Press'), onTap: () {}),
        cellTheme: const TCellThemeData(
          backgroundColor: Colors.white,
          pressedColor: Colors.red,
        ),
      ));
      await gesture.cancel();
      final down =
          await tester.startGesture(tester.getCenter(find.text('Press')));
      await tester.pump();
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(
        containers.any((widget) =>
            (widget.decoration as BoxDecoration?)?.color == Colors.red),
        isTrue,
      );
      await down.up();
      await tester.pump();
    });

    testWidgets('enableFeedback=false 不切换按压背景', (tester) async {
      await tester.pumpWidget(app(
        TCell(
          title: const Text('No feedback'),
          enableFeedback: false,
          onTap: () {},
        ),
        cellTheme: const TCellThemeData(pressedColor: Colors.red),
      ));
      final down = await tester.startGesture(
        tester.getCenter(find.text('No feedback')),
      );
      await tester.pump();
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(
        containers.any((widget) =>
            (widget.decoration as BoxDecoration?)?.color == Colors.red),
        isFalse,
      );
      await down.up();
    });

    for (final align in TCellAlign.values) {
      testWidgets('${align.name} 对齐可渲染', (tester) async {
        await tester.pumpWidget(app(TCell(
          title: Text(align.name),
          align: align,
        )));
        expect(find.text(align.name), findsOneWidget);
      });
    }

    testWidgets('Theme 提供高度、对齐、边框和文字样式', (tester) async {
      await tester.pumpWidget(app(
        const TCell(
          title: Text('Theme title'),
          subtitle: Text('Theme subtitle'),
          note: Text('Theme note'),
          arrow: true,
          required: true,
        ),
        cellTheme: const TCellThemeData(
          titleStyle: TextStyle(fontSize: 18),
          requiredStyle: TextStyle(color: Colors.red),
          subtitleStyle: TextStyle(fontSize: 13),
          noteStyle: TextStyle(fontSize: 12),
          arrowColor: Colors.green,
          borderColor: Colors.blue,
          backgroundColor: Colors.white,
          padding: EdgeInsets.all(8),
          align: TCellAlign.top,
          showBottomBorder: true,
          height: 80,
        ),
      ));
      expect(tester.getSize(find.byType(TCell)), const Size(800, 80));
    });

    testWidgets('默认文本使用 token 字体并限制横向溢出', (tester) async {
      const title = 'Very long title that should stay on one visual line';
      const subtitle = 'Subtitle keeps its natural wrapping behavior';
      const note = 'Very long note that should ellipsize';

      await tester.pumpWidget(app(const SizedBox(
        width: 180,
        child: TCell(
          title: Text(title),
          subtitle: Text(subtitle),
          note: Text(note),
          arrow: true,
        ),
      )));

      final titleStyle = DefaultTextStyle.of(tester.element(find.text(title)));
      final token = TThemeData.defaultData();
      expect(titleStyle.maxLines, 1);
      expect(titleStyle.overflow, TextOverflow.ellipsis);
      expect(titleStyle.softWrap, isFalse);
      expect(titleStyle.style.fontSize, token.fontBodyLarge?.size);
      expect(titleStyle.style.height, token.fontBodyLarge?.height);

      final noteStyle = DefaultTextStyle.of(tester.element(find.text(note)));
      expect(noteStyle.maxLines, 1);
      expect(noteStyle.overflow, TextOverflow.ellipsis);
      expect(noteStyle.softWrap, isFalse);
      expect(noteStyle.style.fontSize, token.fontBodyMedium?.size);
      expect(noteStyle.style.height, token.fontBodyMedium?.height);

      final subtitleStyle =
          DefaultTextStyle.of(tester.element(find.text(subtitle)));
      expect(subtitleStyle.maxLines, isNull);
      expect(subtitleStyle.style.fontSize, token.fontBodyMedium?.size);
      expect(subtitleStyle.style.height, token.fontBodyMedium?.height);
      expect(tester.takeException(), isNull);
    });

    testWidgets('显式 Text 配置可覆盖默认单行限制', (tester) async {
      const title = 'Explicitly multiline title';

      await tester.pumpWidget(app(const TCell(
        title: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.clip,
          softWrap: true,
        ),
      )));

      final text = tester.widget<Text>(find.text(title));
      expect(text.maxLines, 2);
      expect(text.overflow, TextOverflow.clip);
      expect(text.softWrap, isTrue);
    });
  });

  group('TCellGroup', () {
    const cells = [
      TCell(title: Text('A')),
      TCell(title: Text('B')),
    ];

    testWidgets('渲染标题、cells 和默认分隔线', (tester) async {
      await tester.pumpWidget(app(const TCellGroup(
        title: Text('Group'),
        cells: cells,
      )));
      expect(find.text('Group'), findsOneWidget);
      expect(find.byType(TCell), findsNWidgets(2));
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('builder 包装指定 cell', (tester) async {
      await tester.pumpWidget(app(TCellGroup(
        cells: cells,
        builder: (_, cell, index) => KeyedSubtree(
          key: ValueKey('cell-$index'),
          child: cell,
        ),
      )));
      expect(find.byKey(const ValueKey('cell-0')), findsOneWidget);
      expect(find.byKey(const ValueKey('cell-1')), findsOneWidget);
    });

    testWidgets('card 实例形态覆盖 Theme', (tester) async {
      await tester.pumpWidget(app(
        const TCellGroup(variant: TCellGroupVariant.card, cells: cells),
        cellTheme: const TCellThemeData(
          groupVariant: TCellGroupVariant.standard,
          cardBorderRadius: BorderRadius.all(Radius.circular(6)),
          cardPadding: EdgeInsets.all(4),
        ),
      ));
      expect(find.byType(TCellGroup), findsOneWidget);
    });

    testWidgets('Theme 控制组边框、末尾分隔线和标题', (tester) async {
      await tester.pumpWidget(app(
        const TCellGroup(title: Text('Group'), cells: cells),
        cellTheme: const TCellThemeData(
          groupBordered: true,
          showLastDivider: true,
          groupBorderColor: Colors.red,
          groupTitleStyle: TextStyle(fontSize: 20),
          titlePadding: EdgeInsets.all(3),
        ),
      ));
      expect(find.byType(Divider), findsNWidgets(2));
    });

    testWidgets('组标题默认使用 token 字体并限制横向溢出', (tester) async {
      const title = 'Very long cell group title that should not overflow';

      await tester.pumpWidget(app(const SizedBox(
        width: 120,
        child: TCellGroup(title: Text(title), cells: cells),
      )));

      final token = TThemeData.defaultData();
      final titleStyle = DefaultTextStyle.of(tester.element(find.text(title)));
      expect(titleStyle.maxLines, 1);
      expect(titleStyle.overflow, TextOverflow.ellipsis);
      expect(titleStyle.softWrap, isFalse);
      expect(titleStyle.style.fontSize, token.fontBodyMedium?.size);
      expect(titleStyle.style.height, token.fontBodyMedium?.height);
      expect(tester.takeException(), isNull);
    });

    testWidgets('scrollable 使用 ListView 并占满约束', (tester) async {
      await tester.pumpWidget(app(const SizedBox(
        height: 160,
        child: TCellGroup(scrollable: true, cells: cells),
      )));
      expect(find.byType(ListView), findsOneWidget);
    });
  });

  group('TCellThemeData', () {
    const a = TCellThemeData(
      titleStyle: TextStyle(fontSize: 10),
      requiredStyle: TextStyle(fontSize: 11),
      subtitleStyle: TextStyle(fontSize: 12),
      noteStyle: TextStyle(fontSize: 13),
      groupTitleStyle: TextStyle(fontSize: 14),
      arrowColor: Colors.red,
      borderColor: Colors.blue,
      groupBorderColor: Colors.green,
      backgroundColor: Colors.white,
      pressedColor: Colors.black,
      padding: EdgeInsets.all(2),
      cardBorderRadius: BorderRadius.all(Radius.circular(2)),
      cardPadding: EdgeInsets.all(3),
      titlePadding: EdgeInsets.all(4),
      align: TCellAlign.top,
      showBottomBorder: true,
      height: 40,
      groupVariant: TCellGroupVariant.standard,
      groupBordered: true,
      showLastDivider: false,
    );
    const b = TCellThemeData(
      titleStyle: TextStyle(fontSize: 20),
      requiredStyle: TextStyle(fontSize: 21),
      subtitleStyle: TextStyle(fontSize: 22),
      noteStyle: TextStyle(fontSize: 23),
      groupTitleStyle: TextStyle(fontSize: 24),
      arrowColor: Colors.blue,
      borderColor: Colors.red,
      groupBorderColor: Colors.black,
      backgroundColor: Colors.black,
      pressedColor: Colors.white,
      padding: EdgeInsets.all(4),
      cardBorderRadius: BorderRadius.all(Radius.circular(4)),
      cardPadding: EdgeInsets.all(5),
      titlePadding: EdgeInsets.all(6),
      align: TCellAlign.bottom,
      showBottomBorder: false,
      height: 60,
      groupVariant: TCellGroupVariant.card,
      groupBordered: false,
      showLastDivider: true,
    );

    test('copyWith 与 lerp 覆盖全部字段', () {
      final copied = a.copyWith(height: 50, align: TCellAlign.center);
      expect(copied.height, 50);
      expect(copied.align, TCellAlign.center);
      expect(copied.titleStyle, a.titleStyle);
      final value = a.lerp(b, 0.5);
      expect(value.titleStyle?.fontSize, 15);
      expect(value.requiredStyle?.fontSize, 16);
      expect(value.subtitleStyle?.fontSize, 17);
      expect(value.noteStyle?.fontSize, 18);
      expect(value.groupTitleStyle?.fontSize, 19);
      expect(value.arrowColor, isNotNull);
      expect(value.borderColor, isNotNull);
      expect(value.groupBorderColor, isNotNull);
      expect(value.backgroundColor, isNotNull);
      expect(value.pressedColor, isNotNull);
      expect(value.padding, const EdgeInsets.all(3));
      expect(value.cardBorderRadius, BorderRadius.circular(3));
      expect(value.cardPadding, const EdgeInsets.all(4));
      expect(value.titlePadding, const EdgeInsets.all(5));
      expect(value.align, TCellAlign.bottom);
      expect(value.showBottomBorder, false);
      expect(value.height, 50);
      expect(value.groupVariant, TCellGroupVariant.card);
      expect(value.groupBordered, false);
      expect(value.showLastDivider, true);
      expect(a.lerp(null, 0.5), same(a));
    });
  });
}
