part of 'avatar_page.dart';

extension _AvatarSpecialModule on _TAvatarPageState {
  ExampleModule get _avatarSpecialModule => ExampleModule(
    title: '特殊类型',
    children: [
      ExampleItem(
        desc: '纯展示的头像组',
        padding: _avatarItemPadding,
        center: false,
        builder: _buildDisplayAvatar,
      ),
      ExampleItem(
        desc: '带操作的头像组',
        padding: _avatarItemPadding,
        center: false,
        builder: _buildOperationAvatar,
      ),
    ],
  );
}
