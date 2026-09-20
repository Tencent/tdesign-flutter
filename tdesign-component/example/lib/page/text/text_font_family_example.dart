import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'text')
class TextFontFamilyExample extends StatelessWidget {
  const TextFontFamilyExample({super.key});

  Widget _buildFontFamily(BuildContext context) {
    return TText(
      '0123456789',
      fontFamily: FontFamily(
        fontFamily: 'TCloudNumber',
        package: 'tdesign_flutter',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildFontFamily(context);
  }
}
