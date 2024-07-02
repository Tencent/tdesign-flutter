import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDBadgePage extends StatefulWidget {
  const TDBadgePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDBadgePageState();
}

class _TDBadgePageState extends State<TDBadgePage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tdTitle(),
        desc: '用于告知用户，该区域的状态变化或者待处理任务的数量。',
        exampleCodeGroup: 'badge',
        children: [
          ExampleModule(
            title: '组件类型',
            children: [
              ExampleItem(
                  ignoreCode: true,
                  desc: '红点徽标',
                  builder: (context) {
                    return Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.bottomLeft,
                            margin: const EdgeInsets.only(
                                top: 8, left: 16, right: 16, bottom: 8),
                            child: CodeWrapper(
                              builder: _buildRedPointMessageBadge,
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            margin: const EdgeInsets.only(
                                top: 8, left: 16, right: 16, bottom: 8),
                            child: CodeWrapper(
                              builder: _buildRedPointIconBadge,
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            margin: const EdgeInsets.only(
                                top: 8, left: 16, right: 16, bottom: 8),
                            child: CodeWrapper(
                              builder: _buildRedPointButtonBadge,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ExampleItem(
                  ignoreCode: true,
                  desc: '数字徽标',
                  builder: (context) {
                    return Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // 垂直方向上末端对齐
                        children: [
                          Container(
                            alignment: Alignment.bottomLeft,
                            margin: const EdgeInsets.only(
                                top: 8, left: 16, right: 16, bottom: 8),
                            child: CodeWrapper(
                              builder: _buildMessageNumberBadge,
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            margin: const EdgeInsets.only(
                                top: 8, left: 16, right: 16, bottom: 8),
                            child: CodeWrapper(
                              builder: _buildIconNumberBadge,
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            margin: const EdgeInsets.only(
                                top: 8, left: 16, right: 16, bottom: 8),
                            child: CodeWrapper(
                              builder: _buildButtonNumberBadge,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ExampleItem(
                  ignoreCode: true,
                  desc: '自定义徽标',
                  builder: (context) {
                    return Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // 垂直方向上末端对齐
                        children: [
                          Container(
                            alignment: Alignment.bottomLeft,
                            margin: const EdgeInsets.only(
                                top: 8, left: 16, right: 16, bottom: 8),
                            child: CodeWrapper(
                              builder: _buildCustomBadgeShowingNumberEight,
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            margin: const EdgeInsets.only(
                                top: 8, left: 16, right: 16, bottom: 8),
                            child: CodeWrapper(
                              builder: _buildCustomBadgeShowingNumberZero,
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            margin: const EdgeInsets.only(
                                top: 8, left: 16, right: 16, bottom: 8),
                            child: CodeWrapper(
                              builder:
                                  _buildCustomBadgeWithoutShowingNumberZero,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ],
          ),
          ExampleModule(
            title: '组件样式',
            children: [
              ExampleItem(desc: '圆形徽标', builder: _buildCircleBadge),
              ExampleItem(desc: '方形徽标', builder: _buildSquareBadge),
              ExampleItem(desc: '气泡徽标', builder: _buildBubbleBadge),
              ExampleItem(desc: '角标', builder: _buildSubscriptBadge),
            ],
          ),
          ExampleModule(
            title: '组件尺寸',
            children: [
              ExampleItem(desc: 'Large', builder: _buildLargeBadge),
              ExampleItem(desc: 'Medium', builder: _buildMediumBadge)
            ],
          ),
          ExampleModule(
            title: '最大数字上限',
            children: [
              ExampleItem(
                  ignoreCode: true,
                  desc: '未超过上限',
                  builder: (context) {
                    return Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.bottomLeft,
                            margin: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 8),
                            child: CodeWrapper(
                              builder: _buildLessThanMaxCountBadge,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ExampleItem(
                  ignoreCode: true,
                  desc: '超过上限',
                  builder: (context) {
                    return Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.bottomLeft,
                            margin: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 8),
                            child: CodeWrapper(
                              builder: _buildMoreThanMaxCountBadge,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ],
          )
        ]);
  }

  @Demo(group: 'badge')
  Widget _buildRedPointMessageBadge(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 24,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          TDText(
            '消息',
            font: TDTheme.of(context).fontBodyLarge,
          ),
          const Positioned(
            child: TDBadge(TDBadgeType.redPoint),
            right: 0,
            top: 0,
          )
        ],
      ),
    );
  }

  @Demo(group: 'badge')
  Widget _buildRedPointIconBadge(BuildContext context) {
    return const SizedBox(
      width: 27,
      height: 27,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Icon(TDIcons.notification),
          Positioned(
            child: TDBadge(TDBadgeType.redPoint),
            right: 0,
            top: 0,
          )
        ],
      ),
    );
  }

  @Demo(group: 'badge')
  Widget _buildRedPointButtonBadge(BuildContext context) {
    return const SizedBox(
      width: 83,
      height: 48,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          TDButton(
            width: 80,
            height: 48,
            text: '按钮',
            size: TDButtonSize.large,
            type: TDButtonType.fill,
          ),
          Positioned(
            child: TDBadge(TDBadgeType.redPoint),
            right: 0,
            top: 0,
          )
        ],
      ),
    );
  }

  @Demo(group: 'badge')
  Widget _buildMessageNumberBadge(BuildContext context) {
    return SizedBox(
      width: 54,
      height: 36,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          TDText(
            '消息',
            font: TDTheme.of(context).fontBodyLarge,
          ),
          const Positioned(
            child: TDBadge(
              TDBadgeType.message,
              count: '8',
            ),
            left: 28,
            bottom: 18,
          )
        ],
      ),
    );
  }

  @Demo(group: 'badge')
  Widget _buildIconNumberBadge(BuildContext context) {
    return const SizedBox(
      width: 42,
      height: 36,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Icon(TDIcons.notification),
          Positioned(
            child: TDBadge(
              TDBadgeType.message,
              count: '8',
            ),
            left: 18,
            bottom: 18,
          )
        ],
      ),
    );
  }

  @Demo(group: 'badge')
  Widget _buildButtonNumberBadge(BuildContext context) {
    return const SizedBox(
      width: 86,
      height: 54,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          TDButton(
            width: 80,
            height: 48,
            text: '按钮',
            size: TDButtonSize.large,
          ),
          Positioned(
            child: TDBadge(
              TDBadgeType.message,
              count: '8',
            ),
            right: 0,
            top: 0,
          )
        ],
      ),
    );
  }

  @Demo(group: 'badge')
  Widget _buildCustomBadgeShowingNumberEight(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 56,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            child: const Icon(TDIcons.notification),
            decoration: BoxDecoration(
                color: TDTheme.of(context).grayColor2,
                borderRadius:
                    BorderRadius.circular(TDTheme.of(context).radiusDefault)),
            height: 48,
            width: 48,
          ),
          const Positioned(
            child: TDBadge(
              TDBadgeType.message,
              count: '8',
            ),
            right: 0,
            top: 0,
          )
        ],
      ),
    );
  }

  @Demo(group: 'badge')
  Widget _buildCustomBadgeShowingNumberZero(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 56,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            child: const Icon(TDIcons.notification),
            decoration: BoxDecoration(
                color: TDTheme.of(context).grayColor2,
                borderRadius:
                    BorderRadius.circular(TDTheme.of(context).radiusDefault)),
            height: 48,
            width: 48,
          ),
          const Positioned(
            child: TDBadge(
              TDBadgeType.message,
              count: '0',
            ),
            right: 0,
            top: 0,
          )
        ],
      ),
    );
  }

  @Demo(group: 'badge')
  Widget _buildCustomBadgeWithoutShowingNumberZero(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 56,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            child: const Icon(TDIcons.notification),
            decoration: BoxDecoration(
                color: TDTheme.of(context).grayColor2,
                borderRadius:
                    BorderRadius.circular(TDTheme.of(context).radiusDefault)),
            height: 48,
            width: 48,
          ),
          const Positioned(
            child: TDBadge(
              TDBadgeType.message,
              count: '0',
              showZero: false,
            ),
            right: 0,
            top: 0,
          )
        ],
      ),
    );
  }

  @Demo(group: 'badge')
  Widget _buildCircleBadge(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 34,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Icon(TDIcons.notification),
                Positioned(
                  child: TDBadge(
                    TDBadgeType.message,
                    count: '16',
                  ),
                  left: 18,
                  bottom: 18,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @Demo(group: 'badge')
  Widget _buildSquareBadge(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 34,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Icon(TDIcons.notification),
                Positioned(
                  child: TDBadge(
                    TDBadgeType.square,
                    border: TDBadgeBorder.small,
                    count: '16',
                  ),
                  left: 20,
                  bottom: 18,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @Demo(group: 'badge')
  Widget _buildBubbleBadge(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          SizedBox(
            width: 67,
            height: 56,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Container(
                  child: const Icon(TDIcons.shop),
                  decoration: BoxDecoration(
                      color: TDTheme.of(context).grayColor2,
                      borderRadius: BorderRadius.circular(
                          TDTheme.of(context).radiusDefault)),
                  height: 48,
                  width: 48,
                ),
                const Positioned(
                  child: TDBadge(
                    TDBadgeType.bubble,
                    count: '领积分',
                  ),
                  right: 0,
                  top: 0,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @Demo(group: 'badge')
  Widget _buildSubscriptBadge(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 16),
          alignment: Alignment.centerLeft,
          child: TDText(
            '单行标题',
            textColor: TDTheme.of(context).fontGyColor1,
            font: TDTheme.of(context).fontBodyLarge,
          ),
          color: Colors.white,
          height: 48,
          width: MediaQuery.of(context).size.width,
        ),
        const TDBadge(
          TDBadgeType.subscript,
          message: 'NEW',
        ),
      ],
    );
  }

  @Demo(group: 'badge')
  Widget _buildLargeBadge(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          SizedBox(
            width: 68,
            height: 70,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                TDAvatar(
                  size: TDAvatarSize.large,
                  type: TDAvatarType.icon,
                ),
                Positioned(
                  child: TDBadge(
                    TDBadgeType.message,
                    size: TDBadgeSize.large,
                    count: '8',
                  ),
                  left: 48,
                  bottom: 48,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @Demo(group: 'badge')
  Widget _buildMediumBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      child: const Row(
        children: [
          SizedBox(
            width: 120,
            height: 54,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                TDAvatar(
                  size: TDAvatarSize.medium,
                  type: TDAvatarType.icon,
                ),
                Positioned(
                  child: TDBadge(
                    TDBadgeType.message,
                    count: '8',
                  ),
                  left: 36,
                  bottom: 36,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @Demo(group: 'badge')
  Widget _buildLessThanMaxCountBadge(BuildContext context) {
    return const SizedBox(
      width: 60,
      height: 50,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: Icon(TDIcons.notification),
          ),
          Positioned(
            child: TDBadge(
              TDBadgeType.square,
              count: '8888',
              maxCount: '9000',
              size: TDBadgeSize.large,
              border: TDBadgeBorder.large,
            ),
            left: 18,
            bottom: 18,
          ),
        ],
      ),
    );
  }

  @Demo(group: 'badge')
  Widget _buildMoreThanMaxCountBadge(BuildContext context) {
    return const SizedBox(
      width: 60,
      height: 50,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: Icon(TDIcons.notification),
          ),
          Positioned(
            child: TDBadge(
              TDBadgeType.square,
              count: '888',
              maxCount: '99',
              size: TDBadgeSize.large,
              border: TDBadgeBorder.large,
            ),
            left: 18,
            bottom: 18,
          ),
        ],
      ),
    );
  }
}
