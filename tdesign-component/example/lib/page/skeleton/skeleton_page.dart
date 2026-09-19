import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

part 'skeleton_type.dart';
part 'skeleton_animation.dart';

class TSkeletonPage extends StatelessWidget {
  const TSkeletonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '用于等待加载内容所展示的占位图形组合，有动态效果加载效果，减少用户等待焦虑。',
      exampleCodeGroup: 'skeleton',
      children: [_skeletonTypeModule, _skeletonAnimationModule],
    );
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
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            const TSkeleton(variant: TSkeletonVariant.avatar),
            SizedBox(width: context.tTheme.spacer12),
            const Expanded(
              child: TSkeleton.custom(
                layout: TSkeletonLayout(
                  rows: [
                    [TSkeletonBlock.line(), TSkeletonBlock.spacer(flex: 1)],
                    [TSkeletonBlock.line()],
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: context.tTheme.spacer16),
        Row(
          children: <Widget>[
            TSkeleton.custom(
              layout: TSkeletonLayout(
                rows: [
                  [
                    TSkeletonBlock(
                      width: 48,
                      height: 48,
                      style: TSkeletonBlockStyle(
                        borderRadius: context.tTheme.radiusDefault,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: context.tTheme.spacer12),
            const Expanded(
              child: TSkeleton.custom(
                layout: TSkeletonLayout(
                  rows: [
                    [TSkeletonBlock.line(), TSkeletonBlock.spacer(flex: 1)],
                    [TSkeletonBlock.line()],
                  ],
                ),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        return TSkeleton.custom(
          layout: TSkeletonLayout(
            rows: [
              [
                TSkeletonBlock(
                  width: 48,
                  height: 48,
                  flex: null,
                  style: TSkeletonBlockStyle(
                    borderRadius: context.tTheme.radiusDefault,
                  ),
                ),
              ],
              const [TSkeletonBlock.line(width: 48, flex: null)],
            ],
          ),
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
                const [TSkeletonBlock.line(), TSkeletonBlock.spacer(flex: 1)],
              ],
            ),
          ),
        ),
      );
    }

    return Row(
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
