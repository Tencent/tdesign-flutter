/*
 * Created by haozhicao@tencent.com on 6/17/22.
 * td_dialog_page.dart
 * 
 */

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

import '../example_widget.dart';


class TDDialogPage extends StatefulWidget {
  const TDDialogPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDDialogPageState();
}

class _TDDialogPageState extends State<TDDialogPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: '对话框 Dialog',
        padding: const EdgeInsets.all(3),
        children: [
          _dividerWidget('确认弹框'),
          ElevatedButton(
              onPressed: () {
                _showDialog(const TDConfirmDialog(
                  title: '对话框标题',
                ));
              },
              child: const Text('只有标题')),
          ElevatedButton(
              onPressed: () {
                _showDialog(const TDConfirmDialog(
                  title: '对话框标题长，对话框标题长，对话框标题长长长长长长长长',
                ));
              },
              child: const Text('长标题')),
          ElevatedButton(
              onPressed: () {
                _showDialog(const TDConfirmDialog(
                  content:
                      '告知当前状态、信息和解决方法，等内容。描述文案尽可能控制在三行内,告知当前状态、信息和解决方法，等内容。描述文案尽可能控制在三行内告知当前状态、信息和解决方法，等内容。描述文案尽可能控制在三行内',
                ));
              },
              child: const Text('只有内容')),
          ElevatedButton(
              onPressed: () {
                _showDialog(TDConfirmDialog(
                  title: '对话框标题',
                  content:
                      '告知当前状态、信息和解决方法，等内容。描述文案尽可能控制在三行内,告知当前状态、信息和解决方法，等内容。',
                  action: () {
                    print('知道了');
                  },
                ));
              },
              child: const Text('标题+内容')),
          ElevatedButton(
              onPressed: () {
                _showDialog(const TDConfirmDialog(
                  contentMaxHeight: 100,
                  title: '对话框标题',
                  content:
                      '告知当前状态、信息和解决方法，等内容。描述文案很多描述文案很多描述文案很多描述文案很多描述文案很多描述文案很多描述文案很多描述文案很多描述文案很多描述文案很多描述文案很多描述文案很多描述文案很多描述文案很多描述文案很多描述文案很多描述文案很多描述文案很多描述文案很多描述文案很多描述文案很多描述文案很多描述文案很多描述文案很多描述文案很多描述文案很多描述文案很多描述文案很多描述文案很',
                ));
              },
              child: const Text('标题+可滚动内容')),
          _dividerWidget('多选项弹窗'),
          ElevatedButton(
              onPressed: () {
                _showDialog(TDAlertDialog(
                  title: '对话框标题',
                  content:
                      '告知当前状态、信息和解决方法，等内容。描述文案尽可能控制在三行内,告知当前状态、信息和解决方法，等内容。',
                  rightBtn: TDDialogButton(
                      title: '确定',
                      action: () {
                        print('点击了确定按钮');
                      }),
                ));
              },
              child: const Text('左右选择')),
          ElevatedButton(
              onPressed: () {
                _showDialog(TDAlertDialog.vertical(
                  title: '对话框标题',
                  content:
                      '告知当前状态、信息和解决方法，等内容。描述文案尽可能控制在三行内,告知当前状态、信息和解决方法，等内容。',
                  buttons: [
                    TDDialogButton(
                        title: '第一行',
                        action: () {
                          print('点击了第一行');
                        }),
                    TDDialogButton(
                        title: '第二行',
                        action: () {
                          print('点击了第二行');
                        }),
                    TDDialogButton(
                        title: '取消',
                        action: () {
                          print('点击了取消');
                        },
                        titleColor: Colors.black87,
                        fontWeight: FontWeight.w400)
                  ],
                ));
              },
              child: const Text('上下选择')),
          _dividerWidget('输入类弹窗'),
          ElevatedButton(
              onPressed: () {
                _showDialog(TDInputDialog(
                  title: '对话框标题',
                  content: '告知当前状态、信息和解决方法',
                  textEditingController: TextEditingController(),
                  rightBtn: TDDialogButton(
                      title: '确定',
                      action: () {
                        print('点击了确定按钮');
                      }),
                ));
              },
              child: const Text('输入类对话框')),
          _dividerWidget('带图片弹窗'),
          ElevatedButton(
              onPressed: () {
                _showDialog(TDImageDialog(
                  title: '对话框标题',
                  content: '告知当前状态、信息和解决方法',
                  image: Image.network(
                    'http://static.runoob.com/images/demo/demo2.jpg',
                    // fit: BoxFit.cover,
                  ),
                  rightBtn: TDDialogButton(
                      title: '确定',
                      action: () {
                        print('点击了确定按钮');
                      }),
                ));
              },
              child: const Text('带图片弹窗')),
        ]);
  }

  void _showDialog(Widget dialog,{bool useRootNavigator = false}) {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return dialog;
      },
      useRootNavigator: useRootNavigator,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 100),
    );
  }

  Widget _dividerWidget(String title) {
    return Row(
      children: [
        const Spacer(),
        const TDDivider(
          height: 1,
          width: 100,
        ),
        const SizedBox(
          width: 10,
        ),
        TDText(title),
        const SizedBox(
          width: 10,
        ),
        const TDDivider(
          height: 1,
          width: 100,
        ),
        const Spacer(),
      ],
    );
  }
}
