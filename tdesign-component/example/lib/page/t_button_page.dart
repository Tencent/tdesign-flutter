import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

class TButtonPage extends StatefulWidget {
  const TButtonPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TButtonPageState();
}

class _TButtonPageState extends State<TButtonPage> {
  void onTap() {
    TToast.showText('点击了按钮', context: context);
  }

  void onLongPress() {
    TToast.showText('长按了按钮', context: context);
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
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
                  color: TTheme.of(context).grayColor14,
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
                color: TTheme.of(context).bgColorContainer,
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  // spacing: 16,
                  children: [
                    TButton(
                      isBlock: true,
                      text: '填充block按钮',
                      theme: TButtonTheme.primary,
                    ),
                    SizedBox(height: 16),
                    TButton(
                      isBlock: true,
                      text: '描边block按钮',
                      type: TButtonType.outline,
                      theme: TButtonTheme.primary,
                    ),
                    SizedBox(height: 16),
                    TButton(
                      isBlock: true,
                      text: '文字block按钮',
                      type: TButtonType.text,
                      theme: TButtonTheme.primary,
                    ),
                    SizedBox(height: 16),
                    TButton(
                      isBlock: true,
                      text: '幽灵block按钮',
                      type: TButtonType.ghost,
                      theme: TButtonTheme.primary,
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
              return TButton(
                text: '点击跳转',
                size: TButtonSize.large,
                shape: TButtonShape.rectangle,
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
  TButton _buildLightTextButton(BuildContext context) {
    return const TButton(
      text: '文字按钮',
      size: TButtonSize.large,
      type: TButtonType.text,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.light,
    );
  }

  @Demo(group: 'button')
  TButton _buildLightStrokeButton(BuildContext context) {
    return const TButton(
      text: '描边按钮',
      size: TButtonSize.large,
      type: TButtonType.outline,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.light,
    );
  }

  @Demo(group: 'button')
  TButton _buildDangerTextButton(BuildContext context) {
    return const TButton(
      text: '文字按钮',
      size: TButtonSize.large,
      type: TButtonType.text,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.danger,
    );
  }

  @Demo(group: 'button')
  TButton _buildDangerStrokeButton(BuildContext context) {
    return const TButton(
      text: '描边按钮',
      size: TButtonSize.large,
      type: TButtonType.outline,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.danger,
    );
  }

  @Demo(group: 'button')
  TButton _buildDangerFillButton(BuildContext context) {
    return const TButton(
      text: '填充按钮',
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.danger,
    );
  }

  @Demo(group: 'button')
  TButton _buildDefaultTextButton(BuildContext context) {
    return const TButton(
      text: '文字按钮',
      size: TButtonSize.large,
      type: TButtonType.text,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.defaultTheme,
    );
  }

  @Demo(group: 'button')
  TButton _buildDefaultStrokeButton(BuildContext context) {
    return const TButton(
      text: '描边按钮',
      size: TButtonSize.large,
      type: TButtonType.outline,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.defaultTheme,
    );
  }

  @Demo(group: 'button')
  TButton _buildFilledButton(BuildContext context) {
    return const TButton(
      text: '填充按钮',
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.filled,
      theme: TButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TButton _buildCircleButton(BuildContext context) {
    return const TButton(
      icon: TIcons.app,
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.circle,
      theme: TButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TButton _buildRoundButton(BuildContext context) {
    return const TButton(
      text: '填充按钮',
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.round,
      theme: TButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TButton _buildExtraSmallButton(BuildContext context) {
    return const TButton(
      text: '按钮28',
      size: TButtonSize.extraSmall,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TButton _buildSmallButton(BuildContext context) {
    return const TButton(
      text: '按钮32',
      size: TButtonSize.small,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TButton _buildMediumButton(BuildContext context) {
    return const TButton(
      text: '按钮40',
      size: TButtonSize.medium,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TButton _buildLargeButton(BuildContext context) {
    return const TButton(
      text: '按钮48',
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TButton _buildDisablePrimaryTextButton(BuildContext context) {
    return const TButton(
      text: '文字按钮',
      size: TButtonSize.large,
      type: TButtonType.text,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
      disabled: true,
    );
  }

  @Demo(group: 'button')
  TButton _buildDisablePrimaryStrokeButton(BuildContext context) {
    return const TButton(
      text: '描边按钮',
      size: TButtonSize.large,
      type: TButtonType.outline,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
      disabled: true,
    );
  }

  @Demo(group: 'button')
  TButton _buildDisableDefaultFillButton(BuildContext context) {
    return const TButton(
      text: '填充按钮',
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.defaultTheme,
      disabled: true,
    );
  }

  @Demo(group: 'button')
  TButton _buildDisableLightFillButton(BuildContext context) {
    return const TButton(
      text: '填充按钮',
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.light,
      disabled: true,
    );
  }

  @Demo(group: 'button')
  TButton _buildDisablePrimaryFillButton(BuildContext context) {
    return const TButton(
      text: '填充按钮',
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
      disabled: true,
    );
  }

  @Demo(group: 'button')
  TButton _buildFilledFillButton(BuildContext context) {
    return const TButton(
      text: '填充按钮',
      icon: TIcons.app,
      size: TButtonSize.large,
      type: TButtonType.fill,
      theme: TButtonTheme.primary,
      isBlock: true,
    );
  }

  @Demo(group: 'button')
  TButton _buildDefaultGhostButton(BuildContext context) {
    return const TButton(
      text: '幽灵按钮',
      size: TButtonSize.large,
      type: TButtonType.ghost,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.defaultTheme,
    );
  }

  @Demo(group: 'button')
  TButton _buildDangerGhostButton(BuildContext context) {
    return const TButton(
      text: '幽灵按钮',
      size: TButtonSize.large,
      type: TButtonType.ghost,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.danger,
    );
  }

  @Demo(group: 'button')
  TButton _buildPrimaryGhostButton(BuildContext context) {
    return const TButton(
      text: '幽灵按钮',
      size: TButtonSize.large,
      type: TButtonType.ghost,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TButton _buildSquareIconButton(BuildContext context) {
    return const TButton(
      icon: TIcons.app,
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.square,
      theme: TButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TButton _buildLoadingIconButton(BuildContext context) {
    return TButton(
      text: '加载中',
      iconWidget: TLoading(
        size: TLoadingSize.small,
        icon: TLoadingIcon.circle,
        iconColor: TTheme.of(context).whiteColor1,
      ),
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TButton _buildRectangleIconButton(BuildContext context) {
    return const TButton(
      text: '填充按钮',
      icon: TIcons.app,
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TButton _buildPrimaryTextButton(BuildContext context) {
    return const TButton(
      text: '文字按钮',
      size: TButtonSize.large,
      type: TButtonType.text,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TButton _buildPrimaryStrokeButton(BuildContext context) {
    return const TButton(
      text: '描边按钮',
      size: TButtonSize.large,
      type: TButtonType.outline,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TButton _buildDefaultFillButton(BuildContext context) {
    return const TButton(
      text: '填充按钮',
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.defaultTheme,
    );
  }

  @Demo(group: 'button')
  @Demo(group: 'button')
  TButton _buildPrimaryFillButton(BuildContext context) {
    return const TButton(
      text: '填充按钮',
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TButton _buildLightFillButton(BuildContext context) {
    return const TButton(
      text: '填充按钮',
      size: TButtonSize.large,
      type: TButtonType.fill,
      shape: TButtonShape.rectangle,
      theme: TButtonTheme.light,
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
              child: TButton(
                text: '填充按钮',
                size: TButtonSize.large,
                type: TButtonType.fill,
                shape: TButtonShape.rectangle,
                theme: TButtonTheme.light,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: TButton(
                text: '填充按钮',
                size: TButtonSize.large,
                type: TButtonType.fill,
                shape: TButtonShape.rectangle,
                theme: TButtonTheme.primary,
              ),
            ),
          ],
        ));
  }

  @Demo(group: 'button')
  Widget _buildChildTestButton(BuildContext context) {
    return TButton(
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
        TButton(
          text: '填充按钮',
          icon: TIcons.app,
          size: TButtonSize.large,
          type: TButtonType.fill,
          shape: TButtonShape.rectangle,
          theme: TButtonTheme.primary,
          iconPosition: TButtonIconPosition.right,
        ),
        TButton(
          icon: TIcons.app,
          size: TButtonSize.large,
          type: TButtonType.fill,
          shape: TButtonShape.rectangle,
          theme: TButtonTheme.primary,
          iconPosition: TButtonIconPosition.right,
        ),
        TButton(
          text: '间距20',
          icon: TIcons.app,
          size: TButtonSize.large,
          type: TButtonType.fill,
          shape: TButtonShape.rectangle,
          theme: TButtonTheme.primary,
          iconPosition: TButtonIconPosition.right,
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
        TButton(
          text: '填充按钮',
          icon: TIcons.app,
          size: TButtonSize.large,
          type: TButtonType.fill,
          shape: TButtonShape.rectangle,
          theme: TButtonTheme.primary,
          iconPosition: TButtonIconPosition.right,
          gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
        ),
        TButton(
          icon: TIcons.app,
          size: TButtonSize.large,
          type: TButtonType.fill,
          shape: TButtonShape.rectangle,
          theme: TButtonTheme.primary,
          iconPosition: TButtonIconPosition.right,
          gradient: LinearGradient(
              colors: [Colors.red, Colors.blue], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        TButton(
          text: '间距20',
          icon: TIcons.app,
          size: TButtonSize.large,
          type: TButtonType.fill,
          shape: TButtonShape.rectangle,
          theme: TButtonTheme.primary,
          iconPosition: TButtonIconPosition.right,
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
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.primary,
              ),
              TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.primary,
                style: TButtonStyle.generateFillStyleByTheme(context, TButtonTheme.primary, TButtonStatus.active),
              ),
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.primary,
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
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.light,
              ),
              TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.light,
                style: TButtonStyle.generateFillStyleByTheme(context, TButtonTheme.light, TButtonStatus.active),
              ),
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.light,
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
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.defaultTheme,
              ),
              TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.defaultTheme,
                style:
                    TButtonStyle.generateFillStyleByTheme(context, TButtonTheme.defaultTheme, TButtonStatus.active),
              ),
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.defaultTheme,
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
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.danger,
              ),
              TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.danger,
                style: TButtonStyle.generateFillStyleByTheme(context, TButtonTheme.danger, TButtonStatus.active),
              ),
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.danger,
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
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.primary,
                type: TButtonType.outline,
              ),
              TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.primary,
                style: TButtonStyle.generateOutlineStyleByTheme(context, TButtonTheme.primary, TButtonStatus.active),
                type: TButtonType.outline,
              ),
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.primary,
                disabled: true,
                type: TButtonType.outline,
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
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.light,
                type: TButtonType.outline,
              ),
              TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.light,
                style: TButtonStyle.generateOutlineStyleByTheme(context, TButtonTheme.light, TButtonStatus.active),
                type: TButtonType.outline,
              ),
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.light,
                disabled: true,
                type: TButtonType.outline,
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
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.defaultTheme,
                type: TButtonType.outline,
              ),
              TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.defaultTheme,
                style: TButtonStyle.generateOutlineStyleByTheme(
                    context, TButtonTheme.defaultTheme, TButtonStatus.active),
                type: TButtonType.outline,
              ),
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.defaultTheme,
                disabled: true,
                type: TButtonType.outline,
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
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.danger,
                type: TButtonType.outline,
              ),
              TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.danger,
                style: TButtonStyle.generateOutlineStyleByTheme(context, TButtonTheme.danger, TButtonStatus.active),
                type: TButtonType.outline,
              ),
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.danger,
                disabled: true,
                type: TButtonType.outline,
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
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.primary,
                type: TButtonType.text,
              ),
              TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.primary,
                style: TButtonStyle.generateTextStyleByTheme(context, TButtonTheme.primary, TButtonStatus.active),
                type: TButtonType.text,
              ),
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.primary,
                disabled: true,
                type: TButtonType.text,
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
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.light,
                type: TButtonType.text,
              ),
              TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.light,
                style: TButtonStyle.generateTextStyleByTheme(context, TButtonTheme.light, TButtonStatus.active),
                type: TButtonType.text,
              ),
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.light,
                disabled: true,
                type: TButtonType.text,
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
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.defaultTheme,
                type: TButtonType.text,
              ),
              TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.defaultTheme,
                style:
                    TButtonStyle.generateTextStyleByTheme(context, TButtonTheme.defaultTheme, TButtonStatus.active),
                type: TButtonType.text,
              ),
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.defaultTheme,
                disabled: true,
                type: TButtonType.text,
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
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.danger,
                type: TButtonType.text,
              ),
              TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.danger,
                style: TButtonStyle.generateTextStyleByTheme(context, TButtonTheme.danger, TButtonStatus.active),
                type: TButtonType.text,
              ),
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.danger,
                disabled: true,
                type: TButtonType.text,
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
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.primary,
                type: TButtonType.ghost,
              ),
              TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.primary,
                style: TButtonStyle.generateGhostStyleByTheme(context, TButtonTheme.primary, TButtonStatus.active),
                type: TButtonType.ghost,
              ),
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.primary,
                disabled: true,
                type: TButtonType.ghost,
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
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.light,
                type: TButtonType.ghost,
              ),
              TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.light,
                style: TButtonStyle.generateGhostStyleByTheme(context, TButtonTheme.light, TButtonStatus.active),
                type: TButtonType.ghost,
              ),
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.light,
                disabled: true,
                type: TButtonType.ghost,
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
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.defaultTheme,
                type: TButtonType.ghost,
              ),
              TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.defaultTheme,
                style:
                    TButtonStyle.generateGhostStyleByTheme(context, TButtonTheme.defaultTheme, TButtonStatus.active),
                type: TButtonType.ghost,
              ),
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.defaultTheme,
                disabled: true,
                type: TButtonType.ghost,
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
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.danger,
                type: TButtonType.ghost,
              ),
              TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.danger,
                style: TButtonStyle.generateGhostStyleByTheme(context, TButtonTheme.danger, TButtonStatus.active),
                type: TButtonType.ghost,
              ),
              const TButton(
                icon: TIcons.app,
                text: 'Button',
                theme: TButtonTheme.danger,
                disabled: true,
                type: TButtonType.ghost,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
