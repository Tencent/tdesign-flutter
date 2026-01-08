import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  testWidgets('TDMultiCascader works inside SingleChildScrollView', (WidgetTester tester) async {
    final data = [
      {
        "value": "1",
        "label": "Dept 1",
        "children": [
          {"value": "1-1", "label": "Dept 1-1"},
        ]
      },
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: TDMultiCascader(
              title: 'Test',
              cascaderHeight: 400,
              data: data,
              onChange: (value) {},
            ),
          ),
        ),
      ),
    );

    // If it renders without throwing exception, it passed.
    expect(find.text('Test'), findsOneWidget);
    expect(find.text('Dept 1'), findsOneWidget);
    expect(find.byType(TDMultiCascader), findsOneWidget);
  });

  testWidgets('TDMultiCascader with initialIndexes', (WidgetTester tester) async {
    final data = [
      {
        "value": "1",
        "label": "Province 1",
        "children": [
          {
            "value": "1-1",
            "label": "City 1-1",
            "children": [
              {"value": "1-1-1", "label": "District 1-1-1"},
              {"value": "1-1-2", "label": "District 1-1-2"},
            ]
          },
          {"value": "1-2", "label": "City 1-2"},
        ]
      },
      {"value": "2", "label": "Province 2"},
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TDMultiCascader(
            title: 'Test with initialIndexes',
            cascaderHeight: 400,
            data: data,
            initialIndexes: [0, 0, 1],
            onChange: (value) {},
          ),
        ),
      ),
    );

    // Wait for initialization
    await tester.pumpAndSettle();

    // Verify the widget renders
    expect(find.byType(TDMultiCascader), findsOneWidget);
    expect(find.text('Test with initialIndexes'), findsOneWidget);
  });

  testWidgets('TDMultiCascader with empty initialIndexes', (WidgetTester tester) async {
    final data = [
      {
        "value": "1",
        "label": "Item 1",
        "children": [
          {"value": "1-1", "label": "Item 1-1"},
        ]
      },
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TDMultiCascader(
            title: 'Test empty initialIndexes',
            cascaderHeight: 400,
            data: data,
            initialIndexes: [],
            onChange: (value) {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Should still render without error
    expect(find.byType(TDMultiCascader), findsOneWidget);
    expect(find.text('Test empty initialIndexes'), findsOneWidget);
  });

  testWidgets('TDMultiCascader with invalid initialIndexes', (WidgetTester tester) async {
    final data = [
      {
        "value": "1",
        "label": "Item 1",
        "children": [
          {"value": "1-1", "label": "Item 1-1"},
        ]
      },
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TDMultiCascader(
            title: 'Test invalid initialIndexes',
            cascaderHeight: 400,
            data: data,
            initialIndexes: [10, 20, 30], // Invalid indexes
            onChange: (value) {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Should still render without crashing
    expect(find.byType(TDMultiCascader), findsOneWidget);
    expect(find.text('Test invalid initialIndexes'), findsOneWidget);
  });
}
