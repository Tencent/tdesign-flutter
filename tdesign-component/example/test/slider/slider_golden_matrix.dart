import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/slider/slider_capsule_example.dart';
import 'package:tdesign_flutter_example/page/slider/slider_labeled_example.dart';
import 'package:tdesign_flutter_example/page/slider/slider_labeled_range_example.dart';
import 'package:tdesign_flutter_example/page/slider/slider_scale_example.dart';
import 'package:tdesign_flutter_example/page/slider/slider_scale_range_example.dart';
import 'package:tdesign_flutter_example/page/slider/slider_vertical_example.dart';

import '../demo_page_test_utils.dart';
import 'slider_boundary_sources.dart';
import 'slider_demo_test_spec.dart';
import 'slider_endpoint_test_utils.dart';

class SliderDefectMatrix {
  const SliderDefectMatrix(this.image, this.scenes);
  final ui.Image image;
  final List<Map<String, Object>> scenes;

  Future<void> saveEvidence(String name) async {
    final directory = Directory('test/failures')..createSync(recursive: true);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    File(
      '${directory.path}/$name.png',
    ).writeAsBytesSync(bytes!.buffer.asUint8List());
    File('${directory.path}/$name.json').writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert({
        'scenes': scenes,
        'size': [image.width, image.height],
        'scale': 1,
      }),
    );
  }
}

class _Frame {
  const _Frame(this.image, this.origin, this.name);
  final ui.Image image;
  final Offset origin;
  final String name;
}

class _Tile {
  const _Tile(this.frame, this.rect, this.label, this.vertical, this.record);
  final _Frame frame;
  final Rect rect;
  final String label;
  final bool vertical;
  final Map<String, Object> record;
}

// This packs real rendered content, without reproducing slider geometry or
// changing its layout. Sampling is explicit by defect, not a parameter product.
class _Collector {
  final frames = <_Frame>[];
  final tiles = <_Tile>[];

  Future<_Frame> grab(WidgetTester tester, Finder root, String name) async {
    final origin = tester.getTopLeft(root);
    final image = (await tester.runAsync(() async {
      final image = await tester
          .renderObject<RenderRepaintBoundary>(root)
          .toImage(pixelRatio: 1);
      if (const bool.fromEnvironment('SLIDER_REVIEW_CAPTURE')) {
        final directory = Directory('test/failures')
          ..createSync(recursive: true);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        File(
          '${directory.path}/source_$name.png',
        ).writeAsBytesSync(bytes!.buffer.asUint8List());
      }
      return image;
    }))!;
    final frame = _Frame(image, origin, name);
    frames.add(frame);
    return frame;
  }

  void add(
    WidgetTester tester,
    Finder body,
    _Frame frame, {
    required String id,
    required String label,
    required String defect,
    bool vertical = false,
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    final bounds = tester.getRect(body).shift(-frame.origin);
    final rect =
        Rect.fromLTRB(
          (bounds.left - padding.left).floorToDouble(),
          (bounds.top - padding.top).floorToDouble(),
          (bounds.right + padding.right).ceilToDouble(),
          (bounds.bottom + padding.bottom).ceilToDouble(),
        ).intersect(
          Rect.fromLTWH(
            0,
            0,
            frame.image.width.toDouble(),
            frame.image.height.toDouble(),
          ),
        );
    expect(rect.isEmpty, isFalse, reason: id);
    tiles.add(
      _Tile(frame, rect, label, vertical, {
        'id': id,
        'defect': defect,
        'source_name': frame.name,
        'source_rect': [rect.left, rect.top, rect.right, rect.bottom],
      }),
    );
  }

  Future<SliderDefectMatrix> finish(
    WidgetTester tester,
    ThemeMode mode,
    int columns,
  ) async {
    final ordered = [
      ...tiles.where((t) => !t.vertical),
      ...tiles.where((t) => t.vertical),
    ];
    const columnWidth = 410, padding = 10, caption = 38.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)
      ..drawColor(
        mode == ThemeMode.dark
            ? const Color(0xff202124)
            : const Color(0xfff3f5f8),
        BlendMode.src,
      );
    var y = 10.0;
    for (var start = 0; start < ordered.length; start += columns) {
      var height = 0.0;
      for (var i = start; i < start + columns && i < ordered.length; i++) {
        if (ordered[i].rect.height > height) {
          height = ordered[i].rect.height;
        }
      }
      for (var i = start; i < start + columns && i < ordered.length; i++) {
        final tile = ordered[i];
        final x = padding + (i - start) * columnWidth.toDouble();
        final painter = TextPainter(
          text: TextSpan(
            text: tile.label,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 13,
              color: mode == ThemeMode.dark ? Colors.white : Colors.black,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: columnWidth - padding * 2.0);
        painter.paint(canvas, Offset(x, y));
        painter.dispose();
        final target =
            Offset(
              x +
                  ((columnWidth - padding * 2 - tile.rect.width) / 2)
                      .floorToDouble(),
              y + caption + ((height - tile.rect.height) / 2).floorToDouble(),
            ) &
            tile.rect.size;
        canvas.drawImageRect(
          tile.frame.image,
          tile.rect,
          target,
          Paint()..filterQuality = FilterQuality.none,
        );
        tile.record['matrix_rect'] = [
          target.left,
          target.top,
          target.right,
          target.bottom,
        ];
      }
      y += height + caption + padding;
    }
    final picture = recorder.endRecording();
    final image = (await tester.runAsync(
      () => picture.toImage(columns * columnWidth + padding, y.ceil()),
    ))!;
    picture.dispose();
    return SliderDefectMatrix(image, ordered.map((t) => t.record).toList());
  }

  void dispose() {
    for (final frame in frames) {
      frame.image.dispose();
    }
  }
}

Finder _example(String id) => find
    .ancestor(
      of: find.byKey(ValueKey('slider-$id')),
      matching: find.byWidgetPredicate(
        (w) =>
            w is SliderLabeledExample ||
            w is SliderLabeledRangeExample ||
            w is SliderScaleExample ||
            w is SliderScaleRangeExample ||
            w is SliderCapsuleExample ||
            w is SliderVerticalExample,
      ),
    )
    .first;

Future<SliderDefectMatrix> captureSliderEndpointMatrix(
  WidgetTester tester,
  ThemeMode mode,
) async {
  final collector = _Collector();
  try {
    for (final end in [0, 100]) {
      await pumpFullDemoPage(tester, sliderDemoPageTestSpec, mode);
      await moveSliderDemoToEndpoints(tester, end);
      final frame = await collector.grab(
        tester,
        find.byKey(const ValueKey('slider-demo-page')),
        'slider_endpoint_${end}_${mode.name}',
      );
      for (final id in [
        'labeled',
        'labeled-range',
        'scale',
        'scale-range',
        'capsule',
        'capsule-labeled-range',
        'capsule-scale',
        'capsule-scale-range',
        'vertical',
        'vertical-scale-range',
        'vertical-capsule',
        'vertical-capsule-scale-range',
      ]) {
        // A full-range control has both endpoints in one scene.
        if (end == 100 && id.contains('range')) {
          continue;
        }
        collector.add(
          tester,
          _example(id),
          frame,
          id: '$id/$end',
          label: '$id\n${id.contains('range') ? 'range 0..100' : 'value $end'}',
          defect: id.startsWith('vertical')
              ? 'vertical value/tick alignment'
              : 'thumb/label endpoints and discrete gaps',
          vertical: id.startsWith('vertical'),
        );
      }
      await disposeDemoPage(tester);
    }
    expect(collector.tiles.length, 18);
    return await collector.finish(tester, mode, 3);
  } finally {
    collector.dispose();
  }
}

Future<SliderDefectMatrix> captureSliderBoundaryMatrix(
  WidgetTester tester,
  ThemeMode mode,
) async {
  final collector = _Collector();
  try {
    await pumpSliderGeometryBoundarySources(tester, mode);
    var frame = await collector.grab(
      tester,
      find.byKey(const ValueKey('geometry-boundary-source')),
      'geometry_boundary_${mode.name}',
    );
    for (final entry in [
      (
        'near-edge',
        'boundary-near-edge',
        'normal: theme trackHeight=24\nvalue 0.02; value label',
      ),
      (
        'narrow-discrete',
        'boundary-discrete-48',
        'capsule discrete range\ncontainer width=48',
      ),
    ]) {
      collector.add(
        tester,
        find.byKey(ValueKey(entry.$2)),
        frame,
        id: entry.$1,
        label: entry.$3,
        defect: entry.$1 == 'near-edge'
            ? 'thick track near endpoint'
            : 'narrow discrete paint',
        padding: entry.$1 == 'narrow-discrete'
            ? const EdgeInsets.symmetric(horizontal: 6)
            : EdgeInsets.zero,
      );
    }
    await disposeDemoPage(tester);
    await pumpFullDemoPage(
      tester,
      sliderGeometryDemoSpec(24, TextDirection.rtl),
      mode,
    );
    await moveSliderDemoToEndpoints(tester, 0);
    frame = await collector.grab(
      tester,
      find.byKey(const ValueKey('slider-demo-page')),
      'rtl_boundary_${mode.name}',
    );
    for (final id in ['scale', 'capsule-scale']) {
      collector.add(
        tester,
        _example(id),
        frame,
        id: 'rtl-$id',
        label: '$id | RTL | value 0\nnormal theme trackHeight=24',
        defect: 'RTL thumb, ticks and capsule gaps',
      );
    }
    await disposeDemoPage(tester);
    await pumpSliderConstraintBoundarySource(tester, mode);
    frame = await collector.grab(
      tester,
      find.byKey(const ValueKey('constraint-boundary-source')),
      'slider_constraints_100_${mode.name}',
    );
    collector.add(
      tester,
      find.byKey(const ValueKey('constraints-8')),
      frame,
      id: 'narrow-continuous',
      label: 'capsule continuous range\ncontainer width=8; after real drag',
      defect: 'thumb adapts to longitudinal constraint',
      padding: const EdgeInsets.symmetric(horizontal: 6),
    );
    collector.add(
      tester,
      find.byWidgetPredicate(
        (w) => w is TSlider && w.value == .4 && w.max == 1,
      ),
      frame,
      id: 'thin-cross-axis',
      label: 'normal slider\ncontainer height=8',
      defect: 'thumb adapts to cross-axis constraint',
      padding: const EdgeInsets.symmetric(vertical: 8),
    );
    for (final id in ['normal', 'capsule']) {
      collector.add(
        tester,
        find.byKey(ValueKey('constraints-vertical-$id')),
        frame,
        id: 'large-$id',
        label:
            '$id: ${id == 'normal' ? 'theme trackHeight=192' : 'theme spacer3=240'}\ncontainer 48 x 232; value 100',
        defect: 'large thickness obeys cross-axis constraint',
        vertical: true,
        padding: const EdgeInsets.all(8),
      );
    }
    await disposeDemoPage(tester);
    expect(collector.tiles.length, 8);
    return await collector.finish(tester, mode, 2);
  } finally {
    collector.dispose();
  }
}
