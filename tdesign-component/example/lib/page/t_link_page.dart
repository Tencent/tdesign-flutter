import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TLinkViewPage extends StatefulWidget {
  const TLinkViewPage({Key? key}) : super(key: key);

  @override
  State<TLinkViewPage> createState() => _TLinkViewPageState();
}

class _TLinkViewPageState extends State<TLinkViewPage> {
  void _onLinkPressed() {
    TToast.showText('点击了链接', context: context);
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '文字超链接用于跳转一个新页面，如当前项目跳转，友情链接等。',
      backgroundColor: context.tTheme.bgColorPage,
      exampleCodeGroup: 'link',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '基础文字链接', builder: _buildBasicLinks),
            ExampleItem(desc: '下划线文字链接', builder: _buildUnderlineLinks),
            ExampleItem(desc: '前置图标文字链接', builder: _buildPrefixLinks),
            ExampleItem(desc: '后置图标文字链接', builder: _buildSuffixLinks),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(desc: '不同主题', builder: _buildColorSchemeLinks),
            ExampleItem(desc: '禁用状态', builder: _buildDisabledLinks),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [ExampleItem(desc: '链接尺寸', builder: _buildLinkSizes)],
        ),
      ],
    );
  }

  @ExampleCode(group: 'link')
  Widget _buildBasicLinks(BuildContext context) {
    return _exampleRow(context, [
      _link(colorScheme: TLinkColorScheme.primary),
      _link(),
    ]);
  }

  @ExampleCode(group: 'link')
  Widget _buildUnderlineLinks(BuildContext context) {
    return _exampleRow(context, [
      _link(colorScheme: TLinkColorScheme.primary, underline: true),
      _link(underline: true),
    ]);
  }

  @ExampleCode(group: 'link')
  Widget _buildPrefixLinks(BuildContext context) {
    return _exampleRow(context, [
      _link(
        colorScheme: TLinkColorScheme.primary,
        prefixIcon: const Icon(TIcons.link),
      ),
      _link(prefixIcon: const Icon(TIcons.link)),
    ]);
  }

  @ExampleCode(group: 'link')
  Widget _buildSuffixLinks(BuildContext context) {
    return _exampleRow(context, [
      _link(
        colorScheme: TLinkColorScheme.primary,
        suffixIcon: const Icon(TIcons.jump),
      ),
      _link(suffixIcon: const Icon(TIcons.jump)),
    ]);
  }

  @ExampleCode(group: 'link')
  Widget _buildColorSchemeLinks(BuildContext context) {
    return Column(
      children: [
        _exampleRow(context, [
          _link(
            colorScheme: TLinkColorScheme.primary,
            suffixIcon: const Icon(TIcons.jump),
          ),
          _link(suffixIcon: const Icon(TIcons.jump)),
          _link(
            colorScheme: TLinkColorScheme.danger,
            suffixIcon: const Icon(TIcons.jump),
          ),
        ]),
        const SizedBox(height: 16),
        _exampleRow(context, [
          _link(
            colorScheme: TLinkColorScheme.warning,
            suffixIcon: const Icon(TIcons.jump),
          ),
          _link(
            colorScheme: TLinkColorScheme.success,
            suffixIcon: const Icon(TIcons.jump),
          ),
        ]),
      ],
    );
  }

  @ExampleCode(group: 'link')
  Widget _buildDisabledLinks(BuildContext context) {
    return Column(
      children: [
        _exampleRow(context, [
          _link(
            colorScheme: TLinkColorScheme.primary,
            suffixIcon: const Icon(TIcons.jump),
            disabled: true,
          ),
          _link(suffixIcon: const Icon(TIcons.jump), disabled: true),
          _link(
            colorScheme: TLinkColorScheme.danger,
            suffixIcon: const Icon(TIcons.jump),
            disabled: true,
          ),
        ]),
        const SizedBox(height: 16),
        _exampleRow(context, [
          _link(
            colorScheme: TLinkColorScheme.warning,
            suffixIcon: const Icon(TIcons.jump),
            disabled: true,
          ),
          _link(
            colorScheme: TLinkColorScheme.success,
            suffixIcon: const Icon(TIcons.jump),
            disabled: true,
          ),
        ]),
      ],
    );
  }

  @ExampleCode(group: 'link')
  Widget _buildLinkSizes(BuildContext context) {
    return _exampleRow(context, [
      _link(
        label: 'S号链接',
        colorScheme: TLinkColorScheme.primary,
        size: TLinkSize.small,
        suffixIcon: const Icon(TIcons.jump),
      ),
      _link(
        label: 'M号链接',
        colorScheme: TLinkColorScheme.primary,
        size: TLinkSize.medium,
        suffixIcon: const Icon(TIcons.jump),
      ),
      _link(
        label: 'L号链接',
        colorScheme: TLinkColorScheme.primary,
        size: TLinkSize.large,
        suffixIcon: const Icon(TIcons.jump),
      ),
    ]);
  }

  Widget _exampleRow(BuildContext context, List<Widget> children) {
    return Container(
      height: 48,
      color: context.tTheme.bgColorContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      ),
    );
  }

  TLink _link({
    String label = '跳转链接',
    TLinkColorScheme? colorScheme,
    TLinkSize size = TLinkSize.small,
    bool? underline,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool disabled = false,
  }) {
    return TLink(
      child: Text(label),
      colorScheme: colorScheme,
      size: size,
      underline: underline,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      onPressed: disabled ? null : _onLinkPressed,
    );
  }
}
