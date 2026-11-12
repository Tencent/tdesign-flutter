import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class SliderConstraintsFixture extends StatefulWidget {
  const SliderConstraintsFixture({super.key});
  @override
  State<SliderConstraintsFixture> createState() =>
      _SliderConstraintsFixtureState();
}

class _SliderConstraintsFixtureState extends State<SliderConstraintsFixture> {
  final values = <String, RangeValues>{
    for (final id in ['8', '24', '48', '320', 'resize'])
      id: const RangeValues(.2, .8),
  };
  final verticalValues = <String, double>{'normal': 35, 'capsule': 35};
  double dynamicWidth = 320;
  void resize(double width) => setState(() => dynamicWidth = width);

  Widget range(String id, double width) => SizedBox(
    height: 82,
    child: Column(
      children: [
        Text(
          'width=$id  range=${values[id]!.start.toStringAsFixed(1)}..${values[id]!.end.toStringAsFixed(1)}',
          style: const TextStyle(fontSize: 12),
        ),
        SizedBox(
          width: width,
          height: 48,
          child: TRangeSlider(
            key: ValueKey('constraints-$id'),
            value: values[id]!,
            variant: TSliderVariant.capsule,
            onChanged: (v) => setState(() => values[id] = v),
          ),
        ),
      ],
    ),
  );

  Widget vertical(String id, {required bool capsule}) => Builder(
    builder: (context) {
      final inherited = Theme.of(context);
      final theme = capsule
          ? inherited.mergeExtension(
              context.tTheme.copyWith(spacerMap: const {'spacer3': 240}),
            )
          : inherited.mergeExtension(const TSliderThemeData(trackHeight: 192));
      return Theme(
        data: theme,
        // Ordinary consumer composition: public theme + constrained rotated slider.
        // These are Flutter container dimensions, not a TSlider length option.
        child: Column(
          children: [
            Text(
              capsule ? 'capsule: spacer3 = 240' : 'normal: trackHeight = 192',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'value: ${verticalValues[id]!.round()}',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 48,
              height: 232,
              child: RotatedBox(
                quarterTurns: 1,
                child: TSlider(
                  key: ValueKey('constraints-vertical-$id'),
                  value: verticalValues[id]!,
                  max: 100,
                  variant: capsule
                      ? TSliderVariant.capsule
                      : TSliderVariant.normal,
                  onChanged: (v) => setState(() => verticalValues[id] = v),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SizedBox(height: 16),
      const Text(
        'Narrow ranges: drag to 0, then back to 0.4',
        style: TextStyle(fontSize: 14),
      ),
      const SizedBox(height: 12),
      for (final width in [8, 24, 48, 320]) range('$width', width.toDouble()),
      const Text(
        'Resize during one gesture: 320 -> 8 -> 24',
        style: TextStyle(fontSize: 14),
      ),
      range('resize', dynamicWidth),
      const Text(
        'Test container: 48px wide x 232px tall',
        style: TextStyle(fontSize: 14),
      ),
      const Text(
        'Flutter layout; no slider length parameter',
        style: TextStyle(fontSize: 12),
      ),
      const SizedBox(height: 18),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          vertical('normal', capsule: false),
          vertical('capsule', capsule: true),
        ],
      ),
      const SizedBox(height: 28),
      const Text(
        'Test container height: 8px',
        style: TextStyle(fontSize: 12),
      ),
      const SizedBox(height: 16),
      SizedBox(
        width: 320,
        height: 8,
        child: TSlider(value: .4, onChanged: (_) {}),
      ),
    ],
  );
}

Future<void> exerciseSliderConstraintsFixture(
  WidgetTester t,
  int endpoint,
) async {
  Finder native(String id) => find.descendant(
    of: find.byKey(ValueKey('constraints-$id')),
    matching: find.byWidgetPredicate((w) => w is Slider || w is RangeSlider),
  );
  Offset at(String id, double ratio) {
    final f = native(id),
        box = t.renderObject<RenderBox>(f),
        theme = SliderTheme.of(t.element(f));
    final rect = t.widget(f) is Slider
        ? theme.trackShape!.getPreferredRect(parentBox: box, sliderTheme: theme)
        : theme.rangeTrackShape!.getPreferredRect(
            parentBox: box,
            sliderTheme: theme,
          );
    return box.localToGlobal(
      Offset(rect.left + ratio * rect.width, rect.center.dy),
    );
  }

  for (final id in ['8', '24', '48', '320']) {
    final gesture = await t.startGesture(at(id, .2));
    await gesture.moveBy(const Offset(-40, 0));
    await t.pumpAndSettle();
    await gesture.moveTo(at(id, .4));
    await t.pumpAndSettle();
    await gesture.up();
    await t.pumpAndSettle();
    expect(t.widget<RangeSlider>(native(id)).values.start, closeTo(.4, 1e-9));
  }
  final state = t.state<_SliderConstraintsFixtureState>(
    find.byType(SliderConstraintsFixture),
  );
  final gesture = await t.startGesture(at('resize', .2));
  await gesture.moveBy(const Offset(-40, 0));
  await t.pumpAndSettle();
  state.resize(8);
  await t.pumpAndSettle();
  await gesture.moveTo(at('resize', .4));
  await t.pumpAndSettle();
  expect(state.values['resize']!.start, closeTo(.4, 1e-9));
  state.resize(24);
  await t.pumpAndSettle();
  await gesture.moveTo(at('resize', .4));
  await t.pumpAndSettle();
  await gesture.up();
  await t.pumpAndSettle();
  for (final id in ['vertical-normal', 'vertical-capsule']) {
    final from = at(id, .35), to = at(id, endpoint / 100);
    await t.dragFrom(from, to - from);
    await t.pumpAndSettle();
    expect(
      t.widget<Slider>(native(id)).value,
      closeTo(endpoint.toDouble(), 1e-9),
    );
    // Assert the consumer's Flutter constraints, without consulting internal metrics.
    final box = t.renderObject<RenderBox>(native(id));
    expect(box.size, const Size(232, 48));
  }
  expect(t.takeException(), isNull);
}
