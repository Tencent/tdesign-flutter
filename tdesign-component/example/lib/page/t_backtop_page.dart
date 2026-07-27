import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TBackTopPage extends StatefulWidget {
  const TBackTopPage({Key? key}) : super(key: key);

  @override
  State<TBackTopPage> createState() => _TBackTopPageState();
}

class _TBackTopPageState extends State<TBackTopPage> {
  final ScrollController controller = ScrollController();
  TBackTopShape shape = TBackTopShape.circle;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      scrollController: controller,
      title: tTitle(),
      desc: '用于当页面过长往下滑动时，帮助用户快速回到页面顶部。',
      exampleCodeGroup: 'backtop',
      floatingActionButton: shape == TBackTopShape.halfCircle
          ? Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: -16,
                  bottom: 10,
                  child: TBackTop(
                    controller: controller,
                    showText: true,
                    shape: shape,
                    visibilityOffset: 100,
                    onPressed: () {},
                  ),
                ),
              ],
            )
          : TBackTop(
              controller: controller,
              showText: true,
              shape: shape,
              visibilityOffset: 100,
              onPressed: () {},
            ),
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '圆形返回顶部', builder: _buildCircleBackTop),
          ExampleItem(desc: '半圆形返回顶部', builder: _buildHalfCircleBackTop),
        ]),
        ExampleModule(title: '滚动内容', children: [
          ExampleItem(desc: '自然滚动内容', builder: _buildScrollableContent),
        ])
      ],
    );
  }

  @Demo(group: 'backtop')
  Widget _buildCircleBackTop(BuildContext context) {
    return getCustomButton(
      context,
      '圆形返回顶部',
      () => _showBackTop(TBackTopShape.circle),
    );
  }

  @Demo(group: 'backtop')
  Widget _buildHalfCircleBackTop(BuildContext context) {
    return Column(
      children: [
        getCustomButton(
          context,
          '半圆形返回顶部',
          () => _showBackTop(TBackTopShape.halfCircle),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
          child: Wrap(
            spacing: 16,
            runSpacing: 24,
            children: List.generate(6, (_) => getDemoBox(context)),
          ),
        ),
      ],
    );
  }

  @Demo(group: 'backtop')
  Widget _buildScrollableContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 16,
        runSpacing: 24,
        children: List.generate(12, (_) => getDemoBox(context)),
      ),
    );
  }

  void _showBackTop(TBackTopShape nextShape) {
    setState(() {
      shape = nextShape;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !controller.hasClients) {
        return;
      }
      final position = controller.position;
      final targetOffset =
          position.maxScrollExtent >= 500 ? 500.0 : position.maxScrollExtent;
      if (targetOffset <= position.minScrollExtent) {
        return;
      }
      controller.jumpTo(targetOffset);
    });
  }

  Widget getCustomButton(
      BuildContext context, String text, void Function() onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: TButton(
          child: Text(text),
          size: TButtonSize.large,
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          onPressed: onTap,
        ),
      ),
    );
  }

  Widget getDemoBox(BuildContext context) {
    final theme = context.tTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 163,
          height: 163,
          decoration: BoxDecoration(
            color: theme.bgColorComponent,
            borderRadius: BorderRadius.circular(theme.radiusExtraLarge),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 163,
          height: 16,
          decoration: BoxDecoration(
            color: theme.bgColorComponent,
            borderRadius: BorderRadius.circular(theme.radiusSmall),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 100,
          height: 16,
          decoration: BoxDecoration(
            color: theme.bgColorComponent,
            borderRadius: BorderRadius.circular(theme.radiusSmall),
          ),
        ),
      ],
    );
  }
}
