part of 'footer_page.dart';

extension _FooterTypeModule on TFooterPage {
  ExampleModule get _footerTypeModule => const ExampleModule(
    title: '类型',
    children: [
      ExampleItem(desc: '基础页脚', builder: _buildFooter),
      ExampleItem(desc: '基础加链接页脚', builder: _buildSingleLinkFooter),
      ExampleItem(desc: '品牌页脚', builder: _buildBrandFooter),
    ],
  );
}
