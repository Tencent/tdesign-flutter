import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TFooterPage extends StatelessWidget {
  const TFooterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(context),
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
    return const TFooter(
      TFooterType.text,
      text: 'Copyright © 2019-2023 TDesign.All Rights Reserved.',
    );
  }

  @Demo(group: 'footer')
  Widget _buildSingleLinkFooter(BuildContext context) {
    return TFooter(
      TFooterType.link,
      links: [
        TLink(
          label: '底部链接',
          style: TLinkStyle.primary,
          type: TLinkType.withSuffixIcon,
          uri: Uri.parse('https://example.com'),
          linkClick: (link) {
            print('点击了链接 $link');
          },
        ),
      ],
      text: 'Copyright © 2019-2023 TDesign.All Rights Reserved.',
    );
  }

  @Demo(group: 'footer')
  Widget _buildLinksFooter(BuildContext context) {
    return TFooter(
      TFooterType.link,
      links: [
        TLink(
          label: '底部链接1',
          style: TLinkStyle.primary,
          uri: Uri.parse('https://example.com'),
          linkClick: (link) {
            print('点击了链接1 $link');
          },
        ),
        TLink(
          label: '底部链接2',
          style: TLinkStyle.primary,
          uri: Uri.parse('https://example.com'),
          linkClick: (link) {
            print('点击了链接2 $link');
          },
        ),
      ],
      text: 'Copyright © 2019-2023 TDesign.All Rights Reserved.',
    );
  }

  @Demo(group: 'footer')
  Widget _buildBrandFooter(BuildContext context) {
    return const TFooter(
      TFooterType.brand,
      logo: 'assets/img/td_brand.png',
      width: 204,
    );
  }
}
