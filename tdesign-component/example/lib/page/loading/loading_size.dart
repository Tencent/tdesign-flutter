part of 'loading_page.dart';

extension _LoadingSizeModule on _TLoadingPageState {
  ExampleModule get _loadingSizeModule => ExampleModule(
    title: '组件尺寸',
    children: [
      ExampleItem(
        desc: '大尺寸',
        center: false,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        builder: _buildLoadingSizes,
      ),
    ],
  );
}
