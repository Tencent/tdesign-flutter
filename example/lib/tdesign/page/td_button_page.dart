import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

// ignore: use_key_in_widget_constructors
class TdButtonPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TdButtonPageState();
}

class _TdButtonPageState extends State<TdButtonPage> {
  final GlobalKey _btnKey = GlobalKey();

  void onClick() {
    TDToast.showText(context, "点击了按钮");
  }

  void onLongClick() {
    TDToast.showText(context, "长按了按钮");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('button组件'),
        ),
        body: Container(
          color: Colors.white,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  TDButton(
                    content: "常规S",
                    width: 80,
                    theme: TDButtonTheme.Primary,
                    shape: TDButtonShape.Round,
                    size: TDButtonSize.Small,
                    click: onClick,
                    longClick: onLongClick,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  TDButton(
                    content: "常规M",
                    width: 200,
                    theme: TDButtonTheme.Default,
                    shape: TDButtonShape.Round,
                    size: TDButtonSize.Medium,
                    click: onClick,
                    longClick: onLongClick,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  TDButton(
                    content: "常规L",
                    width: 300,
                    theme: TDButtonTheme.Default,
                    shape: TDButtonShape.Round,
                    size: TDButtonSize.Large,
                    click: onClick,
                    longClick: onLongClick,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              Column(
                children: [
                  TDButton(
                    content: "强调S",
                    width: 80,
                    theme: TDButtonTheme.Primary,
                    shape: TDButtonShape.Round,
                    size: TDButtonSize.Small,
                    click: onClick,
                    longClick: onLongClick,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  TDButton(
                    content: "强调M",
                    width: 200,
                    theme: TDButtonTheme.Primary,
                    shape: TDButtonShape.Round,
                    size: TDButtonSize.Medium,
                    click: onClick,
                    longClick: onLongClick,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  TDButton(
                    key: _btnKey,
                    content: "强调L",
                    theme: TDButtonTheme.Primary,
                    shape: TDButtonShape.Round,
                    size: TDButtonSize.Large,
                    type: TDButtonType.Progress,
                    click: onClick,
                    longClick: onLongClick,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              Column(
                children: [
                  TDButton(
                    content: "不可点击",
                    width: 200,
                    theme: TDButtonTheme.Default,
                    shape: TDButtonShape.Round,
                    size: TDButtonSize.Large,
                    disabled: true,
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
