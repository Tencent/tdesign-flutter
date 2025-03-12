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
        backgroundColor: const Color(0xFFF0F2F5),
        title: tdTitle(),
        desc: '当功能使用图标即可表意清楚时，可使用纯图标悬浮按钮，例如：添加、发布。',
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
        color: TDTheme.of(context).whiteColor1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
      const SizedBox(
        height: 48,
        width: 80,
      ),
      TDLink(
        label: '跳转链接',
        style: TDLinkStyle.defaultStyle,
        type: type,
        size: TDLinkSize.small,
      ),
      const SizedBox(
        height: 16,
      ),
    ];
  }

  @Demo(group: 'link')
  Widget _withUnderline(BuildContext context) {
    return Container(
        color: TDTheme.of(context).whiteColor1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildLinksWithType(TDLinkType.withUnderline),
        ));
  }

  @Demo(group: 'link')
  Widget _withSuffixIcon(BuildContext context) {
    return Container(
        color: TDTheme.of(context).whiteColor1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildLinksWithType(TDLinkType.withSuffixIcon),
        ));
  }

  @Demo(group: 'link')
  Widget _withPrefixIcon(BuildContext context) {
    return Container(
        color: TDTheme.of(context).whiteColor1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
      children: [
        Container(
            color: TDTheme.of(context).whiteColor1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLinkWithTypeAndState(TDLinkStyle.primary, state),
                const SizedBox(height: 48, width: 50),
                _buildLinkWithTypeAndState(TDLinkStyle.defaultStyle, state),
                const SizedBox(height: 48, width: 50),
                _buildLinkWithTypeAndState(TDLinkStyle.danger, state),
              ],
            )),
        const SizedBox(height: 16),
        Container(
            color: TDTheme.of(context).whiteColor1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLinkWithTypeAndState(TDLinkStyle.warning, state),
                const SizedBox(height: 48, width: 50),
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
        color: TDTheme.of(context).whiteColor1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLinkWithSizeAndStyle(TDLinkStyle.primary, TDLinkSize.small),
            const SizedBox(height: 48, width: 40),
            _buildLinkWithSizeAndStyle(TDLinkStyle.primary, TDLinkSize.medium),
            const SizedBox(height: 48, width: 40),
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
