import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TLinkViewPage extends StatefulWidget {
  const TLinkViewPage({Key? key}) : super(key: key);

  @override
  _TLinkViewPageState createState() => _TLinkViewPageState();
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
        exampleCodeGroup: 'link',
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(desc: '基础文字链接', builder: _buildBasicLinks),
            ExampleItem(desc: '下划线文字链接', builder: _buildUnderlineLinks),
            ExampleItem(desc: '前置图标文字链接', builder: _buildPrefixLinks),
            ExampleItem(desc: '后置图标文字链接', builder: _buildSuffixLinks),
          ]),
          ExampleModule(title: '组件状态', children: [
            ExampleItem(desc: '不同主题', builder: _buildColorSchemeLinks),
            ExampleItem(desc: '禁用状态', builder: _buildDisabledLinks)
          ]),
          ExampleModule(
              title: '组件样式',
              children: [ExampleItem(desc: '链接尺寸', builder: _buildLinkSizes)]),
        ]);
  }

  @ExampleCode(group: 'link')
  Widget _buildBasicLinks(BuildContext context) {
    return Container(
        color: context.tTheme.bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildLinksWithVariant(TLinkVariant.basic),
        ));
  }

  @ExampleCode(group: 'link')
  Widget _buildUnderlineLinks(BuildContext context) {
    return Container(
        color: context.tTheme.bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildLinksWithVariant(TLinkVariant.underline),
        ));
  }

  @ExampleCode(group: 'link')
  Widget _buildPrefixLinks(BuildContext context) {
    return Container(
        color: context.tTheme.bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              _buildLinksWithVariant(TLinkVariant.icon, prefixIconData: TIcons.link),
        ));
  }

  @ExampleCode(group: 'link')
  Widget _buildSuffixLinks(BuildContext context) {
    return Container(
        color: context.tTheme.bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              _buildLinksWithVariant(TLinkVariant.icon, suffixIconData: TIcons.jump),
        ));
  }

  List<Widget> _buildLinksWithVariant(
    TLinkVariant variant, {
    IconData? prefixIconData,
    IconData? suffixIconData,
  }) {
    return [
      _buildLink(
        TLinkColorScheme.primary,
        variant,
        prefixIconData: prefixIconData,
        suffixIconData: suffixIconData,
      ),
      _buildLink(
        TLinkColorScheme.defaultTheme,
        variant,
        prefixIconData: prefixIconData,
        suffixIconData: suffixIconData,
      ),
    ];
  }

  TLink _buildLink(
    TLinkColorScheme colorScheme,
    TLinkVariant variant, {
    IconData? prefixIconData,
    IconData? suffixIconData,
    bool disabled = false,
  }) {
    return TLink(
      child: const Text('跳转链接'),
      colorScheme: colorScheme,
      variant: variant,
      size: TLinkSize.medium,
      prefixIconData: prefixIconData,
      suffixIconData: suffixIconData,
      onPressed: disabled ? null : _onLinkPressed,
    );
  }

  @ExampleCode(group: 'link')
  Widget _buildColorSchemeLinks(BuildContext context) {
    return Column(
      children: [
        Container(
          color: context.tTheme.bgColorContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLink(TLinkColorScheme.primary, TLinkVariant.icon,
                  suffixIconData: TIcons.jump),
              _buildLink(TLinkColorScheme.defaultTheme, TLinkVariant.icon,
                  suffixIconData: TIcons.jump),
              _buildLink(TLinkColorScheme.danger, TLinkVariant.icon,
                  suffixIconData: TIcons.jump),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          color: context.tTheme.bgColorContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLink(TLinkColorScheme.warning, TLinkVariant.icon,
                  suffixIconData: TIcons.jump),
              _buildLink(TLinkColorScheme.success, TLinkVariant.icon,
                  suffixIconData: TIcons.jump),
            ],
          ),
        ),
      ],
    );
  }

  @ExampleCode(group: 'link')
  Widget _buildDisabledLinks(BuildContext context) {
    return Column(
      children: [
        Container(
          color: context.tTheme.bgColorContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLink(TLinkColorScheme.primary, TLinkVariant.icon,
                  suffixIconData: TIcons.jump, disabled: true),
              _buildLink(TLinkColorScheme.defaultTheme, TLinkVariant.icon,
                  suffixIconData: TIcons.jump, disabled: true),
              _buildLink(TLinkColorScheme.danger, TLinkVariant.icon,
                  suffixIconData: TIcons.jump, disabled: true),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          color: context.tTheme.bgColorContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLink(TLinkColorScheme.warning, TLinkVariant.icon,
                  suffixIconData: TIcons.jump, disabled: true),
              _buildLink(TLinkColorScheme.success, TLinkVariant.icon,
                  suffixIconData: TIcons.jump, disabled: true),
            ],
          ),
        ),
      ],
    );
  }

  @ExampleCode(group: 'link')
  Widget _buildLinkSizes(BuildContext context) {
    return Container(
        color: context.tTheme.bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSizeLink(TLinkSize.small),
            _buildSizeLink(TLinkSize.medium),
            _buildSizeLink(TLinkSize.large),
          ],
        ));
  }

  TLink _buildSizeLink(TLinkSize size) {
    final label =
        size == TLinkSize.small ? 'S' : (size == TLinkSize.medium ? 'M' : 'L');
    return TLink(
      child: Text('${label}跳转链接'),
      colorScheme: TLinkColorScheme.primary,
      variant: TLinkVariant.icon,
      size: size,
      suffixIconData: TIcons.jump,
      onPressed: _onLinkPressed,
    );
  }
}
