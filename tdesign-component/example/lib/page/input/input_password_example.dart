import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'input')
class InputPasswordExample extends StatefulWidget {
  const InputPasswordExample({super.key});

  @override
  State<InputPasswordExample> createState() => _InputPasswordExampleState();
}

class _InputPasswordExampleState extends State<InputPasswordExample> {
  Widget _buildPassword(BuildContext context) {
    final token = context.tTheme;
    return Column(
      children: [
        const TFormItem(
          label: '输入密码',
          verticalAlignment: TFormItemVerticalAlignment.center,
          child: TInput(
            borderless: true,
            hintText: '请输入密码',
            initialValue: '12345678',
            obscureText: true,
            showPasswordToggle: true,
            inputType: TextInputType.visiblePassword,
          ),
        ),
        const SizedBox(height: 16),
        TFormItem(
          label: '验证码',
          verticalAlignment: TFormItemVerticalAlignment.center,
          child: TInput(
            borderless: true,
            hintText: '输入验证码',
            suffix: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 1,
                  height: 24,
                  color: token.componentStrokeColor,
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 72,
                  height: 24,
                  child: Center(
                    child: TText(
                      'DwrSe',
                      key: const ValueKey('input-captcha'),
                      style: TextStyle(
                        color: token.successNormalColor,
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        TFormItem(
          label: '手机号',
          errorText: phoneError ? '手机号输入不正确' : null,
          verticalAlignment: TFormItemVerticalAlignment.center,
          child: TInput(
            borderless: true,
            hintText: '输入手机号码',
            onChanged: _onPhoneChanged,
            inputType: TextInputType.number,
            suffix: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 1,
                  height: 24,
                  color: token.componentStrokeColor,
                ),
                const SizedBox(width: 16),
                Text(
                  '发送验证码',
                  style: TextStyle(
                    color: token.brandNormalColor,
                    fontSize: token.fontBodyLarge?.size,
                    height: token.fontBodyLarge?.height,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        TFormItem(
          label: '价格',
          errorText: priceError ? '请输入正确的价格' : null,
          verticalAlignment: TFormItemVerticalAlignment.center,
          child: TInput(
            controller: priceController,
            focusNode: priceFocusNode,
            borderless: true,
            hintText: '0.00',
            onChanged: _onPriceChanged,
            textAlign: TextAlign.end,
            suffix: Text(
              '元',
              style: TextStyle(
                color: token.textColorPrimary,
                fontSize: token.fontBodyMedium?.size,
                height: token.fontBodyMedium?.height,
              ),
            ),
            inputType: TextInputType.number,
          ),
        ),
        const SizedBox(height: 16),
        TFormItem(
          label: '数量',
          verticalAlignment: TFormItemVerticalAlignment.center,
          child: TInput(
            borderless: true,
            hintText: '填写个数',
            textAlign: TextAlign.end,
            suffix: Text(
              '个',
              style: TextStyle(
                color: token.textColorPrimary,
                fontSize: token.fontBodyMedium?.size,
                height: token.fontBodyMedium?.height,
              ),
            ),
            inputType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  bool phoneError = false;

  void _onPhoneChanged(String value) {
    final valid = RegExp(r'^[1][3,4,5,7,8,9][0-9]{9}$').hasMatch(value);
    if (phoneError == valid) {
      setState(() => phoneError = !valid);
    }
  }

  bool priceError = false;

  final controller = TextEditingController();

  final priceController = TextEditingController();

  final priceFocusNode = FocusNode();

  void _onPriceChanged(String value) {
    final valid = RegExp(r'^\d+(\.\d+)?$').hasMatch(value);
    if (priceError == valid) {
      setState(() => priceError = !valid);
    }
  }

  @override
  void initState() {
    super.initState();
    priceFocusNode.addListener(_formatPriceOnBlur);
  }

  @override
  void dispose() {
    controller.dispose();
    priceController.dispose();
    priceFocusNode
      ..removeListener(_formatPriceOnBlur)
      ..dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    return _buildPassword(context);
  }
}
