import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

class TDButtonPage extends StatefulWidget {
  const TDButtonPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDButtonPageState();
}

class _TDButtonPageState extends State<TDButtonPage> {
  void onTap() {
    TDToast.showText('点击了按钮', context: context);
  }

  void onLongPress() {
    TDToast.showText('长按了按钮', context: context);
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      desc: '用于开启一个闭环的操作任务，如“删除”对象、“购买”商品等。',
      exampleCodeGroup: 'button',
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(
              ignoreCode: true,
              desc: '基础按钮',
              builder: (context) {
                return Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 16),
                  child: Wrap(
                    spacing: 16, // 主轴方向间距
                    runSpacing: 16, // 交叉轴方向间距
                    children: [
                      CodeWrapper(
                        builder: _buildPrimaryFillButton,
                        methodName: '_buildPrimaryFillButton',
                      ),
                      CodeWrapper(
                        builder: _buildLightFillButton,
                        methodName: '_buildLightFillButton',
                      ),
                      CodeWrapper(builder: _buildDefaultFillButton),
                      CodeWrapper(builder: _buildPrimaryStrokeButton),
                      CodeWrapper(builder: _buildPrimaryTextButton),
                    ],
                  ),
                );
              }),
          ExampleItem(
              ignoreCode: true,
              desc: '图标按钮',
              center: false,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.only(left: 16),
                  child: Wrap(
                    spacing: 16, // 主轴方向间距
                    runSpacing: 16, // 交叉轴方向间距
                    children: [
                      CodeWrapper(builder: _buildRectangleIconButton),
                      CodeWrapper(builder: _buildSquareIconButton),
                      CodeWrapper(builder: _buildLoadingIconButton)
                    ],
                  ),
                );
              }),
          ExampleItem(
              ignoreCode: true,
              desc: '幽灵按钮',
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  color: TDTheme.of(context).grayColor14,
                  child: Wrap(
                    spacing: 16, // 主轴方向间距
                    runSpacing: 16, // 交叉轴方向间距
                    children: [
                      CodeWrapper(builder: _buildPrimaryGhostButton),
                      CodeWrapper(builder: _buildDangerGhostButton),
                      CodeWrapper(builder: _buildDefaultGhostButton),
                    ],
                  ),
                );
              }),
          ExampleItem(ignoreCode: true, desc: '组合按钮', builder: (_) => CodeWrapper(builder: _buildCombinationButtons)),
          ExampleItem(desc: '通栏按钮', builder: _buildFilledFillButton),
        ]),
        ExampleModule(title: '组件状态', children: [
          ExampleItem(
              ignoreCode: true,
              desc: '按钮禁用状态',
              builder: (context) {
                return Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16, // 主轴方向间距
                  runSpacing: 16, // 交叉轴方向间距
                  children: [
                    CodeWrapper(builder: _buildDisablePrimaryFillButton),
                    CodeWrapper(builder: _buildDisableLightFillButton),
                    CodeWrapper(builder: _buildDisableDefaultFillButton),
                    CodeWrapper(builder: _buildDisablePrimaryStrokeButton),
                    CodeWrapper(builder: _buildDisablePrimaryTextButton),
                  ],
                );
              }),
        ]),
        ExampleModule(title: '组件主题', children: [
          ExampleItem(
              ignoreCode: true,
              desc: '按钮尺寸',
              builder: (context) {
                return Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16, // 主轴方向间距
                  runSpacing: 16, // 交叉轴方向间距
                  children: [
                    CodeWrapper(builder: _buildLargeButton),
                    CodeWrapper(builder: _buildMediumButton),
                    CodeWrapper(builder: _buildSmallButton),
                    CodeWrapper(builder: _buildExtraSmallButton),
                  ],
                );
              }),
          ExampleItem(
              ignoreCode: true,
              desc: '按钮形状',
              builder: (context) {
                return Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16, // 主轴方向间距
                  runSpacing: 16, // 交叉轴方向间距
                  children: [
                    CodeWrapper(
                      builder: _buildPrimaryFillButton,
                    ),
                    CodeWrapper(builder: _buildSquareIconButton),
                    CodeWrapper(builder: _buildRoundButton),
                    CodeWrapper(builder: _buildCircleButton),
                    CodeWrapper(builder: _buildFilledButton)
                  ],
                );
              }),
          ExampleItem(
              ignoreCode: true,
              desc: '按钮主题',
              builder: (context) {
                return Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16, // 主轴方向间距
                  runSpacing: 16, // 交叉轴方向间距
                  children: [
                    /// 默认主题
                    CodeWrapper(builder: _buildDefaultFillButton),
                    CodeWrapper(builder: _buildDefaultStrokeButton),
                    CodeWrapper(builder: _buildDefaultTextButton),

                    /// primary主题
                    CodeWrapper(
                      builder: _buildPrimaryFillButton,
                    ),
                    CodeWrapper(builder: _buildPrimaryStrokeButton),
                    CodeWrapper(builder: _buildPrimaryTextButton),

                    /// danger主题
                    CodeWrapper(builder: _buildDangerFillButton),
                    CodeWrapper(builder: _buildDangerStrokeButton),
                    CodeWrapper(builder: _buildDangerTextButton),

                    /// light主题
                    CodeWrapper(builder: _buildLightFillButton),
                    CodeWrapper(builder: _buildLightStrokeButton),
                    CodeWrapper(
                      builder: _buildLightTextButton,
                    ),
                  ],
                );
              }),
        ]),
      ],
      test: [
        ExampleItem(
            ignoreCode: true,
            desc: '测试child',
            builder: (context) {
              return CodeWrapper(builder: _buildChildTestButton);
            }),
        ExampleItem(
            ignoreCode: true,
            desc: '通栏按钮测试',
            builder: (context) {
              return Container(
                color: TDTheme.of(context).bgColorContainer,
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  // spacing: 16,
                  children: [
                    TDButton(
                      isBlock: true,
                      text: '填充block按钮',
                      theme: TDButtonTheme.primary,
                    ),
                    SizedBox(height: 16),
                    TDButton(
                      isBlock: true,
                      text: '描边block按钮',
                      type: TDButtonType.outline,
                      theme: TDButtonTheme.primary,
                    ),
                    SizedBox(height: 16),
                    TDButton(
                      isBlock: true,
                      text: '文字block按钮',
                      type: TDButtonType.text,
                      theme: TDButtonTheme.primary,
                    ),
                    SizedBox(height: 16),
                    TDButton(
                      isBlock: true,
                      text: '幽灵block按钮',
                      type: TDButtonType.ghost,
                      theme: TDButtonTheme.primary,
                    ),
                  ],
                ),
              );
            }),
        ExampleItem(ignoreCode: true, desc: '各种按钮状态测试', builder: _buildStatusDisplay),
        ExampleItem(
            ignoreCode: true,
            desc: '按钮中路由跳转',
            builder: (context) {
              return TDButton(
                text: '点击跳转',
                size: TDButtonSize.large,
                shape: TDButtonShape.rectangle,
                onTap: () async {
                  var result = await Navigator.of(context).pushNamedAndRemoveUntil('divider', (router) {
                    return true;
                  });
                  print('pushNamedAndRemoveUntil result: $result');
                },
              );
            }),
        ExampleItem(
            ignoreCode: true,
            desc: '图标在文字右侧',
            builder: (context) {
              return CodeWrapper(builder: _buildRightIconButton);
            }),
        ExampleItem(
            ignoreCode: true,
            desc: '渐变色背景按钮',
            builder: (context) {
              return CodeWrapper(builder: _buildGradientButton);
            }),
      ],
    );
  }

  @Demo(group: 'button')
  TDButton _buildLightTextButton(BuildContext context) {
    return const TDButton(
      text: '文字按钮',
      size: TDButtonSize.large,
      type: TDButtonType.text,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.light,
    );
  }

  @Demo(group: 'button')
  TDButton _buildLightStrokeButton(BuildContext context) {
    return const TDButton(
      text: '描边按钮',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.light,
    );
  }

  @Demo(group: 'button')
  TDButton _buildDangerTextButton(BuildContext context) {
    return const TDButton(
      text: '文字按钮',
      size: TDButtonSize.large,
      type: TDButtonType.text,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.danger,
    );
  }

  @Demo(group: 'button')
  TDButton _buildDangerStrokeButton(BuildContext context) {
    return const TDButton(
      text: '描边按钮',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.danger,
    );
  }

  @Demo(group: 'button')
  TDButton _buildDangerFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.danger,
    );
  }

  @Demo(group: 'button')
  TDButton _buildDefaultTextButton(BuildContext context) {
    return const TDButton(
      text: '文字按钮',
      size: TDButtonSize.large,
      type: TDButtonType.text,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.defaultTheme,
    );
  }

  @Demo(group: 'button')
  TDButton _buildDefaultStrokeButton(BuildContext context) {
    return const TDButton(
      text: '描边按钮',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.defaultTheme,
    );
  }

  @Demo(group: 'button')
  TDButton _buildFilledButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.filled,
      theme: TDButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TDButton _buildCircleButton(BuildContext context) {
    return const TDButton(
      icon: TDIcons.app,
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.circle,
      theme: TDButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TDButton _buildRoundButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.round,
      theme: TDButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TDButton _buildExtraSmallButton(BuildContext context) {
    return const TDButton(
      text: '按钮28',
      size: TDButtonSize.extraSmall,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TDButton _buildSmallButton(BuildContext context) {
    return const TDButton(
      text: '按钮32',
      size: TDButtonSize.small,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TDButton _buildMediumButton(BuildContext context) {
    return const TDButton(
      text: '按钮40',
      size: TDButtonSize.medium,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TDButton _buildLargeButton(BuildContext context) {
    return const TDButton(
      text: '按钮48',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TDButton _buildDisablePrimaryTextButton(BuildContext context) {
    return const TDButton(
      text: '文字按钮',
      size: TDButtonSize.large,
      type: TDButtonType.text,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
      disabled: true,
    );
  }

  @Demo(group: 'button')
  TDButton _buildDisablePrimaryStrokeButton(BuildContext context) {
    return const TDButton(
      text: '描边按钮',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
      disabled: true,
    );
  }

  @Demo(group: 'button')
  TDButton _buildDisableDefaultFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.defaultTheme,
      disabled: true,
    );
  }

  @Demo(group: 'button')
  TDButton _buildDisableLightFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.light,
      disabled: true,
    );
  }

  @Demo(group: 'button')
  TDButton _buildDisablePrimaryFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
      disabled: true,
    );
  }

  @Demo(group: 'button')
  TDButton _buildFilledFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      icon: TDIcons.app,
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      theme: TDButtonTheme.primary,
      isBlock: true,
    );
  }

  @Demo(group: 'button')
  TDButton _buildDefaultGhostButton(BuildContext context) {
    return const TDButton(
      text: '幽灵按钮',
      size: TDButtonSize.large,
      type: TDButtonType.ghost,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.defaultTheme,
    );
  }

  @Demo(group: 'button')
  TDButton _buildDangerGhostButton(BuildContext context) {
    return const TDButton(
      text: '幽灵按钮',
      size: TDButtonSize.large,
      type: TDButtonType.ghost,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.danger,
    );
  }

  @Demo(group: 'button')
  TDButton _buildPrimaryGhostButton(BuildContext context) {
    return const TDButton(
      text: '幽灵按钮',
      size: TDButtonSize.large,
      type: TDButtonType.ghost,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TDButton _buildSquareIconButton(BuildContext context) {
    return const TDButton(
      icon: TDIcons.app,
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.square,
      theme: TDButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TDButton _buildLoadingIconButton(BuildContext context) {
    return TDButton(
      text: '加载中',
      iconWidget: TDLoading(
        size: TDLoadingSize.small,
        icon: TDLoadingIcon.circle,
        iconColor: TDTheme.of(context).whiteColor1,
      ),
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TDButton _buildRectangleIconButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      icon: TDIcons.app,
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TDButton _buildPrimaryTextButton(BuildContext context) {
    return const TDButton(
      text: '文字按钮',
      size: TDButtonSize.large,
      type: TDButtonType.text,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TDButton _buildPrimaryStrokeButton(BuildContext context) {
    return const TDButton(
      text: '描边按钮',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TDButton _buildDefaultFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.defaultTheme,
    );
  }

  @Demo(group: 'button')
  @Demo(group: 'button')
  TDButton _buildPrimaryFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TDButton _buildLightFillButton(BuildContext context) {
    return const TDButton(
      text: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.light,
    );
  }

  @Demo(group: 'button')
  Widget _buildCombinationButtons(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          // spacing: 16,
          children: [
            Expanded(
              child: TDButton(
                text: '填充按钮',
                size: TDButtonSize.large,
                type: TDButtonType.fill,
                shape: TDButtonShape.rectangle,
                theme: TDButtonTheme.light,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: TDButton(
                text: '填充按钮',
                size: TDButtonSize.large,
                type: TDButtonType.fill,
                shape: TDButtonShape.rectangle,
                theme: TDButtonTheme.primary,
              ),
            ),
          ],
        ));
  }

  @Demo(group: 'button')
  Widget _buildChildTestButton(BuildContext context) {
    return TDButton(
      child: Container(
        // 高度被按钮约束了
        height: 48,
        width: 48,
        color: Colors.red,
      ),
    );
  }

  @Demo(group: 'button')
  Widget _buildRightIconButton(BuildContext context) {
    return const Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        TDButton(
          text: '填充按钮',
          icon: TDIcons.app,
          size: TDButtonSize.large,
          type: TDButtonType.fill,
          shape: TDButtonShape.rectangle,
          theme: TDButtonTheme.primary,
          iconPosition: TDButtonIconPosition.right,
        ),
        TDButton(
          icon: TDIcons.app,
          size: TDButtonSize.large,
          type: TDButtonType.fill,
          shape: TDButtonShape.rectangle,
          theme: TDButtonTheme.primary,
          iconPosition: TDButtonIconPosition.right,
        ),
        TDButton(
          text: '间距20',
          icon: TDIcons.app,
          size: TDButtonSize.large,
          type: TDButtonType.fill,
          shape: TDButtonShape.rectangle,
          theme: TDButtonTheme.primary,
          iconPosition: TDButtonIconPosition.right,
          iconTextSpacing: 20,
        )
      ],
    );
  }

  @Demo(group: 'button')
  Widget _buildGradientButton(BuildContext context) {
    return const Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        TDButton(
          text: '填充按钮',
          icon: TDIcons.app,
          size: TDButtonSize.large,
          type: TDButtonType.fill,
          shape: TDButtonShape.rectangle,
          theme: TDButtonTheme.primary,
          iconPosition: TDButtonIconPosition.right,
          gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
        ),
        TDButton(
          icon: TDIcons.app,
          size: TDButtonSize.large,
          type: TDButtonType.fill,
          shape: TDButtonShape.rectangle,
          theme: TDButtonTheme.primary,
          iconPosition: TDButtonIconPosition.right,
          gradient: LinearGradient(
              colors: [Colors.red, Colors.blue], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        TDButton(
          text: '间距20',
          icon: TDIcons.app,
          size: TDButtonSize.large,
          type: TDButtonType.fill,
          shape: TDButtonShape.rectangle,
          theme: TDButtonTheme.primary,
          iconPosition: TDButtonIconPosition.right,
          iconTextSpacing: 20,
          gradient: LinearGradient(
              colors: [Colors.red, Colors.blue], begin: Alignment.centerRight, end: Alignment.centerLeft),
        )
      ],
    );
  }

  Widget _buildStatusDisplay(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        /// fill
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.primary,
              ),
              TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.primary,
                style: TDButtonStyle.generateFillStyleByTheme(context, TDButtonTheme.primary, TDButtonStatus.active),
              ),
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.primary,
                disabled: true,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.light,
              ),
              TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.light,
                style: TDButtonStyle.generateFillStyleByTheme(context, TDButtonTheme.light, TDButtonStatus.active),
              ),
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.light,
                disabled: true,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.defaultTheme,
              ),
              TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.defaultTheme,
                style:
                    TDButtonStyle.generateFillStyleByTheme(context, TDButtonTheme.defaultTheme, TDButtonStatus.active),
              ),
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.defaultTheme,
                disabled: true,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.danger,
              ),
              TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.danger,
                style: TDButtonStyle.generateFillStyleByTheme(context, TDButtonTheme.danger, TDButtonStatus.active),
              ),
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.danger,
                disabled: true,
              ),
            ],
          ),
        ),

        /// outline
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.primary,
                type: TDButtonType.outline,
              ),
              TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.primary,
                style: TDButtonStyle.generateOutlineStyleByTheme(context, TDButtonTheme.primary, TDButtonStatus.active),
                type: TDButtonType.outline,
              ),
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.primary,
                disabled: true,
                type: TDButtonType.outline,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.light,
                type: TDButtonType.outline,
              ),
              TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.light,
                style: TDButtonStyle.generateOutlineStyleByTheme(context, TDButtonTheme.light, TDButtonStatus.active),
                type: TDButtonType.outline,
              ),
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.light,
                disabled: true,
                type: TDButtonType.outline,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.defaultTheme,
                type: TDButtonType.outline,
              ),
              TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.defaultTheme,
                style: TDButtonStyle.generateOutlineStyleByTheme(
                    context, TDButtonTheme.defaultTheme, TDButtonStatus.active),
                type: TDButtonType.outline,
              ),
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.defaultTheme,
                disabled: true,
                type: TDButtonType.outline,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.danger,
                type: TDButtonType.outline,
              ),
              TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.danger,
                style: TDButtonStyle.generateOutlineStyleByTheme(context, TDButtonTheme.danger, TDButtonStatus.active),
                type: TDButtonType.outline,
              ),
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.danger,
                disabled: true,
                type: TDButtonType.outline,
              ),
            ],
          ),
        ),

        /// text
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.primary,
                type: TDButtonType.text,
              ),
              TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.primary,
                style: TDButtonStyle.generateTextStyleByTheme(context, TDButtonTheme.primary, TDButtonStatus.active),
                type: TDButtonType.text,
              ),
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.primary,
                disabled: true,
                type: TDButtonType.text,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.light,
                type: TDButtonType.text,
              ),
              TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.light,
                style: TDButtonStyle.generateTextStyleByTheme(context, TDButtonTheme.light, TDButtonStatus.active),
                type: TDButtonType.text,
              ),
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.light,
                disabled: true,
                type: TDButtonType.text,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.defaultTheme,
                type: TDButtonType.text,
              ),
              TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.defaultTheme,
                style:
                    TDButtonStyle.generateTextStyleByTheme(context, TDButtonTheme.defaultTheme, TDButtonStatus.active),
                type: TDButtonType.text,
              ),
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.defaultTheme,
                disabled: true,
                type: TDButtonType.text,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.danger,
                type: TDButtonType.text,
              ),
              TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.danger,
                style: TDButtonStyle.generateTextStyleByTheme(context, TDButtonTheme.danger, TDButtonStatus.active),
                type: TDButtonType.text,
              ),
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.danger,
                disabled: true,
                type: TDButtonType.text,
              ),
            ],
          ),
        ),

        /// ghost
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          color: Colors.black,
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.primary,
                type: TDButtonType.ghost,
              ),
              TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.primary,
                style: TDButtonStyle.generateGhostStyleByTheme(context, TDButtonTheme.primary, TDButtonStatus.active),
                type: TDButtonType.ghost,
              ),
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.primary,
                disabled: true,
                type: TDButtonType.ghost,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          color: Colors.black,
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.light,
                type: TDButtonType.ghost,
              ),
              TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.light,
                style: TDButtonStyle.generateGhostStyleByTheme(context, TDButtonTheme.light, TDButtonStatus.active),
                type: TDButtonType.ghost,
              ),
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.light,
                disabled: true,
                type: TDButtonType.ghost,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          color: Colors.black,
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.defaultTheme,
                type: TDButtonType.ghost,
              ),
              TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.defaultTheme,
                style:
                    TDButtonStyle.generateGhostStyleByTheme(context, TDButtonTheme.defaultTheme, TDButtonStatus.active),
                type: TDButtonType.ghost,
              ),
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.defaultTheme,
                disabled: true,
                type: TDButtonType.ghost,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          color: Colors.black,
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.danger,
                type: TDButtonType.ghost,
              ),
              TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.danger,
                style: TDButtonStyle.generateGhostStyleByTheme(context, TDButtonTheme.danger, TDButtonStatus.active),
                type: TDButtonType.ghost,
              ),
              const TDButton(
                icon: TDIcons.app,
                text: 'Button',
                theme: TDButtonTheme.danger,
                disabled: true,
                type: TDButtonType.ghost,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
