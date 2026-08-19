import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/input/t_input_resolve.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  test('TInputThemeData copyWith and lerp', () {
    const base = TInputThemeData(
      clearButtonMode: TInputClearButtonMode.always,
      clearIconSize: 16,
      multilineMinLines: 3,
      textStyle: TextStyle(color: Colors.red),
      cursorColor: Colors.red,
      decorationTheme: InputDecorationTheme(fillColor: Colors.red),
      clearIconColor: Colors.red,
    );
    const other = TInputThemeData(
      clearButtonMode: TInputClearButtonMode.never,
      clearIconSize: 24,
      multilineMinLines: 6,
      textStyle: TextStyle(color: Colors.blue),
      cursorColor: Colors.blue,
      decorationTheme: InputDecorationTheme(fillColor: Colors.blue),
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
            decorationTheme: const InputDecorationTheme(
              fillColor: Colors.green,
            ),
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
    expect(base.lerp(other, 0.25).decorationTheme, base.decorationTheme);
    expect(base.lerp(other, 0.5).clearIconColor, isNotNull);
  });

  test('TInputResolve preserves decoration and fills missing content', () {
    const base = InputDecoration(
      labelText: 'base label',
      hintText: 'base hint',
      prefixIcon: Icon(Icons.search),
      suffixIcon: Icon(Icons.info),
    );
    final resolved = TInputResolve.resolveDecoration(
      base: base,
      label: 'fallback label',
      hintText: 'fallback hint',
      prefix: const Icon(Icons.add),
      suffix: const Icon(Icons.close),
    );
    expect(resolved.labelText, 'base label');
    expect(resolved.hintText, 'base hint');
    expect((resolved.prefixIcon as Icon).icon, Icons.search);
    expect((resolved.suffixIcon as Icon).icon, Icons.info);

    final fallback = TInputResolve.resolveDecoration(
      label: 'label',
      hintText: 'hint',
      prefix: const Icon(Icons.add),
      suffix: const Icon(Icons.close),
    );
    expect(fallback.labelText, 'label');
    expect(fallback.hintText, 'hint');
    expect(fallback.filled, isFalse);
    expect(fallback.fillColor, Colors.transparent);
  });

  test('TInputResolve isolates default fill from Material input theme', () {
    final resolved = TInputResolve.resolveDecoration();

    expect(resolved.filled, isFalse);
    expect(resolved.fillColor, Colors.transparent);
  });

  test('TInputResolve preserves explicit decoration fill', () {
    const fillColor = Color(0xFFE5E5E5);
    final resolved = TInputResolve.resolveDecoration(
      base: const InputDecoration(filled: true, fillColor: fillColor),
    );

    expect(resolved.filled, isTrue);
    expect(resolved.fillColor, fillColor);
  });
}
