import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDToastPage extends StatefulWidget {
  const TDToastPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDToastPageState();
}

class _TDToastPageState extends State<TDToastPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tdTitle(),
        desc: '用于轻量级反馈或提示，不会打断用户操作。',
        exampleCodeGroup: 'toast',
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(desc: '纯文字', builder: _textToast),
            ExampleItem(desc: '多行文字', builder: _multipleToast),
            ExampleItem(desc: '带横向图标', builder: _horizontalIconToast),
            ExampleItem(desc: '带竖向图标', builder: _verticalIconToast),
            ExampleItem(desc: '加载状态', builder: _loadingToast),
            ExampleItem(desc: '加载状态(无文字)', builder: _loadingWithoutTextToast),
            ExampleItem(desc: '停止加载', builder: _dismissLoadingToast),
          ]),
          ExampleModule(title: '组件状态', children: [
            ExampleItem(desc: '成功提示', builder: _successToast),
            ExampleItem(desc: '成功提示(竖向)', builder: _successVerticalToast),
            ExampleItem(desc: '警告提示', builder: _warningToast),
            ExampleItem(desc: '警告提示(竖向)', builder: _warningVerticalToast),
            ExampleItem(desc: '失败提示', builder: _failToast),
            ExampleItem(desc: '失败提示(竖向)', builder: _failVerticalToast),
          ])
        ],
      test: [
        ExampleItem(desc: '禁止滚动+点击', builder: _preventTapToast),
      ],
    );
  }

  @Demo(group: 'toast')
  Widget _textToast(BuildContext context) {
    return TDButton(
      onTap: () {
        TDToast.showText('轻提示文字内容', context: context);
      },
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '纯文字',
    );
  }

  @Demo(group: 'toast')
  Widget _multipleToast(BuildContext context) {
    return TDButton(
      onTap: () {
        TDToast.showText('最多一行展示十个汉字宽度限制最多不超过三行文字', context: context);
      },
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '多行文字',
    );
  }

  @Demo(group: 'toast')
  Widget _horizontalIconToast(BuildContext context) {
    return TDButton(
      onTap: () {
        TDToast.showIconText('带横向图标',
            icon: TDIcons.check_circle, context: context);
      },
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '带横向图标',
    );
  }

  @Demo(group: 'toast')
  Widget _verticalIconToast(BuildContext context) {
    return TDButton(
      onTap: () {
        TDToast.showIconText('带竖向图标',
            icon: TDIcons.check_circle,
            direction: IconTextDirection.vertical,
            context: context);
      },
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '带竖向图标',
    );
  }

  @Demo(group: 'toast')
  Widget _loadingToast(BuildContext context) {
    return TDButton(
      onTap: () {
        TDToast.showLoading(context: context);
      },
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '加载状态',
    );
  }

  @Demo(group: 'toast')
  Widget _loadingWithoutTextToast(BuildContext context) {
    return TDButton(
      onTap: () {
        TDToast.showLoadingWithoutText(context: context);
      },
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '加载状态（无文案）',
    );
  }

  @Demo(group: 'toast')
  Widget _dismissLoadingToast(BuildContext context) {
    return const TDButton(
      onTap: TDToast.dismissLoading,
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '停止加载',
    );
  }

  @Demo(group: 'toast')
  Widget _successToast(BuildContext context) {
    return TDButton(
      onTap: () {
        TDToast.showSuccess('成功文案',context: context);
      },
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '成功提示',
    );
  }

  @Demo(group: 'toast')
  Widget _successVerticalToast(BuildContext context) {
    return TDButton(
      onTap: () {
        TDToast.showSuccess('成功文案',
            direction: IconTextDirection.vertical, context: context);
      },
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '成功提示(竖向)',
    );
  }

  @Demo(group: 'toast')
  Widget _warningToast(BuildContext context) {
    return TDButton(
      onTap: () {
        TDToast.showWarning('警告文案',
            direction: IconTextDirection.horizontal, context: context);
      },
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '警告提示',
    );
  }

  @Demo(group: 'toast')
  Widget _warningVerticalToast(BuildContext context) {
    return TDButton(
      onTap: () {
        TDToast.showWarning('警告文案',
            direction: IconTextDirection.vertical, context: context);
      },
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '警告提示(竖向)',
    );
  }

  @Demo(group: 'toast')
  Widget _failToast(BuildContext context) {
    return TDButton(
      onTap: () {
        TDToast.showFail('失败文案',
            direction: IconTextDirection.horizontal, context: context);
      },
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '失败提示',
    );
  }

  @Demo(group: 'toast')
  Widget _failVerticalToast(BuildContext context) {
    return TDButton(
      onTap: () {
        TDToast.showFail('失败文案',
            direction: IconTextDirection.vertical, context: context);
      },
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '失败提示(竖向)',
    );
  }

  @Demo(group: 'toast')
  Widget _preventTapToast(BuildContext context) {
    return TDButton(
      onTap: () {
        TDToast.showText('轻提示文字内容',
            context: context,
            preventTap: true,
            backgroundColor: Colors.black.withOpacity(0.7));
      },
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      theme: TDButtonTheme.primary,
      isBlock: true,
      text: '禁止滚动+点击',
    );
  }
}
