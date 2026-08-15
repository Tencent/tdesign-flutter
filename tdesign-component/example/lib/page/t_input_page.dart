import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

/// 每个示例之间的间距，与 H5（tdesign-mobile-vue）示例 `.t-input + .t-input` 保持一致。
const double _kExampleGap = 16;

/// TInput 示例页。
///
/// 分组与文案对齐 H5（tdesign-mobile-vue）`src/input/demos`：
/// 01 组件类型 / 02 组件状态 / 03 组件样式。
class TInputViewPage extends StatefulWidget {
  const TInputViewPage({super.key});

  @override
  State<TInputViewPage> createState() => _TInputViewPageState();
}

class _TInputViewPageState extends State<TInputViewPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      exampleCodeGroup: 'input',
      desc: '用于单行文本信息输入。',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '基础输入框', builder: _buildBasic),
            ExampleItem(desc: '带字数限制输入框', builder: _buildMaxLength),
            ExampleItem(desc: '带操作输入框', builder: _buildSuffix),
            ExampleItem(desc: '带图标输入框', builder: _buildPrefix),
            ExampleItem(desc: '特定类型输入框', builder: _buildSpecial),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(desc: '输入框状态', builder: _buildStatus),
            ExampleItem(desc: '信息超长状态', builder: _buildLongLabel),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(desc: '内容位置', builder: _buildAlign),
            ExampleItem(desc: '竖排样式', builder: _buildLayout),
            ExampleItem(desc: '非通栏样式', builder: _buildBanner),
            ExampleItem(desc: '标签外置样式', builder: _buildBordered),
            ExampleItem(desc: '自定义样式输入框', builder: _buildCustom),
          ],
        ),
      ],
      test: const [],
    );
  }

  @ExampleCode(group: 'input')
  Widget _buildBasic(BuildContext context) => const Column(
    children: [
      TInput(label: '标签文字', hintText: '请输入文字'),
      SizedBox(height: _kExampleGap),
      TInput(label: '标签文字', required: true, hintText: '请输入文字'),
      SizedBox(height: _kExampleGap),
      TInput(hintText: '请输入文字'),
    ],
  );

  @ExampleCode(group: 'input')
  Widget _buildMaxLength(BuildContext context) => const Column(
    children: [
      TInput(
        label: '标签文字',
        hintText: '请输入文字',
        maxLength: 10,
        tips: '最大输入10个字符',
        decoration: InputDecoration(counterText: ''),
      ),
      SizedBox(height: _kExampleGap),
      TInput(
        label: '标签文字',
        hintText: '请输入文字',
        maxcharacter: 10,
        tips: '最大输入10个字符，汉字算两个',
      ),
    ],
  );

  @ExampleCode(group: 'input')
  Widget _buildSuffix(BuildContext context) => Column(
    children: [
      const TInput(
        label: '标签文字',
        hintText: '请输入文字',
        suffix: Icon(TIcons.info_circle),
      ),
      const SizedBox(height: _kExampleGap),
      TInput(
        label: '标签文字',
        hintText: '请输入手机号码',
        suffix: TButton(
          child: const Text('操作按钮'),
          size: TButtonSize.extraSmall,
          colorScheme: TButtonColorScheme.primary,
          onPressed: () {},
        ),
      ),
      const SizedBox(height: _kExampleGap),
      const TInput(
        label: '标签文字',
        hintText: '请输入文字',
        suffix: Icon(TIcons.user),
      ),
    ],
  );

  @ExampleCode(group: 'input')
  Widget _buildPrefix(BuildContext context) => const Column(
    children: [
      TInput(
        label: '标签文字',
        hintText: '请输入文字',
        prefix: Icon(TIcons.app),
      ),
      SizedBox(height: _kExampleGap),
      TInput(hintText: '请输入文字', prefix: Icon(TIcons.app)),
    ],
  );

  @ExampleCode(group: 'input')
  Widget _buildSpecial(BuildContext context) => Column(
    children: [
      const TInput(
        initialValue: '520 TDesign',
        label: '输入密码',
        obscureText: true,
      ),
      const SizedBox(height: _kExampleGap),
      const TInput(
        label: '验证码',
        hintText: '输入验证码',
        suffix: Icon(TIcons.qrcode),
      ),
      const SizedBox(height: _kExampleGap),
      TInput(
        initialValue: '17600600600',
        label: '手机号',
        hintText: '输入手机号码',
        inputType: TextInputType.phone,
        suffix: TButton(
          child: const Text('发送验证码'),
          size: TButtonSize.extraSmall,
          variant: TButtonVariant.text,
          onPressed: () {},
        ),
      ),
      const SizedBox(height: _kExampleGap),
      const TInput(
        label: '价格',
        hintText: '0.00',
        align: TInputAlign.right,
        suffix: Text('元'),
        inputType: TextInputType.number,
      ),
      const SizedBox(height: _kExampleGap),
      const TInput(
        label: '数量',
        hintText: '填写个数',
        align: TInputAlign.right,
        suffix: Text('个'),
        inputType: TextInputType.number,
      ),
    ],
  );

  @ExampleCode(group: 'input')
  Widget _buildStatus(BuildContext context) => Column(
    children: [
      TInput(
        initialValue: '已输入文字',
        label: '标签文字',
        status: TInputStatus.error,
        tips: '辅助说明',
        suffix: Icon(TIcons.close, color: context.tTheme.errorColor6),
      ),
      const SizedBox(height: _kExampleGap),
      const TInput(
        initialValue: '不可编辑文字',
        label: '标签文字',
        enabled: false,
      ),
    ],
  );

  @ExampleCode(group: 'input')
  Widget _buildLongLabel(BuildContext context) => const TInput(
    label: '标签超长时最多十个字',
    hintText: '请输入文字',
  );

  @ExampleCode(group: 'input')
  Widget _buildAlign(BuildContext context) => const Column(
    children: [
      TInput(label: '标签左对齐', hintText: '请输入文字'),
      SizedBox(height: _kExampleGap),
      TInput(
        label: '标签居中',
        hintText: '请输入文字',
        align: TInputAlign.center,
      ),
      SizedBox(height: _kExampleGap),
      TInput(
        label: '标签右对齐',
        hintText: '请输入文字',
        align: TInputAlign.right,
      ),
    ],
  );

  @ExampleCode(group: 'input')
  Widget _buildLayout(BuildContext context) => const TInput(
    label: '标签文字',
    layout: TInputLayout.vertical,
    hintText: '请输入文字',
    suffix: Icon(TIcons.error_circle_filled),
  );

  @ExampleCode(group: 'input')
  Widget _buildBanner(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    clipBehavior: Clip.antiAlias,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(6)),
    ),
    child: const TInput(label: '标签文字', hintText: '请输入文字'),
  );

  @ExampleCode(group: 'input')
  Widget _buildBordered(BuildContext context) => Column(
    children: [
      const Align(
        alignment: Alignment.centerLeft,
        child: TText('标签文字'),
      ),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          border: Border.all(color: const Color(0xFFDCDCDC)),
        ),
        child: TInput(
          hintText: '请输入文字',
          borderless: true,
          suffix: Icon(
            TIcons.error_circle_filled,
            color: context.tTheme.errorColor6,
          ),
        ),
      ),
    ],
  );

  @ExampleCode(group: 'input')
  Widget _buildCustom(BuildContext context) => Theme(
    data: Theme.of(context).mergeExtension(
      const TInputThemeData(
        cursorColor: Colors.redAccent,
        decorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF4B4B4B)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
          ),
        ),
      ),
    ),
    child: const TInput(label: '标签文字', hintText: '请输入文字'),
  );
}
