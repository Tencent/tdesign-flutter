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
        ExampleModule(title: '组件示例', children: [
          ExampleItem(desc: '带标题及操作', builder: _buildWithTitlePopup),
          ExampleItem(
            desc: '自定义关闭按钮',
            builder: _buildCustomClosePopup,
          ),
        ]),
        ExampleModule(title: '嵌套弹窗', children: [
          ExampleItem(desc: '多层 Popup 嵌套使用', builder: _buildNestedPopup),
        ]),
      ],
    );
  }

  @ExampleCode(group: 'popup')
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

  @ExampleCode(group: 'popup')
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

  @ExampleCode(group: 'popup')
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

  @ExampleCode(group: 'popup')
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

  @ExampleCode(group: 'popup')
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

  @ExampleCode(group: 'popup')
  Widget _buildWithTitlePopup(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const TText('带标题及操作'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TPopup.show(
            context,
            options: TPopupOptions.bottom(
              height: 258,
              titleWidget: const TText('标题文字'),
              child: const Center(child: TText('内容区域')),
            ),
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popup')
  Widget _buildCustomClosePopup(BuildContext context) {
    final theme = context.tTheme;
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const TText('自定义关闭按钮'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TPopup.show(
            context,
            options: TPopupOptions.center(
              width: 240,
              height: 200,
              closeBuilder: (_, close) => IconButton(
                tooltip: '关闭',
                icon: Icon(
                  TIcons.close_circle,
                  color: theme.fontWhColor1,
                  size: 32,
                ),
                onPressed: close,
              ),
              child: Container(
                width: 240,
                height: 200,
                color: theme.bgColorContainer,
                alignment: Alignment.center,
                child: const TText('自定义关闭按钮'),
              ),
            ),
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popup')
  Widget _buildNestedPopup(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const TText('嵌套弹窗'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TPopupHandle? outerHandle;
          outerHandle = TPopup.show(
            context,
            options: TPopupOptions.bottom(
              height: 360,
              headerBuilder: null,
              child: Builder(
                builder: (innerContext) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TText(
                          '外层：仅 child，无内置头部',
                          textColor: innerContext.tTheme.textColorSecondary,
                        ),
                        const SizedBox(height: 16),
                        TButton(
                          child: const TText('打开内层 Popup'),
                          size: TButtonSize.large,
                          variant: TButtonVariant.outline,
                          colorScheme: TButtonColorScheme.primary,
                          onPressed: () {
                            TPopup.show(
                              innerContext,
                              options: TPopupOptions.bottom(
                                height: 240,
                                titleWidget: const TText('内层标题'),
                                child: const Center(
                                  child: TText('内层内容区域'),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        TButton(
                          child: const TText('关闭外层'),
                          size: TButtonSize.large,
                          variant: TButtonVariant.outline,
                          colorScheme: TButtonColorScheme.primary,
                          onPressed: () => outerHandle?.close(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
