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
      desc: '用于基础列表展示，可附带文字、品牌 logo、操作，常用商详、个人中心、设置等页面。',
      exampleCodeGroup: 'footer',
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
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
