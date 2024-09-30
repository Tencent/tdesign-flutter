import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

class TDFormPage extends StatelessWidget {
  const TDFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // debugPaintBaselinesEnabled = true;
    return ExamplePage(
      title: tdTitle(context),
      exampleCodeGroup: 'form',
      backgroundColor: const Color(0xfff6f6f6),
      children: [
        ExampleModule(title: '禁用态开关', children: [
          ExampleItem(desc: '基础开关', builder: _buildSwitchWithBase),
        ]),
        ExampleModule(title: 'Form', children: [
          ExampleItem(desc: '', builder: _buildUserNameItem),
          ExampleItem(desc: '', builder: _buildPassWordItem),
          ExampleItem(desc: '', builder: _buildhorizontalRadiosItem),
        ]),
      ],
    );
  }
}

@Demo(group: 'form')
Widget _buildUserNameItem(BuildContext buildContext) {
  
  return TDFormItem(label:'用户名',
  name: 'name',
  help:'请输入用户名');
}

@Demo(group: 'form')
Widget _buildPassWordItem(BuildContext buildContext) {

  return TDFormItem(label:'密码',
      name: 'password',
      help:'请输入密码');
}

@Demo(group: 'form')
Widget _buildhorizontalRadiosItem(BuildContext buildContext) {

  return TDFormItem(label:'性别',
      name: 'gender',
      );
}

@Demo(group: 'switch')
Widget _buildSwitchWithBase(BuildContext context) {
  return _buildItem(
    context,
    const TDSwitch(),
    title: '禁用态',
  );
}

/// 每一项的封装
@Demo(group: 'switch')
Widget _buildItem(BuildContext context, Widget switchItem,
    {String? title, String? desc}) {
  final theme = TDTheme.of(context);
  Widget current = Row(
    children: [
      Expanded(
          child: TDText(
            title ?? '',
            textColor: theme.fontGyColor1,
          )),
      TDText(
        desc ?? '',
        textColor: theme.grayColor6,
      ),
      SizedBox(child: switchItem)
    ],
  );
  current = Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: SizedBox(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: current,
        ),
        color: Colors.white,
      ),
      height: 56,
    ),
  );
  return Column(mainAxisSize: MainAxisSize.min, children: [current]);
}
