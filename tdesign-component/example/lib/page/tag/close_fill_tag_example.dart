import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'tag')
class CloseFillTagExample extends StatefulWidget {
  const CloseFillTagExample({super.key});

  @override
  State<CloseFillTagExample> createState() => _CloseFillTagExampleState();
}

class _CloseFillTagExampleState extends State<CloseFillTagExample> {
  Widget _buildCloseFillTag(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: _closableTags
          .map(
            (text) => TTag(
              text,
              variant: TTagVariant.light,
              needCloseIcon: true,
              onCloseTap: () => setState(() => _closableTags.remove(text)),
            ),
          )
          .toList(),
    );
  }

  Widget _buildCloseOutlineTag(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: _closableOutlineTags
          .map(
            (text) => TTag(
              text,
              variant: TTagVariant.outline,
              needCloseIcon: true,
              onCloseTap: () =>
                  setState(() => _closableOutlineTags.remove(text)),
            ),
          )
          .toList(),
    );
  }

  final List<String> _closableOutlineTags = ['标签文字'];

  final List<String> _closableTags = ['标签文字'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 16),
        Builder(builder: _buildCloseFillTag),
        const SizedBox(width: 16),
        Builder(builder: _buildCloseOutlineTag),
      ],
    );
  }
}
