import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../annotation/demo.dart';
import '../base/example_widget.dart';

///
/// TDPopup掩饰
///
class TDPopupPage extends StatefulWidget {
  const TDPopupPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TDPopupPageState();
  }
}

class TDPopupPageState extends State<TDPopupPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      padding: const EdgeInsets.only(top: 16),
      backgroundColor: Colors.white,
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
              return TDButton(
                text: '底部弹出层-带标题及操作',
                isBlock: true,
                theme: TDButtonTheme.primary,
                type: TDButtonType.outline,
                size: TDButtonSize.large,
                onTap: () {
                  Navigator.of(context).push(TDSlidePopupRoute(
                      modalBarrierColor: TDTheme.of(context).fontGyColor2,
                      slideTransitionFrom: SlideTransitionFrom.bottom,
                      builder: (context) {
                        return TDPopupBottomConfirmPanel(
                          title: '标题文字标题文字标题文字标题文字标题文字标题文字标题文字标题文字',
                          leftText: '点这里确认!',
                          leftTextColor: TDTheme.of(context).brandNormalColor,
                          leftClick: () {
                            TDToast.showText('确认', context: context);
                            Navigator.maybePop(context);
                          },
                          rightText: '关闭',
                          rightTextColor: TDTheme.of(context).errorNormalColor,
                          rightClick: () {
                            Navigator.maybePop(context);
                          },
                          child: Container(
                            height: 200,
                          ),
                        );
                      }));
                },
              );
            }),
        ExampleItem(
            desc: '带关闭超长文本',
            builder: (_) {
              return TDButton(
                text: '底部弹出层-带标题及操作',
                isBlock: true,
                theme: TDButtonTheme.primary,
                type: TDButtonType.outline,
                size: TDButtonSize.large,
                onTap: () {
                  Navigator.of(context).push(TDSlidePopupRoute(
                      modalBarrierColor: TDTheme.of(context).fontGyColor2,
                      slideTransitionFrom: SlideTransitionFrom.bottom,
                      builder: (context) {
                        return TDPopupBottomDisplayPanel(
                          title: '标题文字标题文字标题文字标题文字标题文字标题文字标题文字',
                          closeColor: TDTheme.of(context).errorNormalColor,
                          closeClick: () {
                            Navigator.maybePop(context);
                          },
                          child: Container(
                            height: 200,
                          ),
                        );
                      }));
                },
              );
            }),
        ExampleItem(
            desc: '修改圆角',
            builder: (_) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: TDButton(
                      text: '底部弹出层-修改圆角',
                      isBlock: true,
                      theme: TDButtonTheme.primary,
                      type: TDButtonType.outline,
                      size: TDButtonSize.large,
                      onTap: () {
                        Navigator.of(context).push(TDSlidePopupRoute(
                            modalBarrierColor: TDTheme.of(context).fontGyColor2,
                            slideTransitionFrom: SlideTransitionFrom.bottom,
                            builder: (context) {
                              return TDPopupBottomDisplayPanel(
                                title: '标题文字标题文字标题文字标题文字标题文字标题文字标题文字',
                                closeColor: TDTheme.of(context).errorNormalColor,
                                closeClick: () {
                                  Navigator.maybePop(context);
                                },
                                child: Container(
                                  height: 200,
                                ),
                                radius: 6,
                              );
                            }));
                      },
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.all(8),
                      child: TDButton(
                        text: '底部弹出层-修改圆角',
                        isBlock: true,
                        theme: TDButtonTheme.primary,
                        type: TDButtonType.outline,
                        size: TDButtonSize.large,
                        onTap: () {
                          Navigator.of(context).push(TDSlidePopupRoute(
                              modalBarrierColor: TDTheme.of(context).fontGyColor2,
                              slideTransitionFrom: SlideTransitionFrom.bottom,
                              builder: (context) {
                                return TDPopupBottomConfirmPanel(
                                  title: '标题文字标题文字标题文字标题文字标题文字标题文字标题文字',
                                  leftText: '点这里确认!',
                                  leftTextColor: TDTheme.of(context).brandNormalColor,
                                  leftClick: () {
                                    TDToast.showText('确认', context: context);
                                    Navigator.maybePop(context);
                                  },
                                  rightText: '关闭',
                                  rightTextColor: TDTheme.of(context).errorNormalColor,
                                  rightClick: () {
                                    Navigator.maybePop(context);
                                  },
                                  child: Container(
                                    height: 200,
                                  ),
                                  radius: 6,
                                );
                              }));
                        },
                      )),
                  Container(
                      margin: const EdgeInsets.all(8),
                      child: TDButton(
                        text: '居中弹出层-修改圆角',
                        isBlock: true,
                        theme: TDButtonTheme.primary,
                        type: TDButtonType.outline,
                        size: TDButtonSize.large,
                        onTap: () {
                          Navigator.of(context).push(TDSlidePopupRoute(
                              modalBarrierColor: TDTheme.of(context).fontGyColor2,
                              slideTransitionFrom: SlideTransitionFrom.center,
                              builder: (context) {
                                return TDPopupCenterPanel(
                                  closeColor: TDTheme.of(context).errorNormalColor,
                                  closeClick: () {
                                    Navigator.maybePop(context);
                                  },
                                  child: const SizedBox(
                                    height: 240,
                                    width: 240,
                                  ),
                                  radius: 6,
                                );
                              }));
                        },
                      )),
                  Container(
                      margin: const EdgeInsets.all(8),
                      child: TDButton(
                        text: '居中弹出层-底部关闭-修改圆角',
                        isBlock: true,
                        theme: TDButtonTheme.primary,
                        type: TDButtonType.outline,
                        size: TDButtonSize.large,
                        onTap: () {
                          Navigator.of(context).push(TDSlidePopupRoute(
                              modalBarrierColor: TDTheme.of(context).fontGyColor2,
                              slideTransitionFrom: SlideTransitionFrom.center,
                              builder: (context) {
                                return TDPopupCenterPanel(
                                  closeUnderBottom: true,
                                  closeClick: () {
                                    Navigator.maybePop(context);
                                  },
                                  child: const SizedBox(
                                    height: 240,
                                    width: 240,
                                  ),
                                  radius: 6,
                                );
                              }));
                        },
                      )),
                ],
              );
            }),
        ExampleItem(
          desc: '自定义位置',
          builder: (_) {
            return TDButton(
              text: '自定义位置',
              isBlock: true,
              theme: TDButtonTheme.primary,
              type: TDButtonType.outline,
              size: TDButtonSize.large,
              onTap: () {
                var renderBox = navBarkey.currentContext!.findRenderObject() as RenderBox;
                Navigator.of(context).push(
                  TDSlidePopupRoute(
                    modalBarrierColor: TDTheme.of(context).fontGyColor2,
                    slideTransitionFrom: SlideTransitionFrom.right,
                    modalTop: renderBox.size.height,
                    builder: (context) {
                      return Container(
                        color: Colors.white,
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
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: TDButton(
                      text: '底部弹出层-键盘弹默认遮挡',
                      isBlock: true,
                      theme: TDButtonTheme.primary,
                      type: TDButtonType.outline,
                      size: TDButtonSize.large,
                      onTap: () {
                        Navigator.of(context).push(TDSlidePopupRoute(
                            modalBarrierColor: TDTheme.of(context).fontGyColor2,
                            slideTransitionFrom: SlideTransitionFrom.bottom,
                            builder: (context) {
                              return TDPopupBottomDisplayPanel(
                                title: '标题文字标题文字标题文字标题文字标题文字标题文字标题文字',
                                closeColor: TDTheme.of(context).errorNormalColor,
                                closeClick: () {
                                  Navigator.maybePop(context);
                                },
                                child: Material(
                                  child: SizedBox(
                                    height: 100,
                                    child: TDInput(
                                      type: TDInputType.normal,
                                      leftLabel: '标签文字',
                                      hintText: '请输入文字',
                                      maxLength: 10,
                                      additionInfo: '最大输入10个字符',
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                                radius: 6,
                              );
                            }));
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: TDButton(
                      text: '底部弹出层-键盘弹出不遮挡',
                      isBlock: true,
                      theme: TDButtonTheme.primary,
                      type: TDButtonType.outline,
                      size: TDButtonSize.large,
                      onTap: () {
                        Navigator.of(context).push(TDSlidePopupRoute(
                            modalBarrierColor: TDTheme.of(context).fontGyColor2,
                            slideTransitionFrom: SlideTransitionFrom.bottom,
                            focusMove: true,
                            builder: (context) {
                              return TDPopupBottomDisplayPanel(
                                title: '标题文字标题文字标题文字标题文字标题文字标题文字标题文字',
                                closeColor: TDTheme.of(context).errorNormalColor,
                                closeClick: () {
                                  Navigator.maybePop(context);
                                },
                                child: Material(
                                  child: SizedBox(
                                    height: 100,
                                    child: TDInput(
                                      type: TDInputType.normal,
                                      leftLabel: '标签文字',
                                      hintText: '请输入文字',
                                      maxLength: 10,
                                      additionInfo: '最大输入10个字符',
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                                radius: 6,
                              );
                            }));
                      },
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.all(8),
                      child: TDButton(
                        text: '居中弹出层-键盘弹出不遮挡',
                        isBlock: true,
                        theme: TDButtonTheme.primary,
                        type: TDButtonType.outline,
                        size: TDButtonSize.large,
                        onTap: () {
                          Navigator.of(context).push(TDSlidePopupRoute(
                              modalBarrierColor: TDTheme.of(context).fontGyColor2,
                              slideTransitionFrom: SlideTransitionFrom.center,
                              focusMove: true,
                              builder: (context) {
                                return TDPopupCenterPanel(
                                  closeColor: TDTheme.of(context).errorNormalColor,
                                  closeClick: () {
                                    Navigator.maybePop(context);
                                  },
                                  child: Material(
                                    child: SizedBox(
                                      height: 340,
                                      child: Column(
                                        children: [
                                          TDInput(
                                            type: TDInputType.normal,
                                            leftLabel: '标签文字1',
                                            hintText: '请输入文字1',
                                            maxLength: 10,
                                            backgroundColor: Colors.white,
                                          ),
                                          TDInput(
                                            type: TDInputType.normal,
                                            leftLabel: '标签文字2',
                                            hintText: '请输入文字2',
                                            maxLength: 10,
                                            backgroundColor: Colors.white,
                                          ),
                                          TDInput(
                                            type: TDInputType.normal,
                                            leftLabel: '标签文字3',
                                            hintText: '请输入文字3',
                                            maxLength: 10,
                                            backgroundColor: Colors.white,
                                          ),
                                          TDInput(
                                            type: TDInputType.normal,
                                            leftLabel: '标签文字4',
                                            hintText: '请输入文字4',
                                            maxLength: 10,
                                            backgroundColor: Colors.white,
                                          ),
                                          TDInput(
                                            type: TDInputType.normal,
                                            leftLabel: '会被键盘遮挡的输入框1',
                                            hintText: '会被键盘遮挡小部分',
                                            maxLength: 10,
                                            backgroundColor: Colors.white,
                                          ),
                                          TDInput(
                                            type: TDInputType.normal,
                                            leftLabel: '会被键盘遮挡的输入框2',
                                            hintText: '会被键盘遮挡全遮挡',
                                            maxLength: 10,
                                            backgroundColor: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  radius: 6,
                                );
                              }));
                        },
                      ))
                ],
              );
            }),
        ExampleItem(
          desc: '可拖动全屏',
          builder: (_) {
            return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
            Container(
            margin: const EdgeInsets.all(8),
            child: TDButton(
              text: '可拖动全屏',
              isBlock: true,
              theme: TDButtonTheme.primary,
              type: TDButtonType.outline,
              size: TDButtonSize.large,
              onTap: () {

                Navigator.of(context).push(TDSlidePopupRoute(
                    modalBarrierColor: TDTheme.of(context).fontGyColor2,
                    slideTransitionFrom: SlideTransitionFrom.bottom,
                    builder: (context) {
                      return TDPopupBottomDisplayPanel(
                        title: '标题文字',
                        draggable: true,
                        closeColor: TDTheme.of(context).errorNormalColor,
                        closeClick: () {
                          Navigator.maybePop(context);
                        },
                        child: Container(
                          height: 20,
                        ),
                      );
                    }));
              },
            )),
                  Container(
                      margin: const EdgeInsets.all(8),
                      child: TDButton(
                        text: '可拖动全屏',
                        isBlock: true,
                        theme: TDButtonTheme.primary,
                        type: TDButtonType.outline,
                        size: TDButtonSize.large,
                        onTap: () {

                          Navigator.of(context).push(TDSlidePopupRoute(
                              modalBarrierColor: TDTheme.of(context).fontGyColor2,
                              slideTransitionFrom: SlideTransitionFrom.bottom,
                              builder: (context) {
                                return TDPopupBottomConfirmPanel(
                                  title: '标题文字',
                                  draggable: true,
                                  leftClick: () {
                                    Navigator.maybePop(context);
                                  },
                                  rightClick: () {
                                    TDToast.showText('确定', context: context);
                                    Navigator.maybePop(context);
                                  },
                                  child: Container(
                                    height: 20,
                                  ),
                                );
                              }));
                        },
                      )),
                ]);
          },
        ),
      ],
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromTop(BuildContext context) {
    return TDButton(
      text: '顶部弹出',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.top,
            open: () {
              print('open');
            },
            opened: () {
              print('opened');
            },
            builder: (context) {
              return Container(
                color: Colors.white,
                height: 240,
              );
            }));
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromLeft(BuildContext context) {
    return TDButton(
      text: '左侧弹出',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.left,
            builder: (context) {
              return Container(
                color: Colors.white,
                width: 280,
              );
            }));
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromCenter(BuildContext context) {
    return TDButton(
      text: '中间弹出',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.center,
            builder: (context) {
              return Container(
                color: Colors.white,
                width: 240,
                height: 240,
              );
            }));
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromBottom(BuildContext context) {
    return TDButton(
      text: '底部弹出',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.bottom,
            builder: (context) {
              return Container(
                color: Colors.white,
                height: 240,
              );
            }));
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromRight(BuildContext context) {
    return TDButton(
      text: '右侧弹出',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.right,
            builder: (context) {
              return Container(
                color: Colors.white,
                width: 280,
              );
            }));
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromBottomWithOperationAndTitle(BuildContext context) {
    return TDButton(
      text: '底部弹出层-带标题及操作',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.bottom,
            builder: (context) {
              return TDPopupBottomConfirmPanel(
                title: '标题文字',
                leftClick: () {
                  Navigator.maybePop(context);
                },
                rightClick: () {
                  TDToast.showText('确定', context: context);
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
  Widget _buildPopFromBottomWithOperation(BuildContext context) {
    return TDButton(
      text: '底部弹出层-带操作',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.bottom,
            builder: (context) {
              return TDPopupBottomConfirmPanel(
                leftClick: () {
                  Navigator.maybePop(context);
                },
                rightClick: () {
                  TDToast.showText('确定', context: context);
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
    return TDButton(
      text: '底部弹出层-带标题及关闭',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.bottom,
            builder: (context) {
              return TDPopupBottomDisplayPanel(
                title: '标题文字',
                closeClick: () {
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
  Widget _buildPopFromBottomWithCloseAndLeftTitle(BuildContext context) {
    return TDButton(
      text: '底部弹出层-带左边标题及关闭',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.bottom,
            builder: (context) {
              return TDPopupBottomDisplayPanel(
                title: '标题文字',
                titleLeft: true,
                closeClick: () {
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
  Widget _buildPopFromBottomWithClose(BuildContext context) {
    return TDButton(
      text: '底部弹出层-带关闭',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.bottom,
            builder: (context) {
              return TDPopupBottomDisplayPanel(
                closeClick: () {
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
  Widget _buildPopFromBottomWithTitle(BuildContext context) {
    return TDButton(
      text: '底部弹出层-仅标题',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.bottom,
            builder: (context) {
              return TDPopupBottomDisplayPanel(
                title: '标题文字',
                hideClose: true,
                // closeClick: () {
                //   Navigator.maybePop(context);
                // },
                child: Container(
                  height: 200,
                ),
              );
            }));
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromCenterWithClose(BuildContext context) {
    return TDButton(
      text: '居中弹出层-带关闭',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            isDismissible: false,
            slideTransitionFrom: SlideTransitionFrom.center,
            builder: (context) {
              return TDPopupCenterPanel(
                closeClick: () {
                  Navigator.maybePop(context);
                },
                child: const SizedBox(
                  width: 240,
                  height: 240,
                ),
              );
            }));
      },
    );
  }

  @Demo(group: 'popup')
  Widget _buildPopFromCenterWithUnderClose(BuildContext context) {
    return TDButton(
      text: '居中弹出层-关闭在下方',
      isBlock: true,
      theme: TDButtonTheme.primary,
      type: TDButtonType.outline,
      size: TDButtonSize.large,
      onTap: () {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            isDismissible: false,
            slideTransitionFrom: SlideTransitionFrom.center,
            builder: (context) {
              return TDPopupCenterPanel(
                closeUnderBottom: true,
                closeClick: () {
                  Navigator.maybePop(context);
                },
                child: const SizedBox(
                  width: 240,
                  height: 240,
                ),
              );
            }));
      },
    );
  }
}
