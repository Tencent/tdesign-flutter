import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// 在缺少基线时保留实际渲染供人工查看，不修改像素比较结果。
Future<void> captureGoldenEvidence(
  WidgetTester tester,
  Finder finder,
  String path,
) async {
  await tester.runAsync(() async {
    var renderObject = tester.element(finder).renderObject!;
    while (!renderObject.isRepaintBoundary) {
      renderObject = renderObject.parent!;
    }
    final image = await (renderObject.debugLayer! as OffsetLayer).toImage(
      renderObject.paintBounds,
    );
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('test/failures/${path.split('/').last}');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes!.buffer.asUint8List());
    image.dispose();
  });
}
