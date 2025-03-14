import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

class TDSkeletonPage extends StatefulWidget {
  const TDSkeletonPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDSkeletonPageState();
}

class _TDSkeletonPageState extends State<TDSkeletonPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tdTitle(),
        desc: '当网络较慢时，在页面真实数据加载之前，给用户展示出页面的大致结构。',
        exampleCodeGroup: 'skeleton',
        backgroundColor: TDTheme.of(context).whiteColor1,
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
              TDTheme.of(context).spacer16,
              0,
              TDTheme.of(context).spacer16,
              0,
            ),
            child: isFlexible
                ? Row(children: [builder(context)])
                : builder(context),
          );

  @Demo(group: 'skeleton')
  Widget _buildAvatarSkeleton(BuildContext context) {
    return TDSkeleton(theme: TDSkeletonTheme.avatar);
  }

  @Demo(group: 'skeleton')
  Widget _buildImageSkeleton(BuildContext context) {
    return TDSkeleton(theme: TDSkeletonTheme.image);
  }

  @Demo(group: 'skeleton')
  Widget _buildTextSkeleton(BuildContext context) {
    return TDSkeleton(theme: TDSkeletonTheme.text);
  }

  @Demo(group: 'skeleton')
  Widget _buildParagraphSkeleton(BuildContext context) {
    return TDSkeleton(theme: TDSkeletonTheme.paragraph);
  }

  @Demo(group: 'skeleton')
  Widget _buildCellSkeleton(BuildContext context) {
    var rowColsAvatar = TDSkeleton(theme: TDSkeletonTheme.avatar);
    var rowColsImage = TDSkeleton.fromRowCol(
      rowCol: TDSkeletonRowCol(objects: const [
        [TDSkeletonRowColObj.rect(width: 48, height: 48, flex: null)]
      ]),
    );
    var rowColsContent = TDSkeleton.fromRowCol(
      rowCol: TDSkeletonRowCol(
        objects: const [
          [TDSkeletonRowColObj(), TDSkeletonRowColObj.spacer(flex: 1)],
          [TDSkeletonRowColObj()]
        ],
      ),
    );

    return Column(
      children: [
        Row(
          children: [
            rowColsAvatar,
            const SizedBox(width: 12),
            rowColsContent,
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            rowColsImage,
            const SizedBox(width: 12),
            rowColsContent,
          ],
        ),
      ],
    );
  }

  @Demo(group: 'skeleton')
  Widget _buildGridSkeleton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < 5; i++)
          TDSkeleton.fromRowCol(
            rowCol: TDSkeletonRowCol(objects: const [
              [TDSkeletonRowColObj.rect(width: 48, height: 48, flex: null)],
              [TDSkeletonRowColObj.text(width: 48, flex: null)],
            ]),
          ),
      ],
    );
  }

  @Demo(group: 'skeleton')
  Widget _buildCombineSkeleton(BuildContext context) {
    var rowCols = Flexible(
        child: LayoutBuilder(
            builder: (context, constraints) => Row(children: [
                  TDSkeleton.fromRowCol(
                    rowCol: TDSkeletonRowCol(
                      objects: [
                        [
                          TDSkeletonRowColObj(
                              width: constraints.maxWidth*0.96,
                              height: constraints.maxWidth,
                              flex: null,
                              style: TDSkeletonRowColObjStyle(
                                  borderRadius: (context) =>
                                      TDTheme.of(context).radiusExtraLarge))
                        ],
                        [TDSkeletonRowColObj.text(
                          width: constraints.maxWidth*0.96,
                        )],
                        const [
                          TDSkeletonRowColObj.text(),
                          TDSkeletonRowColObj.spacer(flex: 1),
                        ],
                      ],
                    ),
                  )
                ])));

    return Row(
      children: [
        rowCols,
        SizedBox(width: TDTheme.of(context).spacer4),
        rowCols,
      ],
    );
  }

  @Demo(group: 'skeleton')
  Widget _buildGradientSkeleton(BuildContext context) {
    return TDSkeleton(
      animation: TDSkeletonAnimation.gradient,
      theme: TDSkeletonTheme.paragraph,
    );
  }

  @Demo(group: 'skeleton')
  Widget _buildFlashedSkeleton(BuildContext context) {
    return TDSkeleton(
      animation: TDSkeletonAnimation.flashed,
      theme: TDSkeletonTheme.paragraph,
    );
  }
}
