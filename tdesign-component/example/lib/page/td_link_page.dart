import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TDLinkViewPage extends StatefulWidget {
  const TDLinkViewPage({Key? key}) : super(key: key);

  @override
  _TDLinkViewPageState createState() => _TDLinkViewPageState();
}

class _TDLinkViewPageState extends State<TDLinkViewPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tdTitle(),
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
        color: TDTheme.of(context).bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildLinksWithType(TDLinkType.basic),
        ));
  }

  List<Widget> _buildLinksWithType(TDLinkType type) {
    return [
      TDLink(
        label: '跳转链接',
        style: TDLinkStyle.primary,
        type: type,
        size: TDLinkSize.small,
      ),
      TDLink(
        label: '跳转链接',
        style: TDLinkStyle.defaultStyle,
        type: type,
        size: TDLinkSize.small,
      ),
    ];
  }

  @Demo(group: 'link')
  Widget _withUnderline(BuildContext context) {
    return Container(
        height: 48,
        color: TDTheme.of(context).bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildLinksWithType(TDLinkType.withUnderline),
        ));
  }

  @Demo(group: 'link')
  Widget _withSuffixIcon(BuildContext context) {
    return Container(
        height: 48,
        color: TDTheme.of(context).bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildLinksWithType(TDLinkType.withSuffixIcon),
        ));
  }

  @Demo(group: 'link')
  Widget _withPrefixIcon(BuildContext context) {
    return Container(
        height: 48,
        color: TDTheme.of(context).bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildLinksWithType(TDLinkType.withPrefixIcon),
        ));
  }

  @Demo(group: 'link')
  Widget _buildLinkStats(BuildContext context) {
    return _buildLinkWithStyles(TDLinkState.normal);
  }

  @Demo(group: 'link')
  Widget _buildDisabledLinkStats(BuildContext context) {
    return _buildLinkWithStyles(TDLinkState.disabled);
  }

  Column _buildLinkWithStyles(TDLinkState state) {
    return Column(
      spacing: 16,
      children: [
        Container(
            height: 48,
            color: TDTheme.of(context).bgColorContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLinkWithTypeAndState(TDLinkStyle.primary, state),
                _buildLinkWithTypeAndState(TDLinkStyle.defaultStyle, state),
                _buildLinkWithTypeAndState(TDLinkStyle.danger, state),
              ],
            )),
        Container(
            height: 48,
            color: TDTheme.of(context).bgColorContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLinkWithTypeAndState(TDLinkStyle.warning, state),
                _buildLinkWithTypeAndState(TDLinkStyle.success, state),
              ],
            )),
      ],
    );
  }

  TDLink _buildLinkWithTypeAndState(TDLinkStyle style, TDLinkState state) {
    return TDLink(
      label: '跳转链接',
      style: style,
      state: state,
      type: TDLinkType.withSuffixIcon,
      size: TDLinkSize.small,
    );
  }

  @Demo(group: 'link')
  Widget _buildLinkSizes(BuildContext context) {
    return Container(
        height: 48,
        color: TDTheme.of(context).bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildLinkWithSizeAndStyle(TDLinkStyle.primary, TDLinkSize.small),
            _buildLinkWithSizeAndStyle(TDLinkStyle.primary, TDLinkSize.medium),
            _buildLinkWithSizeAndStyle(TDLinkStyle.primary, TDLinkSize.large),
          ],
        ));
  }

  TDLink _buildLinkWithSizeAndStyle(TDLinkStyle style, TDLinkSize size) {
    var s = size == TDLinkSize.small
        ? 'S'
        : (size == TDLinkSize.medium ? 'M' : 'L');
    return TDLink(
      label: '${s}号链接',
      style: style,
      state: TDLinkState.normal,
      type: TDLinkType.withSuffixIcon,
      size: size,
    );
  }
}
