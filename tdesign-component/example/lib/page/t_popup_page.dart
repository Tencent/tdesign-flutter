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
        ExampleModule(title: '头部与操作', children: [
          ExampleItem(desc: '操作槽 默认 / 自定义', builder: _buildBottomBuiltInHeaderDemos),
          ExampleItem(desc: 'headerBuilder', builder: _buildPopFromBottomWithHeaderClose),
          ExampleItem(desc: 'closeBuilder 自定义', builder: _buildPopFromCenterClose),
        ]),
        ExampleModule(title: '安全区域', children: [
          ExampleItem(
            desc: 'useSafeArea，真机看橙色底边标记',
            builder: _buildApiUseSafeAreaCompare,
          ),
        ]),
        ExampleModule(title: '圆角', children: [
          ExampleItem(desc: 'radius + bottom inset', builder: _buildApiRadiusCompare),
        ]),
        ExampleModule(title: '更多 API', children: [
          ExampleItem(desc: '生命周期', builder: _buildApiLifecycle),
          ExampleItem(desc: 'right inset.top', builder: _buildApiCustomPosition),
          ExampleItem(desc: 'showOverlay false', builder: _buildApiShowOverlayFalse),
          ExampleItem(desc: 'onOverlayClick', builder: _buildApiOnOverlayClick),
          ExampleItem(desc: 'duration 600ms', builder: _buildApiDuration),
        ]),
        ExampleModule(title: '嵌套', children: [
          ExampleItem(desc: '嵌套 show', builder: _buildNestedPopup),
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
  Widget _buildBottomBuiltInHeaderDemos(BuildContext context) {
    final theme = context.tTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TButton(
          child: const TText('操作槽 默认'),
          size: TButtonSize.large,
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          onPressed: () {
            TPopup.show(
              context,
              options: TPopupOptions.bottom(
                height: 280,
                titleWidget: const TText('标题'),
                child: ColoredBox(
                  color: theme.bgColorContainer,
                  child: const SizedBox.expand(),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        TButton(
          child: const TText('操作槽 自定义'),
          size: TButtonSize.large,
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          onPressed: () {
            TPopup.show(
              context,
              options: TPopupOptions.bottom(
                height: 280,
                titleWidget: const TText('标题'),
                cancelBuilder: _bottomCancelSlot,
                confirmBuilder: _bottomConfirmSlot,
                child: ColoredBox(
                  color: theme.bgColorContainer,
                  child: const SizedBox.expand(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @ExampleCode(group: 'popup')
  Widget _buildPopFromBottomWithHeaderClose(BuildContext context) {
    final theme = context.tTheme;
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const TText('headerBuilder'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TPopup.show(
            context,
            options: TPopupOptions.bottom(
              height: 280,
              headerBuilder: _bottomTitleCloseHeader(title: '标题文字'),
              child: ColoredBox(
                color: theme.bgColorContainer,
                child: const SizedBox.expand(),
              ),
            ),
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popup')
  Widget _buildPopFromCenterClose(BuildContext context) {
    final theme = context.tTheme;
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const TText('closeBuilder 自定义'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TPopup.show(
            context,
            options: TPopupOptions.center(
              width: 240,
              height: 200,
              closeBuilder: _centerCustomCloseSlot,
              child: ColoredBox(
                color: theme.bgColorContainer,
                child: const SizedBox.expand(),
              ),
            ),
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popup')
  Widget _buildApiUseSafeAreaCompare(BuildContext context) {
    final theme = context.tTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TText(
          'useSafeArea，真机看橙色底边标记',
          textColor: theme.textColorSecondary,
          font: theme.fontBodyMedium,
        ),
        const SizedBox(height: 16),
        TButton(
          child: const TText('useSafeArea 开'),
          size: TButtonSize.large,
          colorScheme: TButtonColorScheme.primary,
          onPressed: () => _showSafeAreaBottomPopup(context, useSafeArea: true),
        ),
        const SizedBox(height: 12),
        TButton(
          child: const TText('useSafeArea 关'),
          size: TButtonSize.large,
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          onPressed: () =>
              _showSafeAreaBottomPopup(context, useSafeArea: false),
        ),
      ],
    );
  }

  @ExampleCode(group: 'popup')
  Widget _buildApiRadiusCompare(BuildContext context) {
    final theme = context.tTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TText(
          'radius + bottom inset',
          textColor: theme.textColorSecondary,
          font: theme.fontBodyMedium,
        ),
        const SizedBox(height: 16),
        TButton(
          child: const TText('radius 默认'),
          size: TButtonSize.large,
          colorScheme: TButtonColorScheme.primary,
          onPressed: () => _showRadiusBottomPopup(context),
        ),
        const SizedBox(height: 12),
        TButton(
          child: const TText('radius 0'),
          size: TButtonSize.large,
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          onPressed: () => _showRadiusBottomPopup(context, radius: 0),
        ),
        const SizedBox(height: 12),
        TButton(
          child: const TText('radius 28'),
          size: TButtonSize.large,
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          onPressed: () => _showRadiusBottomPopup(context, radius: 28),
        ),
        const SizedBox(height: 12),
        TButton(
          child: const TText('center radius'),
          size: TButtonSize.large,
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          onPressed: () => _showRadiusCenterPopup(context),
        ),
        const SizedBox(height: 12),
        TButton(
          child: const TText('center r32'),
          size: TButtonSize.large,
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          onPressed: () => _showRadiusCenterPopup(context, radius: 32),
        ),
      ],
    );
  }

  @ExampleCode(group: 'popup')
  Widget _buildApiLifecycle(BuildContext context) {
    final theme = context.tTheme;
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const TText('生命周期'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TPopup.show(
            context,
            options: TPopupOptions.bottom(
              height: 300,
              titleWidget: const TText('生命周期'),
              onOpen: () => _lifecycleToast(context, 'onOpen'),
              onOpened: () => _lifecycleToast(context, 'onOpened'),
              onClose: () => _lifecycleToast(context, 'onClose'),
              onClosed: () => _lifecycleToast(context, 'onClosed'),
              child: ColoredBox(
                color: theme.bgColorContainer,
                child: Center(
                  child: TText(
                    '打开：onOpen → onOpened\n关闭：onClose → onClosed',
                    textColor: theme.textColorSecondary,
                    font: theme.fontBodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popup')
  Widget _buildApiCustomPosition(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const TText('right inset.top'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TPopup.show(
            context,
            options: TPopupOptions.right(
              width: 280,
              inset: const TPopupRightInset(top: 44),
              child: ColoredBox(
                color: context.tTheme.bgColorContainer,
                child: const SizedBox.expand(),
              ),
            ),
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popup')
  Widget _buildApiShowOverlayFalse(BuildContext context) {
    final theme = context.tTheme;
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const TText('showOverlay false'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TPopup.show(
            context,
            options: TPopupOptions.bottom(
              height: 280,
              showOverlay: false,
              // 不显示可见蒙层，但仍阻断背景交互；须保留其它关闭入口。
              titleWidget: const TText('透明模态'),
              child: ColoredBox(
                color: theme.bgColorContainer,
                child: const SizedBox.expand(),
              ),
            ),
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popup')
  Widget _buildApiOnOverlayClick(BuildContext context) {
    final theme = context.tTheme;
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const TText('onOverlayClick'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TPopup.show(
            context,
            options: TPopupOptions.bottom(
              height: 260,
              onOverlayClick: () =>
                  TToast.showText('点击蒙层', context: context),
              child: ColoredBox(
                color: theme.bgColorContainer,
                child: const SizedBox.expand(),
              ),
            ),
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popup')
  Widget _buildApiDuration(BuildContext context) {
    final theme = context.tTheme;
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const TText('duration 600ms'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TPopup.show(
            context,
            options: TPopupOptions.bottom(
              height: 240,
              animationDuration: const Duration(milliseconds: 600),
              child: ColoredBox(
                color: theme.bgColorContainer,
                child: const SizedBox.expand(),
              ),
            ),
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popup')
  Widget _buildNestedPopup(BuildContext context) {
    final theme = context.tTheme;
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const TText('嵌套 show'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          TPopupHandle? outerHandle;
          outerHandle = TPopup.show(
            context,
            options: TPopupOptions.bottom(
              height: 360,
              child: Builder(
                builder: (innerContext) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TText(
                          '外层：仅 child',
                          textColor: theme.textColorSecondary,
                        ),
                        const SizedBox(height: 16),
                        TButton(
                          child: const TText('内层 bottom'),
                          size: TButtonSize.large,
                          colorScheme: TButtonColorScheme.primary,
                          onPressed: () {
                            TPopup.show(
                              innerContext,
                              options: TPopupOptions.bottom(
                                height: 280,
                                titleWidget: const TText('内层标题'),
                                child: ColoredBox(
                                  color: theme.bgColorSecondaryContainer,
                                  child: const SizedBox.expand(),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        TButton(
                          child: const TText('Handle.close'),
                          size: TButtonSize.large,
                          variant: TButtonVariant.outline,
                          onPressed: () => _toastThen(
                            innerContext,
                            '点击：关闭外层',
                            () => outerHandle?.close(),
                          ),
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

  Widget _bottomCancelSlot(BuildContext context, VoidCallback close) {
    final theme = context.tTheme;
    return TButton(
      child: TText('自定义取消', textColor: theme.errorNormalColor),
      variant: TButtonVariant.text,
      onPressed: close,
    );
  }

  Widget _bottomConfirmSlot(BuildContext _, VoidCallback close) {
    return TButton(
      child: const TText('自定义确定'),
      variant: TButtonVariant.text,
      colorScheme: TButtonColorScheme.primary,
      onPressed: close,
    );
  }

  TPopupHeaderBuilder _bottomTitleCloseHeader({required String title}) {
    return (BuildContext context, VoidCallback close) {
      final theme = context.tTheme;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: TText(title, font: theme.fontTitleLarge),
            ),
            GestureDetector(
              onTap: close,
              child: const Icon(Icons.close, size: 20),
            ),
          ],
        ),
      );
    };
  }

  Widget _centerCustomCloseSlot(BuildContext context, VoidCallback close) {
    final theme = context.tTheme;
    return GestureDetector(
      onTap: close,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.bgColorContainer,
          border: Border.all(color: theme.componentBorderColor),
        ),
        child: const Icon(Icons.close, size: 16),
      ),
    );
  }

  void _showSafeAreaBottomPopup(BuildContext context,
      {required bool useSafeArea}) {
    final theme = context.tTheme;
    TPopup.show(
      context,
      options: TPopupOptions.bottom(
        height: 240,
        useSafeArea: useSafeArea,
        child: ColoredBox(
          color: theme.bgColorContainer,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 8,
              color: theme.warningNormalColor,
            ),
          ),
        ),
      ),
    );
  }

  void _showRadiusBottomPopup(BuildContext context, {double? radius}) {
    final theme = context.tTheme;
    TPopup.show(
      context,
      options: TPopupOptions.bottom(
        height: 240,
        radius: radius,
        child: ColoredBox(
          color: theme.bgColorContainer,
          child: const SizedBox.expand(),
        ),
      ),
    );
  }

  void _showRadiusCenterPopup(BuildContext context, {double? radius}) {
    final theme = context.tTheme;
    TPopup.show(
      context,
      options: TPopupOptions.center(
        width: 240,
        height: 200,
        radius: radius,
        child: ColoredBox(
          color: theme.bgColorContainer,
          child: const SizedBox.expand(),
        ),
      ),
    );
  }

  void _lifecycleToast(BuildContext context, String msg) {
    TToast.showText(msg, context: context);
  }

  void _toastThen(
    BuildContext context,
    String msg,
    VoidCallback action,
  ) {
    action();
    TToast.showText(msg, context: context);
  }
}
