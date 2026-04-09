import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../annotation/demo.dart';
import '../base/example_widget.dart';

///
/// TPopup演示
///
class TPopupPage extends StatelessWidget {
  const TPopupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(context),
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
            ExampleItem(builder: _buildPopFromBottomWithOperation),
            ExampleItem(builder: _buildPopFromBottomWithCloseAndTitle),
            ExampleItem(builder: _buildPopFromBottomWithCloseAndLeftTitle),
            ExampleItem(builder: _buildPopFromBottomWithClose),
            ExampleItem(builder: _buildPopFromBottomWithTitle),
            ExampleItem(builder: _buildPopFromCenterWithClose),
            ExampleItem(builder: _buildPopFromCenterWithUnderClose),
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
                  Navigator.of(context).push(
                    TSlidePopupRoute(
                      slideTransitionFrom: SlideTransitionFrom.bottom,
                      builder: (context) {
                        return TPopupBottomConfirmPanel(
                          title: '标题文字标题文字标题文字标题文字标题文字标题文字标题文字标题文字',
                          leftText: '点这里确认!',
                          leftTextColor: TTheme.of(context).brandNormalColor,
                          leftClick: () {
                            TToast.showText('确认', context: context);
                            Navigator.maybePop(context);
                          },
                          rightText: '关闭',
                          rightTextColor: TTheme.of(context).errorNormalColor,
                          rightClick: () => Navigator.maybePop(context),
                          child: Container(height: 200),
                        );
                      },
                    ),
                  );
                },
              );
            }),
        ExampleItem(
            desc: '带关闭超长文本',
            builder: (_) {
              return TButton(
                text: '底部弹出层-带标题及操作',
                isBlock: true,
                theme: TButtonTheme.primary,
                type: TButtonType.outline,
                size: TButtonSize.large,
                onTap: () {
                  Navigator.of(context).push(
                    TSlidePopupRoute(
                        slideTransitionFrom: SlideTransitionFrom.bottom,
                        builder: (context) {
                          return TPopupBottomDisplayPanel(
                            title: '标题文字标题文字标题文字标题文字标题文字标题文字标题文字',
                            closeColor: TTheme.of(context).errorNormalColor,
                            closeClick: () => Navigator.maybePop(context),
                            child: Container(height: 200),
                          );
                        }),
                  );
                },
              );
            }),
        ExampleItem(
            desc: '修改圆角',
            builder: (_) {
              return Column(
                // spacing: 16,
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
                      Navigator.of(context).push(
                        TSlidePopupRoute(
                            slideTransitionFrom: SlideTransitionFrom.bottom,
                            builder: (context) {
                              return TPopupBottomDisplayPanel(
                                title: '标题文字标题文字标题文字标题文字标题文字标题文字标题文字',
                                closeColor:
                                    TTheme.of(context).errorNormalColor,
                                closeClick: () => Navigator.maybePop(context),
                                child: Container(height: 200),
                                radius: 6,
                              );
                            }),
                      );
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
                      Navigator.of(context).push(
                        TSlidePopupRoute(
                            slideTransitionFrom: SlideTransitionFrom.bottom,
                            builder: (context) {
                              return TPopupBottomConfirmPanel(
                                title: '标题文字标题文字标题文字标题文字标题文字标题文字标题文字',
                                leftText: '点这里确认!',
                                leftTextColor:
                                    TTheme.of(context).brandNormalColor,
                                leftClick: () {
                                  TToast.showText('确认', context: context);
                                  Navigator.maybePop(context);
                                },
                                rightText: '关闭',
                                rightTextColor:
                                    TTheme.of(context).errorNormalColor,
                                rightClick: () => Navigator.maybePop(context),
                                child: Container(height: 200),
                                radius: 6,
                              );
                            }),
                      );
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
                      Navigator.of(context).push(
                        TSlidePopupRoute(
                            slideTransitionFrom: SlideTransitionFrom.center,
                            builder: (context) {
                              return TPopupCenterPanel(
                                closeColor:
                                    TTheme.of(context).errorNormalColor,
                                closeClick: () {
                                  Navigator.maybePop(context);
                                },
                                child: const SizedBox(height: 240, width: 240),
                                radius: 6,
                              );
                            }),
                      );
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
                      Navigator.of(context).push(
                        TSlidePopupRoute(
                            slideTransitionFrom: SlideTransitionFrom.center,
                            builder: (context) {
                              return TPopupCenterPanel(
                                closeUnderBottom: true,
                                closeClick: () {
                                  Navigator.maybePop(context);
                                },
                                child: const SizedBox(height: 240, width: 240),
                                radius: 6,
                              );
                            }),
                      );
                    },
                  ),
                ],
              );
            }),
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
                var renderBox =
                    navBarkey.currentContext!.findRenderObject() as RenderBox;
                Navigator.of(context).push(
                  TSlidePopupRoute(
                    slideTransitionFrom: SlideTransitionFrom.right,
                    modalTop: renderBox.size.height,
                    builder: (context) {
                      return Container(
                        color: TTheme.of(context).bgColorContainer,
                        width: 280,
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
        ExampleItem(
            desc: '弹出层包含输入框且不会被键盘遮挡',
            builder: (_) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // spacing: 16,
                children: [
                  TButton(
                    text: '底部弹出层-键盘弹出默认遮挡',
                    isBlock: true,
                    theme: TButtonTheme.primary,
                    type: TButtonType.outline,
                    size: TButtonSize.large,
                    onTap: () {
                      Navigator.of(context).push(
                        TSlidePopupRoute(
                            slideTransitionFrom: SlideTransitionFrom.bottom,
                            builder: (context) {
                              return TPopupBottomDisplayPanel(
                                title: '标题文字标题文字标题文字标题文字标题文字标题文字标题文字',
                                closeColor:
                                    TTheme.of(context).errorNormalColor,
                                closeClick: () => Navigator.maybePop(context),
                                child: Material(
                                  child: SizedBox(
                                    height: 100,
                                    child: TInput(
                                      type: TInputType.normal,
                                      leftLabel: '标签文字',
                                      hintText: '请输入文字',
                                      maxLength: 10,
                                      additionInfo: '最大输入10个字符',
                                    ),
                                  ),
                                ),
                                radius: 6,
                              );
                            }),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TButton(
                    text: '底部弹出层-键盘弹出不遮挡',
                    isBlock: true,
                    theme: TButtonTheme.primary,
                    type: TButtonType.outline,
                    size: TButtonSize.large,
                    onTap: () {
                      Navigator.of(context).push(
                        TSlidePopupRoute(
                            slideTransitionFrom: SlideTransitionFrom.bottom,
                            focusMove: true,
                            builder: (context) {
                              return TPopupBottomDisplayPanel(
                                title: '标题文字标题文字标题文字标题文字标题文字标题文字标题文字',
                                closeColor:
                                    TTheme.of(context).errorNormalColor,
                                closeClick: () {
                                  Navigator.maybePop(context);
                                },
                                child: Material(
                                  child: SizedBox(
                                    height: 100,
                                    child: TInput(
                                      type: TInputType.normal,
                                      leftLabel: '标签文字',
                                      hintText: '请输入文字',
                                      maxLength: 10,
                                      additionInfo: '最大输入10个字符',
                                    ),
                                  ),
                                ),
                                radius: 6,
                              );
                            }),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TButton(
                    text: '居中弹出层-键盘弹出不遮挡',
                    isBlock: true,
                    theme: TButtonTheme.primary,
                    type: TButtonType.outline,
                    size: TButtonSize.large,
                    onTap: () {
                      Navigator.of(context).push(
                        TSlidePopupRoute(
                            slideTransitionFrom: SlideTransitionFrom.center,
                            focusMove: true,
                            builder: (context) {
                              return TPopupCenterPanel(
                                closeColor:
                                    TTheme.of(context).errorNormalColor,
                                closeClick: () {
                                  Navigator.maybePop(context);
                                },
                                child: SizedBox(
                                  height: 348,
                                  child: Column(
                                    children: [
                                      TInput(
                                        type: TInputType.normal,
                                        leftLabel: '标签文字1',
                                        hintText: '请输入文字1',
                                        maxLength: 10,
                                      ),
                                      TInput(
                                        type: TInputType.normal,
                                        leftLabel: '标签文字2',
                                        hintText: '请输入文字2',
                                        maxLength: 10,
                                      ),
                                      TInput(
                                        type: TInputType.normal,
                                        leftLabel: '标签文字3',
                                        hintText: '请输入文字3',
                                        maxLength: 10,
                                      ),
                                      TInput(
                                        type: TInputType.normal,
                                        leftLabel: '标签文字4',
                                        hintText: '请输入文字4',
                                        maxLength: 10,
                                      ),
                                      TInput(
                                        type: TInputType.normal,
                                        leftLabel: '会被键盘遮挡的输入框1',
                                        hintText: '会被键盘遮挡小部分',
                                        maxLength: 10,
                                      ),
                                      TInput(
                                        type: TInputType.normal,
                                        leftLabel: '会被键盘遮挡的输入框2',
                                        hintText: '会被键盘遮挡全遮挡',
                                        maxLength: 10,
                                      )
                                    ],
                                  ),
                                ),
                                radius: 6,
                              );
                            }),
                      );
                    },
                  )
                ],
              );
            }),
        ExampleItem(
          /// todo fix 动画闪烁
          desc: '可拖动全屏',
          builder: (_) {
            return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // spacing: 16,
                children: [
                  TButton(
                    text: '可拖动全屏',
                    isBlock: true,
                    theme: TButtonTheme.primary,
                    type: TButtonType.outline,
                    size: TButtonSize.large,
                    onTap: () {
                      Navigator.of(context).push(
                        TSlidePopupRoute(
                            slideTransitionFrom: SlideTransitionFrom.bottom,
                            builder: (context) {
                              return TPopupBottomDisplayPanel(
                                title: '标题文字',
                                draggable: true,
                                closeColor:
                                    TTheme.of(context).errorNormalColor,
                                closeClick: () {
                                  Navigator.maybePop(context);
                                },
                                child: Container(height: 200),
                              );
                            }),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TButton(
                    text: '可拖动全屏-带标题及操作',
                    isBlock: true,
                    theme: TButtonTheme.primary,
                    type: TButtonType.outline,
                    size: TButtonSize.large,
                    onTap: () {
                      Navigator.of(context).push(
                        TSlidePopupRoute(
                            slideTransitionFrom: SlideTransitionFrom.bottom,
                            builder: (context) {
                              return TPopupBottomConfirmPanel(
                                title: '标题文字',
                                draggable: true,
                                leftClick: () {
                                  Navigator.maybePop(context);
                                },
                                rightClick: () {
                                  TToast.showText('确定', context: context);
                                  Navigator.maybePop(context);
                                },
                                child: Container(height: 200),
                              );
                            }),
                      );
                    },
                  ),
                ]);
          },
        ),
      ],
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromTop(BuildContext context) {
    return TButton(
      text: '顶部弹出',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        Navigator.of(context).push(
          TSlidePopupRoute(
              slideTransitionFrom: SlideTransitionFrom.top,
              open: () {
                print('open');
              },
              opened: () {
                print('opened');
              },
              builder: (context) {
                return Container(
                  color: TTheme.of(context).bgColorContainer,
                  height: 240,
                );
              }),
        );
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
        Navigator.of(context).push(
          TSlidePopupRoute(
              slideTransitionFrom: SlideTransitionFrom.left,
              builder: (context) {
                return Container(
                  color: TTheme.of(context).bgColorContainer,
                  width: 280,
                );
              }),
        );
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
        Navigator.of(context).push(
          TSlidePopupRoute(
              slideTransitionFrom: SlideTransitionFrom.center,
              builder: (context) {
                return Container(
                  decoration: BoxDecoration(
                    color: TTheme.of(context).bgColorContainer,
                    borderRadius:
                        BorderRadius.circular(TTheme.of(context).radiusLarge),
                  ),
                  width: 240,
                  height: 240,
                );
              }),
        );
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
        Navigator.of(context).push(
          TSlidePopupRoute(
              slideTransitionFrom: SlideTransitionFrom.bottom,
              builder: (context) {
                return Container(
                  color: TTheme.of(context).bgColorContainer,
                  height: 240,
                );
              }),
        );
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
        Navigator.of(context).push(
          TSlidePopupRoute(
              slideTransitionFrom: SlideTransitionFrom.right,
              builder: (context) {
                return Container(
                  color: TTheme.of(context).bgColorContainer,
                  width: 280,
                );
              }),
        );
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
        Navigator.of(context).push(
          TSlidePopupRoute(
            slideTransitionFrom: SlideTransitionFrom.bottom,
            builder: (context) {
              return TPopupBottomConfirmPanel(
                title: '标题文字',
                leftClick: () {
                  Navigator.maybePop(context);
                },
                rightClick: () {
                  TToast.showText('确定', context: context);
                  Navigator.maybePop(context);
                },
                child: Container(height: 200),
              );
            },
          ),
        );
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromBottomWithOperation(BuildContext context) {
    return TButton(
      text: '底部弹出层-带操作',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TSlidePopupRoute(
            modalBarrierColor: TTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.bottom,
            builder: (context) {
              return TPopupBottomConfirmPanel(
                leftClick: () {
                  Navigator.maybePop(context);
                },
                rightClick: () {
                  TToast.showText('确定', context: context);
                  Navigator.maybePop(context);
                },
                child: Container(
                  height: 200,
                ),
              );
            }));
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
        Navigator.of(context).push(
          TSlidePopupRoute(
              slideTransitionFrom: SlideTransitionFrom.bottom,
              builder: (context) {
                return TPopupBottomDisplayPanel(
                  title: '标题文字',
                  closeClick: () {
                    Navigator.maybePop(context);
                  },
                  child: Container(height: 200),
                );
              }),
        );
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromBottomWithCloseAndLeftTitle(BuildContext context) {
    return TButton(
      text: '底部弹出层-带左边标题及关闭',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        Navigator.of(context).push(
          TSlidePopupRoute(
              slideTransitionFrom: SlideTransitionFrom.bottom,
              builder: (context) {
                return TPopupBottomDisplayPanel(
                  title: '标题文字',
                  titleLeft: true,
                  closeClick: () {
                    Navigator.maybePop(context);
                  },
                  child: Container(height: 200),
                );
              }),
        );
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromBottomWithClose(BuildContext context) {
    return TButton(
      text: '底部弹出层-带关闭',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        Navigator.of(context).push(
          TSlidePopupRoute(
              slideTransitionFrom: SlideTransitionFrom.bottom,
              builder: (context) {
                return TPopupBottomDisplayPanel(
                  closeClick: () {
                    Navigator.maybePop(context);
                  },
                  child: Container(height: 200),
                );
              }),
        );
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromBottomWithTitle(BuildContext context) {
    return TButton(
      text: '底部弹出层-仅标题',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        Navigator.of(context).push(
          TSlidePopupRoute(
              slideTransitionFrom: SlideTransitionFrom.bottom,
              builder: (context) {
                return TPopupBottomDisplayPanel(
                  title: '标题文字',
                  hideClose: true,
                  // closeClick: () {
                  //   Navigator.maybePop(context);
                  // },
                  child: Container(height: 200),
                );
              }),
        );
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
        Navigator.of(context).push(
          TSlidePopupRoute(
              isDismissible: false,
              slideTransitionFrom: SlideTransitionFrom.center,
              builder: (context) {
                return TPopupCenterPanel(
                  closeClick: () {
                    Navigator.maybePop(context);
                  },
                  child: const SizedBox(width: 240, height: 240),
                );
              }),
        );
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromCenterWithUnderClose(BuildContext context) {
    return TButton(
      text: '居中弹出层-关闭在下方',
      isBlock: true,
      theme: TButtonTheme.primary,
      type: TButtonType.outline,
      size: TButtonSize.large,
      onTap: () {
        Navigator.of(context).push(
          TSlidePopupRoute(
              isDismissible: false,
              slideTransitionFrom: SlideTransitionFrom.center,
              builder: (context) {
                return TPopupCenterPanel(
                  closeUnderBottom: true,
                  closeClick: () {
                    Navigator.maybePop(context);
                  },
                  child: const SizedBox(width: 240, height: 240),
                );
              }),
        );
      },
    );
  }
}
