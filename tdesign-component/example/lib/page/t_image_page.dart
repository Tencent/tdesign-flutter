import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TImagePage extends StatefulWidget {
  const TImagePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TImageState();
}

class TImageState extends State<TImagePage>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    animation = Tween(begin: 0.0, end: 4.0).animate(animationController);
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      exampleCodeGroup: 'image',
      desc: '用于展示效果，主要为上下左右居中裁切、拉伸、平铺等方式。',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
                ignoreCode: true,
                desc: '',
                builder: (context) {
                  return Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 8),
                    child: Wrap(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: CodeWrapper(
                            builder: _imageClip,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: CodeWrapper(
                            builder: _imageStretch,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ExampleItem(
                ignoreCode: true,
                desc: '',
                builder: (context) {
                  return Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 8),
                    child: Wrap(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: CodeWrapper(
                            builder: _imageFitHeight,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8), // 适应宽
                          child: CodeWrapper(
                            builder: _imageFitWidth,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ExampleItem(
                ignoreCode: true,
                desc: '',
                builder: (context) {
                  return Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 8),
                    child: Wrap(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: CodeWrapper(
                            builder: _imageSquare,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: CodeWrapper(
                            builder: _imageRoundedSquare,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: CodeWrapper(
                            builder: _imageCircle,
                          ),
                        ),
                      ],
                    ),
                  );
                })
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(
                ignoreCode: true,
                desc: '',
                builder: (context) {
                  return Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 8),
                    child: Wrap(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: CodeWrapper(
                            builder: _loadingDefault,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: CodeWrapper(
                            builder: _loadingCustom,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ExampleItem(
                ignoreCode: true,
                desc: '',
                builder: (context) {
                  return Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 8),
                    child: Wrap(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: CodeWrapper(
                            builder: _failDefault,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: CodeWrapper(
                            builder: _failCustom,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ],
        )
      ],
      test: [
        ExampleItem(
            ignoreCode: true,
            desc: '',
            builder: (context) {
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 8),
                child: Wrap(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: CodeWrapper(
                        builder: _imageFile,
                      ),
                    ),
                  ],
                ),
              );
            }),
      ],
    );
  }

/* 图片裁剪 */
  @Demo(group: 'image')
  Widget _imageClip(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TText(
            '裁剪',
            font: TTheme.of(context).fontBodyMedium,
          ),
        ),
        const TImage(
          assetUrl: 'assets/img/image.png',
          type: TImageType.clip,
        ),
      ],
    );
  }

/* 图片拉伸 */
  @Demo(group: 'image')
  Widget _imageStretch(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TText(
            '拉伸',
            font: TTheme.of(context).fontBodyMedium,
          ),
        ),
        Container(
          color: TTheme.of(context).bgColorContainerHover,
          width: 121,
          height: 72,
          child: const Stack(
            alignment: Alignment.center,
            children: [
              TImage(
                assetUrl: 'assets/img/image.png',
                width: 121,
                height: 50,
                type: TImageType.stretch,
              ),
            ],
          ),
        ),
      ],
    );
  }

/* 图片适应高 */
  @Demo(group: 'image')
  Widget _imageFitHeight(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TText(
            '适应高',
            font: TTheme.of(context).fontBodyMedium,
          ),
        ),
        Container(
          width: 89,
          height: 72,
          color: TTheme.of(context).bgColorContainerHover,
          child: const TImage(
            assetUrl: 'assets/img/image.png',
            type: TImageType.fitHeight,
          ),
        ),
      ],
    );
  }

  /* 图片适应宽 */
  @Demo(group: 'image')
  Widget _imageFitWidth(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TText(
            '适应宽',
            font: TTheme.of(context).fontBodyMedium,
          ),
        ),
        Container(
          width: 72,
          height: 89,
          color: TTheme.of(context).bgColorContainerHover,
          child: const TImage(
            assetUrl: 'assets/img/image.png',
            type: TImageType.fitWidth,
          ),
        ),
      ],
    );
  }

/* 方形 */
  @Demo(group: 'image')
  Widget _imageSquare(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TText(
            '方形',
            font: TTheme.of(context).fontBodyMedium,
          ),
        ),
        const TImage(
          assetUrl: 'assets/img/image.png',
          type: TImageType.square,
        ),
      ],
    );
  }

/* 圆角方形 */
  @Demo(group: 'image')
  Widget _imageRoundedSquare(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TText(
            '圆角方形',
            font: TTheme.of(context).fontBodyMedium,
          ),
        ),
        const TImage(
          assetUrl: 'assets/img/image.png',
          type: TImageType.roundedSquare,
          width: 72,
          height: 72,
        ),
      ],
    );
  }

/* 圆形 */
  @Demo(group: 'image')
  Widget _imageCircle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TText(
            '圆形',
            font: TTheme.of(context).fontBodyMedium,
          ),
        ),
        const TImage(
          assetUrl: 'assets/img/image.png',
          width: 72,
          height: 72,
          type: TImageType.circle,
        ),
      ],
    );
  }

/* 加载默认提示 */
  @Demo(group: 'image')
  Widget _loadingDefault(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TText(
            '加载默认提示',
            font: TTheme.of(context).fontBodyMedium,
          ),
        ),
        Container(
            height: 72,
            width: 72,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(TTheme.of(context).radiusDefault)),
            child: Container(
                alignment: Alignment.center,
                color: TTheme.of(context).bgColorContainerHover,
                child: Icon(
                  TIcons.ellipsis,
                  size: 22,
                  color: TTheme.of(context).textColorPlaceholder,
                ))),

        /// @tips 实际组件写法如下：上面仅为加载展示
        // const TImage(
        //   imgUrl:
        //       'https://images.pexels.com/photos/842711/pexels-photo-842711.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        //   type: TImageType.roundedSquare,
        // ),
      ],
    );
  }

/* 加载自定义提示 */
  @Demo(group: 'image')
  Widget _loadingCustom(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TText(
            '加载自定义提示',
            font: TTheme.of(context).fontBodyMedium,
          ),
        ),
        Container(
            height: 72,
            width: 72,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(TTheme.of(context).radiusDefault)),
            child: Container(
                alignment: Alignment.center,
                color: TTheme.of(context).bgColorContainerHover,
                child: RotationTransition(
                    turns: animation,
                    alignment: Alignment.center,
                    child: TCircleIndicator(
                      color: TTheme.of(context).brandNormalColor,
                      size: 18,
                      lineWidth: 3,
                    )))),
        // 实际组件写法如下：上面仅为加载展示
        // TImage(
        //   imgUrl:
        //       'https://images.pexels.com/photos/842711/pexels-photo-842711.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        //   loadingWidget: RotationTransition(
        //       turns: animation,
        //       alignment: Alignment.center,
        //       child: TCircleIndicator(
        //         color: TTheme.of(context).brandNormalColor,
        //         size: 18,
        //         lineWidth: 3,
        //       )),
        //   type: TImageType.roundedSquare,
        // ),
      ],
    );
  }

/* 失败默认提示 */
  @Demo(group: 'image')
  Widget _failDefault(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TText(
            '失败默认提示',
            font: TTheme.of(context).fontBodyMedium,
          ),
        ),
        const TImage(
          imgUrl: 'error',
          type: TImageType.roundedSquare,
        ),
      ],
    );
  }

/* 失败自定义提示 */
  @Demo(group: 'image')
  Widget _failCustom(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TText(
            '失败自定义提示',
            font: TTheme.of(context).fontBodyMedium,
          ),
        ),
        TImage(
          imgUrl: 'error',
          errorWidget: TText(
            '加载失败',
            forceVerticalCenter: true,
            font: TTheme.of(context).fontBodyExtraSmall,
          ),
          type: TImageType.roundedSquare,
        ),
      ],
    );
  }

  @Demo(group: 'image')
  Widget _imageFile(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: TImage(
        imageFile: File('/sdcard/td/test.jpg'),
        type: TImageType.fitWidth,
      ),
    );
  }
}
