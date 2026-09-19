part of 'pull_down_refresh_page.dart';

extension _PullDownRefreshCustomTextModule on _TPullDownRefreshPageState {
  ExampleModule get _pullDownRefreshCustomTextModule => ExampleModule(
    title: '自定义提示语',
    children: [
      ExampleItem(
        desc: 'loadingTexts（小程序已有公开 props 的新增 API 演示，Demo 形态仅参考 Mobile Vue）',
        builder: _buildLoadingTexts,
      ),
    ],
  );
}
