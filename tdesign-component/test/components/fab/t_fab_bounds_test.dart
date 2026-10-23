import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  group('TFabBounds', () {
    test('构造器正确赋值', () {
      const bounds = TFabBounds(start: 10, end: 20);
      expect(bounds.start, 10);
      expect(bounds.end, 20);
    });

    test('const 构造器相同参数 identical', () {
      const a = TFabBounds(start: 0, end: 100);
      const b = TFabBounds(start: 0, end: 100);
      expect(identical(a, b), isTrue);
    });
  });
}
