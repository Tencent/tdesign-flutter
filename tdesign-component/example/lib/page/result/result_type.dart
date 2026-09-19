part of 'result_page.dart';

extension _ResultTypeModule on TResultPage {
  ExampleModule get _resultTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(desc: '基础结果', builder: _buildBasicResults),
      ExampleItem(desc: '带描述结果', builder: _buildDescriptionResults),
      ExampleItem(desc: '自定义结果', builder: _buildCustomResult),
      ExampleItem(desc: '页面示例', builder: _buildPageExample),
    ],
  );
}
