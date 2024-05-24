import 'package:flutter/material.dart';

import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';
import 'dart:io';
class TDImagePage extends StatefulWidget {
  const TDImagePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TDImageState();
}

class TDImageState extends State<TDImagePage>
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
              ExampleItem(desc: '', builder: _imageClip),
              ExampleItem(desc: '', builder: _imageFitWidth),
              ExampleItem(desc: '', builder: _imageSquare),
            ],
          ),
          ExampleModule(
            title: '组件状态',
            children: [
              ExampleItem(desc: '', builder: _loading),
              ExampleItem(desc: '', builder: _fail),
            ],
          )
        ],
     test: [
       ExampleItem(desc: '加载本地文件', builder: _imageFile),
     ],);
  }
  @Demo(group: 'image')
  Widget _imageClip(BuildContext context)  {

    return Row(
      children: [
        const SizedBox(
          width: 16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TDText(
                '裁剪',
                font: TDTheme.of(context).fontBodyMedium,
                textColor: TDTheme.of(context).fontGyColor2.withOpacity(0.6),
              ),
            ),
             const TDImage(
               assetUrl: 'assets/img/image.png',
               type: TDImageType.clip,
            ),
          ],
        ),
        const SizedBox(
          width: 24,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TDText(
                '适应高',
                font: TDTheme.of(context).fontBodyMedium,
                textColor: TDTheme.of(context).fontGyColor2.withOpacity(0.6),
              ),
            ),
            Container(
              width: 89,
              height: 72,
              color: Colors.black,
              child: const TDImage(
                assetUrl: 'assets/img/image.png',
                type: TDImageType.fitHeight,
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 24,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TDText(
                '拉伸',
                font: TDTheme.of(context).fontBodyMedium,
                textColor: TDTheme.of(context).fontGyColor2.withOpacity(0.6),
              ),
            ),
            Container(
              color: Colors.black,
              width: 121,
              height: 72,
              child: Stack(
                alignment: Alignment.center,
                children: const [
                  TDImage(
                    assetUrl: 'assets/img/image.png',
                    width: 121,
                    height: 50,
                    type: TDImageType.stretch,
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  @Demo(group: 'image')
  Widget _imageFitWidth(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TDText(
                  '适应宽',
                  font: TDTheme.of(context).fontBodyMedium,
                  textColor: TDTheme.of(context).fontGyColor2.withOpacity(0.6),
                ),
              ),
              Container(
                width: 72,
                height: 89,
                color: Colors.black,
                child: const TDImage(
                  assetUrl: 'assets/img/image.png',
                  type: TDImageType.fitWidth,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @Demo(group: 'image')
  Widget _imageSquare(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TDText(
                  '方形',
                  font: TDTheme.of(context).fontBodyMedium,
                  textColor: TDTheme.of(context).fontGyColor2.withOpacity(0.6),
                ),
              ),
              const TDImage(
                assetUrl: 'assets/img/image.png',
                type: TDImageType.square,
              ),
            ],
          ),
          const SizedBox(
            width: 24,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TDText(
                  '圆角方形',
                  font: TDTheme.of(context).fontBodyMedium,
                  textColor: TDTheme.of(context).fontGyColor2.withOpacity(0.6),
                ),
              ),
              const TDImage(
                assetUrl: 'assets/img/image.png',
                type: TDImageType.roundedSquare,
                width: 72,
                height: 72,
              ),
            ],
          ),
          const SizedBox(
            width: 24,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TDText(
                  '圆形',
                  font: TDTheme.of(context).fontBodyMedium,
                  textColor: TDTheme.of(context).fontGyColor2.withOpacity(0.6),
                ),
              ),
              const TDImage(
                assetUrl: 'assets/img/image.png',
                width: 72,
                height: 72,
                type: TDImageType.circle,
              ),
            ],
          )
        ],
      ),
    );
  }

  @Demo(group: 'image')
  Widget _loading(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TDText(
                '加载默认提示',
                font: TDTheme.of(context).fontBodyMedium,
                textColor: TDTheme.of(context).fontGyColor2.withOpacity(0.6),
              ),
            ),
            Container(
                height: 72,
                width: 72,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(TDTheme.of(context).radiusDefault)),
                child: Container(
                    alignment: Alignment.center,
                    color: TDTheme.of(context).grayColor2,
                    child: Icon(
                      TDIcons.ellipsis,
                      size: 22,
                      color: TDTheme.of(context).fontGyColor3,
                    )
                )
            ),
            // 实际组件写法如下：上面仅为加载展示
            // const TDImage(
            //   imgUrl:
            //       'https://images.pexels.com/photos/842711/pexels-photo-842711.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
            //   type: TDImageType.roundedSquare,
            // ),
          ],
        ),
        const SizedBox(
          width: 24,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TDText(
                '加载自定义提示',
                font: TDTheme.of(context).fontBodyMedium,
                textColor: TDTheme.of(context).fontGyColor2.withOpacity(0.6),
              ),
            ),
            Container(
                height: 72,
                width: 72,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(TDTheme.of(context).radiusDefault)),
                child: Container(
                    alignment: Alignment.center,
                    color: TDTheme.of(context).grayColor2,
                    child: RotationTransition(
                        turns: animation,
                        alignment: Alignment.center,
                        child: TDCircleIndicator(
                          color: TDTheme.of(context).brandNormalColor,
                          size: 18,
                          lineWidth: 3,
                        ))
                )
            ),
            // 实际组件写法如下：上面仅为加载展示
            // TDImage(
            //   imgUrl:
            //       'https://images.pexels.com/photos/842711/pexels-photo-842711.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
            //   loadingWidget: RotationTransition(
            //       turns: animation,
            //       alignment: Alignment.center,
            //       child: TDCircleIndicator(
            //         color: TDTheme.of(context).brandNormalColor,
            //         size: 18,
            //         lineWidth: 3,
            //       )),
            //   type: TDImageType.roundedSquare,
            // ),
          ],
        ),
        const SizedBox(
          width: 24,
        ),
      ],
    );
  }

  @Demo(group: 'image')
  Widget _fail(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TDText(
                  '失败默认提示',
                  font: TDTheme.of(context).fontBodyMedium,
                  textColor: TDTheme.of(context).fontGyColor2.withOpacity(0.6),
                ),
              ),
              const TDImage(
                imgUrl: 'error',
                type: TDImageType.roundedSquare,
              ),
            ],
          ),
          const SizedBox(
            width: 24,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TDText(
                  '失败自定义提示',
                  font: TDTheme.of(context).fontBodyMedium,
                  textColor: TDTheme.of(context).fontGyColor2.withOpacity(0.6),
                ),
              ),
              TDImage(
                imgUrl: 'error',
                errorWidget: TDText(
                  '加载失败',
                  forceVerticalCenter: true,
                  font: TDTheme.of(context).fontBodyExtraSmall,
                  fontWeight: FontWeight.w500,
                  textColor: TDTheme.of(context).fontGyColor3,
                ),
                type: TDImageType.roundedSquare,
              ),
            ],
          ),
          const SizedBox(
            width: 24,
          ),
        ],
      ),
    );
  }

  Widget _imageFile(BuildContext context) {

    return Container(
      width: 72,
      height: 72,
      child:  TDImage(
        imageFile: File('/sdcard/td/test.jpg'),
        type: TDImageType.fitWidth,
      ),
    );
  }
}
