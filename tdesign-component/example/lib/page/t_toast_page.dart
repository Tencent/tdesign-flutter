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
        ExampleModule(title: '基础提示', children: [
          ExampleItem(desc: '纯文字', builder: _buildTextToast),
          ExampleItem(desc: '多行文字', builder: _buildMultipleTextToast),
          ExampleItem(desc: '竖向图标', builder: _buildVerticalIconToast),
          ExampleItem(
            desc: '加载状态（无文字）',
            builder: _buildLoadingWithoutTextToast,
          ),
          ExampleItem(
            desc: '加载状态自定义',
            builder: _buildLoadingCustomToast,
          ),
        ]),
        ExampleModule(title: '组件状态', children: [
          ExampleItem(desc: '成功', builder: _buildSuccessToast),
          ExampleItem(desc: '警告', builder: _buildWarningToast),
          ExampleItem(desc: '失败', builder: _buildFailToast),
        ]),
        ExampleModule(title: '展示位置', children: [
          ExampleItem(desc: '顶部', builder: _buildTopToast),
          ExampleItem(desc: '居中', builder: _buildMiddleToast),
          ExampleItem(desc: '底部', builder: _buildBottomToast),
        ]),
        ExampleModule(title: '显示遮罩', children: [
          ExampleItem(desc: '半透明遮罩', builder: _buildShowOverlayToast),
        ]),
        ExampleModule(title: '展示时长', children: [
          ExampleItem(desc: '自定义时长', builder: _buildCustomDurationToast),
          ExampleItem(desc: '手动关闭', builder: _buildManualCloseToast),
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
  Widget _buildMultipleTextToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('多行文字'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showText(
            '最多一行展示十个汉字宽度限制最多不超过三行文字',
            context: context,
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'toast')
  Widget _buildVerticalIconToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('竖向图标'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showIconText(
            '带竖向图标',
            icon: TIcons.check_circle,
            direction: IconTextDirection.vertical,
            context: context,
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'toast')
  Widget _buildLoadingWithoutTextToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('加载状态（无文字）'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          final id = TToast.showLoadingWithoutText(context: context);
          // 2 秒后关闭
          Future.delayed(const Duration(seconds: 2), () {
            TToast.dismissToast(id);
          });
        },
      ),
    );
  }

  @ExampleCode(group: 'toast')
  Widget _buildLoadingCustomToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('加载状态自定义'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          final id = TToast.showLoading(
            context: context,
            customWidget: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: context.tTheme.brandColor1,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const TText('加载'),
            ),
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
  Widget _buildTopToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('顶部展示'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showText(
            '顶部提示',
            context: context,
            placement: TToastPlacement.top,
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'toast')
  Widget _buildMiddleToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('居中展示'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showText('居中提示', context: context);
        },
      ),
    );
  }

  @ExampleCode(group: 'toast')
  Widget _buildBottomToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('底部展示'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showText(
            '底部提示',
            context: context,
            placement: TToastPlacement.bottom,
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'toast')
  Widget _buildShowOverlayToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('半透明遮罩'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showText(
            '遮罩展示',
            context: context,
            overlay: const TOverlayConfig(
              showOverlay: true,
              opacity: 0.4,
              preventTap: true,
            ),
          );
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
            null,
            context: context,
            duration: const Duration(seconds: 5),
            customWidget: TweenAnimationBuilder<double>(
              tween: Tween(begin: 5, end: 0),
              duration: const Duration(seconds: 5),
              builder: (context, remaining, _) {
                return TText(
                  '${remaining.ceil()} 秒后关闭',
                  font: context.tTheme.fontBodyMedium,
                  textColor: context.tTheme.textColorAnti,
                );
              },
            ),
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'toast')
  Widget _buildManualCloseToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('手动关闭'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          final id = TToast.showLoading(
            context: context,
            text: '加载中...',
          );
          // 0.5 秒后手动关闭
          Future.delayed(const Duration(milliseconds: 500), () {
            TToast.dismissToast(id);
          });
        },
      ),
    );
  }
}
