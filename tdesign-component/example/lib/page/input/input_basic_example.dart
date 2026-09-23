import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'input')
class InputBasicExample extends StatefulWidget {
  const InputBasicExample({super.key});

  @override
  State<InputBasicExample> createState() => _InputBasicExampleState();
}

class _InputBasicExampleState extends State<InputBasicExample> {
  Widget _buildBasic(BuildContext context) => Column(
    children: [
      const TFormItem(
        label: '标签文字',
        child: TInput(borderless: true, hintText: '请输入文字'),
      ),
      const SizedBox(height: 16),
      const TFormItem(
        label: '标签文字',
        required: true,
        child: TInput(borderless: true, hintText: '请输入文字'),
      ),
      const SizedBox(height: 16),
      TFormItem(
        child: TInput(
          controller: controller,
          borderless: true,
          hintText: '请输入文字',
        ),
      ),
    ],
  );

  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    priceController.dispose();
    priceFocusNode
      ..removeListener(_formatPriceOnBlur)
      ..dispose();
    super.dispose();
  }

  final priceController = TextEditingController();

  final priceFocusNode = FocusNode();

  void _formatPriceOnBlur() {
    if (priceFocusNode.hasFocus) {
      return;
    }
    final value = priceController.text;
    if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
      return;
    }
    final formatted = double.parse(value).toStringAsFixed(2);
    if (formatted != value) {
      priceController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    priceFocusNode.addListener(_formatPriceOnBlur);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(
        const TFormThemeData(
          requiredMarkPosition: TFormRequiredMarkPosition.right,
        ),
      ),
      child: _buildBasic(context),
    );
  }
}
