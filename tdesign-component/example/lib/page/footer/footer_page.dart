import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'brand_footer_example.dart';
import 'footer_example.dart';
import 'single_link_footer_example.dart';

@ExampleCodeManifest()
class TFooterPage extends StatelessWidget {
  const TFooterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '用于展示App的版权声明、联系信息、重要页面链接和其他相关内容等信息。',
      exampleCodeGroup: 'footer',
      children: [
        ExampleModule(
          title: '类型',
          children: [
            ExampleItem(
              desc: '基础页脚',
              methodName: 'FooterExample',
              builder: (_) => const FooterExample(),
            ),
            ExampleItem(
              desc: '基础加链接页脚',
              methodName: 'SingleLinkFooterExample',
              builder: (_) => const SingleLinkFooterExample(),
            ),
            ExampleItem(
              desc: '品牌页脚',
              methodName: 'BrandFooterExample',
              builder: (_) => const BrandFooterExample(),
            ),
          ],
        ),
      ],
    );
  }
}
