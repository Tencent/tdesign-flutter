part of 'avatar_page.dart';

extension _AvatarSizeModule on _TAvatarPageState {
  ExampleModule get _avatarSizeModule => ExampleModule(
    title: '组件尺寸',
    children: [
      ExampleItem(
        desc: '组件尺寸',
        padding: _avatarItemPadding,
        builder: _buildSizeAvatar,
      ),
    ],
  );
}
