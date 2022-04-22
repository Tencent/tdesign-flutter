import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

// ignore: use_key_in_widget_constructors
class TdAvatarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TdAvatarPageState();
}

class _TdAvatarPageState extends State<TdAvatarPage> {
  @override
  Widget build(BuildContext context) {
    String imgUrl = 'https://photo.16pic.com/00/53/26/16pic_5326745_b.jpg';
    return Scaffold(
        appBar: AppBar(
          title: const Text('avatar组件'),
        ),
        body: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  TDAvatar(
                      size: TDAvatarSize.Large,
                      type: TDAvatarType.Default,
                      avatarUrl: imgUrl),
                  TDAvatar(
                      size: TDAvatarSize.Large,
                      type: TDAvatarType.Circle,
                      avatarUrl: imgUrl),
                  TDAvatar(
                      size: TDAvatarSize.Large,
                      type: TDAvatarType.Square,
                      avatarUrl: imgUrl),
                  const TDAvatar(
                    size: TDAvatarSize.Large,
                    type: TDAvatarType.CustomText,
                    text: 'W',
                  ),
                ]),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  TDAvatar(
                      size: TDAvatarSize.Medium,
                      type: TDAvatarType.Default,
                      avatarUrl: imgUrl),
                  TDAvatar(
                      size: TDAvatarSize.Medium,
                      type: TDAvatarType.Circle,
                      avatarUrl: imgUrl),
                  TDAvatar(
                      size: TDAvatarSize.Medium,
                      type: TDAvatarType.Square,
                      avatarUrl: imgUrl),
                  const TDAvatar(
                    size: TDAvatarSize.Medium,
                    type: TDAvatarType.CustomText,
                    text: 'A',
                  ),
                ]),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  TDAvatar(
                      size: TDAvatarSize.Small,
                      type: TDAvatarType.Default,
                      avatarUrl: imgUrl),
                  TDAvatar(
                      size: TDAvatarSize.Small,
                      type: TDAvatarType.Circle,
                      avatarUrl: imgUrl),
                  TDAvatar(
                      size: TDAvatarSize.Small,
                      type: TDAvatarType.Square,
                      avatarUrl: imgUrl),
                  const TDAvatar(
                    size: TDAvatarSize.Small,
                    type: TDAvatarType.CustomText,
                    text: 'T',
                  ),
                ]),
              ],
            )));
  }
}
