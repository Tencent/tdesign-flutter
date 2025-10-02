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
  int num = 8;

  @override
  Widget build(BuildContext context) {
    var padding = const EdgeInsets.symmetric(horizontal: 16);

    return ExamplePage(
      title: tdTitle(),
      desc: '用于告知用户，该区域的状态变化或者待处理任务的数量。',
      exampleCodeGroup: 'badge',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
                desc: '红点徽标',
                ignoreCode: true,
                padding: padding,
                builder: (context) {
                  return Row(
                    spacing: 32,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CodeWrapper(builder: _buildRedPointMessageBadge),
                      CodeWrapper(builder: _buildRedPointIconBadge),
                      CodeWrapper(builder: _buildRedPointButtonBadge),
                    ],
                  );
                }),
            ExampleItem(
                desc: '数字徽标',
                ignoreCode: true,
                padding: padding,
                builder: (context) {
                  return Row(
                    spacing: 32,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CodeWrapper(builder: _buildMessageNumberBadge),
                      CodeWrapper(builder: _buildIconNumberBadge),
                      CodeWrapper(builder: _buildButtonNumberBadge),
                    ],
                  );
                }),
            ExampleItem(
                desc: '自定义徽标',
                ignoreCode: true,
                padding: padding,
                builder: (context) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 32,
                    children: [
                      CodeWrapper(builder: _buildCustomBadgeShowingNumber),
                      CodeWrapper(builder: _buildCustomBadgeShowingNumberZero),
                      CodeWrapper(
                          builder: _buildCustomBadgeWithoutShowingNumberZero),
                    ],
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
      ],
      test: [
        ExampleItem(
          ignoreCode: true,
          desc: '未超过上限',
          builder: _buildLessThanMaxCountBadge,
        ),
        ExampleItem(
          ignoreCode: true,
          desc: '超过上限',
          builder: _buildMoreThanMaxCountBadge,
        )
      ],
      floatingActionButton: TDFab(
          theme: TDFabTheme.primary,
          onClick: () {
            setState(() {
              num = num + 1;
            });
          }),
    );
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
      width: 56,
      height: 36,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          TDText('消息', font: TDTheme.of(context).fontBodyLarge),
          Positioned(
            child: TDBadge(TDBadgeType.message, count: num.toString()),
            left: 28,
            bottom: 18,
          )
        ],
      ),
    );
  }

  @Demo(group: 'badge')
  Widget _buildIconNumberBadge(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 36,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          const Icon(TDIcons.notification),
          Positioned(
            child: TDBadge(TDBadgeType.message, count: num.toString()),
            left: 18,
            bottom: 18,
          )
        ],
      ),
    );
  }

  @Demo(group: 'badge')
  Widget _buildButtonNumberBadge(BuildContext context) {
    return SizedBox(
      width: 86,
      height: 54,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          const TDButton(
            width: 80,
            height: 48,
            text: '按钮',
            size: TDButtonSize.large,
          ),
          Positioned(
            child: TDBadge(TDBadgeType.message, count: num.toString()),
            right: 0,
            top: 0,
          )
        ],
      ),
    );
  }

  @Demo(group: 'badge')
  Widget _buildCustomBadgeShowingNumber(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 56,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            child: const Icon(TDIcons.notification),
            decoration: BoxDecoration(
                color: TDTheme.of(context).bgColorComponent,
                borderRadius:
                    BorderRadius.circular(TDTheme.of(context).radiusDefault)),
            height: 48,
            width: 48,
          ),
          Positioned(
            child: TDBadge(TDBadgeType.message, count: num.toString()),
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
                color: TDTheme.of(context).bgColorComponent,
                borderRadius:
                    BorderRadius.circular(TDTheme.of(context).radiusDefault)),
            height: 48,
            width: 48,
          ),
          const Positioned(
            child: TDBadge(TDBadgeType.message, count: '0'),
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
                color: TDTheme.of(context).bgColorComponent,
                borderRadius:
                    BorderRadius.circular(TDTheme.of(context).radiusDefault)),
            height: 48,
            width: 48,
          ),
          const Positioned(
            // 不显示 0
            child: TDBadge(TDBadgeType.message, count: '0', showZero: false),
            right: 0,
            top: 0,
          )
        ],
      ),
    );
  }

  @Demo(group: 'badge')
  Widget _buildCircleBadge(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 34,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          const Icon(TDIcons.notification),
          Positioned(
            child: TDBadge(TDBadgeType.message, count: num.toString()),
            left: 18,
            bottom: 18,
          )
        ],
      ),
    );
  }

  @Demo(group: 'badge')
  Widget _buildSquareBadge(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 34,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          const Icon(TDIcons.notification),
          Positioned(
            child: TDBadge(
              TDBadgeType.square,
              border: TDBadgeBorder.small,
              count: num.toString(),
            ),
            left: 20,
            bottom: 18,
          )
        ],
      ),
    );
  }

  @Demo(group: 'badge')
  Widget _buildBubbleBadge(BuildContext context) {
    return SizedBox(
      width: 67,
      height: 56,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            child: const Icon(TDIcons.shop),
            decoration: BoxDecoration(
                color: TDTheme.of(context).bgColorComponent,
                borderRadius:
                    BorderRadius.circular(TDTheme.of(context).radiusDefault)),
            height: 48,
            width: 48,
          ),
          const Positioned(
            child: TDBadge(TDBadgeType.bubble, count: '领积分'),
            right: 0,
            top: 0,
          )
        ],
      ),
    );
  }

  @Demo(group: 'badge')
  Widget _buildSubscriptBadge(BuildContext context) {
    return const Stack(
      alignment: Alignment.topRight,
      children: [
        TDCell(title: '单行标题'),
        TDBadge(TDBadgeType.subscript, message: 'NEW'),
      ],
    );
  }

  @Demo(group: 'badge')
  Widget _buildLargeBadge(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 68,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          const TDAvatar(size: TDAvatarSize.large, type: TDAvatarType.icon),
          Positioned(
            child: TDBadge(TDBadgeType.message,
                size: TDBadgeSize.large, count: num.toString()),
            left: 48,
            bottom: 48,
          )
        ],
      ),
    );
  }

  @Demo(group: 'badge')
  Widget _buildMediumBadge(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 54,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          const TDAvatar(size: TDAvatarSize.medium, type: TDAvatarType.icon),
          Positioned(
            child: TDBadge(TDBadgeType.message, count: num.toString()),
            left: 36,
            bottom: 36,
          )
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
          Positioned(left: 0, bottom: 0, child: Icon(TDIcons.notification)),
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
