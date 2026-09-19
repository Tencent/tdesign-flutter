part of 'divider_page.dart';

extension _DividerStatusModule on TDividerPage {
  ExampleModule get _dividerStatusModule => ExampleModule(
    title: '组件状态',
    children: [
      ExampleItem(
        key: const Key('divider-dashed-example'),
        desc: '虚线样式',
        center: false,
        builder: _buildDashedDividers,
      ),
    ],
  );
}
