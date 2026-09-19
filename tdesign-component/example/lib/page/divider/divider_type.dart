part of 'divider_page.dart';

extension _DividerTypeModule on TDividerPage {
  ExampleModule get _dividerTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(
        key: const Key('divider-base-example'),
        desc: '水平分割线',
        center: false,
        builder: _buildBaseDividers,
      ),
    ],
  );
}
