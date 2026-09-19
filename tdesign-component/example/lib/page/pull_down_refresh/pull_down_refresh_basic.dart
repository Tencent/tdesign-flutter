part of 'pull_down_refresh_page.dart';

extension _PullDownRefreshBasicModule on _TPullDownRefreshPageState {
  ExampleModule get _pullDownRefreshBasicModule => ExampleModule(
    title: '顶部下拉刷新',
    children: [
      ExampleItem(
        desc: '基础用法',
        center: false,
        padding: EdgeInsets.zero,
        builder: _buildRefresh,
      ),
    ],
  );
}
