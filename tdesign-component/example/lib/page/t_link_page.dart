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
          children: _buildLinksWithVariant(
            TLinkVariant.icon,
            prefixIconBuilder: _linkIcon,
          ),
        ));
  }

  @ExampleCode(group: 'link')
  Widget _buildSuffixLinks(BuildContext context) {
    return Container(
        color: context.tTheme.bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildLinksWithVariant(
            TLinkVariant.icon,
            suffixIconBuilder: _jumpIcon,
          ),
        ));
  }

  List<Widget> _buildLinksWithVariant(
    TLinkVariant variant, {
    Widget Function(Color color)? prefixIconBuilder,
    Widget Function(Color color)? suffixIconBuilder,
  }) {
    return [
      _buildLink(
        colorScheme: TLinkColorScheme.primary,
        variant: variant,
        prefixIconBuilder: prefixIconBuilder,
        suffixIconBuilder: suffixIconBuilder,
      ),
      _buildLink(
        colorScheme: TLinkColorScheme.defaultTheme,
        variant: variant,
        prefixIconBuilder: prefixIconBuilder,
        suffixIconBuilder: suffixIconBuilder,
      ),
    ];
  }

  TLink _buildLink(
    TLinkColorScheme colorScheme,
    TLinkVariant variant, {
    Widget Function(Color color)? prefixIconBuilder,
    Widget Function(Color color)? suffixIconBuilder,
    bool disabled = false,
  }) {
    final iconColor = _linkColor(context, colorScheme, disabled: disabled);
    return TLink(
      child: const Text('跳转链接'),
      colorScheme: colorScheme,
      variant: variant,
      size: TLinkSize.medium,
      prefixIcon: prefixIconBuilder?.call(iconColor),
      suffixIcon: suffixIconBuilder?.call(iconColor),
      onPressed: disabled ? null : _onLinkPressed,
    );
  }

  Color _linkColor(BuildContext context, TLinkColorScheme colorScheme,
      {bool disabled = false}) {
    if (disabled) {
      return context.tTheme.textDisabledColor;
    }
    return switch (colorScheme) {
      TLinkColorScheme.primary => context.tTheme.brandNormalColor,
      TLinkColorScheme.danger => context.tTheme.errorNormalColor,
      TLinkColorScheme.warning => context.tTheme.warningNormalColor,
      TLinkColorScheme.success => context.tTheme.successNormalColor,
      TLinkColorScheme.defaultTheme => context.tTheme.textColorPrimary,
    };
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
                  suffixIconBuilder: _jumpIcon),
              _buildLink(TLinkColorScheme.defaultTheme, TLinkVariant.icon,
                  suffixIconBuilder: _jumpIcon),
              _buildLink(TLinkColorScheme.danger, TLinkVariant.icon,
                  suffixIconBuilder: _jumpIcon),
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
                  suffixIconBuilder: _jumpIcon),
              _buildLink(TLinkColorScheme.success, TLinkVariant.icon,
                  suffixIconBuilder: _jumpIcon),
            ],
          ),
        ),
      ],
    );
  }

  Widget _linkIcon(Color color) =>
      Icon(TIcons.link, size: 16, color: color);

  Widget _jumpIcon(Color color) =>
      Icon(TIcons.jump, size: 16, color: color);

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
                  suffixIconBuilder: _jumpIcon, disabled: true),
              _buildLink(TLinkColorScheme.defaultTheme, TLinkVariant.icon,
                  suffixIconBuilder: _jumpIcon, disabled: true),
              _buildLink(TLinkColorScheme.danger, TLinkVariant.icon,
                  suffixIconBuilder: _jumpIcon, disabled: true),
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
                  suffixIconBuilder: _jumpIcon, disabled: true),
              _buildLink(TLinkColorScheme.success, TLinkVariant.icon,
                  suffixIconBuilder: _jumpIcon, disabled: true),
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
      suffixIcon: Icon(TIcons.jump,
          size: 16, color: context.tTheme.brandNormalColor),
      onPressed: _onLinkPressed,
    );
  }
}
