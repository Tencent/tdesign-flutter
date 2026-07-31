import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

class TSkeletonPage extends StatelessWidget {
  const TSkeletonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tTitle(context),
        desc: '当网络较慢时，在页面真实数据加载之前，给用户展示出页面的大致结构。',
        exampleCodeGroup: 'skeleton',
        children: [
          ExampleModule(
            title: '类型',
            children: [
              ExampleItem(
                desc: '头像骨架屏',
                builder: _wrapper(_buildAvatarSkeleton),
                methodName: '_buildAvatarSkeleton',
              ),
              ExampleItem(
                desc: '图片骨架屏',
                builder: _wrapper(_buildImageSkeleton),
                methodName: '_buildImageSkeleton',
              ),
              ExampleItem(
                desc: '文本骨架屏',
                builder: _wrapper(_buildTextSkeleton, isFlexible: true),
                methodName: '_buildTextSkeleton',
              ),
              ExampleItem(
                desc: '段落骨架屏',
                builder: _wrapper(_buildParagraphSkeleton, isFlexible: true),
                methodName: '_buildParagraphSkeleton',
              ),
              ExampleItem(
                desc: '单元格骨架屏',
                builder: _wrapper(_buildCellSkeleton),
                methodName: '_buildCellSkeleton',
              ),
              ExampleItem(
                desc: '宫格骨架屏',
                builder: _wrapper(_buildGridSkeleton),
                methodName: '_buildGridSkeleton',
              ),
              ExampleItem(
                desc: '图文组合骨架屏',
                builder: _wrapper(_buildCombineSkeleton),
                methodName: '_buildCombineSkeleton',
              ),
            ],
          ),
          ExampleModule(
            title: '组件动效',
            children: [
              ExampleItem(
                desc: '渐变加载效果',
                builder: _wrapper(_buildGradientSkeleton, isFlexible: true),
                methodName: '_buildGradientSkeleton',
              ),
              ExampleItem(
                desc: '闪烁加载效果',
                builder: _wrapper(_buildFlashedSkeleton, isFlexible: true),
                methodName: '_buildFlashedSkeleton',
              ),
            ],
          ),
        ]);
  }

  Widget Function(BuildContext) _wrapper(
    Function(BuildContext) builder, {
    bool isFlexible = false,
  }) =>
      (context) => Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(
              context.tTheme.spacer16,
              0,
              context.tTheme.spacer16,
              0,
            ),
            child: isFlexible
                ? Row(children: [Expanded(child: builder(context))])
                : builder(context),
          );

  @ExampleCode(group: 'skeleton')
  Widget _buildAvatarSkeleton(BuildContext context) {
    return const TSkeleton(variant: TSkeletonVariant.avatar);
  }

  @ExampleCode(group: 'skeleton')
  Widget _buildImageSkeleton(BuildContext context) {
    return const TSkeleton(variant: TSkeletonVariant.image);
  }

  @ExampleCode(group: 'skeleton')
  Widget _buildTextSkeleton(BuildContext context) {
    return const TSkeleton(variant: TSkeletonVariant.text);
  }

  @ExampleCode(group: 'skeleton')
  Widget _buildParagraphSkeleton(BuildContext context) {
    return const TSkeleton(variant: TSkeletonVariant.paragraph);
  }

  @ExampleCode(group: 'skeleton')
  Widget _buildCellSkeleton(BuildContext context) {
    return const Column(
      // spacing: 16,
      children: <Widget>[
        Row(
          // spacing: 12,
          children: <Widget>[
            TSkeleton(variant: TSkeletonVariant.avatar),
            SizedBox(width: 12),
            Expanded(
              child: TSkeleton.custom(
                layout: TSkeletonLayout(rows: [
                  [TSkeletonBlock.line(), TSkeletonBlock.spacer(flex: 1)],
                  [TSkeletonBlock.line()]
                ]),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          // spacing: 12,
          children: <Widget>[
            TSkeleton.custom(
              layout: TSkeletonLayout(rows: [
                [TSkeletonBlock.rectangle(width: 48, height: 48)]
              ]),
            ),
            SizedBox(width: 12),
            Expanded(
              child: TSkeleton.custom(
                layout: TSkeletonLayout(rows: [
                  [TSkeletonBlock.line(), TSkeletonBlock.spacer(flex: 1)],
                  [TSkeletonBlock.line()]
                ]),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @ExampleCode(group: 'skeleton')
  Widget _buildGridSkeleton(BuildContext context) {
    return Row(
      // spacing: 16,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        return const TSkeleton.custom(
          layout: TSkeletonLayout(rows: [
            [TSkeletonBlock.rectangle(width: 48, height: 48, flex: null)],
            [TSkeletonBlock.line(width: 48, flex: null)],
          ]),
        );
      }),
    );
  }

  @ExampleCode(group: 'skeleton')
  Widget _buildCombineSkeleton(BuildContext context) {
    Widget buildRowCols() {
      return Expanded(
        child: LayoutBuilder(
          builder: (context, constraints) => TSkeleton.custom(
            layout: TSkeletonLayout(
              rows: [
                [
                  TSkeletonBlock(
                    width: constraints.maxWidth,
                    height: constraints.maxWidth,
                    flex: null,
                    style: TSkeletonBlockStyle(
                      borderRadius: context.tTheme.radiusExtraLarge,
                    ),
                  ),
                ],
                [TSkeletonBlock.line(width: constraints.maxWidth)],
                const [
                  TSkeletonBlock.line(),
                  TSkeletonBlock.spacer(flex: 1),
                ],
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      // spacing: context.tTheme.spacer16,
      children: [
        buildRowCols(),
        SizedBox(width: context.tTheme.spacer16),
        buildRowCols(),
      ],
    );
  }

  @ExampleCode(group: 'skeleton')
  Widget _buildGradientSkeleton(BuildContext context) {
    return const TSkeleton(
      animation: TSkeletonAnimation.gradient,
      variant: TSkeletonVariant.paragraph,
    );
  }

  @ExampleCode(group: 'skeleton')
  Widget _buildFlashedSkeleton(BuildContext context) {
    return const TSkeleton(
      animation: TSkeletonAnimation.flashed,
      variant: TSkeletonVariant.paragraph,
    );
  }
}
