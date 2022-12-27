import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';
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
    return Container(
        color: TDTheme.of(context).grayColor2,
        child: ExamplePage(
          title: '按钮 Button',
          desc: '用于开启一个闭环的操作任务，如“删除”对象、“购买”商品等。',
          exampleCodeGroup: 'button',
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          children: [
            ExampleModule(title: '组件类型', children: [
              ExampleItem(
                  desc: '基础按钮',
                  builder: (context) {
                    return Wrap(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildPrimaryFillButton(),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildLightFillButton(),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDefaultFillButton(),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildPrimaryStrokeButton(),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildPrimaryTextButton(),
                        ),
                      ],
                    );
                  }),
              ExampleItem(
                  desc: '图标按钮',
                  builder: (context) {
                    return Wrap(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildRectangleIconButton(),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildSquareIconButton(),
                        )
                      ],
                    );
                  }),
              ExampleItem(
                  desc: '幽灵按钮',
                  builder: (context) {
                    return Container(
                      color: TDTheme.of(context).grayColor14,
                      child: Wrap(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: _buildPrimaryGhostButton(),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: _buildDangerGhostButton(),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: _buildDefaultGhostButton(),
                          ),
                        ],
                      ),
                    );
                  }),
              ExampleItem(
                  desc: '组合按钮',
                  builder: _buildCombinationButtons),
              ExampleItem(
                  desc: '通栏按钮',
                  builder: (context) {
                    return Container(
                      margin: const EdgeInsets.all(16),
                      child: _buildFilledFillButton(),
                    );
                  }),
            ]),
            ExampleModule(title: '组件状态', children: [
              ExampleItem(
                  desc: '按钮禁用状态',
                  builder: (context) {
                    return Wrap(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDisablePrimaryFillButton(),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDisableLightFillButton(),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDisableDefaultFillButton(),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDisablePrimaryStrokeButton(),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDisablePrimaryTextButton(),
                        ),
                      ],
                    );
                  }),
            ]),
            ExampleModule(title: '组件主题', children: [
              ExampleItem(
                  desc: '按钮尺寸',
                  builder: (context) {
                    return Wrap(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(16),
                          child: _buildLargeButton(),
                        ),
                        Container(
                          margin: const EdgeInsets.all(16),
                          child: _buildMediumButton(),
                        ),
                        Container(
                          margin: const EdgeInsets.all(16),
                          child: _buildSmallButton(),
                        ),
                        Container(
                          margin: const EdgeInsets.all(16),
                          child: _buildExtraSmallButton(),
                        ),
                      ],
                    );
                  }),
              ExampleItem(
                  desc: '按钮形状',
                  builder: (context) {
                    return Wrap(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildPrimaryFillButton(),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildSquareIconButton(),
                        ),
                        Container(
                          width: 200,
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildRoundButton(),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildCircleButton(),
                        ),
                        _buildFilledButton()
                      ],
                    );
                  }),
              ExampleItem(
                  desc: '按钮主题',
                  builder: (context) {
                    return Wrap(
                      children: [
                        /// 默认主题
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDefaultFillButton(),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDefaultStrokeButton(),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDefaultTextButton(),
                        ),

                        /// primary主题
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildPrimaryFillButton(),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildPrimaryStrokeButton(),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildPrimaryTextButton(),
                        ),

                        /// danger主题
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDangerFillButton(),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDangerStrokeButton(),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildDangerTextButton(),
                        ),

                        /// light主题
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildLightFillButton(),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildLightStrokeButton(),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: _buildLightTextButton(),
                        ),
                      ],
                    );
                  }),
            ]),
          ],
          test: [
            ExampleItem(
                desc: '测试child',
                builder: (context) {
                  return const TDButton(
                    child: TDAvatar(),
                  );
                })
          ],
        ));
  }

  @Demo(group: 'button')
  TDButton _buildLightTextButton() {
    return const TDButton(
                          content: '文字按钮',
                          size: TDButtonSize.large,
                          type: TDButtonType.text,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.light,
                        );
  }

  @Demo(group: 'button')
  TDButton _buildLightStrokeButton() {
    return const TDButton(
                          content: '描边按钮',
                          size: TDButtonSize.large,
                          type: TDButtonType.stroke,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.light,
                        );
  }

  @Demo(group: 'button')
  TDButton _buildDangerTextButton() {
    return const TDButton(
                          content: '文字按钮',
                          size: TDButtonSize.large,
                          type: TDButtonType.text,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.danger,
                        );
  }

  @Demo(group: 'button')
  TDButton _buildDangerStrokeButton() {
    return const TDButton(
                          content: '描边按钮',
                          size: TDButtonSize.large,
                          type: TDButtonType.stroke,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.danger,
                        );
  }

  @Demo(group: 'button')
  TDButton _buildDangerFillButton() {
    return const TDButton(
                          content: '填充按钮',
                          size: TDButtonSize.large,
                          type: TDButtonType.fill,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.danger,
                        );
  }

  @Demo(group: 'button')
  TDButton _buildDefaultTextButton() {
    return const TDButton(
                          content: '文字按钮',
                          size: TDButtonSize.large,
                          type: TDButtonType.text,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.defaultTheme,
                        );
  }

  @Demo(group: 'button')
  TDButton _buildDefaultStrokeButton() {
    return const TDButton(
                          content: '描边按钮',
                          size: TDButtonSize.large,
                          type: TDButtonType.stroke,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.defaultTheme,
                        );
  }

  @Demo(group: 'button')
  TDButton _buildFilledButton() {
    return const TDButton(
                        content: '填充按钮',
                        size: TDButtonSize.large,
                        type: TDButtonType.fill,
                        shape: TDButtonShape.filled,
                        theme: TDButtonTheme.primary,
                      );
  }

  @Demo(group: 'button')
  TDButton _buildCircleButton() {
    return const TDButton(
                          icon: TDIcons.app,
                          size: TDButtonSize.large,
                          type: TDButtonType.fill,
                          shape: TDButtonShape.circle,
                          theme: TDButtonTheme.primary,
                        );
  }

  @Demo(group: 'button')
  TDButton _buildRoundButton() {
    return const TDButton(
                          content: '填充按钮',
                          size: TDButtonSize.large,
                          type: TDButtonType.fill,
                          shape: TDButtonShape.round,
                          theme: TDButtonTheme.primary,
                        );
  }

  @Demo(group: 'button')
  TDButton _buildExtraSmallButton() {
    return const TDButton(
                          content: '极小按钮28',
                          size: TDButtonSize.extraSmall,
                          type: TDButtonType.fill,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.primary,
                        );
  }

  @Demo(group: 'button')
  TDButton _buildSmallButton() {
    return const TDButton(
                          content: '小号按钮32',
                          size: TDButtonSize.small,
                          type: TDButtonType.fill,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.primary,
                        );
  }

  @Demo(group: 'button')
  TDButton _buildMediumButton() {
    return const TDButton(
                          content: '中号按钮40',
                          size: TDButtonSize.medium,
                          type: TDButtonType.fill,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.primary,
                        );
  }

  @Demo(group: 'button')
  TDButton _buildLargeButton() {
    return const TDButton(
                          content: '大号按钮48',
                          size: TDButtonSize.large,
                          type: TDButtonType.fill,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.primary,
                        );
  }

  @Demo(group: 'button')
  TDButton _buildDisablePrimaryTextButton() {
    return const TDButton(
                          content: '文字按钮',
                          size: TDButtonSize.large,
                          type: TDButtonType.text,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.primary,
                          disabled: true,
                        );
  }

  @Demo(group: 'button')
  TDButton _buildDisablePrimaryStrokeButton() {
    return const TDButton(
                          content: '描边按钮',
                          size: TDButtonSize.large,
                          type: TDButtonType.stroke,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.primary,
                          disabled: true,
                        );
  }

  @Demo(group: 'button')
  TDButton _buildDisableDefaultFillButton() {
    return const TDButton(
                          content: '填充按钮',
                          size: TDButtonSize.large,
                          type: TDButtonType.fill,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.defaultTheme,
                          disabled: true,
                        );
  }

  @Demo(group: 'button')
  TDButton _buildDisableLightFillButton() {
    return const TDButton(
                          content: '填充按钮',
                          size: TDButtonSize.large,
                          type: TDButtonType.fill,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.light,
                          disabled: true,
                        );
  }

  @Demo(group: 'button')
  TDButton _buildDisablePrimaryFillButton() {
    return const TDButton(
                          content: '填充按钮',
                          size: TDButtonSize.large,
                          type: TDButtonType.fill,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.primary,
                          disabled: true,
                        );
  }

  @Demo(group: 'button')
  TDButton _buildFilledFillButton() {
    return const TDButton(
                      content: '填充按钮',
                      icon: TDIcons.app,
                      size: TDButtonSize.large,
                      type: TDButtonType.fill,
                      shape: TDButtonShape.filled,
                      theme: TDButtonTheme.primary,
                    );
  }

  @Demo(group: 'button')
  TDButton _buildDefaultGhostButton() {
    return const TDButton(
                            content: '幽灵按钮',
                            size: TDButtonSize.large,
                            type: TDButtonType.ghost,
                            shape: TDButtonShape.rectangle,
                            theme: TDButtonTheme.defaultTheme,
                          );
  }

  @Demo(group: 'button')
  TDButton _buildDangerGhostButton() {
    return const TDButton(
                            content: '幽灵按钮',
                            size: TDButtonSize.large,
                            type: TDButtonType.ghost,
                            shape: TDButtonShape.rectangle,
                            theme: TDButtonTheme.danger,
                          );
  }

  @Demo(group: 'button')
  TDButton _buildPrimaryGhostButton() {
    return const TDButton(
                            content: '幽灵按钮',
                            size: TDButtonSize.large,
                            type: TDButtonType.ghost,
                            shape: TDButtonShape.rectangle,
                            theme: TDButtonTheme.primary,
                          );
  }

  @Demo(group: 'button')
  TDButton _buildSquareIconButton() {
    return const TDButton(
                          icon: TDIcons.app,
                          size: TDButtonSize.large,
                          type: TDButtonType.fill,
                          shape: TDButtonShape.square,
                          theme: TDButtonTheme.primary,
                        );
  }

  @Demo(group: 'button')
  TDButton _buildRectangleIconButton() {
    return const TDButton(
                          content: '填充按钮',
                          icon: TDIcons.app,
                          size: TDButtonSize.large,
                          type: TDButtonType.fill,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.primary,
                        );
  }

  @Demo(group: 'button')
  TDButton _buildPrimaryTextButton() {
    return const TDButton(
                          content: '文字按钮',
                          size: TDButtonSize.large,
                          type: TDButtonType.text,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.primary,
                        );
  }

  @Demo(group: 'button')
  TDButton _buildPrimaryStrokeButton() {
    return const TDButton(
                          content: '描边按钮',
                          size: TDButtonSize.large,
                          type: TDButtonType.stroke,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.primary,
                        );
  }

  @Demo(group: 'button')
  TDButton _buildDefaultFillButton() {
    return const TDButton(
                          content: '填充按钮',
                          size: TDButtonSize.large,
                          type: TDButtonType.fill,
                          shape: TDButtonShape.rectangle,
                          theme: TDButtonTheme.defaultTheme,
                        );
  }

  @Demo(group: 'button')
  @Demo(group: 'button')
  TDButton _buildPrimaryFillButton() {
    return const TDButton(
      content: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
    );
  }

  @Demo(group: 'button')
  TDButton _buildLightFillButton() {
    return const TDButton(
      content: '填充按钮',
      size: TDButtonSize.large,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.light,
    );
  }

  @Demo(group: 'button')
  Widget _buildCombinationButtons(BuildContext context) {
    return Row(
      children: const [
        SizedBox(
          width: 16,
        ),
        Expanded(
            child: TDButton(
              content: '填充按钮',
              size: TDButtonSize.large,
              type: TDButtonType.fill,
              shape: TDButtonShape.rectangle,
              theme: TDButtonTheme.light,
            )),
        SizedBox(
          width: 16,
        ),
        Expanded(
            child: TDButton(
              content: '填充按钮',
              size: TDButtonSize.large,
              type: TDButtonType.fill,
              shape: TDButtonShape.rectangle,
              theme: TDButtonTheme.primary,
            )),
        SizedBox(
          width: 16,
        ),
      ],
    );
  }
}
