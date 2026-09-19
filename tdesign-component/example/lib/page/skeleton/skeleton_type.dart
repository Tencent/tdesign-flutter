part of 'skeleton_page.dart';

extension _SkeletonTypeModule on TSkeletonPage {
  ExampleModule get _skeletonTypeModule => ExampleModule(
    title: '骨架屏类型',
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
  );
}
