part of 'avatar_page.dart';

extension _AvatarTypeModule on _TAvatarPageState {
  ExampleModule get _avatarTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(
        desc: '图片头像',
        padding: _avatarItemPadding,
        builder: _buildImageAvatar,
      ),
      ExampleItem(
        desc: '字符头像',
        padding: _avatarItemPadding,
        builder: _buildTextAvatar,
      ),
      ExampleItem(
        desc: '图标头像',
        padding: _avatarItemPadding,
        builder: _buildIconAvatar,
      ),
      ExampleItem(
        desc: '带徽标头像',
        padding: _avatarItemPadding,
        builder: _buildBadgeAvatar,
      ),
    ],
  );
}
