import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'tag')
class TagSelectColorSchemesExample extends StatefulWidget {
  const TagSelectColorSchemesExample({super.key});

  @override
  State<TagSelectColorSchemesExample> createState() =>
      _TagSelectColorSchemesExampleState();
}

class _TagSelectColorSchemesExampleState
    extends State<TagSelectColorSchemesExample> {
  Widget _buildSelectColorSchemes(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        TSelectTag(
          '主要',
          colorScheme: TTagColorScheme.primary,
          value: _primarySelected,
          onChanged: (value) => setState(() => _primarySelected = value),
        ),
        TSelectTag(
          '成功',
          colorScheme: TTagColorScheme.success,
          value: _successSelected,
          onChanged: (value) => setState(() => _successSelected = value),
        ),
        TSelectTag(
          '警告',
          colorScheme: TTagColorScheme.warning,
          value: _warningSelected,
          onChanged: (value) => setState(() => _warningSelected = value),
        ),
        TSelectTag(
          '危险',
          colorScheme: TTagColorScheme.danger,
          value: _dangerSelected,
          onChanged: (value) => setState(() => _dangerSelected = value),
        ),
      ],
    );
  }

  bool _primarySelected = true;

  bool _successSelected = true;

  bool _warningSelected = true;

  bool _dangerSelected = true;

  @override
  Widget build(BuildContext context) {
    return _buildSelectColorSchemes(context);
  }
}
