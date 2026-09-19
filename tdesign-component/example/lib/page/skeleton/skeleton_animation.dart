part of 'skeleton_page.dart';

extension _SkeletonAnimationModule on TSkeletonPage {
  ExampleModule get _skeletonAnimationModule => ExampleModule(
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
  );
}
