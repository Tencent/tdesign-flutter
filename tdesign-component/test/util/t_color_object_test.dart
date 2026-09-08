import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  group('TColorObject parse & format', () {
    test('parses hex and outputs all formats', () {
      final color = TColorObject('#0052D9');
      expect(color.hex, '#0052D9');
      expect(color.rgb, 'rgb(0, 82, 217)');
      expect(color.hsv, 'hsv(217, 100%, 85%)');
      expect(color.hsl, 'hsl(217, 100%, 43%)');
      expect(color.cmyk, 'cmyk(100, 62, 0, 15)');
      expect(color.css, 'rgba(0, 82, 217, 1)');
    });

    test('parses hex8 and keeps alpha', () {
      final color = TColorObject('#0052D980');
      expect(color.hex8, '#0052D980');
      expect(color.rgba, 'rgba(0, 82, 217, 0.5)');
      expect(color.alpha, closeTo(0.502, 0.001));
    });

    test('parses rgb / rgba string', () {
      final color = TColorObject('rgb(255, 0, 0)');
      expect(color.hex, '#FF0000');
      final rgba = TColorObject('rgba(0, 255, 0, 0.5)');
      expect(rgba.hex8, '#00FF0080');
    });

    test('parses hsl string', () {
      final color = TColorObject('hsl(120, 100%, 50%)');
      expect(color.hex, '#00FF00');
    });

    test('parses hsv string', () {
      final color = TColorObject('hsv(0, 100%, 100%)');
      expect(color.hex, '#FF0000');
      // #0052D9 的 HSV 表示（含舍入）。
      final fromHex = TColorObject('#0052D9');
      expect(fromHex.hsv, 'hsv(217, 100%, 85%)');
    });

    test('parses cmyk string', () {
      final color = TColorObject('cmyk(100, 62, 0, 15)');
      expect(color.rgb, 'rgb(0, 82, 217)');
    });

    test('format with enableAlpha upgrades to alpha format', () {
      final color = TColorObject('#0052D9');
      expect(color.format(TColorPickerFormat.hex), '#0052D9');
      expect(
        color.format(TColorPickerFormat.hex, enableAlpha: true),
        '#0052D9FF',
      );
      expect(
        color.format(TColorPickerFormat.rgb, enableAlpha: true),
        'rgba(0, 82, 217, 1)',
      );
      expect(
        color.format(TColorPickerFormat.hsl, enableAlpha: true),
        'hsla(217, 100%, 43%, 1)',
      );
    });

    test('alpha setter clamps to 0..1', () {
      final color = TColorObject('#0052D9');
      color.alpha = 1.5;
      expect(color.alpha, 1);
      color.alpha = -0.5;
      expect(color.alpha, 0);
    });
  });
}
