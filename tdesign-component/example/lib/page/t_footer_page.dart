import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TFooterPage extends StatelessWidget {
  const TFooterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '用于展示App的版权声明、联系信息、重要页面链接和其他相关内容等信息。',
      exampleCodeGroup: 'footer',
      children: const [
        ExampleModule(
          title: '01 类型',
          children: [
            ExampleItem(desc: '基础页脚', builder: _buildFooter),
            ExampleItem(desc: '基础加链接页脚', builder: _buildSingleLinkFooter),
            ExampleItem(desc: '品牌页脚', builder: _buildBrandFooter),
          ],
        ),
      ],
    );
  }
}

@ExampleCode(group: 'footer')
Widget _buildFooter(BuildContext context) {
  return const TFooter(text: 'Copyright © 2021-2031 TD.All Rights Reserved.');
}

@ExampleCode(group: 'footer')
Widget _buildSingleLinkFooter(BuildContext context) {
  TLink link(String text) => TLink(
    child: Text(text),
    underline: true,
    colorScheme: TLinkColorScheme.primary,
    onPressed: () {},
  );
  return Column(
    children: [
      TFooter(
        links: [link('底部链接')],
        text: 'Copyright © 2021-2031 TD.All Rights Reserved.',
      ),
      const SizedBox(height: 24),
      TFooter(
        links: [link('底部链接'), link('底部链接')],
        text: 'Copyright © 2021-2031 TD.All Rights Reserved.',
      ),
    ],
  );
}

@ExampleCode(group: 'footer')
Widget _buildBrandFooter(BuildContext context) {
  const logo = TImage(
    src: 'assets/img/t_brand.png',
    width: 104,
    height: 24,
    fit: BoxFit.contain,
  );
  return const Column(
    children: [
      TFooter(logo: logo),
      SizedBox(height: 24),
      TFooter(logo: logo),
    ],
  );
}
