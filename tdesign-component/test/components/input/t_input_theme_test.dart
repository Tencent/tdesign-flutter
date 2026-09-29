import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  test('TInputThemeData copyWith and lerp', () {
    const base = TInputThemeData(
      clearIconSize: 16,
      textStyle: TextStyle(color: Colors.red),
      hintStyle: TextStyle(color: Colors.red),
      clearIconColor: Colors.red,
    );
    const other = TInputThemeData(
      clearIconSize: 24,
      textStyle: TextStyle(color: Colors.blue),
      hintStyle: TextStyle(color: Colors.blue),
      clearIconColor: Colors.blue,
    );

    expect(
      base
          .copyWith(
            clearIconSize: 20,
            textStyle: const TextStyle(color: Colors.green),
            hintStyle: const TextStyle(color: Colors.green),
            clearIconColor: Colors.green,
          )
          .clearIconSize,
      20,
    );
    expect(base.lerp(null, 0.5), same(base));
    expect(base.lerp(other, 0.5).clearIconSize, 20);
    expect(base.lerp(other, 0.5).textStyle?.color, isNotNull);
    expect(base.lerp(other, 0.5).hintStyle?.color, isNotNull);
    expect(base.lerp(other, 0.5).clearIconColor, isNotNull);
  });
}
