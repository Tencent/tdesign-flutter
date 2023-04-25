import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

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
        desc: '按照时间顺序或倒序规则的展示信息内容。',
        exampleCodeGroup: 'link',
        children: [
          ExampleModule(title: 'Type 组件类型', children: [
            ExampleItem(desc: 'Basic Link 基础文字链接', builder: _basicTypeBasic),
            ExampleItem(
                desc: 'Link with Underline 下划线文字链接', builder: _withUnderline),
            ExampleItem(
                desc: 'Link with PrefixIcon 前置图标文字链接',
                builder: _withPrefixIcon),
            ExampleItem(
                desc: 'Link with SuffixIcon 后置图标文字链接',
                builder: _withSuffixIcon),
          ]),
          ExampleModule(title: 'Status 组件状态', children: [
            ExampleItem(desc: 'Link Status 链接状态', builder: _buildLinkStats)
          ]),
          ExampleModule(title: 'Style 组件样式', children: [
            ExampleItem(desc: 'Link Size 链接尺寸', builder: _buildLinkSizes)
          ])
        ]);
  }

  @Demo(group: 'link')
  Widget _basicTypeBasic(BuildContext context) {
    return Row(
      children: _buildLinksWithType(TDLinkType.basic),
    );
  }

  List<Widget> _buildLinksWithType(TDLinkType type) {
    return [
      TDLink(
        label: 'Link',
        style: TDLinkStyle.primary,
        type: type,
        size: TDLinkSize.small,
      ),
      const SizedBox(
        height: 16,
        width: 32,
      ),
      TDLink(
        label: 'Link',
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
    return Row(
      children: _buildLinksWithType(TDLinkType.withUnderline),
    );
  }

  @Demo(group: 'link')
  Widget _withSuffixIcon(BuildContext context) {
    return Row(
      children: _buildLinksWithType(TDLinkType.withSuffixIcon),
    );
  }

  @Demo(group: 'link')
  Widget _withPrefixIcon(BuildContext context) {
    return Row(
      children: _buildLinksWithType(TDLinkType.withPrefixIcon),
    );
  }

  @Demo(group: 'link')
  Widget _buildLinkStats(BuildContext context) {
    return Table(
      children: <TableRow>[
        _buildLinksWithStat(TDLinkState.normal),
        _buildGapRow(),
        _buildLinksWithStat(TDLinkState.active),
        _buildGapRow(),
        _buildLinksWithStat(TDLinkState.disabled),
        _buildGapRow(),
        TableRow(
          children: [
            Text('Primary',
                style: TextStyle(color: TDTheme.of(context).fontGyColor3)),
            Text('Default',
                style: TextStyle(color: TDTheme.of(context).fontGyColor3)),
            Text('Danger',
                style: TextStyle(color: TDTheme.of(context).fontGyColor3)),
            Text('Warning',
                style: TextStyle(color: TDTheme.of(context).fontGyColor3)),
            Text('Success',
                style: TextStyle(color: TDTheme.of(context).fontGyColor3)),
            const Text(''),
          ],
        )
      ],
    );
  }

  TableRow _buildGapRow() {
    return const TableRow(children: [
      SizedBox(height: 20),
      SizedBox(height: 20),
      SizedBox(height: 20),
      SizedBox(height: 20),
      SizedBox(height: 20),
      SizedBox(height: 20)
    ]);
  }

  TableRow _buildLinksWithStat(TDLinkState state) {
    return TableRow(
      children: [
        _buildLinkWithTypeAndState(TDLinkStyle.primary, state),
        _buildLinkWithTypeAndState(TDLinkStyle.defaultStyle, state),
        _buildLinkWithTypeAndState(TDLinkStyle.danger, state),
        _buildLinkWithTypeAndState(TDLinkStyle.warning, state),
        _buildLinkWithTypeAndState(TDLinkStyle.success, state),
        Text(state.name,
            style: TextStyle(color: TDTheme.of(context).fontGyColor3)),
      ],
    );
  }

  TDLink _buildLinkWithTypeAndState(TDLinkStyle style, TDLinkState state) {
    return TDLink(
      label: 'Link',
      style: style,
      state: state,
      type: TDLinkType.withSuffixIcon,
      size: TDLinkSize.large,
    );
  }

  Widget _buildLinkSizes(BuildContext context) {
    return Table(
      children: [
        _buildLinkWithSize(TDLinkSize.large),
        _buildGapRow(),
        _buildLinkWithSize(TDLinkSize.medium),
        _buildGapRow(),
        _buildLinkWithSize(TDLinkSize.small),
      ],
    );
  }

  TableRow _buildLinkWithSize(TDLinkSize size) {
    return TableRow(children: [
      _buildLinkWithSizeAndStyle(TDLinkStyle.primary, size),
      _buildLinkWithSizeAndStyle(TDLinkStyle.defaultStyle, size),
      _buildLinkWithSizeAndStyle(TDLinkStyle.danger, size),
      _buildLinkWithSizeAndStyle(TDLinkStyle.warning, size),
      _buildLinkWithSizeAndStyle(TDLinkStyle.success, size),
      Text(size.name,
          style: TextStyle(color: TDTheme.of(context).fontGyColor3)),
    ]);
  }

  TDLink _buildLinkWithSizeAndStyle(TDLinkStyle style, TDLinkSize size) {
    return TDLink(
      label: 'Link',
      style: style,
      state: TDLinkState.normal,
      type: TDLinkType.withSuffixIcon,
      size: size,
    );
  }
}
