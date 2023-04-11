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
        uri: Uri.parse('https://github.com'),
      ),
      const SizedBox(
        height: 16,
        width: 32,
      ),
      TDLink(
        label: 'Link',
        style: TDLinkStyle.defaultStyle,
        type: type,
        uri: Uri.parse('https://github.com'),
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
}
