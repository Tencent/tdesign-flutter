import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

part 'toast_basic.dart';
part 'toast_status.dart';
part 'toast_mask.dart';
part 'toast_manual_close.dart';

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
        _toastBasicModule,
        _toastStatusModule,
        _toastMaskModule,
        _toastManualCloseModule,
      ],
    );
  }

  @ExampleCode(group: 'toast')
  Widget _buildTextToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('纯文本'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showText('轻提示文字内容', context: context);
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
          TToast.showText('最多一行展示十个汉字宽度限制最多不超过三行文字', context: context);
        },
      ),
    );
  }

  @ExampleCode(group: 'toast')
  Widget _buildHorizontalIconToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('带横向图标'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showIconText(
            '带横向图标',
            icon: TIcons.check_circle,
            direction: IconTextDirection.horizontal,
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
        child: const Text('带竖向图标'),
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
  Widget _buildLoadingToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('加载状态'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          final id = TToast.showLoading(text: '加载中...', context: context);
          // 3 秒后关闭
          Future.delayed(const Duration(seconds: 3), () {
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
        child: const Text('成功提示'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showSuccess(
            '成功文案',
            direction: IconTextDirection.vertical,
            context: context,
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'toast')
  Widget _buildWarningToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('警告提示'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showWarning(
            '警告文案',
            direction: IconTextDirection.vertical,
            context: context,
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'toast')
  Widget _buildFailToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('错误提示'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showFail(
            '错误文案',
            direction: IconTextDirection.vertical,
            context: context,
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'toast')
  Widget _buildCoverToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('禁止滑动和点击'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TToast.showText(
            '禁止滑动和点击',
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

  /// 手动关闭 demo 中「显示提示」返回的实例 ID，供「关闭提示」定向关闭。
  static String? _manualToastId;

  @ExampleCode(group: 'toast')
  Widget _buildShowToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('显示提示'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          _manualToastId = TToast.showText(
            '轻提示文字内容',
            context: context,
            duration: const Duration(seconds: 99999999),
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'toast')
  Widget _buildHideToast(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('关闭提示'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          final id = _manualToastId;
          if (id != null) {
            TToast.dismissToast(id);
          }
        },
      ),
    );
  }
}
