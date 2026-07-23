import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
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
            ExampleItem(desc: '带图标链接', builder: _buildIconLinks),
          ]),
          ExampleModule(title: '组件状态', children: [
            ExampleItem(desc: '不同主题色', builder: _buildColorSchemeLinks),
            ExampleItem(desc: '禁用状态', builder: _buildDisabledLinks)
          ]),
          ExampleModule(
              title: '组件样式',
              children: [ExampleItem(desc: '链接尺寸', builder: _buildLinkSizes)]),
        ]);
  }

  @Demo(group: 'link')
  Widget _buildBasicLinks(BuildContext context) {
    return Container(
        color: context.tTheme.bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildLinksWithVariant(TLinkVariant.basic),
        ));
  }

  @Demo(group: 'link')
  Widget _buildUnderlineLinks(BuildContext context) {
    return Container(
        color: context.tTheme.bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildLinksWithVariant(TLinkVariant.underline),
        ));
  }

  @Demo(group: 'link')
  Widget _buildIconLinks(BuildContext context) {
    return Container(
        color: context.tTheme.bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildLinksWithVariant(TLinkVariant.icon),
        ));
  }

  List<Widget> _buildLinksWithVariant(TLinkVariant variant) {
    return [
      TLink(
        child: const Text('跳转链接'),
        colorScheme: TLinkColorScheme.primary,
        variant: variant,
        size: TLinkSize.medium,
        onPressed: _onLinkPressed,
      ),
      TLink(
        child: const Text('跳转链接'),
        colorScheme: TLinkColorScheme.defaultTheme,
        variant: variant,
        size: TLinkSize.medium,
        onPressed: _onLinkPressed,
      ),
    ];
  }

  @Demo(group: 'link')
  Widget _buildColorSchemeLinks(BuildContext context) {
    return Column(
      children: [
        Container(
          color: context.tTheme.bgColorContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLinkWithColorScheme(TLinkColorScheme.primary),
              _buildLinkWithColorScheme(TLinkColorScheme.defaultTheme),
              _buildLinkWithColorScheme(TLinkColorScheme.danger),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          color: context.tTheme.bgColorContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLinkWithColorScheme(TLinkColorScheme.warning),
              _buildLinkWithColorScheme(TLinkColorScheme.success),
            ],
          ),
        ),
      ],
    );
  }

  @Demo(group: 'link')
  Widget _buildDisabledLinks(BuildContext context) {
    return Column(
      children: [
        Container(
          color: context.tTheme.bgColorContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLinkWithColorScheme(TLinkColorScheme.primary,
                  disabled: true),
              _buildLinkWithColorScheme(TLinkColorScheme.defaultTheme,
                  disabled: true),
              _buildLinkWithColorScheme(TLinkColorScheme.danger,
                  disabled: true),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          color: context.tTheme.bgColorContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLinkWithColorScheme(TLinkColorScheme.warning,
                  disabled: true),
              _buildLinkWithColorScheme(TLinkColorScheme.success,
                  disabled: true),
            ],
          ),
        ),
      ],
    );
  }

  TLink _buildLinkWithColorScheme(TLinkColorScheme colorScheme,
      {bool disabled = false}) {
    return TLink(
      child: const Text('跳转链接'),
      colorScheme: colorScheme,
      variant: TLinkVariant.basic,
      size: TLinkSize.medium,
      onPressed: disabled ? null : _onLinkPressed,
    );
  }

  @Demo(group: 'link')
  Widget _buildLinkSizes(BuildContext context) {
    return Container(
        color: context.tTheme.bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildLinkWithSize(TLinkSize.small),
            _buildLinkWithSize(TLinkSize.medium),
            _buildLinkWithSize(TLinkSize.large),
          ],
        ));
  }

  TLink _buildLinkWithSize(TLinkSize size) {
    final label =
        size == TLinkSize.small ? 'S' : (size == TLinkSize.medium ? 'M' : 'L');
    return TLink(
      child: Text('${label}号链接'),
      colorScheme: TLinkColorScheme.primary,
      variant: TLinkVariant.icon,
      size: size,
      onPressed: _onLinkPressed,
    );
  }
}
