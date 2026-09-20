import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'checkbox')
class HorizontalCheckboxExample extends StatefulWidget {
  const HorizontalCheckboxExample({super.key});

  @override
  State<HorizontalCheckboxExample> createState() =>
      _HorizontalCheckboxExampleState();
}

class _HorizontalCheckboxExampleState extends State<HorizontalCheckboxExample> {
  Widget _horizontalCheckbox(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(
        const TCheckboxThemeData(
          variant: TCheckboxVariant.circle,
          customSpace: EdgeInsets.symmetric(vertical: 8),
        ),
      ),
      child: ColoredBox(
        color: context.tTheme.bgColorContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final option in _horizontalOptions)
                TCheckbox(
                  value: _horizontalValue.contains(option.value),
                  title: option.label,
                  showDivider: false,
                  onChanged: (_) => _toggleHorizontal(option.value),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static const _horizontalOptions = [
    TCheckboxOption(value: 'a', label: '多选标题'),
    TCheckboxOption(value: 'b', label: '多选标题'),
    TCheckboxOption(value: 'c', label: '上限四字'),
  ];

  List<String> _horizontalValue = ['a', 'b'];

  void _toggleHorizontal(String value) {
    setState(() {
      _horizontalValue = _horizontalValue.contains(value)
          ? _horizontalValue.where((item) => item != value).toList()
          : [..._horizontalValue, value];
    });
  }

  @override
  Widget build(BuildContext context) {
    return _horizontalCheckbox(context);
  }
}
