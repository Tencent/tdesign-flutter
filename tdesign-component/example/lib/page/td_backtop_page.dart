import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TDBackTopPage extends StatefulWidget {
  const TDBackTopPage({Key? key}) : super(key: key);

  @override
  State<TDBackTopPage> createState() => _TDBackTopPageState();
}

class _TDBackTopPageState extends State<TDBackTopPage> {
  ScrollController controller = ScrollController();
  bool showBackTop = false;
  TDBackTopStyle style = TDBackTopStyle.circle;
  TDBackTopTheme theme = TDBackTopTheme.light;

  @override
  void initState() {
    super.initState();
    controller.addListener(listenCallback);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        theme = Theme.of(context).brightness == Brightness.dark
            ? TDBackTopTheme.light
            : TDBackTopTheme.dark;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(listenCallback);
  }

  void listenCallback() {
    final shouldShow = controller.offset >= 100;
    if (shouldShow != showBackTop) {
      setState(() {
        showBackTop = shouldShow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        scrollController: controller,
        title: tdTitle(),
        desc: '用于当页面过长往下滑动时，帮助用户快速回到页面顶部。',
        exampleCodeGroup: 'backtop',
        floatingActionButton: Stack(
          clipBehavior: Clip.none,
          children: [
            Visibility(
                visible: showBackTop,
                child: style == TDBackTopStyle.halfCircle
                    ? Positioned(
                        right: -16,
                        bottom: 10,
                        child: TDBackTop(
                          controller: controller,
                          theme: theme,
                          showText: true,
                          style: style,
                        ))
                    : TDBackTop(
                        controller: controller,
                        theme: theme,
                        showText: true,
                        style: style,
                      )),
          ],
        ),
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(desc: '圆形返回顶部', builder: _buildCircleBackTop),
            ExampleItem(desc: '半圆形返回顶部', builder: _buildHalfCircleBackTop),
          ])
        ]);
  }

  @Demo(group: 'backtop')
  Widget _buildCircleBackTop(BuildContext context) {
    return getCustomButton(context, '圆形返回顶部', () {
      setState(() {
        showBackTop = true;
        if (controller.hasClients) {
          controller.jumpTo(500);
        }
        style = TDBackTopStyle.circle;
      });
    });
  }

  @Demo(group: 'backtop')
  Widget _buildHalfCircleBackTop(BuildContext context) {
    return Column(
      children: [
        getCustomButton(context, '半圆形返回顶部', () {
          setState(() {
            showBackTop = true;
            if (controller.hasClients) {
              controller.jumpTo(500);
            }
            style = TDBackTopStyle.halfCircle;
          });
        }),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
          child: Wrap(
            spacing: 16,
            runSpacing: 24,
            children: List.generate(6, (_) => getDemoBox(context)),
          ),
        )
      ],
    );
  }

  Widget getCustomButton(
      BuildContext context, String text, void Function() onTap) {
    return TDButton(
      text: text,
      isBlock: true,
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      shape: TDButtonShape.rectangle,
      theme: TDButtonTheme.primary,
      onTap: onTap,
    );
  }

  Widget getDemoBox(BuildContext context) {
    final theme = TDTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 163,
          height: 163,
          decoration: BoxDecoration(
              color: theme.bgColorContainer,
              borderRadius:
                  BorderRadius.circular(theme.radiusExtraLarge)),
        ),
        const SizedBox(height: 10),
        Container(
          width: 163,
          height: 16,
          decoration: BoxDecoration(
              color: theme.bgColorContainer,
              borderRadius:
                  BorderRadius.circular(theme.radiusSmall)),
        ),
        const SizedBox(height: 10),
        Container(
            width: 100,
            height: 16,
            decoration: BoxDecoration(
                color: theme.bgColorContainer,
                borderRadius:
                    BorderRadius.circular(theme.radiusSmall))),
      ],
    );
  }
}
