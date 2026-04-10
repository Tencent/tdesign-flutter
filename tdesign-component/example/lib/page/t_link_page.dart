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
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tTitle(),
        desc: '文字超链接用于跳转一个新页面，如当前项目跳转，友情链接等。',
        exampleCodeGroup: 'link',
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(desc: '基础文字链接', builder: _basicTypeBasic),
            ExampleItem(desc: '下划线文字链接', builder: _withUnderline),
            ExampleItem(desc: '前置图标文字链接', builder: _withPrefixIcon),
            ExampleItem(desc: '后置图标文字链接', builder: _withSuffixIcon),
          ]),
          ExampleModule(title: '组件状态', children: [
            ExampleItem(desc: '不同主题', builder: _buildLinkStats),
            ExampleItem(desc: '禁用状态', builder: _buildDisabledLinkStats)
          ]),
          ExampleModule(
              title: '组件样式',
              children: [ExampleItem(desc: '链接尺寸', builder: _buildLinkSizes)]),
        ]);
  }

  @Demo(group: 'link')
  Widget _basicTypeBasic(BuildContext context) {
    return Container(
        height: 48,
        color: TTheme.of(context).bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildLinksWithType(TLinkType.basic),
        ));
  }

  List<Widget> _buildLinksWithType(TLinkType type) {
    return [
      TLink(
        label: '跳转链接',
        style: TLinkStyle.primary,
        type: type,
        size: TLinkSize.small,
      ),
      TLink(
        label: '跳转链接',
        style: TLinkStyle.defaultStyle,
        type: type,
        size: TLinkSize.small,
      ),
    ];
  }

  @Demo(group: 'link')
  Widget _withUnderline(BuildContext context) {
    return Container(
        height: 48,
        color: TTheme.of(context).bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildLinksWithType(TLinkType.withUnderline),
        ));
  }

  @Demo(group: 'link')
  Widget _withSuffixIcon(BuildContext context) {
    return Container(
        height: 48,
        color: TTheme.of(context).bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildLinksWithType(TLinkType.withSuffixIcon),
        ));
  }

  @Demo(group: 'link')
  Widget _withPrefixIcon(BuildContext context) {
    return Container(
        height: 48,
        color: TTheme.of(context).bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildLinksWithType(TLinkType.withPrefixIcon),
        ));
  }

  @Demo(group: 'link')
  Widget _buildLinkStats(BuildContext context) {
    return _buildLinkWithStyles(TLinkState.normal);
  }

  @Demo(group: 'link')
  Widget _buildDisabledLinkStats(BuildContext context) {
    return _buildLinkWithStyles(TLinkState.disabled);
  }

  Column _buildLinkWithStyles(TLinkState state) {
    return Column(
      // spacing: 16,
      children: [
        Container(
          height: 48,
          color: TTheme.of(context).bgColorContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLinkWithTypeAndState(TLinkStyle.primary, state),
              _buildLinkWithTypeAndState(TLinkStyle.defaultStyle, state),
              _buildLinkWithTypeAndState(TLinkStyle.danger, state),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 48,
          color: TTheme.of(context).bgColorContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLinkWithTypeAndState(TLinkStyle.warning, state),
              _buildLinkWithTypeAndState(TLinkStyle.success, state),
            ],
          ),
        ),
      ],
    );
  }

  TLink _buildLinkWithTypeAndState(TLinkStyle style, TLinkState state) {
    return TLink(
      label: '跳转链接',
      style: style,
      state: state,
      type: TLinkType.withSuffixIcon,
      size: TLinkSize.small,
    );
  }

  @Demo(group: 'link')
  Widget _buildLinkSizes(BuildContext context) {
    return Container(
        height: 48,
        color: TTheme.of(context).bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildLinkWithSizeAndStyle(TLinkStyle.primary, TLinkSize.small),
            _buildLinkWithSizeAndStyle(TLinkStyle.primary, TLinkSize.medium),
            _buildLinkWithSizeAndStyle(TLinkStyle.primary, TLinkSize.large),
          ],
        ));
  }

  TLink _buildLinkWithSizeAndStyle(TLinkStyle style, TLinkSize size) {
    var s = size == TLinkSize.small
        ? 'S'
        : (size == TLinkSize.medium ? 'M' : 'L');
    return TLink(
      label: '${s}号链接',
      style: style,
      state: TLinkState.normal,
      type: TLinkType.withSuffixIcon,
      size: size,
    );
  }
}
