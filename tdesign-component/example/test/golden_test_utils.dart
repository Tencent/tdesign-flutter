import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// 为 Golden 比对设置受控的像素差异面积容差，并返回原比较器。
GoldenFileComparator useGoldenDiffTolerance({double maxDiffRate = 0.015}) {
  final original = goldenFileComparator;
  if (original is! LocalFileComparator) {
    return original;
  }
  goldenFileComparator = _TolerantGoldenFileComparator(
    original.basedir.resolve('_golden_test.dart'),
    maxDiffRate: maxDiffRate,
  );
  return original;
}

class _TolerantGoldenFileComparator extends LocalFileComparator {
  _TolerantGoldenFileComparator(super.testFile, {required double maxDiffRate})
    : assert(maxDiffRate >= 0 && maxDiffRate <= 1),
      _maxDiffRate = maxDiffRate;

  final double _maxDiffRate;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );
    if (result.passed || result.diffPercent <= _maxDiffRate) {
      result.dispose();
      return true;
    }
    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }
}
