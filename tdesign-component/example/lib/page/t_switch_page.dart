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
            ExampleItem(desc: '带描述开关', builder: _buildLabel),
            ExampleItem(desc: '自定义颜色开关', builder: _buildColor),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [ExampleItem(builder: _buildStatus)],
        ),
        ExampleModule(
          title: '组件样式',
          children: [ExampleItem(desc: '开关尺寸', builder: _buildSizes)],
        ),
      ],
      test: const [],
    );
  }

  @ExampleCode(group: 'switch')
  Widget _buildBasic(BuildContext context) => const TCell(
    title: Text('基础开关'),
    note: _StatefulSwitch(initialValue: true),
  );

  @ExampleCode(group: 'switch')
  Widget _buildLabel(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const TCell(
        title: Text('带文字开关'),
        note: _StatefulSwitch(
          initialValue: true,
          variant: TSwitchVariant.text,
          openText: '开',
          closeText: '关',
        ),
      ),
      Divider(
        height: 0.5,
        thickness: 0.5,
        indent: context.tTheme.spacer16,
        color: context.tTheme.componentStrokeColor,
      ),
      const TCell(
        title: Text('带图标开关'),
        note: _StatefulSwitch(initialValue: true, variant: TSwitchVariant.icon),
      ),
    ],
  );

  @ExampleCode(group: 'switch')
  Widget _buildColor(BuildContext context) => Theme(
    data: Theme.of(
      context,
    ).mergeExtension(const TSwitchThemeData(trackOnColor: Color(0xFF00A870))),
    child: const TCell(
      title: Text('自定义颜色开关'),
      note: _StatefulSwitch(initialValue: true),
    ),
  );

  @ExampleCode(group: 'switch')
  Widget _buildStatus(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _SwitchGroupLabel('加载状态'),
      const TCell(
        title: Text('加载状态'),
        note: TSwitch(value: false, variant: TSwitchVariant.loading),
      ),
      Divider(
        height: 0.5,
        thickness: 0.5,
        indent: context.tTheme.spacer16,
        color: context.tTheme.componentStrokeColor,
      ),
      const TCell(
        title: Text('加载状态'),
        note: TSwitch(value: true, variant: TSwitchVariant.loading),
      ),
      const _SwitchGroupLabel('禁用状态'),
      const TCell(title: Text('禁用状态'), note: TSwitch(value: false)),
      Divider(
        height: 0.5,
        thickness: 0.5,
        indent: context.tTheme.spacer16,
        color: context.tTheme.componentStrokeColor,
      ),
      const TCell(title: Text('禁用状态'), note: TSwitch(value: true)),
    ],
  );

  @ExampleCode(group: 'switch')
  Widget _buildSizes(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const TCell(
        title: Text('大尺寸 32'),
        note: _StatefulSwitch(initialValue: true, size: TSwitchSize.large),
      ),
      Divider(
        height: 0.5,
        thickness: 0.5,
        indent: context.tTheme.spacer16,
        color: context.tTheme.componentStrokeColor,
      ),
      const TCell(
        title: Text('中尺寸 28'),
        note: _StatefulSwitch(initialValue: true),
      ),
      Divider(
        height: 0.5,
        thickness: 0.5,
        indent: context.tTheme.spacer16,
        color: context.tTheme.componentStrokeColor,
      ),
      const TCell(
        title: Text('小尺寸 24'),
        note: _StatefulSwitch(initialValue: true, size: TSwitchSize.small),
      ),
    ],
  );
}

class _SwitchGroupLabel extends StatelessWidget {
  const _SwitchGroupLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.tTheme.spacer16,
        context.tTheme.spacer16,
        context.tTheme.spacer16,
        context.tTheme.spacer8,
      ),
      child: TText(
        text,
        font: context.tTheme.fontBodyMedium,
        textColor: context.tTheme.textColorSecondary,
      ),
    );
  }
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
