import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget scene(Widget child) {
    return MaterialApp(
      theme: TThemeBuilder.light(TThemeData.defaultData()),
      home: Scaffold(
        body: Center(child: SizedBox(width: 320, child: child)),
      ),
    );
  }

  testWidgets('TSlider Material golden', (tester) async {
    await tester.pumpWidget(scene(Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TSlider(value: 0.35, onChanged: (_) {}),
        const TSlider(value: 0.65),
        TRangeSlider(
          value: const RangeValues(0.2, 0.8),
          onChanged: (_) {},
        ),
        const TRangeSlider(value: RangeValues(0.3, 0.7)),
      ],
    )));
    await expectLater(
      find.byType(Column),
      matchesGoldenFile('goldens/t_slider_material.png'),
    );
  });
}
