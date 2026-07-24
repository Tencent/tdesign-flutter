import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

/// Popup 弹出层示例页面
class TPopupPage extends StatelessWidget {
  const TPopupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '由其他控件触发，屏幕滑出或弹出一块自定义内容区域，覆盖屏幕。',
      exampleCodeGroup: 'popup',
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '底部弹出', builder: _buildBottomPopup),
          ExampleItem(desc: '顶部弹出', builder: _buildTopPopup),
          ExampleItem(desc: '左侧弹出', builder: _buildLeftPopup),
          ExampleItem(desc: '右侧弹出', builder: _buildRightPopup),
          ExampleItem(desc: '中间弹出', builder: _buildCenterPopup),
        ]),
      ],
    );
  }

  @Demo(group: 'popup')
  Widget _buildBottomPopup(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const TText('底部弹出'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TPopup.show(
            context,
            options: TPopupOptions.bottom(
              titleWidget: const TText('底部弹出层'),
              child: const Center(child: TText('弹出层内容区域')),
            ),
          );
        },
      ),
    );
  }

  @Demo(group: 'popup')
  Widget _buildTopPopup(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const TText('顶部弹出'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TPopup.show(
            context,
            options: TPopupOptions.top(
              child: Container(
                padding: const EdgeInsets.only(top: 40),
                alignment: Alignment.center,
                child: const TText('顶部弹出层内容'),
              ),
            ),
          );
        },
      ),
    );
  }

  @Demo(group: 'popup')
  Widget _buildLeftPopup(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const TText('左侧弹出'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TPopup.show(
            context,
            options: TPopupOptions.left(
              child: Container(
                alignment: Alignment.center,
                child: const TText('左侧弹出层内容'),
              ),
            ),
          );
        },
      ),
    );
  }

  @Demo(group: 'popup')
  Widget _buildRightPopup(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const TText('右侧弹出'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TPopup.show(
            context,
            options: TPopupOptions.right(
              child: Container(
                alignment: Alignment.center,
                child: const TText('右侧弹出层内容'),
              ),
            ),
          );
        },
      ),
    );
  }

  @Demo(group: 'popup')
  Widget _buildCenterPopup(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const TText('中间弹出'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TPopup.show(
            context,
            options: TPopupOptions.center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: TText('中间弹出层内容')),
              ),
            ),
          );
        },
      ),
    );
  }
}
