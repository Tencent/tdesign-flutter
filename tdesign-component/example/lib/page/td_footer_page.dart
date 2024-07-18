import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDFooterPage extends StatefulWidget {
  const TDFooterPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDFooterPageState();
}

class _TDFooterPageState extends State<TDFooterPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      backgroundColor: TDTheme.of(context).whiteColor1,
      desc: '可以折叠/展开的内容区域。',
      exampleCodeGroup: 'footer',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '基础页脚', builder: _buildFooter),
            ExampleItem(desc: '基础加链接页脚', builder: _buildSingleLinkFooter),
            ExampleItem(desc: '', builder: _buildLinksFooter),
            ExampleItem(desc: '品牌页脚', builder: _buildBrandFooter),
          ],
        ),
      ],
    );
  }

  @Demo(group: 'footer')
  Widget _buildFooter(BuildContext context) {
    return SizedBox(
      height: 30,
      child:  TDFooter(
        TDFooterType.text,
        text: 'Copyright © 2019-2023 TDesign.All Rights Reserved.',
      ),
    );

  }

  @Demo(group: 'footer')
  Widget _buildSingleLinkFooter(BuildContext context) {
    // 示例链接列表
    final singleLink = <LinkObj>[
      LinkObj(name: '底部链接', uri: Uri.parse('https://example.com')),
    ];

    return TDFooter(
      TDFooterType.link,
      links: singleLink,
      text: 'Copyright © 2019-2023 TDesign.All Rights Reserved.',
    );
  }

  @Demo(group: 'footer')
  Widget _buildLinksFooter(BuildContext context) {
    final links = <LinkObj>[
      LinkObj(name: '底部链接', uri: Uri.parse('https://example.com')),
      LinkObj(name: '底部链接', uri: Uri.parse('https://example.com')),
    ];
    return Column(
      children: [
        SizedBox(height: 12),
        TDFooter(
          TDFooterType.link,
          links: links,
          text: 'Copyright © 2019-2023 TDesign.All Rights Reserved.',
        )
      ],
    );
  }

  @Demo(group: 'footer')
  Widget _buildBrandFooter(BuildContext context) {
    return TDFooter(
      TDFooterType.brand,
      logo: 'assets/img/td_brand.png',
      width: 204,
      height: 48,
    );
  }

}
