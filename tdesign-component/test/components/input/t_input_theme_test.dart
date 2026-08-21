import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  test('TInputThemeData copyWith and lerp', () {
    const base = TInputThemeData(
      clearButtonMode: TInputClearButtonMode.always,
      clearIconSize: 16,
      multilineMinLines: 3,
      textStyle: TextStyle(color: Colors.red),
      cursorColor: Colors.red,
      hintStyle: TextStyle(color: Colors.red),
      clearIconColor: Colors.red,
    );
    const other = TInputThemeData(
      clearButtonMode: TInputClearButtonMode.never,
      clearIconSize: 24,
      multilineMinLines: 6,
      textStyle: TextStyle(color: Colors.blue),
      cursorColor: Colors.blue,
      hintStyle: TextStyle(color: Colors.blue),
      clearIconColor: Colors.blue,
    );

    expect(base.copyWith().clearButtonMode, TInputClearButtonMode.always);
    expect(
      base
          .copyWith(
            clearButtonMode: TInputClearButtonMode.never,
            clearIconSize: 20,
            multilineMinLines: 5,
            textStyle: const TextStyle(color: Colors.green),
            cursorColor: Colors.green,
            hintStyle: const TextStyle(color: Colors.green),
            clearIconColor: Colors.green,
          )
          .multilineMinLines,
      5,
    );
    expect(base.lerp(null, 0.5), same(base));
    expect(
      base.lerp(other, 0.25).clearButtonMode,
      TInputClearButtonMode.always,
    );
    expect(base.lerp(other, 0.75).clearButtonMode, TInputClearButtonMode.never);
    expect(base.lerp(other, 0.5).clearIconSize, 20);
    expect(base.lerp(other, 0.5).textStyle?.color, isNotNull);
    expect(base.lerp(other, 0.5).cursorColor, isNotNull);
    expect(base.lerp(other, 0.5).hintStyle?.color, isNotNull);
    expect(base.lerp(other, 0.5).clearIconColor, isNotNull);
  });
}
