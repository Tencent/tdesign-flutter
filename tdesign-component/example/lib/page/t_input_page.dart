import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

/// TInput 示例页。
class TInputViewPage extends StatefulWidget {
  const TInputViewPage({super.key});

  @override
  State<TInputViewPage> createState() => _TInputViewPageState();
}

class _TInputViewPageState extends State<TInputViewPage> {
  final controller = TextEditingController();
  final priceController = TextEditingController();
  bool phoneError = false;
  bool priceError = false;

  @override
  void dispose() {
    controller.dispose();
    priceController.dispose();
    super.dispose();
  }

  void _onPhoneChanged(String value) {
    final valid = RegExp(r'^[1][3,4,5,7,8,9][0-9]{9}$').hasMatch(value);
    if (phoneError == valid) {
      setState(() => phoneError = !valid);
    }
  }

  void _onPriceChanged(String value) {
    final valid = RegExp(r'^\d+(\.\d+)?$').hasMatch(value);
    if (valid) {
      final formatted = double.parse(value).toStringAsFixed(2);
      if (formatted != value) {
        priceController.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    }
    if (priceError == valid) {
      setState(() => priceError = !valid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(
        const TFormThemeData(
          requiredMarkPosition: TFormRequiredMarkPosition.right,
        ),
      ),
      child: ExamplePage(
        title: tTitle(),
        exampleCodeGroup: 'input',
        desc: '用于单行文本信息输入。',
        compactDemo: true,
        showTestModule: false,
        children: [
          ExampleModule(
            title: '组件类型',
            children: [
              ExampleItem(desc: '基础输入框', builder: _buildBasic, center: false),
              ExampleItem(
                desc: '带字数限制输入框',
                builder: _buildFormatter,
                center: false,
              ),
              ExampleItem(desc: '带操作输入框', builder: _buildAction, center: false),
              ExampleItem(desc: '带图标输入框', builder: _buildSlots, center: false),
              ExampleItem(
                desc: '特定类型输入框',
                builder: _buildPassword,
                center: false,
              ),
            ],
          ),
          ExampleModule(
            title: '组件状态',
            children: [
              ExampleItem(desc: '输入框状态', builder: _buildStatus, center: false),
              ExampleItem(desc: '信息超长状态', builder: _buildLabel, center: false),
            ],
          ),
          ExampleModule(
            title: '组件样式',
            children: [
              ExampleItem(desc: '内容位置', builder: _buildAlign, center: false),
              ExampleItem(desc: '竖排样式', builder: _buildLayout, center: false),
              ExampleItem(desc: '非通栏样式', builder: _buildBanner, center: false),
              ExampleItem(
                desc: '标签外置样式',
                builder: _buildBordered,
                center: false,
              ),
              ExampleItem(
                desc: '自定义样式输入框',
                builder: _buildCustom,
                center: false,
              ),
            ],
          ),
        ],
        test: const [],
      ),
    );
  }

  @ExampleCode(group: 'input')
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
      const SizedBox(height: 16),
    ],
  );

  @ExampleCode(group: 'input')
  Widget _buildSlots(BuildContext context) {
    final token = context.tTheme;

    return ColoredBox(
      color: token.bgColorPage,
      child: const Column(
        children: [
          TFormItem(
            leading: Icon(TIcons.app),
            label: '标签文字',
            verticalAlignment: TFormItemVerticalAlignment.center,
            child: TInput(borderless: true, hintText: '请输入文字'),
          ),
          SizedBox(height: 16),
          TInput(borderless: true, hintText: '请输入文字', prefix: Icon(TIcons.app)),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  @ExampleCode(group: 'input')
  Widget _buildAction(BuildContext context) {
    const suffixIcon = Icon(TIcons.info_circle_filled);
    const avatarIcon = Icon(TIcons.user_avatar);
    return Column(
      children: [
        const TFormItem(
          label: '标签文字',
          verticalAlignment: TFormItemVerticalAlignment.center,
          child: TInput(
            borderless: true,
            hintText: '请输入文字',
            suffix: suffixIcon,
          ),
        ),
        const SizedBox(height: 16),
        TFormItem(
          label: '标签文字',
          help: '最多十个字',
          verticalAlignment: TFormItemVerticalAlignment.start,
          child: const TInput(
            borderless: true,
            hintText: '请输入文字',
            maxCharacter: 10,
          ),
          extra: TButton(
            size: TButtonSize.extraSmall,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {},
            child: const Text('操作按钮'),
          ),
        ),
        const SizedBox(height: 16),
        const TFormItem(
          label: '标签文字',
          verticalAlignment: TFormItemVerticalAlignment.center,
          child: TInput(
            borderless: true,
            hintText: '请输入文字',
            suffix: avatarIcon,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @ExampleCode(group: 'input')
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
            initialValue: '123456',
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
            suffix: SizedBox(
              width: 72,
              height: 24,
              child: OverflowBox(
                minHeight: 36,
                maxHeight: 36,
                alignment: Alignment.center,
                child: Image.network(
                  'https://wwcdn.weixin.qq.com/node/wework/images/202010241547.ac6876be9c.png',
                  width: 72,
                  height: 36,
                  fit: BoxFit.contain,
                ),
              ),
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
            initialValue: '17600600600',
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
        const SizedBox(height: 16),
      ],
    );
  }

  @ExampleCode(group: 'input')
  Widget _buildDisabled(BuildContext context) => const TFormItem(
    label: '标签文字',
    child: TInput(borderless: true, initialValue: '不可编辑文字', enabled: false),
  );

  @ExampleCode(group: 'input')
  Widget _buildLabel(BuildContext context) => const TFormItem(
    label: '标签超长时最多十个字',
    child: TInput(borderless: true, hintText: '请输入文字'),
  );

  @ExampleCode(group: 'input')
  Widget _buildReadOnly(BuildContext context) => const TFormItem(
    label: '标签文字',
    child: TInput(borderless: true, initialValue: '只读模式', readOnly: true),
  );

  @ExampleCode(group: 'input')
  Widget _buildStatus(BuildContext context) {
    final token = context.tTheme;
    return Column(
      children: [
        TFormItem(
          label: '标签文字',
          errorText: '错误提示',
          child: Theme(
            data: Theme.of(context).mergeExtension(
              TInputThemeData(clearIconColor: token.errorNormalColor),
            ),
            child: const TInput(
              borderless: true,
              initialValue: '已输入内容',
              status: TInputStatus.error,
              clearButtonMode: TInputClearButtonMode.always,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildDisabled(context),
        const SizedBox(height: 16),
        _buildReadOnly(context),
        const SizedBox(height: 16),
      ],
    );
  }

  @ExampleCode(group: 'input')
  Widget _buildAlign(BuildContext context) => const Column(
    children: [
      TFormItem(
        label: '左对齐',
        child: TInput(borderless: true, hintText: '请输入文字'),
      ),
      SizedBox(height: 16),
      TFormItem(
        label: '居中',
        child: TInput(
          borderless: true,
          hintText: '请输入文字',
          textAlign: TextAlign.center,
        ),
      ),
      SizedBox(height: 16),
      TFormItem(
        label: '右对齐',
        child: TInput(
          borderless: true,
          hintText: '请输入文字',
          textAlign: TextAlign.end,
        ),
      ),
      SizedBox(height: 16),
    ],
  );

  @ExampleCode(group: 'input')
  Widget _buildLayout(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(
        const TFormThemeData(layout: TFormLayout.vertical, labelGap: 4),
      ),
      child: const TFormItem(
        label: '标签文字',
        child: TInput(
          borderless: true,
          hintText: '请输入文字',
          suffix: Icon(TIcons.info_circle_filled),
        ),
      ),
    );
  }

  @ExampleCode(group: 'input')
  Widget _buildBanner(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: ClipRRect(
      // MiniProgram demo: border-radius: 18rpx.
      borderRadius: BorderRadius.circular(9),
      child: Theme(
        data: Theme.of(
          context,
        ).mergeExtension(const TFormThemeData(borderColor: Colors.transparent)),
        child: const TFormItem(
          label: '标签文字',
          child: TInput(borderless: true, hintText: '请输入文字'),
        ),
      ),
    ),
  );

  @ExampleCode(group: 'input')
  Widget _buildBordered(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .mergeExtension(
            const TFormThemeData(
              layout: TFormLayout.vertical,
              borderColor: Colors.transparent,
              itemPadding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              labelGap: 8,
            ),
          )
          .mergeExtension(
            const TInputThemeData(
              borderRadius: 6,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
      child: const TFormItem(
        label: '标签文字',
        child: TInput(
          hintText: '请输入文字',
          suffix: Icon(TIcons.info_circle_filled),
        ),
      ),
    );
  }

  @ExampleCode(group: 'input')
  Widget _buildCustom(BuildContext context) => ColoredBox(
    color: const Color(0xff2c2c2c),
    child: Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Theme(
        data: Theme.of(context)
            .mergeExtension(
              const TInputThemeData(
                backgroundColor: Color(0xff2c2c2c),
                borderColor: Color(0xff4b4b4b),
                textStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Color(0x59ffffff)),
              ),
            )
            .mergeExtension(
              const TFormThemeData(
                backgroundColor: Color(0xff2c2c2c),
                borderColor: Color(0xff4b4b4b),
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
        child: const TFormItem(
          label: '标签文字',
          child: TInput(borderless: true, hintText: '请输入文字'),
        ),
      ),
    ),
  );

  @ExampleCode(group: 'input')
  Widget _buildFormatter(BuildContext context) => const Column(
    children: [
      TFormItem(
        label: '标签文字',
        help: '最大输入10个字符',
        child: TInput(borderless: true, hintText: '请输入文字', maxLength: 10),
      ),
      SizedBox(height: 16),
      TFormItem(
        label: '标签文字',
        help: '最大输入10个字符，汉字算两个',
        child: TInput(borderless: true, hintText: '请输入文字', maxCharacter: 10),
      ),
      SizedBox(height: 16),
    ],
  );
}
