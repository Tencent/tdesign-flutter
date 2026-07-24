import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TPopoverPage extends StatefulWidget {
  const TPopoverPage({super.key});

  @override
  State<StatefulWidget> createState() => _TPopoverPage();
}

class _TPopoverPage extends State<TPopoverPage> {
  TPopoverColorScheme theme = TPopoverColorScheme.light;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        theme = Theme.of(context).brightness == Brightness.dark
            ? TPopoverColorScheme.light
            : TPopoverColorScheme.dark;
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
        ExampleModule(title: '组件样式', children: [
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
                          child: CodeWrapper(builder: _buildInfoPopover),
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
                          child: CodeWrapper(builder: _buildErrorPopover),
                        ),
                      ],
                    )
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
                    Expanded(
                      child: CodeWrapper(builder: _buildTopPopover),
                    ),
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
        ])
      ],
      test: [
        ExampleItem(
          desc: '显示多行内容',
          builder: _buildMultiLinePopover,
        ),
        ExampleItem(
          desc: '自定义圆角',
          builder: _buildCustomRadiusPopover,
        )
      ],
    );
  }

  @Demo(group: 'popover')
  Widget _buildPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('带箭头'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                  context: _, content: '弹出气泡内容', colorScheme: theme);
            },
          );
        },
      ),
    );
  }

  @Demo(group: 'popover')
  Widget _buildNoArrowPopover(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constrains) {
        return TButton(
          size: TButtonSize.medium,
          child: const Text('不带箭头'),
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          onPressed: () {
            TPopover.showPopover(
                context: _, content: '弹出气泡内容', showArrow: false, colorScheme: theme);
          },
        );
      },
    );
  }

  @Demo(group: 'popover')
  Widget _buildNCustomPopover(BuildContext context) {
    var textStyle = TextStyle(
        color: theme == TPopoverColorScheme.light
            ? context.tTheme.fontGyColor1
            : context.tTheme.fontWhColor1);
    return LayoutBuilder(
      builder: (_, constrains) {
        return TButton(
          child: const Text('自定义内容'),
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          onPressed: () {
            TPopover.showPopover(
              context: _,
              padding: const EdgeInsets.all(0),
              colorScheme: theme,
              // contentWidget 模式下必须指定 width 和 height（组件 initState 断言要求）
              width: 150,
              height: 146,
              contentWidget: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    child: TText('选项1', style: textStyle),
                  ),
                  const TDivider(),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    child: TText('选项2', style: textStyle),
                  ),
                  const TDivider(),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
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

  @Demo(group: 'popover')
  Widget _buildDarkPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('深色'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
              );
            },
          );
        },
      ),
    );
  }

  @Demo(group: 'popover')
  Widget _buildLightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('浅色'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                colorScheme: TPopoverColorScheme.light,
              );
            },
          );
        },
      ),
    );
  }

  @Demo(group: 'popover')
  Widget _buildInfoPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('品牌色'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                colorScheme: TPopoverColorScheme.info,
              );
            },
          );
        },
      ),
    );
  }

  @Demo(group: 'popover')
  Widget _buildSuccessPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('成功色'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                colorScheme: TPopoverColorScheme.success,
              );
            },
          );
        },
      ),
    );
  }

  @Demo(group: 'popover')
  Widget _buildWarningPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('警告色'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                colorScheme: TPopoverColorScheme.warning,
              );
            },
          );
        },
      ),
    );
  }

  @Demo(group: 'popover')
  Widget _buildErrorPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('错误色'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                colorScheme: TPopoverColorScheme.error,
              );
            },
          );
        },
      ),
    );
  }

  @Demo(group: 'popover')
  Widget _buildTopLeftPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('顶部左'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: _,
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

  @Demo(group: 'popover')
  Widget _buildTopPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('顶部中'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: _,
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

  @Demo(group: 'popover')
  Widget _buildTopRightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('顶部右'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: _,
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

  @Demo(group: 'popover')
  Widget _buildBottomLeftPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('底部左'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: _,
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

  @Demo(group: 'popover')
  Widget _buildBottomPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('底部中'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: _,
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

  @Demo(group: 'popover')
  Widget _buildBottomRightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('底部右'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: _,
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

  @Demo(group: 'popover')
  Widget _buildRightTopPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('右侧上'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: _,
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

  @Demo(group: 'popover')
  Widget _buildRightPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('右侧中'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: _,
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

  @Demo(group: 'popover')
  Widget _buildRightBottomPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('右侧下'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: _,
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

  @Demo(group: 'popover')
  Widget _buildLeftTopPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('左侧上'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: _,
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

  @Demo(group: 'popover')
  Widget _buildLeftPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('左侧中'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: _,
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

  @Demo(group: 'popover')
  Widget _buildLeftBottomPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('左侧下'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: _,
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

  @Demo(group: 'popover')
  Widget _buildMultiLinePopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('多行内容'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: _,
                content: '弹出气泡内容弹出气泡内容弹出气泡内容弹出气泡内容',
                colorScheme: theme,
              );
            },
          );
        },
      ),
    );
  }

  @Demo(group: 'popover')
  Widget _buildCustomRadiusPopover(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return TButton(
            size: TButtonSize.medium,
            child: const Text('自定义圆角'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {
              TPopover.showPopover(
                context: _,
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
