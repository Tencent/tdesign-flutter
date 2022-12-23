/*
 * Created by haozhicao@tencent.com on 6/17/22.
 * td_dialog_page.dart
 * 
 */

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

import '../../base/example_widget.dart';

class TDDialogPage extends StatefulWidget {
  const TDDialogPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDDialogPageState();
}

class _TDDialogPageState extends State<TDDialogPage> {
  final _dialogTitle = '对话框标题';
  final _commonContent = '告知当前状态、信息和解决方法，等内容。描述尽可能控制在三行内。';
  final _longContent = '这里是辅助内容文案，这里是辅助内容文案，这里是辅助内容文案，这里是辅助内容文案。\n\n' * 4;
  final _inputHint = '请输入文字';
  final _demoImage = Image.asset(
    'assets/img/brand.png',
  );

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: '对话框 Dialog',
        desc: '用于显示重要提示或请求用户进行重要操作，一种打断当前操作的模态视图。',
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(
                desc: '反馈类对话框',
                builder: (_) => _buildButton(
                    '反馈类-带标题',
                    TDConfirmDialog(
                      title: _dialogTitle,
                      content: _commonContent,
                    ))),
            ExampleItem(
                builder: (_) => _buildButton(
                    '反馈类-无标题',
                    TDConfirmDialog(
                      content: _commonContent,
                    ))),
            ExampleItem(
                builder: (_) => _buildButton(
                    '反馈类-纯标题',
                    TDConfirmDialog(
                      title: _dialogTitle,
                    ))),
            ExampleItem(
                builder: (_) => _buildButton(
                    '反馈类-内容超长',
                    TDConfirmDialog(
                      title: _dialogTitle,
                      content: _longContent,
                      contentMaxHeight: 300,
                    ))),
            ExampleItem(
                desc: '确认类对话框',
                builder: (_) => _buildButton(
                    '确认类-带标题',
                    TDAlertDialog(
                      title: _dialogTitle,
                      content: _commonContent,
                    ))),
            ExampleItem(
                builder: (_) => _buildButton(
                    '确认类-无标题',
                    TDAlertDialog(
                      content: _commonContent,
                    ))),
            ExampleItem(
                builder: (_) => _buildButton(
                    '确认类-纯标题',
                    TDAlertDialog(
                      title: _dialogTitle,
                    ))),
            ExampleItem(
                desc: '输入类对话框',
                builder: (_) => _buildButton(
                    '输入类-带描述',
                    TDInputDialog(
                      textEditingController: TextEditingController(),
                      title: _dialogTitle,
                      content: _commonContent,
                      hintText: _inputHint,
                    ))),
            ExampleItem(
                builder: (_) => _buildButton(
                    '输入类-无描述',
                    TDInputDialog(
                      textEditingController: TextEditingController(),
                      title: _dialogTitle,
                      hintText: _inputHint,
                    ))),
            ExampleItem(
                desc: '带图片的对话框',
                builder: (_) => _buildButton(
                    '图片置顶-带标题描述',
                    TDImageDialog(
                      image: _demoImage,
                      title: _dialogTitle,
                      content: _commonContent,
                    ))),
            ExampleItem(
                builder: (_) => _buildButton(
                    '图片置顶-无标题',
                    TDImageDialog(
                      image: _demoImage,
                      content: _commonContent,
                    ))),
            ExampleItem(
                builder: (_) => _buildButton(
                    '图片置顶-纯标题',
                    TDImageDialog(
                      image: _demoImage,
                      title: _dialogTitle,
                    ))),
            ExampleItem(
                builder: (_) => _buildButton(
                    '图片居中-带标题描述',
                    TDImageDialog(
                      image: _demoImage,
                      title: _dialogTitle,
                      content: _commonContent,
                      imagePosition: TDDialogImagePosition.middle,
                    ))),
            ExampleItem(
                builder: (_) => _buildButton(
                    '图片居中-纯标题',
                    TDImageDialog(
                      image: _demoImage,
                      title: _dialogTitle,
                      imagePosition: TDDialogImagePosition.middle,
                    ))),
            ExampleItem(
                builder: (_) => _buildButton(
                    '图片居中-纯图片',
                    TDImageDialog(
                      image: _demoImage,
                      imagePosition: TDDialogImagePosition.middle,
                    ))),
          ]),
          ExampleModule(title: '组件类型', children: [
            ExampleItem(
                desc: '文字按钮',
                builder: (_) => _buildButton(
                    '文字按钮',
                    TDConfirmDialog(
                      title: _dialogTitle,
                      content: _commonContent,
                      buttonStyle: TDDialogButtonStyle.text,
                    ))),
            ExampleItem(
                desc: '横向基础按钮',
                builder: (_) =>
                    _buildButton('横向基础按钮', const TDConfirmDialog())),
            ExampleItem(
                desc: '纵向基础按钮',
                builder: (_) =>
                    _buildButton('纵向基础按钮', const TDConfirmDialog())),
            ExampleItem(
                desc: '带关闭按钮的对话框',
                builder: (_) =>
                    _buildButton('带关闭按钮的对话框', const TDConfirmDialog())),
          ]),
        ]);
  }

  Widget _buildButton(String title, Widget dialog) {
    return TDButton(
      content: title,
      size: TDButtonSize.large,
      style: TDButtonStyle.weakly(),
      onTap: () {
        _showDialog(dialog);
      },
    );
  }

  void _showDialog(Widget dialog, {bool useRootNavigator = false}) {
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
}
