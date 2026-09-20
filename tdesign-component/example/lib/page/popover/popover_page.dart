import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'popover_arrow_example.dart';
import 'popover_bottom_placements_example.dart';
import 'popover_color_schemes_example.dart';
import 'popover_custom_content_example.dart';
import 'popover_left_placements_example.dart';
import 'popover_no_arrow_example.dart';
import 'popover_right_placements_example.dart';
import 'popover_top_placements_example.dart';

@ExampleCodeManifest()
class TPopoverPage extends StatefulWidget {
  const TPopoverPage({super.key, this.showInternalExamples = false});

  /// 是否展示仅用于组件回归验证的交互与边界场景。
  final bool showInternalExamples;

  @override
  State<StatefulWidget> createState() => _TPopoverPage();
}

class _TPopoverPage extends State<TPopoverPage> {
  TPopoverColorScheme theme = TPopoverColorScheme.light;
  String _eventStatus = '点击或长按气泡后查看结果';
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
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '带箭头的弹出气泡',
              methodName: 'PopoverArrowExample',
              builder: (_) => const PopoverArrowExample(),
            ),
            ExampleItem(
              desc: '不带箭头的弹出气泡',
              methodName: 'PopoverNoArrowExample',
              builder: (_) => const PopoverNoArrowExample(),
            ),
            ExampleItem(
              desc: '自定义内容弹出气泡',
              methodName: 'PopoverCustomContentExample',
              builder: (_) => const PopoverCustomContentExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '',
              methodName: 'PopoverColorSchemesExample',
              builder: (_) => const PopoverColorSchemesExample(),
            ),
            ExampleItem(
              desc: '顶部弹出气泡',
              methodName: 'PopoverTopPlacementsExample',
              builder: (_) => const PopoverTopPlacementsExample(),
            ),
            ExampleItem(
              desc: '底部弹出气泡',
              methodName: 'PopoverBottomPlacementsExample',
              builder: (_) => const PopoverBottomPlacementsExample(),
            ),
            ExampleItem(
              desc: '右侧弹出气泡',
              methodName: 'PopoverRightPlacementsExample',
              builder: (_) => const PopoverRightPlacementsExample(),
            ),
            ExampleItem(
              desc: '左侧弹出气泡',
              methodName: 'PopoverLeftPlacementsExample',
              builder: (_) => const PopoverLeftPlacementsExample(),
            ),
          ],
        ),
        if (widget.showInternalExamples)
          ExampleModule(
            title: '交互与边界',
            children: [
              ExampleItem(
                desc: '点击与长按回调',
                ignoreCode: true,
                builder: _buildEventPopover,
              ),
              ExampleItem(
                desc: '主题与尺寸约束',
                ignoreCode: true,
                builder: _buildThemeSizePopover,
              ),
              ExampleItem(
                desc: '窄屏四角边界与自动翻转',
                ignoreCode: true,
                builder: _buildBoundaryPopover,
              ),
              ExampleItem(
                desc: '键盘遮挡场景',
                ignoreCode: true,
                builder: _buildKeyboardPopover,
              ),
              ExampleItem(
                desc: '锚点销毁与 Future',
                ignoreCode: true,
                builder: _buildLifecyclePopover,
              ),
            ],
          ),
      ],
      test: [
        ExampleItem(desc: '显示多行内容', builder: _buildMultiLinePopover),
        ExampleItem(desc: '自定义圆角', builder: _buildCustomRadiusPopover),
      ],
    );
  }

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
                  content: const Text('点击或长按我'),
                  placement: TPopoverPlacement.bottom,
                  onTap: () {
                    setState(() => _eventStatus = 'onTap：点击或长按我');
                  },
                  onLongTap: () {
                    setState(() => _eventStatus = 'onLongTap：点击或长按我');
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
                    content: const Text('短文本'),
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
                    content: const Text('这是一段用于验证最大宽度和自然换行的较长气泡文本'),
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
                  content: Text('$label边界内容'),
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
                    content: const Text('键盘弹出时保持在可用区域'),
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
                          content: const Text('移除锚点后自动关闭'),
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
                content: const Text('弹出气泡内容弹出气泡内容弹出气泡内容弹出气泡内容'),
                colorScheme: theme,
              );
            },
          );
        },
      ),
    );
  }

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
                content: const Text('弹出气泡内容弹出气泡内容弹出气泡内容弹出气泡内容'),
              );
            },
          );
        },
      ),
    );
  }
}
