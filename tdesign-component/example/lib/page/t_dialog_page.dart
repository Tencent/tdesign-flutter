/*
 * Created by haozhicao@tencent.com on 6/17/22.
 * t_dialog_page.dart
 * 
 */

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDialogPage extends StatefulWidget {
  const TDialogPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDialogPageState();
}

class _TDialogPageState extends State<TDialogPage> {
  final _dialogTitle = '对话框标题';
  final _commonContent = '告知当前状态、信息和解决方法，等内容。描述尽可能控制在三行内。';
  final _longContent = '这里是辅助内容文案，这里是辅助内容文案，这里是辅助内容文案，这里是辅助内容文案。\n\n' * 4;
  final _inputHint = '请输入文字';

  final _demoImage = Image.asset(
    'assets/img/image.png',
  );

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于显示重要提示或请求用户进行重要操作，一种打断当前操作的模态视图。',
      exampleCodeGroup: 'dialog',
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '反馈类对话框', builder: _buildFeedbackNormal),
          ExampleItem(builder: _buildFeedbackNoTitle),
          ExampleItem(builder: _buildFeedbackOnlyTitle),
          ExampleItem(builder: _buildFeedbackLongContent),
          ExampleItem(desc: '确认类对话框', builder: _buildConfirmNormal),
          ExampleItem(builder: _buildConfirmNoTitle),
          ExampleItem(builder: _buildConfirmOnlyTitle),
          ExampleItem(desc: '输入类对话框', builder: _buildInputNormal),
          ExampleItem(builder: _buildInputNoContent),
          ExampleItem(desc: '带图片的对话框', builder: _buildImageTop),
          ExampleItem(builder: _buildImageTopNoTitle),
          ExampleItem(builder: _buildImageTopOnlyTitle),
          ExampleItem(builder: _buildImageMiddle),
          ExampleItem(builder: _buildImageMiddleOnlyTitle),
          ExampleItem(builder: _buildImageMiddleOnlyImage),
        ]),
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '文字按钮', builder: _buildTextButtonSingle),
          ExampleItem(builder: _buildTextButtonDouble),
          ExampleItem(desc: '横向基础按钮', builder: _buildNormalButtonSingle),
          ExampleItem(builder: _buildNormalButtonDouble),
          ExampleItem(desc: '纵向基础按钮', builder: _buildVerticalButtonDouble),
          ExampleItem(builder: _buildVerticalButtonTriple),
          ExampleItem(desc: '带关闭按钮的对话框', builder: _buildDialogWithCloseButton),
        ]),
      ],
      test: [
        ExampleItem(desc: '自定义标题对齐和内容组件', builder: _customFeedbackNormal),
        ExampleItem(builder: _customConfirmNormal),
        ExampleItem(builder: _customConfirmVertical),
        ExampleItem(builder: _customImageTop),
        ExampleItem(desc: '自定义边距和按钮', builder: _customContentAndBtn),
        ExampleItem(desc: '自定义宽度弹窗', builder: _customWidthDialog),
        ExampleItem(desc: '自定义按钮样式', builder: _customButtonStyleDialog)
      ],
    );
  }

  // 反馈类
  @Demo(group: 'dialog')
  Widget _buildFeedbackNormal(BuildContext context) {
    return TButton(
      child: Text('反馈类-带标题'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TConfirmDialog(
              title: _dialogTitle,
              content: _commonContent,
            );
          },
        );
      },
    );
  }

  @Demo(group: 'dialog')
  Widget _buildFeedbackNoTitle(BuildContext context) {
    return TButton(
      child: Text('反馈类-无标题'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TConfirmDialog(
              content: _commonContent,
            );
          },
        );
      },
    );
  }

  @Demo(group: 'dialog')
  Widget _buildFeedbackOnlyTitle(BuildContext context) {
    return TButton(
      child: Text('反馈类-纯标题'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TConfirmDialog(
              title: _dialogTitle,
            );
          },
        );
      },
    );
  }

  @Demo(group: 'dialog')
  Widget _buildFeedbackLongContent(BuildContext context) {
    return TButton(
      child: Text('反馈类-内容超长'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TConfirmDialog(
              title: _dialogTitle,
              content: _longContent,
              contentMaxHeight: 300,
            );
          },
        );
      },
    );
  }

  // 确认类
  @Demo(group: 'dialog')
  Widget _buildConfirmNormal(BuildContext context) {
    return TButton(
      child: Text('确认类-带标题'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TAlertDialog(
              title: _dialogTitle,
              content: _commonContent,
            );
          },
        );
      },
    );
  }

  @Demo(group: 'dialog')
  Widget _buildConfirmNoTitle(BuildContext context) {
    return TButton(
      child: Text('确认类-无标题'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TAlertDialog(
              content: _commonContent,
            );
          },
        );
      },
    );
  }

  @Demo(group: 'dialog')
  Widget _buildConfirmOnlyTitle(BuildContext context) {
    return TButton(
      child: Text('确认类-纯标题'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TAlertDialog(
              title: _dialogTitle,
            );
          },
        );
      },
    );
  }

  // 输入类
  @Demo(group: 'dialog')
  Widget _buildInputNormal(BuildContext context) {
    return TButton(
      child: Text('输入类-带描述'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TInputDialog(
              textEditingController: TextEditingController(),
              title: _dialogTitle,
              content: _commonContent,
              hintText: _inputHint,
            );
          },
        );
      },
    );
  }

  @Demo(group: 'dialog')
  Widget _buildInputNoContent(BuildContext context) {
    return TButton(
      child: Text('输入类-无描述'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TInputDialog(
              textEditingController: TextEditingController(),
              title: _dialogTitle,
              hintText: _inputHint,
            );
          },
        );
      },
    );
  }

  // 图片类型
  @Demo(group: 'dialog')
  Widget _buildImageTop(BuildContext context) {
    return TButton(
      child: Text('图片置顶-带标题描述'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TImageDialog(
              image: _demoImage,
              title: _dialogTitle,
              content: _commonContent,
            );
          },
        );
      },
    );
  }

  @Demo(group: 'dialog')
  Widget _buildImageTopNoTitle(BuildContext context) {
    return TButton(
      child: Text('图片置顶-无标题'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TImageDialog(
              image: _demoImage,
              content: _commonContent,
            );
          },
        );
      },
    );
  }

  @Demo(group: 'dialog')
  Widget _buildImageTopOnlyTitle(BuildContext context) {
    return TButton(
      child: Text('图片置顶-纯标题'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TImageDialog(
              image: _demoImage,
              title: _dialogTitle,
            );
          },
        );
      },
    );
  }

  @Demo(group: 'dialog')
  Widget _buildImageMiddle(BuildContext context) {
    return TButton(
      child: Text('图片居中-带标题描述'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TImageDialog(
              image: _demoImage,
              title: _dialogTitle,
              content: _commonContent,
              imagePosition: TDialogImagePosition.middle,
            );
          },
        );
      },
    );
  }

  @Demo(group: 'dialog')
  Widget _buildImageMiddleOnlyTitle(BuildContext context) {
    return TButton(
      child: Text('图片居中-纯标题'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TImageDialog(
              image: _demoImage,
              title: _dialogTitle,
              imagePosition: TDialogImagePosition.middle,
            );
          },
        );
      },
    );
  }

  @Demo(group: 'dialog')
  Widget _buildImageMiddleOnlyImage(BuildContext context) {
    return TButton(
      child: Text('图片居中-纯图片'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TImageDialog(
              image: _demoImage,
              imagePosition: TDialogImagePosition.middle,
            );
          },
        );
      },
    );
  }

  // 文字按钮
  @Demo(group: 'dialog')
  Widget _buildTextButtonSingle(BuildContext context) {
    return TButton(
      child: Text('单个文字按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TConfirmDialog(
              title: _dialogTitle,
              content: _commonContent,
              buttonStyle: TDialogButtonStyle.text,
            );
          },
        );
      },
    );
  }

  @Demo(group: 'dialog')
  Widget _buildTextButtonDouble(BuildContext context) {
    return TButton(
      child: Text('左右文字按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TAlertDialog(
              title: _dialogTitle,
              content: _commonContent,
              buttonStyle: TDialogButtonStyle.text,
            );
          },
        );
      },
    );
  }

  // 横向基础按钮
  @Demo(group: 'dialog')
  Widget _buildNormalButtonSingle(BuildContext context) {
    return TButton(
      child: Text('单个横向基础按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TConfirmDialog(
              title: _dialogTitle,
              content: _commonContent,
            );
          },
        );
      },
    );
  }

  @Demo(group: 'dialog')
  Widget _buildNormalButtonDouble(BuildContext context) {
    return TButton(
      child: Text('左右横向基础按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TAlertDialog(
              title: _dialogTitle,
              content: _commonContent,
            );
          },
        );
      },
    );
  }

  // 纵向基础按钮
  @Demo(group: 'dialog')
  Widget _buildVerticalButtonDouble(BuildContext context) {
    return TButton(
      child: Text('两个纵向基础按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TAlertDialog.vertical(
                title: _dialogTitle,
                content: _commonContent,
                buttons: [
                  TDialogButtonOptions(
                      title: '主要按钮',
                      action: () {
                        Navigator.pop(context);
                      },
                      colorScheme: TButtonColorScheme.primary),
                  TDialogButtonOptions(
                      title: '次要按钮',
                      titleColor: TTheme.of(context).brandColor7,
                      action: () {
                        Navigator.pop(context);
                      },
                      theme: TButtonColorScheme.light),
                ]);
          },
        );
      },
    );
  }

  @Demo(group: 'dialog')
  Widget _buildVerticalButtonTriple(BuildContext context) {
    return TButton(
      child: Text('三个纵向基础按钮'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TAlertDialog.vertical(
                title: _dialogTitle,
                content: _commonContent,
                buttons: [
                  TDialogButtonOptions(
                      title: '主要按钮',
                      action: () {
                        Navigator.pop(context);
                      },
                      colorScheme: TButtonColorScheme.primary),
                  TDialogButtonOptions(
                      title: '次要按钮',
                      titleColor: TTheme.of(context).brandColor7,
                      action: () {
                        Navigator.pop(context);
                      },
                      theme: TButtonColorScheme.light),
                  TDialogButtonOptions(
                      title: '次要按钮',
                      titleColor: TTheme.of(context).brandColor7,
                      action: () {
                        Navigator.pop(context);
                      },
                      theme: TButtonColorScheme.light),
                ]);
          },
        );
      },
    );
  }

  @Demo(group: 'dialog')
  Widget _buildDialogWithCloseButton(BuildContext context) {
    return TButton(
      child: Text('带关闭按钮的对话框'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TConfirmDialog(
              title: _dialogTitle,
              content: _commonContent,
              showCloseButton: true,
            );
          },
        );
      },
    );
  }

  // 反馈类
  @Demo(group: 'dialog')
  Widget _customFeedbackNormal(BuildContext context) {
    return TButton(
      child: Text('反馈类-标题偏左'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TConfirmDialog(
              title: _dialogTitle,
              titleAlignment: Alignment.centerLeft,
              contentWidget: TText.rich(TTextSpan(children: [
                TTextSpan(text: '红色文字', textColor: Colors.red),
                TTextSpan(text: '绿色文字', textColor: Colors.green),
              ])),
            );
          },
        );
      },
    );
  }

  @Demo(group: 'dialog')
  Widget _customConfirmNormal(BuildContext context) {
    return TButton(
      child: Text('确认类-标题偏右'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TAlertDialog(
              title: _dialogTitle,
              titleAlignment: Alignment.centerRight,
              contentWidget: TText.rich(TTextSpan(children: [
                TTextSpan(text: '红色文字', textColor: Colors.red),
                TTextSpan(text: '绿色文字', textColor: Colors.green),
              ])),
            );
          },
        );
      },
    );
  }

  @Demo(group: 'dialog')
  Widget _customConfirmVertical(BuildContext context) {
    return TButton(
      child: Text('纵向按钮-自定义内容'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TAlertDialog.vertical(
                title: _dialogTitle,
                contentWidget: TText.rich(TTextSpan(children: [
                  TTextSpan(text: '红色文字', textColor: Colors.red),
                  TTextSpan(text: '绿色文字', textColor: Colors.green),
                ])),
                buttons: [
                  TDialogButtonOptions(
                      title: '主要按钮',
                      action: () {
                        Navigator.pop(context);
                      },
                      colorScheme: TButtonColorScheme.primary),
                  TDialogButtonOptions(
                      title: '次要按钮',
                      titleColor: TTheme.of(context).brandColor7,
                      action: () {
                        Navigator.pop(context);
                      },
                      theme: TButtonColorScheme.light),
                ]);
          },
        );
      },
    );
  }

  @Demo(group: 'dialog')
  Widget _customImageTop(BuildContext context) {
    return TButton(
      child: Text('图片置顶-自定义列表内容'),
      size: TButtonSize.large,
      variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TImageDialog(
              image: _demoImage,
              title: _dialogTitle,
              contentWidget: ListView(
                shrinkWrap: true,
                children: const [
                  TText('红色文字', textColor: Colors.red),
                  TText('绿色文字', textColor: Colors.green),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @Demo(group: 'dialog')
  Widget _customContentAndBtn(BuildContext context) {
    return TButton(
        child: Text('自定义边距和按钮'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          showGeneralDialog(
              context: context,
              pageBuilder: (BuildContext buildContext,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return TConfirmDialog(
                  title: _dialogTitle,
                  content: _commonContent,
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  buttonWidget: Container(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                    child: TButton(
                      child: Text('自定义按钮'),
                      colorScheme: TButtonColorScheme.primary,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                );
              });
        });
  }

  @Demo(group: 'dialog')
  Widget _customWidthDialog(BuildContext context) {
    return TButton(
        child: Text('自定义弹窗宽度'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          showGeneralDialog(
              context: context,
              pageBuilder: (BuildContext buildContext,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return TConfirmDialog(
                  width: 500,
                  title: _dialogTitle,
                  content: _commonContent,
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  buttonWidget: Container(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                    child: TButton(
                      child: Text('自定义按钮'),
                      colorScheme: TButtonColorScheme.primary,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                );
              });
        });
  }

  @Demo(group: 'dialog')
  Widget _customButtonStyleDialog(BuildContext context) {
    return TButton(
        child: Text('自定义按钮样式'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,`r`n      colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          showGeneralDialog(
              context: context,
              pageBuilder: (BuildContext buildContext,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return TConfirmDialog(
                  title: _dialogTitle,
                  content: _commonContent,
                  buttonStyleCustom: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(TTheme.of(context).errorClickColor),
                      foregroundColor: WidgetStatePropertyAll(TTheme.of(context).whiteColor1),
                      side: WidgetStatePropertyAll(BorderSide(color: TTheme.of(context).successClickColor, width: 1)),
                    ),
                );
              });
        });
  }
}
