import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TPopoverPage extends StatefulWidget {
  const TPopoverPage({super.key});

  @override
  State<StatefulWidget> createState() => _TPopoverPage();
}

class _TPopoverPage extends State<TPopoverPage> {
  TPopoverColorScheme theme = TPopoverColorScheme.light;
  String _eventStatus = '点击或长按气泡后查看结果';
  String _customContentStatus = '尚未选择菜单项';
  String _lifecycleStatus = '尚未打开生命周期气泡';
  bool _showLifecycleAnchor = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        theme = Theme.of(context).brightness == Brightness.dark
            ? TPopoverColorScheme.light
            : TPopoverColorScheme.defaultTheme;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于文字提示的气泡框。',
      exampleCodeGroup: 'popover',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '带箭头的弹出气泡', builder: _buildPopover),
            ExampleItem(desc: '不带箭头的弹出气泡', builder: _buildNoArrowPopover),
            ExampleItem(desc: '自定义内容弹出气泡', builder: _buildNCustomPopover),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              ignoreCode: true,
              builder: (context) {
                return Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                            child: CodeWrapper(builder: _buildDarkPopover),
                          ),
                          Expanded(
                            child: CodeWrapper(builder: _buildLightPopover),
                          ),
                          Expanded(
                            child: CodeWrapper(builder: _buildPrimaryPopover),
                          ),
                        ],
                      ),
                      Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                            child: CodeWrapper(builder: _buildSuccessPopover),
                          ),
                          Expanded(
                            child: CodeWrapper(builder: _buildWarningPopover),
                          ),
                          Expanded(
                            child: CodeWrapper(builder: _buildDangerPopover),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            ExampleItem(
              desc: '顶部弹出气泡',
              ignoreCode: true,
              builder: (context) {
                return Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: CodeWrapper(builder: _buildTopLeftPopover),
                      ),
                      Expanded(child: CodeWrapper(builder: _buildTopPopover)),
                      Expanded(
                        child: CodeWrapper(builder: _buildTopRightPopover),
                      ),
                    ],
                  ),
                );
              },
            ),
            ExampleItem(
              desc: '底部弹出气泡',
              ignoreCode: true,
              builder: (context) {
                return Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: CodeWrapper(builder: _buildBottomLeftPopover),
                      ),
                      Expanded(
                        child: CodeWrapper(builder: _buildBottomPopover),
                      ),
                      Expanded(
                        child: CodeWrapper(builder: _buildBottomRightPopover),
                      ),
                    ],
                  ),
                );
              },
            ),
            ExampleItem(
              desc: '右侧弹出气泡',
              ignoreCode: true,
              builder: (context) {
                return Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            CodeWrapper(builder: _buildRightTopPopover),
                            CodeWrapper(builder: _buildRightPopover),
                            CodeWrapper(builder: _buildRightBottomPopover),
                          ],
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                );
              },
            ),
            ExampleItem(
              desc: '左侧弹出气泡',
              ignoreCode: true,
              builder: (context) {
                return Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      const Expanded(child: SizedBox()),
                      Expanded(
                        child: Column(
                          children: [
                            CodeWrapper(builder: _buildLeftTopPopover),
                            CodeWrapper(builder: _buildLeftPopover),
                            CodeWrapper(builder: _buildLeftBottomPopover),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        ExampleModule(
          title: '交互与边界',
          children: [
            ExampleItem(desc: '点击与长按回调', builder: _buildEventPopover),
            ExampleItem(
              desc: '可交互自定义内容',
              builder: _buildInteractiveContentPopover,
            ),
            ExampleItem(desc: '主题与尺寸约束', builder: _buildThemeSizePopover),
            ExampleItem(desc: '窄屏四角边界与自动翻转', builder: _buildBoundaryPopover),
            ExampleItem(desc: '键盘遮挡场景', builder: _buildKeyboardPopover),
            ExampleItem(desc: '锚点销毁与 Future', builder: _buildLifecyclePopover),
          ],
        ),
      ],
      test: [
        ExampleItem(desc: '显示多行内容', builder: _buildMultiLinePopover),
        ExampleItem(desc: '自定义圆角', builder: _buildCustomRadiusPopover),
      ],
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('带箭头'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: '弹出气泡内容',
                colorScheme: theme,
              );
            },
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildNoArrowPopover(BuildContext context) {
    return LayoutBuilder(
      builder: (popoverContext, constrains) {
        return TButton(
          size: TButtonSize.medium,
          child: const Text('不带箭头'),
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          onPressed: () {
            TPopover.showPopover(
              context: popoverContext,
              content: '弹出气泡内容',
              showArrow: false,
              colorScheme: theme,
            );
          },
        );
      },
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildNCustomPopover(BuildContext context) {
    var textStyle = TextStyle(
      color: theme == TPopoverColorScheme.light
          ? context.tTheme.fontGyColor1
          : context.tTheme.fontWhColor1,
    );
    return LayoutBuilder(
      builder: (popoverContext, constrains) {
        return TButton(
          child: const Text('自定义内容'),
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          onPressed: () {
            TPopover.showPopover(
              context: popoverContext,
              padding: const EdgeInsets.all(0),
              colorScheme: theme,
              // contentWidget 模式下必须指定确定的 width 和 height。
              width: 150,
              height: 146,
              contentWidget: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    child: TText('选项1', style: textStyle),
                  ),
                  const TDivider(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    child: TText('选项2', style: textStyle),
                  ),
                  const TDivider(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    child: TText('选项3', style: textStyle),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildEventPopover(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (popoverContext, constraints) {
            return TButton(
              key: const Key('popover-event-trigger'),
              variant: TButtonVariant.outline,
              colorScheme: TButtonColorScheme.primary,
              onPressed: () {
                TPopover.showPopover(
                  context: popoverContext,
                  content: '点击或长按我',
                  placement: TPopoverPlacement.bottom,
                  onTap: (content) {
                    setState(() => _eventStatus = 'onTap：$content');
                  },
                  onLongTap: (content) {
                    setState(() => _eventStatus = 'onLongTap：$content');
                  },
                );
              },
              child: const Text('事件回调'),
            );
          },
        ),
        const SizedBox(height: 8),
        TText(_eventStatus, key: const Key('popover-event-status')),
      ],
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildInteractiveContentPopover(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (popoverContext, constraints) {
            return TButton(
              key: const Key('popover-interactive-trigger'),
              variant: TButtonVariant.outline,
              colorScheme: TButtonColorScheme.primary,
              onPressed: () {
                TPopover.showPopover(
                  context: popoverContext,
                  width: 180,
                  height: 104,
                  padding: EdgeInsets.zero,
                  placement: TPopoverPlacement.bottom,
                  contentWidget: Column(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          key: const Key('popover-menu-复制'),
                          behavior: HitTestBehavior.opaque,
                          onTap: () =>
                              setState(() => _customContentStatus = '已选择复制'),
                          child: const Center(child: TText('复制')),
                        ),
                      ),
                      const TDivider(),
                      Expanded(
                        child: GestureDetector(
                          key: const Key('popover-menu-分享'),
                          behavior: HitTestBehavior.opaque,
                          onTap: () =>
                              setState(() => _customContentStatus = '已选择分享'),
                          child: const Center(child: TText('分享')),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('打开操作菜单'),
            );
          },
        ),
        const SizedBox(height: 8),
        TText(
          _customContentStatus,
          key: const Key('popover-interactive-status'),
        ),
      ],
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildThemeSizePopover(BuildContext context) {
    final popoverTheme = Theme.of(context).mergeExtension(
      const TPopoverThemeData(
        backgroundColor: Color(0xFF5E3BB7),
        minWidth: 120,
        maxWidth: 180,
        maxHeight: 120,
      ),
    );
    return Theme(
      data: popoverTheme,
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        children: [
          Builder(
            builder: (popoverContext) {
              return TButton(
                key: const Key('popover-theme-short-trigger'),
                variant: TButtonVariant.outline,
                colorScheme: TButtonColorScheme.primary,
                onPressed: () {
                  TPopover.showPopover(
                    context: popoverContext,
                    content: '短文本',
                    placement: TPopoverPlacement.bottom,
                  );
                },
                child: const Text('主题背景与最小宽度'),
              );
            },
          ),
          Builder(
            builder: (popoverContext) {
              return TButton(
                key: const Key('popover-theme-long-trigger'),
                variant: TButtonVariant.outline,
                colorScheme: TButtonColorScheme.primary,
                onPressed: () {
                  TPopover.showPopover(
                    context: popoverContext,
                    content: '这是一段用于验证最大宽度和自然换行的较长气泡文本',
                    placement: TPopoverPlacement.bottom,
                  );
                },
                child: const Text('最大宽度与自然换行'),
              );
            },
          ),
        ],
      ),
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildBoundaryPopover(BuildContext context) {
    Widget buildTrigger({
      required Alignment alignment,
      required String label,
      required TPopoverPlacement placement,
    }) {
      return Align(
        alignment: alignment,
        child: Builder(
          builder: (popoverContext) {
            return TButton(
              key: Key('popover-boundary-$label'),
              size: TButtonSize.small,
              variant: TButtonVariant.outline,
              colorScheme: TButtonColorScheme.primary,
              onPressed: () {
                TPopover.showPopover(
                  context: popoverContext,
                  content: '$label边界内容',
                  placement: placement,
                );
              },
              child: Text(label),
            );
          },
        ),
      );
    }

    return Container(
      key: const Key('popover-boundary-area'),
      height: 180,
      decoration: BoxDecoration(
        border: Border.all(color: context.tTheme.grayColor4),
        borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
      ),
      child: Stack(
        children: [
          buildTrigger(
            alignment: Alignment.topLeft,
            label: '左上',
            placement: TPopoverPlacement.topLeft,
          ),
          buildTrigger(
            alignment: Alignment.topRight,
            label: '右上',
            placement: TPopoverPlacement.topRight,
          ),
          buildTrigger(
            alignment: Alignment.bottomLeft,
            label: '左下',
            placement: TPopoverPlacement.bottomLeft,
          ),
          buildTrigger(
            alignment: Alignment.bottomRight,
            label: '右下',
            placement: TPopoverPlacement.bottomRight,
          ),
        ],
      ),
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildKeyboardPopover(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextField(
          key: Key('popover-keyboard-input'),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: '先点击输入框唤起键盘',
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Builder(
            builder: (popoverContext) {
              return TButton(
                key: const Key('popover-keyboard-trigger'),
                variant: TButtonVariant.outline,
                colorScheme: TButtonColorScheme.primary,
                onPressed: () {
                  TPopover.showPopover(
                    context: popoverContext,
                    content: '键盘弹出时保持在可用区域',
                    placement: TPopoverPlacement.bottomRight,
                  );
                },
                child: const Text('键盘上方显示'),
              );
            },
          ),
        ),
      ],
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildLifecyclePopover(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            if (_showLifecycleAnchor)
              Builder(
                builder: (popoverContext) {
                  return TButton(
                    key: const Key('popover-lifecycle-anchor'),
                    variant: TButtonVariant.outline,
                    colorScheme: TButtonColorScheme.primary,
                    onPressed: () {
                      setState(() => _lifecycleStatus = 'Popover 展示中');
                      unawaited(
                        TPopover.showPopover(
                          context: popoverContext,
                          content: '移除锚点后自动关闭',
                          placement: TPopoverPlacement.bottom,
                          closeOnClickOutside: false,
                          closeOnScroll: false,
                        ).then((_) {
                          if (mounted) {
                            setState(
                              () => _lifecycleStatus = 'Future 已完成，Overlay 已清理',
                            );
                          }
                        }),
                      );
                    },
                    child: const Text('打开生命周期气泡'),
                  );
                },
              ),
            TButton(
              key: const Key('popover-lifecycle-toggle'),
              variant: TButtonVariant.outline,
              colorScheme: TButtonColorScheme.primary,
              onPressed: () {
                setState(() {
                  _showLifecycleAnchor = !_showLifecycleAnchor;
                  if (_showLifecycleAnchor) {
                    _lifecycleStatus = '锚点已恢复';
                  }
                });
              },
              child: Text(_showLifecycleAnchor ? '移除锚点' : '恢复锚点'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TText(_lifecycleStatus, key: const Key('popover-lifecycle-status')),
      ],
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildDarkPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('深色'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(context: popoverContext, content: '弹出气泡内容');
            },
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildLightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('浅色'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: '弹出气泡内容',
                colorScheme: TPopoverColorScheme.light,
              );
            },
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildPrimaryPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('品牌色'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: '弹出气泡内容',
                colorScheme: TPopoverColorScheme.primary,
              );
            },
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildSuccessPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('成功色'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: '弹出气泡内容',
                colorScheme: TPopoverColorScheme.success,
              );
            },
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildWarningPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('警告色'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: '弹出气泡内容',
                colorScheme: TPopoverColorScheme.warning,
              );
            },
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildDangerPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('错误色'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: '弹出气泡内容',
                colorScheme: TPopoverColorScheme.danger,
              );
            },
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildTopLeftPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('顶部左'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.topLeft,
                colorScheme: theme,
              );
            },
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildTopPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('顶部中'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.top,
                colorScheme: theme,
              );
            },
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildTopRightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('顶部右'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.topRight,
                colorScheme: theme,
              );
            },
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildBottomLeftPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('底部左'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.bottomLeft,
                colorScheme: theme,
              );
            },
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildBottomPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('底部中'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.bottom,
                colorScheme: theme,
              );
            },
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildBottomRightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('底部右'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.bottomRight,
                colorScheme: theme,
              );
            },
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildRightTopPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('右侧上'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.rightTop,
                colorScheme: theme,
              );
            },
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildRightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('右侧中'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.right,
                colorScheme: theme,
              );
            },
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildRightBottomPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('右侧下'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.rightBottom,
                colorScheme: theme,
              );
            },
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildLeftTopPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('左侧上'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.leftTop,
                colorScheme: theme,
              );
            },
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildLeftPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('左侧中'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.left,
                colorScheme: theme,
              );
            },
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildLeftBottomPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('左侧下'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: '弹出气泡内容',
                placement: TPopoverPlacement.leftBottom,
                colorScheme: theme,
              );
            },
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildMultiLinePopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('多行内容'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                content: '弹出气泡内容弹出气泡内容弹出气泡内容弹出气泡内容',
                colorScheme: theme,
              );
            },
          );
        },
      ),
    );
  }

  @ExampleCode(group: 'popover')
  Widget _buildCustomRadiusPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (popoverContext, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('自定义圆角'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: popoverContext,
                radius: BorderRadius.circular(16),
                colorScheme: theme,
                content: '弹出气泡内容弹出气泡内容弹出气泡内容弹出气泡内容',
              );
            },
          );
        },
      ),
    );
  }
}
