---
title: Image 图片
description: 用于展示效果，主要为上下左右居中裁切、拉伸、平铺等方式。
spline: base
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在tdesign_flutter/tdesign_flutter.dart中有所有组件的路径。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

### 1 组件类型


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  
### 1 组件状态


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
  }</pre>

</td-code-block>
                                  


## API
### TDImage
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| imgUrl | String? | - | 图片地址 |
| key |  | - |  |
| type | TDImageType | TDImageType.roundedSquare | 图片类型 |
| errorWidget | Widget? | - | 失败自定义提示 |
| loadingWidget | Widget? | - | 加载自定义提示 |
| width | double? | - | 自定义宽 |
| height | double? | - | 自定义高 |
| fit | BoxFit? | - | 适配样式 |
| frameBuilder | ImageFrameBuilder? | - | 以下系统Image属性，释义请参考系统[Image]中注释 |
| loadingBuilder |  | - |  |
| errorBuilder |  | - |  |
| semanticLabel |  | - |  |
| excludeFromSemantics |  | false |  |
| color |  | - |  |
| opacity |  | - |  |
| colorBlendMode |  | - |  |
| alignment |  | Alignment.center |  |
| repeat |  | ImageRepeat.noRepeat |  |
| centerSlice |  | - |  |
| matchTextDirection |  | false |  |
| gaplessPlayback |  | false |  |
| isAntiAlias |  | false |  |
| filterQuality |  | FilterQuality.low |  |
| cacheHeight |  | - |  |
| cacheWidth |  | - |  |
| assetUrl | String? | - | 本地素材地址 |
| imageFile | File? | - | 图片文件路径 |


  