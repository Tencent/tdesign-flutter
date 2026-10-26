import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  testWidgets('custom flex tab keeps the default bounded toolbar in a Column', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: [TThemeData.defaultData()]),
        home: const Scaffold(
          body: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TTabsBar(
                  tabs: [
                    TTab(
                      child: Column(
                        children: [Expanded(child: Text('custom'))],
                      ),
                    ),
                    TTab(text: 'Two'),
                  ],
                ),
                Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(TTabsBar)).height, 48);
    expect(tester.takeException(), isNull);
  });

  testWidgets('bounded custom tab retains flex layout, theme and selection', (
    tester,
  ) async {
    int? tapped;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: [TThemeData.defaultData()],
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.purple),
          ),
        ),
        home: Scaffold(
          body: Center(
            child: DefaultTabController(
              length: 2,
              child: SizedBox(
                height: 48,
                width: 320,
                child: TTabsBar(
                  onTap: (index) => tapped = index,
                  tabs: [
                    TTab(
                      child: Column(
                        children: [
                          Expanded(
                            child: Builder(
                              builder: (context) => Text(
                                'custom',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const TTab(text: 'Two'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(TTabsBar)).height, 48);
    expect(
      tester.widget<Text>(find.text('custom')).style!.color,
      Colors.purple,
    );
    await tester.tap(find.text('Two'));
    await tester.pumpAndSettle();
    expect(tapped, 1);
    expect(tester.takeException(), isNull);
  });
}
