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

  /// 底部标题 + 关闭（自定义 headerBuilder，使用 [TPopupHeaderData]）。
  static TPopupHeaderBuilder _bottomTitleCloseHeader({
    String? title,
    required VoidCallback onClose,
  }) {
    return (BuildContext ctx, TPopupHeaderData data) {
      final theme = TTheme.of(ctx);
      final headerTitle = data.title ??
          (title != null && title.isNotEmpty
              ? TText(
                  title,
                  textColor: theme.textColorPrimary,
                  font: theme.fontTitleLarge,
                  fontWeight: FontWeight.w700,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null);
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
                onPressed: onClose,
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
          title: '组件类型',
          children: [
            ExampleItem(builder: _buildPopFromTop),
            ExampleItem(builder: _buildPopFromLeft),
            ExampleItem(builder: _buildPopFromCenter),
            ExampleItem(builder: _buildPopFromBottom),
            ExampleItem(builder: _buildPopFromRight),
          ],
        ),
        ExampleModule(
          title: '组件示例',
          children: [
            ExampleItem(builder: _buildPopFromBottomWithOperationAndTitle),
            ExampleItem(builder: _buildPopFromBottomWithCloseAndTitle),
            ExampleItem(builder: _buildPopFromCenterWithClose),
            ExampleItem(builder: _buildPopFromCenterWithUnderClose),
            ExampleItem(builder: _buildNestedPopup),
          ],
        ),
        ExampleModule(
          title: '更多 API',
          children: [
            ExampleItem(builder: _buildApiMarginTop),
            ExampleItem(builder: _buildApiShowOverlayFalse),
            ExampleItem(builder: _buildApiOnOverlayClick),
            ExampleItem(builder: _buildApiDuration),
          ],
        ),
      ],
      test: [
        ExampleItem(
          desc: '操作栏超长文本,指定颜色',
          builder: (_) {
            return TButton(
              text: '底部弹出层-带标题及操作',
              isBlock: true,
              theme: TButtonTheme.primary,
              type: TButtonType.outline,
              size: TButtonSize.large,
              onTap: () {
                TPopup(
                  options: TPopupOptions(
                      placement: TPopupPlacement.bottom,
                      height: 280,
                      title: '标题文字标题文字标题文字标题文字标题文字标题文字标题文字',
                      cancel: TText(
                        '点这里确认!',
                        textColor: TTheme.of(context).brandNormalColor,
                        font: TTheme.of(context).fontBodyLarge,
                      ),
                      confirm: TText(
                        '关闭',
                        textColor: TTheme.of(context).errorNormalColor,
                        font: TTheme.of(context).fontBodyLarge,
                      ),
                      onCancel: () => TToast.showText('确认', context: context),
                      child: Container(height: 200)),
                ).show(context);
              },
            );
          },
        ),
        ExampleItem(
          desc: '带关闭超长文本',
          builder: (_) {
            return TButton(
              text: '底部弹出层-带标题及关闭',
              isBlock: true,
              theme: TButtonTheme.primary,
              type: TButtonType.outline,
              size: TButtonSize.large,
              onTap: () {
                TPopupHandle? handle;
                handle = TPopup(
                  options: TPopupOptions(
                      placement: TPopupPlacement.bottom,
                      height: 280,
                      headerBuilder: _bottomTitleCloseHeader(
                        title: '标题文字标题文字标题文字标题文字标题文字标题文字标题文字',
                        onClose: () => handle?.close(),
                      ),
                      child: Container(height: 200)),
                ).show(context);
              },
            );
          },
        ),
        ExampleItem(
          desc: '修改圆角',
          builder: (_) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TButton(
                  text: '底部弹出层-修改圆角',
                  isBlock: true,
                  theme: TButtonTheme.primary,
                  type: TButtonType.outline,
                  size: TButtonSize.large,
                  onTap: () {
                    TPopupHandle? handle;
                    handle = TPopup(
                      options: TPopupOptions(
                          placement: TPopupPlacement.bottom,
                          height: 280,
                          radius: 6,
                          headerBuilder: _bottomTitleCloseHeader(
                            title: '标题文字标题文字标题文字标题文字标题文字标题文字标题文字',
                            onClose: () => handle?.close(),
                          ),
                          child: Container(height: 200)),
                    ).show(context);
                  },
                ),
                const SizedBox(height: 16),
                TButton(
                  text: '底部弹出层-修改圆角',
                  isBlock: true,
                  theme: TButtonTheme.primary,
                  type: TButtonType.outline,
                  size: TButtonSize.large,
                  onTap: () {
                    TPopup(
                      options: TPopupOptions(
                          placement: TPopupPlacement.bottom,
                          height: 280,
                          radius: 6,
                          title: '标题文字标题文字标题文字标题文字标题文字标题文字标题文字',
                          cancel: TText(
                            '点这里确认!',
                            textColor: TTheme.of(context).brandNormalColor,
                            font: TTheme.of(context).fontBodyLarge,
                          ),
                          confirm: TText(
                            '关闭',
                            textColor: TTheme.of(context).errorNormalColor,
                            font: TTheme.of(context).fontBodyLarge,
                          ),
                          onCancel: () =>
                              TToast.showText('确认', context: context),
                          child: Container(height: 200)),
                    ).show(context);
                  },
                ),
                const SizedBox(height: 16),
                TButton(
                  text: '居中弹出层-修改圆角',
                  isBlock: true,
                  theme: TButtonTheme.primary,
                  type: TButtonType.outline,
                  size: TButtonSize.large,
                  onTap: () {
                    TPopup(
                      options: TPopupOptions(
                          placement: TPopupPlacement.center,
                          width: 240,
                          height: 240,
                          radius: 6,
                          closeBuilder: (_, close) => IconButton(
                                icon: Icon(
                                  TIcons.close_circle,
                                  color: TTheme.of(context).errorNormalColor,
                                  size: 32,
                                ),
                                onPressed: close,
                              ),
                          child: const SizedBox(height: 240, width: 240)),
                    ).show(context);
                  },
                ),
                const SizedBox(height: 16),
                TButton(
                  text: '居中弹出层-底部关闭-修改圆角',
                  isBlock: true,
                  theme: TButtonTheme.primary,
                  type: TButtonType.outline,
                  size: TButtonSize.large,
                  onTap: () {
                    TPopup(
                      options: TPopupOptions(
                          placement: TPopupPlacement.center,
                          width: 240,
                          height: 240,
                          radius: 6,
                          child: const SizedBox(height: 240, width: 240)),
                    ).show(context);
                  },
                ),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '自定义位置',
          builder: (_) {
            return TButton(
              text: '自定义位置',
              isBlock: true,
              theme: TButtonTheme.primary,
              type: TButtonType.outline,
              size: TButtonSize.large,
              onTap: () {
                final renderBox =
                    navBarkey.currentContext!.findRenderObject() as RenderBox;
                TPopup(
                  options: TPopupOptions(
                      placement: TPopupPlacement.right,
                      width: 280,
                      margin: EdgeInsets.only(top: renderBox.size.height),
                      child: Container(
                        color: TTheme.of(context).bgColorContainer,
                      )),
                ).show(context);
              },
            );
          },
        ),
      ],
    );
  }

  // --- 01 组件类型（保持原 Demo 文案与交互）---

  @Demo(group: 'popup')
  Widget _buildPopFromTop(BuildContext context) {
    return TButton(
      text: '顶部弹出',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.top,
              height: 240,
              onOpen: () => print('open'),
              onOpened: () => print('opened'),
              child: Container(
                color: TTheme.of(context).bgColorContainer,
                height: 240,
              )),
        ).show(context);
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromLeft(BuildContext context) {
    return TButton(
      text: '左侧弹出',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.left,
              width: 280,
              child: Container(
                color: TTheme.of(context).bgColorContainer,
              )),
        ).show(context);
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromCenter(BuildContext context) {
    return TButton(
      text: '中间弹出',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.center,
              closeBuilder: null,
              child: Container(
                decoration: BoxDecoration(
                  color: TTheme.of(context).bgColorContainer,
                  borderRadius:
                      BorderRadius.circular(TTheme.of(context).radiusLarge),
                ),
                width: 240,
                height: 240,
              )),
        ).show(context);
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromBottom(BuildContext context) {
    return TButton(
      text: '底部弹出',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 240,
              headerBuilder: null,
              child: Container(
                color: TTheme.of(context).bgColorContainer,
                height: 240,
              )),
        ).show(context);
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromRight(BuildContext context) {
    return TButton(
      text: '右侧弹出',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.right,
              width: 280,
              child: Container(
                color: TTheme.of(context).bgColorContainer,
              )),
        ).show(context);
      },
    );
  }

  // --- 02 组件示例 ---

  /// 外层 Popup 的 child 内再 `TPopup(options: …).show`：用各自 [TPopupHandle] 关闭。
  @Demo(group: 'popup')
  Widget _buildNestedPopup(BuildContext context) {
    return TButton(
      text: '内层再弹一层（嵌套叠加）',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopupHandle? outerHandle;
        outerHandle = TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.bottom,
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
                          text: '打开内层 Popup',
                          isBlock: true,
                          theme: TButtonTheme.primary,
                          size: TButtonSize.large,
                          onTap: () {
                            TPopup(
                              options: TPopupOptions(
                                placement: TPopupPlacement.bottom,
                                height: 280,
                                title: '内层标题',
                                child: Container(
                                  height: 160,
                                  color: TTheme.of(innerContext)
                                      .bgColorSecondaryContainer,
                                ),
                              ),
                            ).show(innerContext);
                          },
                        ),
                        const SizedBox(height: 12),
                        TButton(
                          text: '关闭外层',
                          isBlock: true,
                          type: TButtonType.outline,
                          size: TButtonSize.large,
                          onTap: () => outerHandle?.close(),
                        ),
                      ],
                    ),
                  );
                },
              )),
        ).show(context);
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromBottomWithOperationAndTitle(BuildContext context) {
    return TButton(
      text: '底部弹出层-带标题及操作',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 280,
              title: '标题文字',
              onConfirm: () => TToast.showText('确定', context: context),
              child: Container(height: 200)),
        ).show(context);
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromBottomWithCloseAndTitle(BuildContext context) {
    return TButton(
      text: '底部弹出层-带标题及关闭',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 280,
              cancel: TText(
                '关闭',
                textColor: TTheme.of(context).textColorSecondary,
                font: TTheme.of(context).fontBodyLarge,
              ),
              titleWidget: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(TIcons.info_circle,
                      color: TTheme.of(context).brandNormalColor, size: 18),
                  const SizedBox(width: 4),
                  TText(
                    '自定义标题',
                    textColor: TTheme.of(context).brandNormalColor,
                    font: TTheme.of(context).fontTitleMedium,
                  ),
                ],
              ),
              confirm: TText(
                '完成',
                textColor: TTheme.of(context).brandNormalColor,
                font: TTheme.of(context).fontTitleMedium,
                fontWeight: FontWeight.w600,
              ),
              child: Container(height: 200)),
        ).show(context);
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromCenterWithClose(BuildContext context) {
    return TButton(
      text: '居中弹出层-带关闭',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.center,
              closeOnOverlayClick: false,
              width: 240,
              height: 240,
              closeBuilder: (_, close) => IconButton(
                    icon: Icon(
                      TIcons.close_circle,
                      color: TTheme.of(context).fontWhColor1,
                      size: 32,
                    ),
                    onPressed: close,
                  ),
              child: const SizedBox(width: 240, height: 240)),
        ).show(context);
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromCenterWithUnderClose(BuildContext context) {
    return TButton(
      text: '居中弹出层-自定义下方按钮',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.center,
              closeOnOverlayClick: true,
              width: 240,
              height: 200,
              closeBuilder: (_, close) => IconButton(
                    icon: Icon(
                      TIcons.poweroff,
                      color: TTheme.of(context).fontWhColor1,
                      size: 36,
                    ),
                    onPressed: close,
                  ),
              child: Container(
                width: 240,
                height: 200,
                color: TTheme.of(context).bgColorContainer,
              )),
        ).show(context);
      },
    );
  }

  // --- 更多 API ---

  @Demo(group: 'popup')
  Widget _buildApiMarginTop(BuildContext context) {
    return TButton(
      text: 'bottom margin.top',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 320,
              margin: const EdgeInsets.only(top: 120, left: 16, right: 16),
              title: '日历式留白',
              child: Container(
                height: 240,
                color: TTheme.of(context).bgColorContainer,
              )),
        ).show(context);
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildApiShowOverlayFalse(BuildContext context) {
    return TButton(
      text: 'showOverlay: false（无蒙层）',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 280,
              showOverlay: false,
              // 无蒙层时无法点遮罩关闭，须保留操作栏取消（或其它关闭入口）
              title: '无蒙层',
              child: Container(
                height: 200,
                color: TTheme.of(context).bgColorContainer,
              )),
        ).show(context);
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
        TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 260,
              onOverlayClick: () => TToast.showText('点击蒙层', context: context),
              child: Container(
                height: 200,
                color: TTheme.of(context).bgColorContainer,
              )),
        ).show(context);
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildApiDuration(BuildContext context) {
    return TButton(
      text: 'duration: 600ms',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        TPopup(
          options: TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 240,
              duration: const Duration(milliseconds: 600),
              child: Container(
                height: 200,
                color: TTheme.of(context).bgColorContainer,
              )),
        ).show(context);
      },
    );
  }
}
