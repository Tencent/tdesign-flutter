import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TBadgePage extends StatefulWidget {
  const TBadgePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TBadgePageState();
}

class _TBadgePageState extends State<TBadgePage> {
  int num = 8;

  @override
  Widget build(BuildContext context) {
    var padding = const EdgeInsets.symmetric(horizontal: 16);

    return ExamplePage(
      title: tTitle(),
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
                    // spacing: 32,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CodeWrapper(builder: _buildRedPointMessageBadge),
                      const SizedBox(width: 32),
                      CodeWrapper(builder: _buildRedPointIconBadge),
                      const SizedBox(width: 32),
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
                    // spacing: 32,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CodeWrapper(builder: _buildMessageNumberBadge),
                      const SizedBox(width: 32),
                      CodeWrapper(builder: _buildIconNumberBadge),
                      const SizedBox(width: 32),
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
                    // spacing: 32,
                    children: [
                      CodeWrapper(builder: _buildCustomBadgeShowingNumber),
                      const SizedBox(width: 32),
                      CodeWrapper(builder: _buildCustomBadgeShowingNumberZero),
                      const SizedBox(width: 32),
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
      // 注意：TFab 内部返回 Positioned widget，不能传给 Scaffold.floatingActionButton
      // （会导致布局异常和白色遮罩）。改用原生 FloatingActionButton。
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            num = num + 1;
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @Demo(group: 'badge')
  Widget _buildRedPointMessageBadge(BuildContext context) {
    return SizedBox(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomLeft,
        children: [
          TText(
            '消息',
            font: context.tTheme.fontBodyLarge,
          ),
          const Positioned(
            child: TBadge(variant: TBadgeVariant.dot),
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
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomLeft,
        children: [
          Icon(TIcons.notification),
          Positioned(
            child: TBadge(variant: TBadgeVariant.dot),
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
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomLeft,
        children: [
          SizedBox(
            child: TButton(
              child: Text('按钮'),
              size: TButtonSize.large,
              variant: TButtonVariant.fill,
            ),
          ),
          Positioned(
            child: TBadge(variant: TBadgeVariant.dot),
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
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomLeft,
        children: [
          TText('消息', font: context.tTheme.fontBodyLarge),
          Positioned(
            child: TBadge(count: num),
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
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomLeft,
        children: [
          const Icon(TIcons.notification),
          Positioned(
            child: TBadge(count: num),
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
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomLeft,
        children: [
          const SizedBox(
            child: TButton(
              child: Text('按钮'),
              size: TButtonSize.large,
            ),
          ),
          Positioned(
            child: TBadge(count: num),
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
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            child: const Icon(TIcons.notification),
            decoration: BoxDecoration(
                color: context.tTheme.bgColorComponent,
                borderRadius:
                    BorderRadius.circular(context.tTheme.radiusDefault)),
          ),
          Positioned(
            child: TBadge(count: num),
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
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            child: const Icon(TIcons.notification),
            decoration: BoxDecoration(
                color: context.tTheme.bgColorComponent,
                borderRadius:
                    BorderRadius.circular(context.tTheme.radiusDefault)),
          ),
          const Positioned(
            child: TBadge(count: 0),
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
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            child: const Icon(TIcons.notification),
            decoration: BoxDecoration(
                color: context.tTheme.bgColorComponent,
                borderRadius:
                    BorderRadius.circular(context.tTheme.radiusDefault)),
          ),
          const Positioned(
            // 不显示 0
            child: TBadge(count: 0),
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
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomLeft,
        children: [
          const Icon(TIcons.notification),
          Positioned(
            child: TBadge(count: num),
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
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomLeft,
        children: [
          const Icon(TIcons.notification),
          Positioned(
            child: TBadge(count: num, border: true),
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
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            child: const Icon(TIcons.shop),
            decoration: BoxDecoration(
                color: context.tTheme.bgColorComponent,
                borderRadius:
                    BorderRadius.circular(context.tTheme.radiusDefault)),
          ),
          const Positioned(
            child: TBadge(count: 1, variant: TBadgeVariant.small),
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
      clipBehavior: Clip.none,
      alignment: Alignment.topRight,
      children: [
        TCell(title: Text('单行标题')),
        TBadge(variant: TBadgeVariant.dot),
      ],
    );
  }

  @Demo(group: 'badge')
  Widget _buildLargeBadge(BuildContext context) {
    return SizedBox(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomLeft,
        children: [
          const TAvatar(size: TAvatarSize.large),
          Positioned(
            child: TBadge(count: num),
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
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomLeft,
        children: [
          const TAvatar(size: TAvatarSize.medium),
          Positioned(
            child: TBadge(count: num),
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
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: Icon(TIcons.notification),
          ),
          Positioned(
            child: TBadge(count: 8888, maxCount: 9000),
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
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(left: 0, bottom: 0, child: Icon(TIcons.notification)),
          Positioned(
            child: TBadge(count: 888, maxCount: 99),
            left: 18,
            bottom: 18,
          ),
        ],
      ),
    );
  }
}
