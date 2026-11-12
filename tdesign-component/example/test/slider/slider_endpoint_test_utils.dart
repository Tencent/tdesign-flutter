import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../demo_page_test_utils.dart';
import 'slider_demo_test_spec.dart';

const _endpointIds = [
  'single',
  'range',
  'labeled',
  'labeled-range',
  'scale',
  'scale-range',
  'capsule',
  'capsule-range',
  'capsule-labeled-range',
  'capsule-scale',
  'capsule-scale-range',
  'vertical',
  'vertical-scale-range',
  'vertical-capsule',
  'vertical-capsule-scale-range',
];
Finder _native(String id) => find.descendant(
  of: find.byKey(ValueKey('slider-$id')),
  matching: find.byWidgetPredicate((w) => w is Slider || w is RangeSlider),
);
Rect _trackRect(WidgetTester t, Finder f) {
  final box = t.renderObject<RenderBox>(f);
  final theme = SliderTheme.of(t.element(f));
  final widget = t.widget(f);
  final discrete = widget is Slider
      ? widget.divisions != null
      : (widget as RangeSlider).divisions != null;
  return widget is Slider
      ? theme.trackShape!.getPreferredRect(
          parentBox: box,
          sliderTheme: theme,
          isEnabled: true,
          isDiscrete: discrete,
        )
      : theme.rangeTrackShape!.getPreferredRect(
          parentBox: box,
          sliderTheme: theme,
          isEnabled: true,
          isDiscrete: discrete,
        );
}

Offset _thumbCenter(WidgetTester t, Finder f, double value) {
  final box = t.renderObject<RenderBox>(f);
  final r = _trackRect(t, f);
  final rtl = Directionality.of(t.element(f)) == TextDirection.rtl;
  return box.localToGlobal(
    Offset(r.left + (rtl ? 1 - value : value) * r.width, r.center.dy),
  );
}

Future<void> moveSliderDemoToEndpoints(WidgetTester t, int end) async {
  for (final id in _endpointIds) {
    final f = _native(id);
    final w = t.widget(f);
    final box = t.renderObject<RenderBox>(f);
    final r = _trackRect(t, f);
    final rtl = Directionality.of(t.element(f)) == TextDirection.rtl;
    final minX = rtl ? r.right + 35 : r.left - 35;
    final maxX = rtl ? r.left - 35 : r.right + 35;
    if (w is Slider) {
      final from = _thumbCenter(t, f, (w.value - w.min) / (w.max - w.min));
      final to = box.localToGlobal(Offset(end == 0 ? minX : maxX, r.center.dy));
      await t.dragFrom(from, to - from);
      await t.pumpAndSettle();
      expect(
        (t.widget(f) as Slider).value,
        closeTo(end.toDouble(), .001),
        reason: id,
      );
    } else {
      var range = w as RangeSlider;
      var from = _thumbCenter(
        t,
        f,
        (range.values.start - range.min) / (range.max - range.min),
      );
      var to = box.localToGlobal(Offset(minX, r.center.dy));
      await t.dragFrom(from, to - from);
      await t.pumpAndSettle();
      range = t.widget(f) as RangeSlider;
      from = _thumbCenter(
        t,
        f,
        (range.values.end - range.min) / (range.max - range.min),
      );
      to = box.localToGlobal(Offset(maxX, r.center.dy));
      await t.dragFrom(from, to - from);
      await t.pumpAndSettle();
      range = t.widget(f) as RangeSlider;
      expect(range.values.start, 0, reason: id);
      expect(range.values.end, 100, reason: id);
    }
  }
}

DemoPageTestSpec sliderGeometryDemoSpec(
  double height,
  TextDirection direction,
) => DemoPageTestSpec(
  name: 'slider',
  title: sliderDemoPageTestSpec.title,
  page: Builder(
    builder: (context) => Theme(
      data: Theme.of(
        context,
      ).mergeExtension(TSliderThemeData(trackHeight: height)),
      child: Directionality(
        textDirection: direction,
        child: sliderDemoPageTestSpec.page,
      ),
    ),
  ),
  expectedTexts: sliderDemoPageTestSpec.expectedTexts,
  useAlignmentCjkFont: true,
  supplementalCjkFontFamily: sliderDemoPageTestSpec.supplementalCjkFontFamily,
  supplementalCjkFontPath: sliderDemoPageTestSpec.supplementalCjkFontPath,
);
