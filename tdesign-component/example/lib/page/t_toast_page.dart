import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

/// Toast 轻提示示例页面
class TToastPage extends StatelessWidget {
  const TToastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '轻量级反馈/提示，可快速在屏幕中间展示简要信息并自动消失。',
      exampleCodeGroup: 'toast',
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '纯文字', builder: _buildTextToast),
          ExampleItem(desc: '带图标', builder: _buildIconToast),
          ExampleItem(desc: '加载中', builder: _buildLoadingToast),
        ]),
        ExampleModule(title: '组件状态', children: [
          ExampleItem(desc: '成功', builder: _buildSuccessToast),
          ExampleItem(desc: '警告', builder: _buildWarningToast),
          ExampleItem(desc: '失败', builder: _buildFailToast),
        ]),
        ExampleModule(title: '展示时长', children: [
          ExampleItem(desc: '自定义时长', builder: _buildCustomDurationToast),
        ]),
      ],
    );
  }

  @ExampleCode(group: 'toast')
  Widget _buildTextToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('纯文字'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showText('这是一条纯文字提示', context: context);
        },
      ),
    );
  }

  @ExampleCode(group: 'toast')
  Widget _buildIconToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('带图标'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showIconText(
            '这是一条带图标的提示',
            icon: TIcons.info_circle,
            context: context,
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'toast')
  Widget _buildLoadingToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('加载中'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          final id = TToast.showLoading(
            context: context,
            text: '加载中...',
          );
          // 2 秒后关闭
          Future.delayed(const Duration(seconds: 2), () {
            TToast.dismissToast(id);
          });
        },
      ),
    );
  }

  @ExampleCode(group: 'toast')
  Widget _buildSuccessToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('成功'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showSuccess('操作成功', context: context);
        },
      ),
    );
  }

  @ExampleCode(group: 'toast')
  Widget _buildWarningToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('警告'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.danger,
        onPressed: () {
          TToast.showWarning('请注意风险', context: context);
        },
      ),
    );
  }

  @ExampleCode(group: 'toast')
  Widget _buildFailToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('失败'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.danger,
        onPressed: () {
          TToast.showFail('操作失败', context: context);
        },
      ),
    );
  }

  @ExampleCode(group: 'toast')
  Widget _buildCustomDurationToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('自定义时长（5秒）'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showText(
            '这条提示将显示 5 秒',
            context: context,
            duration: const Duration(seconds: 5),
          );
        },
      ),
    );
  }
}
