import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

///
/// TPopup演示
///
class TPopupPage extends StatelessWidget {
  const TPopupPage({super.key});

  static const double _headerHeight = 58;

  /// 浮层内交互（取消/确定/关闭/蒙层等）时弹出 [TToast]。
  static void _toastThen(
    BuildContext context,
    String message,
    VoidCallback action,
  ) {
    TToast.showText(message, context: context);
    action();
  }

  static const String _lifecycleToastId = 'popup_lifecycle';

  /// 生命周期演示 Toast：复用同一实例，避免连续回调叠多层。
  static void _lifecycleToast(BuildContext context, String message) {
    TToast.dismissToast(_lifecycleToastId);
    TToast.showText(
      message,
      context: context,
      toastId: _lifecycleToastId,
      duration: const Duration(milliseconds: 2000),
      maxLines: 1,
    );
  }

  /// 内置头部左右操作槽（左 cancel / 右 confirm）。
  static TPopupSlotBuilder _bottomHeaderActionSlot({
    required String label,
    required String toastMessage,
    required Color Function(BuildContext ctx) textColor,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return (ctx, close) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _toastThen(ctx, toastMessage, close),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: TText(
              label,
              textColor: textColor(ctx),
              font: TTheme.of(ctx).fontBodyLarge,
              fontWeight: fontWeight,
            ),
          ),
        );
  }

  static TPopupSlotBuilder get _bottomCancelSlot => _bottomHeaderActionSlot(
        label: '取消',
        toastMessage: '点击：取消',
        textColor: (ctx) => TTheme.of(ctx).textColorSecondary,
      );

  static TPopupSlotBuilder get _bottomConfirmSlot => _bottomHeaderActionSlot(
        label: '确定',
        toastMessage: '点击：确定',
        textColor: (ctx) => TTheme.of(ctx).brandNormalColor,
        fontWeight: FontWeight.w600,
      );

  /// center 面板下关闭区自定义（默认内置为 [TIcons.close_circle]）。
  static TPopupSlotBuilder get _centerCustomCloseSlot =>
      (ctx, close) => IconButton(
            icon: Icon(
              TIcons.poweroff,
              color: TTheme.of(ctx).warningNormalColor,
              size: 36,
            ),
            onPressed: () => _toastThen(ctx, '点击：关闭', close),
          );

  /// 底部标题 + 关闭（自定义 headerBuilder：标题居中 + 右侧关闭图标）。
  static TPopupHeaderBuilder _bottomTitleCloseHeader({
    String? title,
  }) {
    return (BuildContext ctx, VoidCallback close) {
      final theme = TTheme.of(ctx);
      final headerTitle = (title != null && title.isNotEmpty)
          ? TText(
              title,
              textColor: theme.textColorPrimary,
              font: theme.fontTitleLarge,
              fontWeight: FontWeight.w700,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null;
      return SizedBox(
        height: _headerHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: Center(child: headerTitle ?? const SizedBox.shrink()),
              ),
              IconButton(
                icon: Icon(TIcons.close, color: theme.textColorSecondary),
                onPressed: () => _toastThen(ctx, '点击：头部关闭', close),
              ),
            ],
          ),
        ),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      padding: const EdgeInsets.only(top: 16),
      exampleCodeGroup: 'popup',
      desc: '由其他控件触发，屏幕滑出或弹出一块自定义内容区域',
      navBarKey: navBarkey,
      children: [
        ExampleModule(
          title: '弹出位置',
          children: [
            ExampleItem(builder: _buildPopFromTop),
            ExampleItem(builder: _buildPopFromLeft),
            ExampleItem(builder: _buildPopFromCenter),
            ExampleItem(builder: _buildPopFromBottom),
            ExampleItem(builder: _buildPopFromRight),
          ],
        ),
        ExampleModule(
          title: '头部与操作',
          children: [
            ExampleItem(builder: _buildBottomBuiltInHeaderDemos),
            ExampleItem(builder: _buildPopFromBottomWithHeaderClose),
            ExampleItem(builder: _buildPopFromCenterClose),
            ExampleItem(builder: _buildNestedPopup),
          ],
        ),
        ExampleModule(
          title: '安全区域',
          children: [
            ExampleItem(builder: _buildApiUseSafeAreaCompare),
          ],
        ),
        ExampleModule(
          title: '圆角',
          children: [
            ExampleItem(builder: _buildApiRadiusCompare),
          ],
        ),
        ExampleModule(
          title: '更多 API',
          children: [
            ExampleItem(builder: _buildApiLifecycle),
            ExampleItem(builder: _buildApiCustomPosition),
            ExampleItem(builder: _buildApiShowOverlayFalse),
            ExampleItem(builder: _buildApiOnOverlayClick),
            ExampleItem(builder: _buildApiDuration),
          ],
        ),
      ],
      test: const [],
    );
  }

  // --- 弹出位置 ---

  @Demo(group: 'popup')
  Widget _buildPopFromTop(BuildContext context) {
    return TButton(
      text: 'top',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context,
          options: TPopupOptions.top(
              height: 240,
              child: Container(
                color: TTheme.of(context).bgColorContainer,
                height: 240,
              )),
        );
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromLeft(BuildContext context) {
    return TButton(
      text: 'left',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context,
          options: TPopupOptions.left(
              width: 280,
              child: Container(
                color: TTheme.of(context).bgColorContainer,
              )),
        );
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromCenter(BuildContext context) {
    return TButton(
      text: 'center',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context,
          options: TPopupOptions.center(
              width: 240,
              height: 240,
              child: Container(
                color: TTheme.of(context).bgColorContainer,
              )),
        );
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromBottom(BuildContext context) {
    return TButton(
      text: 'bottom',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context,
          options: TPopupOptions.bottom(
              height: 240,
              headerBuilder: null,
              child: Container(
                color: TTheme.of(context).bgColorContainer,
                height: 240,
              )),
        );
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromRight(BuildContext context) {
    return TButton(
      text: 'right',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context,
          options: TPopupOptions.right(
              width: 280,
              child: Container(
                color: TTheme.of(context).bgColorContainer,
              )),
        );
      },
    );
  }

  // --- 头部与操作 ---

  /// 外层 Popup 的 child 内再 `TPopup.show(innerContext, options: …)`：用各自 [TPopupHandle] 关闭。
  @Demo(group: 'popup')
  Widget _buildNestedPopup(BuildContext context) {
    return TButton(
      text: '嵌套 show',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
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
                          '外层：headerBuilder: null，仅 child',
                          textColor: TTheme.of(innerContext).textColorSecondary,
                        ),
                        const SizedBox(height: 16),
                        TButton(
                          text: '内层 bottom',
                          isBlock: true,
                          theme: TButtonTheme.primary,
                          size: TButtonSize.large,
                          onTap: () {
                            TPopup.show(
                              innerContext,
                              options: TPopupOptions.bottom(
                                height: 280,
                                titleWidget: const TText('内层标题'),
                                child: Container(
                                  height: 160,
                                  color: TTheme.of(innerContext)
                                      .bgColorSecondaryContainer,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        TButton(
                          text: 'Handle.close',
                          isBlock: true,
                          type: TButtonType.outline,
                          size: TButtonSize.large,
                          onTap: () => _toastThen(
                            innerContext,
                            '点击：关闭外层',
                            () => outerHandle?.close(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )),
        );
      },
    );
  }

  /// 内置头左右槽：默认文案 vs 自定义 cancelBuilder / confirmBuilder。
  @Demo(group: 'popup')
  Widget _buildBottomBuiltInHeaderDemos(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TButton(
          text: '操作槽 默认',
          isBlock: true,
          theme: TButtonTheme.primary,
          type: TButtonType.outline,
          size: TButtonSize.large,
          onTap: () {
            TPopup.show(
              context,
              options: TPopupOptions.bottom(
                height: 280,
                titleWidget: const TText('标题'),
                child: Container(height: 200),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        TButton(
          text: '操作槽 自定义',
          isBlock: true,
          theme: TButtonTheme.primary,
          type: TButtonType.outline,
          size: TButtonSize.large,
          onTap: () {
            TPopup.show(
              context,
              options: TPopupOptions.bottom(
                height: 280,
                titleWidget: const TText('标题'),
                cancelBuilder: _bottomCancelSlot,
                confirmBuilder: _bottomConfirmSlot,
                child: Container(height: 200),
              ),
            );
          },
        ),
      ],
    );
  }

  /// 自定义 headerBuilder：标题居中 + 右侧关闭图标。
  @Demo(group: 'popup')
  Widget _buildPopFromBottomWithHeaderClose(BuildContext context) {
    return TButton(
      text: 'headerBuilder',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context,
          options: TPopupOptions.bottom(
            height: 280,
            headerBuilder: _bottomTitleCloseHeader(title: '标题文字'),
            child: Container(height: 200),
          ),
        );
      },
    );
  }

  /// center：自定义 closeBuilder（面板下方）；默认关闭见「center」。
  @Demo(group: 'popup')
  Widget _buildPopFromCenterClose(BuildContext context) {
    return TButton(
      text: 'closeBuilder 自定义',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context,
          options: TPopupOptions.center(
            width: 240,
            height: 200,
            closeBuilder: _centerCustomCloseSlot,
            child: Container(
              width: 240,
              height: 200,
              color: TTheme.of(context).bgColorContainer,
            ),
          ),
        );
      },
    );
  }

  // --- 安全区域 ---

  /// 底部弹出对比 [useSafeArea] 开启/关闭；橙色条为面板底边标记。
  static void _showSafeAreaBottomPopup(
    BuildContext context, {
    required bool useSafeArea,
  }) {
    final theme = TTheme.of(context);
    TPopup.show(
      context,
      options: TPopupOptions.bottom(
        height: 300,
        useSafeArea: useSafeArea,
        headerBuilder: null,
        child: ColoredBox(
          color: theme.bgColorContainer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: TText(
                  useSafeArea ? 'useSafeArea: true（默认）' : 'useSafeArea: false',
                  textColor: theme.textColorPrimary,
                  font: theme.fontTitleMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TText(
                  useSafeArea
                      ? '面板底边在 Home 指示条上方，橙色标记线不会被遮挡'
                      : '面板底边贴屏幕底边，橙色标记线可能落在 Home 指示条区域',
                  textColor: theme.textColorSecondary,
                  font: theme.fontBodyMedium,
                ),
              ),
              const Spacer(),
              Container(
                height: 14,
                alignment: Alignment.center,
                color: theme.warningNormalColor,
                child: TText(
                  '面板底边标记',
                  textColor: theme.fontWhColor1,
                  font: theme.fontBodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @Demo(group: 'popup')
  Widget _buildApiUseSafeAreaCompare(BuildContext context) {
    final theme = TTheme.of(context);
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
          text: 'useSafeArea 开',
          isBlock: true,
          theme: TButtonTheme.primary,
          size: TButtonSize.large,
          onTap: () => _showSafeAreaBottomPopup(context, useSafeArea: true),
        ),
        const SizedBox(height: 12),
        TButton(
          text: 'useSafeArea 关',
          isBlock: true,
          theme: TButtonTheme.primary,
          type: TButtonType.outline,
          size: TButtonSize.large,
          onTap: () => _showSafeAreaBottomPopup(context, useSafeArea: false),
        ),
      ],
    );
  }

  // --- 圆角 ---

  /// 底部弹层对比 [radius]；配合 [TPopupBottomInset] 留白，顶部圆角更易观察。
  static void _showRadiusBottomPopup(
    BuildContext context, {
    double? radius,
  }) {
    final theme = TTheme.of(context);
    final defaultRadius = theme.radiusExtraLarge;
    final String label;
    if (radius == null) {
      label = '默认圆角 radiusExtraLarge = $defaultRadius';
    } else if (radius == 0) {
      label = '直角 radius = 0';
    } else {
      label = '大圆角 radius = ${radius.toStringAsFixed(0)}';
    }

    TPopup.show(
      context,
      options: TPopupOptions.bottom(
        height: 220,
        radius: radius,
        inset: const TPopupBottomInset(left: 32, right: 32),
        headerBuilder: null,
        child: ColoredBox(
          color: theme.brandNormalColor.withValues(alpha: 0.14),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TText(
                  label,
                  textColor: theme.textColorPrimary,
                  font: theme.fontTitleMedium,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 8),
                TText(
                  '左右留白 32px，请对比面板顶部左右两角的弧度',
                  textColor: theme.textColorSecondary,
                  font: theme.fontBodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 居中弹层对比 [radius]；四角均为圆角。
  static void _showRadiusCenterPopup(
    BuildContext context, {
    double? radius,
  }) {
    final theme = TTheme.of(context);
    final defaultRadius = theme.radiusExtraLarge;
    final label = radius == null
        ? '默认圆角 $defaultRadius'
        : '大圆角 radius = ${radius.toStringAsFixed(0)}';

    TPopup.show(
      context,
      options: TPopupOptions.center(
        width: 280,
        height: 180,
        radius: radius,
        child: ColoredBox(
          color: theme.brandNormalColor.withValues(alpha: 0.14),
          child: Center(
            child: TText(
              label,
              textColor: theme.textColorPrimary,
              font: theme.fontTitleMedium,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  @Demo(group: 'popup')
  Widget _buildApiRadiusCompare(BuildContext context) {
    final theme = TTheme.of(context);
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
          text: 'radius 默认',
          isBlock: true,
          theme: TButtonTheme.primary,
          size: TButtonSize.large,
          onTap: () => _showRadiusBottomPopup(context),
        ),
        const SizedBox(height: 12),
        TButton(
          text: 'radius 0',
          isBlock: true,
          theme: TButtonTheme.primary,
          type: TButtonType.outline,
          size: TButtonSize.large,
          onTap: () => _showRadiusBottomPopup(context, radius: 0),
        ),
        const SizedBox(height: 12),
        TButton(
          text: 'radius 28',
          isBlock: true,
          theme: TButtonTheme.primary,
          type: TButtonType.outline,
          size: TButtonSize.large,
          onTap: () => _showRadiusBottomPopup(context, radius: 28),
        ),
        const SizedBox(height: 12),
        TButton(
          text: 'center radius',
          isBlock: true,
          theme: TButtonTheme.primary,
          type: TButtonType.outline,
          size: TButtonSize.large,
          onTap: () => _showRadiusCenterPopup(context),
        ),
        const SizedBox(height: 12),
        TButton(
          text: 'center r32',
          isBlock: true,
          theme: TButtonTheme.primary,
          type: TButtonType.outline,
          size: TButtonSize.large,
          onTap: () => _showRadiusCenterPopup(context, radius: 32),
        ),
      ],
    );
  }

  // --- 更多 API ---

  /// onOpen / onOpened / onClose / onClosed，Toast 观察调用顺序。
  @Demo(group: 'popup')
  Widget _buildApiLifecycle(BuildContext context) {
    final theme = TTheme.of(context);
    return TButton(
      text: '生命周期',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
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
    );
  }

  @Demo(group: 'popup')
  Widget _buildApiCustomPosition(BuildContext context) {
    return TButton(
      text: 'right inset.top',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        final renderBox =
            navBarkey.currentContext!.findRenderObject() as RenderBox;
        TPopup.show(
          context,
          options: TPopupOptions.right(
            width: 280,
            inset: TPopupRightInset(top: renderBox.size.height),
            child: Container(
              color: TTheme.of(context).bgColorContainer,
            ),
          ),
        );
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildApiShowOverlayFalse(BuildContext context) {
    return TButton(
      text: 'showOverlay false',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context,
          options: TPopupOptions.bottom(
              height: 280,
              showOverlay: false,
              modal: true,
              // 不显示可见蒙层，但仍阻断背景交互；须保留其它关闭入口。
              titleWidget: const TText('透明模态'),
              child: Container(
                height: 200,
                color: TTheme.of(context).bgColorContainer,
              )),
        );
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildApiOnOverlayClick(BuildContext context) {
    return TButton(
      text: 'onOverlayClick',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context,
          options: TPopupOptions.bottom(
              height: 260,
              onOverlayClick: () =>
                  TToast.showText('点击蒙层', context: context),
              child: Container(
                height: 200,
                color: TTheme.of(context).bgColorContainer,
              )),
        );
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildApiDuration(BuildContext context) {
    return TButton(
      text: 'duration 600ms',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup.show(
          context,
          options: TPopupOptions.bottom(
              height: 240,
              animationDuration: const Duration(milliseconds: 600),
              child: Container(
                height: 200,
                color: TTheme.of(context).bgColorContainer,
              )),
        );
      },
    );
  }
}
