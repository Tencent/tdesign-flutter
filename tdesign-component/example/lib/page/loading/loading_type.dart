part of 'loading_page.dart';

extension _LoadingTypeModule on _TLoadingPageState {
  ExampleModule get _loadingTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(
        desc: '纯图标',
        center: false,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        builder: _buildPureIconLoading,
      ),
      ExampleItem(
        desc: '图标加文字横向',
        center: false,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        builder: _buildTextIconHorizontalLoading,
      ),
      ExampleItem(
        desc: '图标加文字竖向',
        center: false,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        builder: _buildTextIconVerticalLoading,
      ),
      ExampleItem(
        desc: '纯文字',
        center: false,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        builder: _buildPureTextLoading,
      ),
    ],
  );
}
