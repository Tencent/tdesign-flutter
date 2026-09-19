part of 'loading_page.dart';

extension _LoadingSpeedModule on _TLoadingPageState {
  ExampleModule get _loadingSpeedModule => ExampleModule(
    title: '加载速度',
    children: [
      ExampleItem(
        desc: '加载速度调整',
        center: false,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        builder: _buildCustomSpeedLoading,
      ),
    ],
  );
}
