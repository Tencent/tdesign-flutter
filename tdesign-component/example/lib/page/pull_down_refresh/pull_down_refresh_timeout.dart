part of 'pull_down_refresh_page.dart';

extension _PullDownRefreshTimeoutModule on _TPullDownRefreshPageState {
  ExampleModule get _pullDownRefreshTimeoutModule => ExampleModule(
    title: '刷新超时',
    children: [
      ExampleItem(
        desc: 'refreshTimeout（小程序已有公开 props 的新增 API 演示，Demo 形态仅参考 Mobile Vue）',
        builder: _buildTimeout,
      ),
    ],
  );
}
