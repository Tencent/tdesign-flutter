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
    var imgUrl = 'https://photo.16pic.com/00/53/26/16pic_5326745_b.jpg';
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
                      size: TDAvatarSize.large,
                      type: TDAvatarType.normal,
                      avatarUrl: imgUrl),
                  TDAvatar(
                      size: TDAvatarSize.large,
                      type: TDAvatarType.circle,
                      avatarUrl: imgUrl),
                  TDAvatar(
                      size: TDAvatarSize.large,
                      type: TDAvatarType.square,
                      avatarUrl: imgUrl),
                  const TDAvatar(
                    size: TDAvatarSize.large,
                    type: TDAvatarType.customText,
                    text: 'W',
                  ),
                ]),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  TDAvatar(
                      size: TDAvatarSize.medium,
                      type: TDAvatarType.normal,
                      avatarUrl: imgUrl),
                  TDAvatar(
                      size: TDAvatarSize.medium,
                      type: TDAvatarType.circle,
                      avatarUrl: imgUrl),
                  TDAvatar(
                      size: TDAvatarSize.medium,
                      type: TDAvatarType.square,
                      avatarUrl: imgUrl),
                  const TDAvatar(
                    size: TDAvatarSize.medium,
                    type: TDAvatarType.customText,
                    text: 'A',
                  ),
                ]),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  TDAvatar(
                      size: TDAvatarSize.small,
                      type: TDAvatarType.normal,
                      avatarUrl: imgUrl),
                  TDAvatar(
                      size: TDAvatarSize.small,
                      type: TDAvatarType.circle,
                      avatarUrl: imgUrl),
                  TDAvatar(
                      size: TDAvatarSize.small,
                      type: TDAvatarType.square,
                      avatarUrl: imgUrl),
                  const TDAvatar(
                    size: TDAvatarSize.small,
                    type: TDAvatarType.customText,
                    text: 'T',
                  ),
                ]),
              ],
            )));
  }
}
