import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDAvatarPage extends StatefulWidget {
  const TDAvatarPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDAvatarPageState();
}

class _TDAvatarPageState extends State<TDAvatarPage> {
  @override
  Widget build(BuildContext context) {
    var assetUrl = 'assets/img/td_avatar_1.png';
    var assetUrl2 = 'assets/img/td_avatar_2.png';

    return ExamplePage(
      backgroundColor: TDTheme.of(context).whiteColor1,
      title: '头像 Avatar',
      exampleCodeGroup: 'avatar',
      desc: '用于告知用户，该区域的状态变化或者待处理任务的数量。',
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(
              desc: '图片头像',
              builder: (_) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: buildImageAvatar(assetUrl),
                );
              }),
          ExampleItem(
              desc: '字符头像',
              builder: (_) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: buildTextAvatar(),
                );
              }),
          ExampleItem(
              desc: '图标头像',
              builder: (_) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: buildIconAvatar(),
                );
              }),
          ExampleItem(
              desc: '带徽标头像',
              builder: (_) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: buildBadgeAvatar(assetUrl),
                );
              }),
        ]),
        ExampleModule(title: '特殊类型', children: [
          ExampleItem(
              desc: '纯展示的头像组',
              builder: (_) {
                var avatarList = [assetUrl, assetUrl2, assetUrl, assetUrl2, assetUrl];
                return buildDisplayAvatar(avatarList);
              }),
          ExampleItem(
              desc: '带操作的头像组',
              builder: (_) {
                var avatarList = [assetUrl, assetUrl2, assetUrl, assetUrl2, assetUrl];
                return buildOperationAvatar(avatarList);
              }),
        ]),
        ExampleModule(title: '组件尺寸', children: [
          ExampleItem(
              desc: '大尺寸 :64px',
              builder: (_) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: buildLargeAvatar(assetUrl),
                );
              }),
          ExampleItem(
              desc: '中尺寸 :48px',
              builder: (_) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: buildMediumAvatar(assetUrl),
                );
              }),
          ExampleItem(
              desc: '小尺寸 :40px',
              builder: (_) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: buildSmallAvatar(assetUrl),
                );
              }),
        ])
      ],
    );
  }

  /// 图片头像
  @Demo(group: 'avatar')
  Widget buildImageAvatar(String assetUrl){
    return Row(
      children: [
        TDAvatar(
          size: TDAvatarSize.medium,
          type: TDAvatarType.normal,
          defaultUrl: assetUrl,),
        const SizedBox(width: 32,),
        TDAvatar(
          size: TDAvatarSize.medium,
          type: TDAvatarType.normal,
          shape: TDAvatarShape.square,
          defaultUrl: assetUrl,),
      ],
    );
  }

  /// 字符头像
  @Demo(group: 'avatar')
  Widget buildTextAvatar(){
    return Row(
      children: const [
        TDAvatar(
            size: TDAvatarSize.medium,
            type: TDAvatarType.customText,
            text: 'A'),
        SizedBox(width: 32,),
        TDAvatar(
            size: TDAvatarSize.medium,
            type: TDAvatarType.customText,
            shape: TDAvatarShape.square,
            text: 'A'),
      ],
    );
  }

  /// 图标头像
  @Demo(group: 'avatar')
  Widget buildIconAvatar(){
    return Row(
      children: const [
        TDAvatar(
          size: TDAvatarSize.medium,
          type: TDAvatarType.icon,),
        SizedBox(width: 32,),
        TDAvatar(
          size: TDAvatarSize.medium,
          type: TDAvatarType.icon,
          shape: TDAvatarShape.square,
        ),
      ],
    );
  }

  /// 带徽标头像
  @Demo(group: 'avatar')
  Widget buildBadgeAvatar(String assetUrl){
    return Row(
      children: [
        SizedBox(
          height: 51,
          width: 51,
          child: Stack(
            alignment:Alignment.bottomLeft,
            children: [
              TDAvatar(
                size: TDAvatarSize.medium,
                type: TDAvatarType.normal,
                defaultUrl: assetUrl,),
              const Positioned(child: TDBadge(TDBadgeType.redPoint), right: 0, top: 0)
            ],
          ),
        ),
        const SizedBox(width: 32,),
        SizedBox(
          height: 51,
          width: 51,
          child: Stack(
            alignment:Alignment.bottomLeft,
            children: const [
              TDAvatar(
                  size: TDAvatarSize.medium,
                  type: TDAvatarType.customText,
                  text: 'A'),
              Positioned(child: TDBadge(TDBadgeType.message,count: '8',), right: 0, top: 0)
            ],
          ),
        ),
        const SizedBox(width: 32,),
        SizedBox(
          width: 51,
          height: 51,
          child: Stack(
            alignment:Alignment.bottomLeft,
            children: const [
              TDAvatar(
                size: TDAvatarSize.medium,
                type: TDAvatarType.icon,),
              Positioned(child: TDBadge(TDBadgeType.message,count: '12',), right: 0, top: 0,)
            ],
          ),
        ),
      ],
    );
  }

  /// 纯展示的头像组
  @Demo(group: 'avatar')
  Widget buildDisplayAvatar(List<String> avatarList){
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 16),
      child: TDAvatar(
        size: TDAvatarSize.medium,
        type: TDAvatarType.display,
        displayText: '+5',
        avatarDisplayListAsset: avatarList,),
    );
  }

  /// 带操作的头像组
  @Demo(group: 'avatar')
  Widget buildOperationAvatar(List<String> avatarList){
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 16),
      child: TDAvatar(
          size: TDAvatarSize.medium,
          type: TDAvatarType.operation,
          avatarDisplayListAsset: avatarList,
          onTap: () {
            TDToast.showText('点击了操作', context: context);
          }),
    );
  }

  /// 组件尺寸 大尺寸
  @Demo(group: 'avatar')
  Widget buildLargeAvatar(String assetUrl){
    return Row(
      children: [
        TDAvatar(
          size: TDAvatarSize.large,
          type: TDAvatarType.normal,
          defaultUrl: assetUrl,),
        const SizedBox(width: 32,),
        const TDAvatar(
            size: TDAvatarSize.large,
            type: TDAvatarType.customText,
            text: 'A'),
        const SizedBox(width: 32,),
        const TDAvatar(
          size: TDAvatarSize.large,
          type: TDAvatarType.icon,),
      ],
    );
  }

  /// 组件尺寸 中尺寸
  @Demo(group: 'avatar')
  Widget buildMediumAvatar(String assetUrl){
    return Row(
      children: [
        TDAvatar(
          size: TDAvatarSize.medium,
          type: TDAvatarType.normal,
          defaultUrl: assetUrl,),
        const SizedBox(width: 48,),
        const TDAvatar(
            size: TDAvatarSize.medium,
            type: TDAvatarType.customText,
            text: 'A'),
        const SizedBox(width: 48,),
        const TDAvatar(
          size: TDAvatarSize.medium,
          type: TDAvatarType.icon,),
      ],
    );
  }

  /// 组件尺寸 小尺寸
  @Demo(group: 'avatar')
  Widget buildSmallAvatar(String assetUrl){
    return Row(
      children: [
        TDAvatar(
          size: TDAvatarSize.small,
          type: TDAvatarType.normal,
          defaultUrl: assetUrl,),
        const SizedBox(width: 56,),
        const TDAvatar(
            size: TDAvatarSize.small,
            type: TDAvatarType.customText,
            text: 'A'),
        const SizedBox(width: 56,),
        const TDAvatar(
          size: TDAvatarSize.small,
          type: TDAvatarType.icon,),
      ],
    );
  }
}
