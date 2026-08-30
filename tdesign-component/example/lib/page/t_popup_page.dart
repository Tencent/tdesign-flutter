import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

/// Popup 弹出层示例页面
class TPopupPage extends StatelessWidget {
  const TPopupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '由其他控件触发，屏幕滑出或弹出一块自定义内容区域。',
      exampleCodeGroup: 'popup',
      padding: const EdgeInsets.symmetric(horizontal: 16),
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              key: const ValueKey('popup-base-examples'),
              desc: '基础弹出层',
              builder: _buildBasePopups,
            ),
          ],
        ),
        ExampleModule(
          title: '组件示例',
          children: [
            ExampleItem(
              key: const ValueKey('popup-application-examples'),
              desc: '应用示例',
              builder: _buildApplicationPopups,
            ),
          ],
        ),
      ],
    );
  }

  @ExampleCode(group: 'popup')
  Widget _buildBasePopups(BuildContext context) {
    Widget popupButton(String label, String key, VoidCallback onPressed) {
      return SizedBox(
        width: double.infinity,
        child: TButton(
          key: ValueKey(key),
          onPressed: onPressed,
          size: TButtonSize.large,
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          child: TText(label),
        ),
      );
    }

    return Column(
      children: [
        popupButton('顶部弹出', 'popup-top-trigger', () {
          TPopup.show(
            context,
            options: TPopupOptions.top(
              child: const Center(child: TText('顶部弹出')),
            ),
          );
        }),
        const SizedBox(height: 16),
        popupButton('左侧弹出', 'popup-left-trigger', () {
          TPopup.show(
            context,
            options: TPopupOptions.left(
              child: const Center(child: TText('左侧弹出')),
            ),
          );
        }),
        const SizedBox(height: 16),
        popupButton('中间弹出', 'popup-center-trigger', () {
          TPopup.show(
            context,
            options: TPopupOptions.center(
              child: const Center(child: TText('中间弹出')),
            ),
          );
        }),
        const SizedBox(height: 16),
        popupButton('底部弹出', 'popup-bottom-trigger', () {
          TPopup.show(
            context,
            options: TPopupOptions.bottom(
              child: const Center(
                key: ValueKey('popup-bottom-content'),
                child: TText('底部弹出'),
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        popupButton('右侧弹出', 'popup-right-trigger', () {
          TPopup.show(
            context,
            options: TPopupOptions.right(
              child: const Center(child: TText('右侧弹出')),
            ),
          );
        }),
      ],
    );
  }

  @ExampleCode(group: 'popup')
  Widget _buildApplicationPopups(BuildContext context) {
    Widget popupButton(String label, String key, VoidCallback onPressed) {
      return SizedBox(
        width: double.infinity,
        child: TButton(
          key: ValueKey(key),
          onPressed: onPressed,
          size: TButtonSize.large,
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          child: TText(label),
        ),
      );
    }

    final theme = context.tTheme;
    return Column(
      children: [
        popupButton('底部弹出层-带标题及操作', 'popup-with-title-trigger', () {
          TPopup.show(
            context,
            options: TPopupOptions.bottom(
              height: 240,
              headerBuilder: (_, close) => TPopupHeader(
                cancelButton: TToolbarPressable(
                  onTap: close,
                  child: TText(
                    '取消',
                    textColor: theme.textColorSecondary,
                    font: theme.fontBodyLarge,
                  ),
                ),
                title: const TText('标题文字'),
                confirmButton: TToolbarPressable(
                  onTap: close,
                  child: TText(
                    '确定',
                    textColor: theme.brandNormalColor,
                    font: theme.fontTitleMedium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              child: const SizedBox(key: ValueKey('popup-with-title-content')),
            ),
          );
        }),
        const SizedBox(height: 16),
        popupButton('居中弹出层-带自定义关闭按钮', 'popup-custom-close-trigger', () {
          TPopup.show(
            context,
            options: TPopupOptions.center(
              width: 240,
              height: 240,
              closeBuilder: (_, close) => IconButton(
                tooltip: '关闭',
                icon: Icon(
                  TIcons.close_circle,
                  color: theme.fontWhColor1,
                  size: 32,
                ),
                onPressed: close,
              ),
              child: const SizedBox(
                key: ValueKey('popup-custom-close-content'),
                width: 240,
                height: 240,
              ),
            ),
          );
        }),
      ],
    );
  }
}
