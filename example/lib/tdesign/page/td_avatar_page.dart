import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

import '../example_base.dart';

// ignore: use_key_in_widget_constructors
class TDAvatarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TDAvatarPageState();
}

class _TDAvatarPageState extends State<TDAvatarPage> {
  @override
  Widget build(BuildContext context) {
    var imgUrl = 'https://photo.16pic.com/00/53/26/16pic_5326745_b.jpg';
    return ExampleWidget(
      title: '头像 Avatar',
      children: [
        ExampleItem(
            desc: '类型--默认',
            builder: (_) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TDAvatar(
                      size: TDAvatarSize.large,
                      type: TDAvatarType.normal,
                      avatarUrl: imgUrl),
                  TDAvatar(
                      size: TDAvatarSize.medium,
                      type: TDAvatarType.normal,
                      avatarUrl: imgUrl),
                  TDAvatar(
                      size: TDAvatarSize.small,
                      type: TDAvatarType.normal,
                      avatarUrl: imgUrl),
                ],
              );
            }),
        ExampleItem(
            desc: '类型-圆形',
            builder: (_) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TDAvatar(
                      size: TDAvatarSize.large,
                      type: TDAvatarType.circle,
                      avatarUrl: imgUrl),
                  TDAvatar(
                      size: TDAvatarSize.medium,
                      type: TDAvatarType.circle,
                      avatarUrl: imgUrl),
                  TDAvatar(
                      size: TDAvatarSize.small,
                      type: TDAvatarType.circle,
                      avatarUrl: imgUrl),
                ],
              );
            }),
        ExampleItem(
            desc: '类型-方形',
            builder: (_) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TDAvatar(
                      size: TDAvatarSize.large,
                      type: TDAvatarType.square,
                      avatarUrl: imgUrl),
                  TDAvatar(
                      size: TDAvatarSize.medium,
                      type: TDAvatarType.square,
                      avatarUrl: imgUrl),
                  TDAvatar(
                      size: TDAvatarSize.small,
                      type: TDAvatarType.square,
                      avatarUrl: imgUrl),
                ],
              );
            }),
        ExampleItem(
            desc: '类型-自定义文字',
            builder: (_) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  TDAvatar(
                    size: TDAvatarSize.large,
                    type: TDAvatarType.customText,
                    text: 'A',
                  ),
                  TDAvatar(
                    size: TDAvatarSize.medium,
                    type: TDAvatarType.customText,
                    text: 'A',
                  ),
                  TDAvatar(
                    size: TDAvatarSize.small,
                    type: TDAvatarType.customText,
                    text: 'A',
                  ),
                ],
              );
            }),
        ExampleItem(
            desc: '特殊类型-带操作',
            builder: (_) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TDAvatar(
                    size: TDAvatarSize.large,
                    type: TDAvatarType.operation,
                    avatarDisplayList: [
                      imgUrl,
                      imgUrl,
                      imgUrl
                    ],
                    onTap: (){
                      TDToast.showText('点击了操作', context: context);
                    }
                  ),
                  TDAvatar(
                    size: TDAvatarSize.medium,
                    type: TDAvatarType.operation,
                    avatarDisplayList: [
                      imgUrl,
                      imgUrl,
                      imgUrl
                    ],
                    onTap: (){
                      TDToast.showText('点击了操作', context: context);
                    }
                  ),
                  TDAvatar(
                    size: TDAvatarSize.small,
                    type: TDAvatarType.operation,
                    avatarDisplayList: [
                      imgUrl,
                      imgUrl,
                      imgUrl
                    ],
                    onTap: (){
                      TDToast.showText('点击了操作', context: context);
                    }
                  ),
                ],
              );
            }),
        ExampleItem(
            desc: '特殊类型-纯展示',
            builder: (_) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TDAvatar(
                      size: TDAvatarSize.large,
                      type: TDAvatarType.display,
                      avatarDisplayList: [
                        imgUrl,
                        imgUrl,
                        imgUrl
                      ],
                    displayText: '+5',
                  ),
                  TDAvatar(
                      size: TDAvatarSize.medium,
                      type: TDAvatarType.display,
                      avatarDisplayList: [
                        imgUrl,
                        imgUrl,
                        imgUrl
                      ],
                    displayText: '+5',
                  ),
                  TDAvatar(
                      size: TDAvatarSize.small,
                      type: TDAvatarType.display,
                      avatarDisplayList: [
                        imgUrl,
                        imgUrl,
                        imgUrl
                      ],
                    displayText: '+5',
                  ),
                ],
              );
            }),
      ],
    );
  }
}
