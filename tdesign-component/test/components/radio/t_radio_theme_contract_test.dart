import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  test('TRadioThemeData copyWith and lerp preserve all visual fields', () {
    const base = TRadioThemeData(
      selectColor: Colors.blue,
      disableColor: Colors.grey,
      titleColor: Colors.black,
      subTitleColor: Colors.black54,
      backgroundColor: Colors.white,
      spacing: 8,
      insetSpacing: 12,
    );
    final copied = base.copyWith(
      selectColor: Colors.red,
      disableColor: Colors.black26,
      titleColor: Colors.green,
      subTitleColor: Colors.orange,
      backgroundColor: Colors.yellow,
      spacing: 10,
      insetSpacing: 14,
    );
    expect(copied.selectColor, Colors.red);
    expect(copied.disableColor, Colors.black26);
    expect(copied.spacing, 10);
    expect(copied.insetSpacing, 14);
    final lerped = base.lerp(copied, 0.5);
    expect(lerped, isA<TRadioThemeData>());
    expect(base.lerp(null, 0.5), same(base));
  });
}
