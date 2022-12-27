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
                            child: const TDButton(
                              content: '填充按钮',
                              size: TDButtonSize.large,
                              type: TDButtonType.fill,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.primary,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const TDButton(
                              content: '填充按钮',
                              size: TDButtonSize.large,
                              type: TDButtonType.fill,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.light,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const TDButton(
                              content: '填充按钮',
                              size: TDButtonSize.large,
                              type: TDButtonType.fill,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.defaultTheme,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const TDButton(
                              content: '描边按钮',
                              size: TDButtonSize.large,
                              type: TDButtonType.stroke,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.primary,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const TDButton(
                              content: '文字按钮',
                              size: TDButtonSize.large,
                              type: TDButtonType.text,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.primary,
                            ),
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
                            child: const TDButton(
                              content: '填充按钮',
                              icon: TDIcons.app,
                              size: TDButtonSize.large,
                              type: TDButtonType.fill,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.primary,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const TDButton(
                              icon: TDIcons.app,
                              size: TDButtonSize.large,
                              type: TDButtonType.fill,
                              shape: TDButtonShape.square,
                              theme: TDButtonTheme.primary,
                            ),
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
                              child: const TDButton(
                                content: '幽灵按钮',
                                size: TDButtonSize.large,
                                type: TDButtonType.ghost,
                                shape: TDButtonShape.rectangle,
                                theme: TDButtonTheme.primary,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              child: const TDButton(
                                content: '幽灵按钮',
                                size: TDButtonSize.large,
                                type: TDButtonType.ghost,
                                shape: TDButtonShape.rectangle,
                                theme: TDButtonTheme.danger,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              child: const TDButton(
                                content: '幽灵按钮',
                                size: TDButtonSize.large,
                                type: TDButtonType.ghost,
                                shape: TDButtonShape.rectangle,
                                theme: TDButtonTheme.defaultTheme,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ExampleItem(
                    desc: '组合按钮',
                    builder: (context) {
                      return Row(
                        children: const [
                          SizedBox(width: 16,),
                          Expanded(child: TDButton(
                            content: '填充按钮',
                            size: TDButtonSize.large,
                            type: TDButtonType.fill,
                            shape: TDButtonShape.rectangle,
                            theme: TDButtonTheme.light,
                          )),
                          SizedBox(width: 16,),
                          Expanded(child: TDButton(
                            content: '填充按钮',
                            size: TDButtonSize.large,
                            type: TDButtonType.fill,
                            shape: TDButtonShape.rectangle,
                            theme: TDButtonTheme.primary,
                          )),
                          SizedBox(width: 16,),
                        ],
                      );
                    }),
                ExampleItem(
                    desc: '通栏按钮',
                    builder: (context) {
                      return Wrap(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(16),
                            child: const TDButton(
                              content: '填充按钮',
                              icon: TDIcons.app,
                              size: TDButtonSize.large,
                              type: TDButtonType.fill,
                              shape: TDButtonShape.filled,
                              theme: TDButtonTheme.primary,
                            ),
                          ),
                        ],
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
                            child: const TDButton(
                              content: '填充按钮',
                              size: TDButtonSize.large,
                              type: TDButtonType.fill,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.primary,
                              disabled: true,
                            ),),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const TDButton(
                              content: '填充按钮',
                              size: TDButtonSize.large,
                              type: TDButtonType.fill,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.light,
                              disabled: true,
                            ),),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const TDButton(
                              content: '填充按钮',
                              size: TDButtonSize.large,
                              type: TDButtonType.fill,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.defaultTheme,
                              disabled: true,
                            ),),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const TDButton(
                              content: '描边按钮',
                              size: TDButtonSize.large,
                              type: TDButtonType.stroke,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.primary,
                              disabled: true,
                            ),),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const TDButton(
                              content: '文字按钮',
                              size: TDButtonSize.large,
                              type: TDButtonType.text,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.primary,
                              disabled: true,
                            ),),
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
                            child: const TDButton(
                              content: '大号按钮48',
                              size: TDButtonSize.large,
                              type: TDButtonType.fill,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.primary,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(16),
                            child: const TDButton(
                              content: '中号按钮40',
                              size: TDButtonSize.medium,
                              type: TDButtonType.fill,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.primary,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(16),
                            child: const TDButton(
                              content: '小号按钮32',
                              size: TDButtonSize.small,
                              type: TDButtonType.fill,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.primary,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(16),
                            child: const TDButton(
                              content: '极小按钮28',
                              size: TDButtonSize.extraSmall,
                              type: TDButtonType.fill,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.primary,
                            ),
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
                            child: const TDButton(
                              content: '填充按钮',
                              size: TDButtonSize.large,
                              type: TDButtonType.fill,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.primary,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const TDButton(
                              icon: TDIcons.app,
                              size: TDButtonSize.large,
                              type: TDButtonType.fill,
                              shape: TDButtonShape.square,
                              theme: TDButtonTheme.primary,
                            ),
                          ),
                          Container(
                            width: 200,
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const TDButton(
                              content: '填充按钮',
                              size: TDButtonSize.large,
                              type: TDButtonType.fill,
                              shape: TDButtonShape.round,
                              theme: TDButtonTheme.primary,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const TDButton(
                              icon: TDIcons.app,
                              size: TDButtonSize.large,
                              type: TDButtonType.fill,
                              shape: TDButtonShape.circle,
                              theme: TDButtonTheme.primary,
                            ),
                          ),
                          const TDButton(
                            content: '填充按钮',
                            size: TDButtonSize.large,
                            type: TDButtonType.fill,
                            shape: TDButtonShape.filled,
                            theme: TDButtonTheme.primary,
                          )
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
                            child: const TDButton(
                              content: '填充按钮',
                              size: TDButtonSize.large,
                              type: TDButtonType.fill,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.defaultTheme,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const TDButton(
                              content: '描边按钮',
                              size: TDButtonSize.large,
                              type: TDButtonType.stroke,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.defaultTheme,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const TDButton(
                              content: '文字按钮',
                              size: TDButtonSize.large,
                              type: TDButtonType.text,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.defaultTheme,
                            ),
                          ),

                          /// primary主题
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const TDButton(
                              content: '填充按钮',
                              size: TDButtonSize.large,
                              type: TDButtonType.fill,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.primary,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const TDButton(
                              content: '描边按钮',
                              size: TDButtonSize.large,
                              type: TDButtonType.stroke,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.primary,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const TDButton(
                              content: '文字按钮',
                              size: TDButtonSize.large,
                              type: TDButtonType.text,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.primary,
                            ),
                          ),

                          /// danger主题
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const TDButton(
                              content: '填充按钮',
                              size: TDButtonSize.large,
                              type: TDButtonType.fill,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.danger,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const TDButton(
                              content: '描边按钮',
                              size: TDButtonSize.large,
                              type: TDButtonType.stroke,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.danger,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const TDButton(
                              content: '文字按钮',
                              size: TDButtonSize.large,
                              type: TDButtonType.text,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.danger,
                            ),
                          ),

                          /// light主题
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const TDButton(
                              content: '填充按钮',
                              size: TDButtonSize.large,
                              type: TDButtonType.fill,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.light,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const TDButton(
                              content: '描边按钮',
                              size: TDButtonSize.large,
                              type: TDButtonType.stroke,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.light,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: const TDButton(
                              content: '文字按钮',
                              size: TDButtonSize.large,
                              type: TDButtonType.text,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.light,
                            ),
                          ),
                        ],
                      );
                    }),
              ]),
            ]));
  }



}
