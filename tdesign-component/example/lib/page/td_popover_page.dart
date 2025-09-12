import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TDPopoverPage extends StatefulWidget {
  const TDPopoverPage({super.key});

  @override
  State<StatefulWidget> createState() => _TDPopoverPage();
}

class _TDPopoverPage extends State<TDPopoverPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      desc: '用于文字提示的气泡框。',
      exampleCodeGroup: 'popover',
      backgroundColor: TDTheme.of(context).whiteColor1,
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
                          flex: 1,
                          child: CodeWrapper(builder: _buildDarkPopover),
                        ),
                        Expanded(
                          flex: 1,
                          child: CodeWrapper(builder: _buildLightPopover),
                        ),
                        Expanded(
                          flex: 1,
                          child: CodeWrapper(builder: _buildInfoPopover),
                        ),
                      ],
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          flex: 1,
                          child: CodeWrapper(builder: _buildSuccessPopover),
                        ),
                        Expanded(
                          flex: 1,
                          child: CodeWrapper(builder: _buildWarningPopover),
                        ),
                        Expanded(
                          flex: 1,
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
                      flex: 1,
                      child: CodeWrapper(builder: _buildTopLeftPopover),
                    ),
                    Expanded(
                      flex: 1,
                      child: CodeWrapper(builder: _buildTopPopover),
                    ),
                    Expanded(
                      flex: 1,
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
                      flex: 1,
                      child: CodeWrapper(builder: _buildBottomLeftPopover),
                    ),
                    Expanded(
                      flex: 1,
                      child: CodeWrapper(builder: _buildBottomPopover),
                    ),
                    Expanded(
                      flex: 1,
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
                      flex: 1,
                      child: Column(
                        children: [
                          CodeWrapper(builder: _buildRightTopPopover),
                          CodeWrapper(builder: _buildRightPopover),
                          CodeWrapper(builder: _buildRightBottomPopover),
                        ],
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
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
                    const Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Expanded(
                      flex: 1,
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
          return TDButton(
            size: TDButtonSize.medium,
            text: '带箭头',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(context: _, content: '弹出气泡内容');
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
        return TDButton(
          size: TDButtonSize.medium,
          text: '不带箭头',
          type: TDButtonType.outline,
          theme: TDButtonTheme.primary,
             
          onTap: () {
            TDPopover.showPopover(
                context: _, content: '弹出气泡内容', showArrow: false);
          },
        );
      },
    );
  }

  Widget _buildPopoverList(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: TDText('选项1',
              style: TextStyle(color: TDTheme.of(context).whiteColor1)),
        ),
        TDDivider(color: TDTheme.of(context).whiteColor1, height: 0.5),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: TDText('选项2',
              style: TextStyle(color: TDTheme.of(context).whiteColor1)),
        ),
        TDDivider(color: TDTheme.of(context).whiteColor1, height: 0.5),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: TDText('选项3',
              style: TextStyle(color: TDTheme.of(context).whiteColor1)),
        ),
      ],
    );
  }

  @Demo(group: 'popover')
  Widget _buildNCustomPopover(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constrains) {
        return TDButton(
          text: '自定义内容',
          type: TDButtonType.outline,
          theme: TDButtonTheme.primary,
             
          onTap: () {
            TDPopover.showPopover(
              context: _,
              padding: const EdgeInsets.all(0),
              width: 108,
              height: 148,
              contentWidget: _buildPopoverList(context),
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
          return TDButton(
            size: TDButtonSize.medium,
            text: '深色',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
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
          return TDButton(
            size: TDButtonSize.medium,
            text: '浅色',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                theme: TDPopoverTheme.light,
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
          return TDButton(
            size: TDButtonSize.medium,
            text: '品牌色',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                theme: TDPopoverTheme.info,
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
          return TDButton(
            size: TDButtonSize.medium,
            text: '成功色',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                theme: TDPopoverTheme.success,
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
          return TDButton(
            size: TDButtonSize.medium,
            text: '警告色',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                theme: TDPopoverTheme.warning,
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
          return TDButton(
            size: TDButtonSize.medium,
            text: '错误色',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                theme: TDPopoverTheme.error,
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
          return TDButton(
            size: TDButtonSize.medium,
            text: '顶部左',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.topLeft,
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
          return TDButton(
            size: TDButtonSize.medium,
            text: '顶部中',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.top,
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
          return TDButton(
            size: TDButtonSize.medium,
            text: '顶部右',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.topRight,
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
          return TDButton(
            size: TDButtonSize.medium,
            text: '底部左',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.bottomLeft,
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
          return TDButton(
            size: TDButtonSize.medium,
            text: '底部中',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.bottom,
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
          return TDButton(
            size: TDButtonSize.medium,
            text: '底部右',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.bottomRight,
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
          return TDButton(
            size: TDButtonSize.medium,
            text: '右侧上',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.rightTop,
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
          return TDButton(
            size: TDButtonSize.medium,
            text: '右侧中',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.right,
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
          return TDButton(
            size: TDButtonSize.medium,
            text: '右侧下',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.rightBottom,
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
          return TDButton(
            size: TDButtonSize.medium,
            text: '左侧上',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.leftTop,
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
          return TDButton(
            size: TDButtonSize.medium,
            text: '左侧中',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.left,
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
          return TDButton(
            size: TDButtonSize.medium,
            text: '左侧下',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                content: '弹出气泡内容',
                placement: TDPopoverPlacement.leftBottom,
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
          return TDButton(
            size: TDButtonSize.medium,
            text: '多行内容',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,
               
            onTap: () {
              TDPopover.showPopover(
                context: _,
                width: 200,
                content: '弹出气泡内容弹出气泡内容弹出气泡内容弹出气泡内容',
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
          return TDButton(
            size: TDButtonSize.medium,
            text: '自定义圆角',
            type: TDButtonType.outline,
            theme: TDButtonTheme.primary,

            onTap: () {
              TDPopover.showPopover(
                context: _,
                width: 200,
                radius: BorderRadius.circular(16),
                content: '弹出气泡内容弹出气泡内容弹出气泡内容弹出气泡内容',
              );
            },
          );
        },
      ),
    );
  }
}
