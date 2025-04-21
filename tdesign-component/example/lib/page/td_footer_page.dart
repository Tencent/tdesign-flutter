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
      desc: '用于展示App的版权声明、联系信息、重要页面链接和其他相关内容等信息。',
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
    return const TDFooter(
      TDFooterType.text,
      text: 'Copyright © 2019-2023 TDesign.All Rights Reserved.',
    );
  }

  @Demo(group: 'footer')
  Widget _buildSingleLinkFooter(BuildContext context) {
    // 示例链接列表
    final singleLink = <TDLink>[
      TDLink(
        label: '底部链接',
        style: TDLinkStyle.primary,
        // type: TDLinkType.withSuffixIcon,
        uri: Uri.parse('https://example.com'),
        linkClick: (link) {
          print('点击了链接 $link');
        },
      ),
    ];

    return TDFooter(
      TDFooterType.link,
      links: singleLink,
      text: 'Copyright © 2019-2023 TDesign.All Rights Reserved.',
    );
  }

  @Demo(group: 'footer')
  Widget _buildLinksFooter(BuildContext context) {
    final links = <TDLink>[
      TDLink(
        label: '底部链接1',
        style: TDLinkStyle.primary,
        uri: Uri.parse('https://example.com'),
        linkClick: (link) {
          print('点击了链接1 $link');
        },
      ),
      TDLink(
        label: '底部链接2',
        style: TDLinkStyle.primary,
        uri: Uri.parse('https://example.com'),
        linkClick: (link) {
          print('点击了链接2 $link');
        },
      ),
    ];
    return Column(
      children: [
        const SizedBox(height: 12),
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
