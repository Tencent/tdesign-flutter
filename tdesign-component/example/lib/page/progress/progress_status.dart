part of 'progress_page.dart';

extension _ProgressStatusModule on TProgressPage {
  ExampleModule get _progressStatusModule => ExampleModule(
    title: '组件状态',
    children: [
      ExampleItem(desc: '线性进度条', builder: _buildLinearStatus),
      ExampleItem(desc: '百分比内显进度条', builder: _buildPlumpStatus),
      ExampleItem(desc: '环形进度条', builder: _buildCircleStatus),
    ],
  );
}
