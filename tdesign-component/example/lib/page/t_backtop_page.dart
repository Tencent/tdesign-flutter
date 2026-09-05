import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TBackTopPage extends StatefulWidget {
  const TBackTopPage({Key? key}) : super(key: key);

  @override
  State<TBackTopPage> createState() => _TBackTopPageState();
}

class _TBackTopPageState extends State<TBackTopPage> {
  final ScrollController controller = ScrollController();

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
      compactDemo: true,
      showTestModule: false,
      floatingActionButton: TBackTop(
        key: const Key('backtop-demo-floating'),
        controller: controller,
        showText: true,
      ),
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '圆形返回顶部', builder: _buildCircleBackTop),
            ExampleItem(desc: '半圆形返回顶部', builder: _buildHalfCircleBackTop),
          ],
        ),
      ],
    );
  }

  @ExampleCode(group: 'backtop')
  Widget _buildCircleBackTop(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        TBackTop(onPressed: () {}),
        TBackTop(colorScheme: TBackTopColorScheme.dark, onPressed: () {}),
        TBackTop(showText: true, onPressed: () {}),
        TBackTop(
          showText: true,
          colorScheme: TBackTopColorScheme.dark,
          onPressed: () {},
        ),
      ],
    );
  }

  @ExampleCode(group: 'backtop')
  Widget _buildHalfCircleBackTop(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            TBackTop(shape: TBackTopShape.halfCircle, onPressed: () {}),
            TBackTop(
              shape: TBackTopShape.halfCircle,
              colorScheme: TBackTopColorScheme.dark,
              onPressed: () {},
            ),
            TBackTop(
              shape: TBackTopShape.halfCircle,
              showText: true,
              onPressed: () {},
            ),
            TBackTop(
              shape: TBackTopShape.halfCircle,
              showText: true,
              colorScheme: TBackTopColorScheme.dark,
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 16,
          runSpacing: 24,
          children: List.generate(
            8,
            (_) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 139,
                  height: 139,
                  decoration: BoxDecoration(
                    color: context.tTheme.bgColorComponent,
                    borderRadius: BorderRadius.circular(
                      context.tTheme.radiusExtraLarge,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 139,
                  height: 16,
                  decoration: BoxDecoration(
                    color: context.tTheme.bgColorComponent,
                    borderRadius: BorderRadius.circular(
                      context.tTheme.radiusSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
