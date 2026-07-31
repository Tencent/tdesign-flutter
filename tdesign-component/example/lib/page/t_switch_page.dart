import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

/// TSwitch 示例页。
class TSwitchPage extends StatelessWidget {
  const TSwitchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      exampleCodeGroup: 'switch',
      desc: '用于控制某个功能的开启和关闭。',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '基础开关', builder: _buildBasic),
            ExampleItem(desc: '文字开关', builder: _buildText),
            ExampleItem(desc: '图标开关', builder: _buildIcon),
            ExampleItem(desc: '主题颜色', builder: _buildTheme),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(desc: '加载状态', builder: _buildLoading),
            ExampleItem(desc: '禁用状态', builder: _buildDisabled),
          ],
        ),
        ExampleModule(
          title: '组件尺寸',
          children: [
            ExampleItem(desc: '大', builder: _buildLarge),
            ExampleItem(desc: '中', builder: _buildMedium),
            ExampleItem(desc: '小', builder: _buildSmall),
          ],
        ),
      ],
      test: const [],
    );
  }

  @ExampleCode(group: 'switch')
  Widget _buildBasic(BuildContext context) => const TCell(
        title: Text('基础开关'),
        note: _StatefulSwitch(),
      );

  @ExampleCode(group: 'switch')
  Widget _buildText(BuildContext context) => const TCell(
        title: Text('文字开关'),
        note: _StatefulSwitch(
          initialValue: true,
          variant: TSwitchVariant.text,
          openText: '开',
          closeText: '关',
        ),
      );

  @ExampleCode(group: 'switch')
  Widget _buildIcon(BuildContext context) => const TCell(
        title: Text('图标开关'),
        note: _StatefulSwitch(
          initialValue: true,
          variant: TSwitchVariant.icon,
        ),
      );

  @ExampleCode(group: 'switch')
  Widget _buildTheme(BuildContext context) => TCell(
        title: const Text('主题颜色'),
        note: Theme(
          data: Theme.of(context).mergeExtension(
            const TSwitchThemeData(trackOnColor: Colors.green),
          ),
          child: const _StatefulSwitch(initialValue: true),
        ),
      );

  @ExampleCode(group: 'switch')
  Widget _buildLoading(BuildContext context) => const TCell(
        title: Text('加载状态'),
        note: TSwitch(
          value: true,
          variant: TSwitchVariant.loading,
        ),
      );

  @ExampleCode(group: 'switch')
  Widget _buildDisabled(BuildContext context) => const TCell(
        title: Text('禁用状态'),
        note: TSwitch(value: false),
      );

  @ExampleCode(group: 'switch')
  Widget _buildLarge(BuildContext context) => const TCell(
        title: Text('大尺寸'),
        note: _StatefulSwitch(size: TSwitchSize.large),
      );

  @ExampleCode(group: 'switch')
  Widget _buildMedium(BuildContext context) => const TCell(
        title: Text('中尺寸'),
        note: _StatefulSwitch(size: TSwitchSize.medium),
      );

  @ExampleCode(group: 'switch')
  Widget _buildSmall(BuildContext context) => const TCell(
        title: Text('小尺寸'),
        note: _StatefulSwitch(size: TSwitchSize.small),
      );
}

class _StatefulSwitch extends StatefulWidget {
  const _StatefulSwitch({
    this.initialValue = false,
    this.size,
    this.variant,
    this.openText,
    this.closeText,
  });

  final bool initialValue;
  final TSwitchSize? size;
  final TSwitchVariant? variant;
  final String? openText;
  final String? closeText;

  @override
  State<_StatefulSwitch> createState() => _StatefulSwitchState();
}

class _StatefulSwitchState extends State<_StatefulSwitch> {
  late bool value = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    return TSwitch(
      value: value,
      size: widget.size,
      variant: widget.variant,
      openText: widget.openText,
      closeText: widget.closeText,
      onChanged: (next) => setState(() => value = next),
    );
  }
}
