part of 'progress_page.dart';

extension _ProgressTypeModule on TProgressPage {
  ExampleModule get _progressTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(desc: '线性进度条', builder: _buildLinear),
      ExampleItem(desc: '百分比内显', builder: _buildPlump),
      ExampleItem(desc: '环形进度条', builder: _buildCircle),
      ExampleItem(desc: '微型环形进度条', builder: _buildMicroCircle),
      ExampleItem(desc: '带操作按钮', builder: _buildButton),
      ExampleItem(desc: '微型按钮进度条', builder: _buildMicroButton),
    ],
  );
}
