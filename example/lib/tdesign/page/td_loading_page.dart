/*
 * Created by haozhicao@tencent.com on 6/28/22.
 * td_loading_page.dart
 * 
 */

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';
import 'package:tdesign_flutter_example/tdesign/example_base.dart';

class TdLoadingPage extends StatefulWidget {

  const TdLoadingPage({Key? key}):super(key: key);

  @override
  State<StatefulWidget> createState() => _TdLoadingPageState();
}

class _TdLoadingPageState extends State<TdLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return ExampleWidget(title: 'Loading', children: [

      TDText('类型', font: TDTheme.of(context).fontXL,),
      ExampleItem(desc: '纯图标', builder: (_){
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const TDLoadingWidget(
              size: TDLoadingSize.medium,
              icon: TDLoadingIcon.circle,
            ),
            const TDLoadingWidget(
              size: TDLoadingSize.medium,
              icon: TDLoadingIcon.activity,
            ),
            TDLoadingWidget(
              size: TDLoadingSize.medium,
              icon: TDLoadingIcon.point,
              iconColor: TDTheme.of(context).brandColor8,
            ),
          ],
        );
      }),
      ExampleItem(desc: '图标加文字横向', builder: (_){
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const TDLoadingWidget(
              size: TDLoadingSize.medium,
              icon: TDLoadingIcon.circle,
              text: '加载中…',
              axis: Axis.horizontal,
            ),
            const TDLoadingWidget(
              size: TDLoadingSize.medium,
              icon: TDLoadingIcon.activity,
              text: '加载中…',
              axis: Axis.horizontal,
            ),
            TDLoadingWidget(
              size: TDLoadingSize.medium,
              icon: TDLoadingIcon.circle,
              text: '加载中…',
              axis: Axis.horizontal,
              textColor: TDTheme.of(context).brandHoverColor,
            ),
          ],
        );
      }),
      ExampleItem(desc: '图标加文字竖向', builder: (_){
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const TDLoadingWidget(
              size: TDLoadingSize.medium,
              icon: TDLoadingIcon.circle,
              text: '加载中…',
              axis: Axis.vertical,
            ),
            const TDLoadingWidget(
              size: TDLoadingSize.medium,
              icon: TDLoadingIcon.activity,
              text: '加载中…',
              axis: Axis.vertical,
            ),
            TDLoadingWidget(
              size: TDLoadingSize.medium,
              icon: TDLoadingIcon.circle,
              text: '加载中…',
              axis: Axis.vertical,
              textColor: TDTheme.of(context).brandHoverColor,
            ),
          ],
        );
      }),
      ExampleItem(desc: '纯文字', builder: (_){
        // TODO: 加载失败和刷新
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
             TDLoadingWidget(
              size: TDLoadingSize.medium,
              text: '加载中…',
            ),
          ],
        );
      }),

      TDText('规格', font: TDTheme.of(context).fontXL,),

      ExampleItem(desc: '图标加文字横向-circle', builder: (_){
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
             TDLoadingWidget(
              size: TDLoadingSize.large,
              icon: TDLoadingIcon.circle,
              text: '加载中(大)…',
              axis: Axis.horizontal,
            ),
             TDLoadingWidget(
              size: TDLoadingSize.medium,
              icon: TDLoadingIcon.circle,
              text: '加载中(中)…',
              axis: Axis.horizontal,
            ),
             TDLoadingWidget(
              size: TDLoadingSize.small,
              icon: TDLoadingIcon.circle,
              text: '加载中(小)…',
              axis: Axis.horizontal,
            ),
          ],
        );
      }),
      ExampleItem(desc: '图标加文字横向-activity', builder: (_){
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
             TDLoadingWidget(
              size: TDLoadingSize.large,
              icon: TDLoadingIcon.activity,
              text: '加载中(大)…',
              axis: Axis.horizontal,
            ),
             TDLoadingWidget(
              size: TDLoadingSize.medium,
              icon: TDLoadingIcon.activity,
              text: '加载中(中)…',
              axis: Axis.horizontal,
            ),
             TDLoadingWidget(
              size: TDLoadingSize.small,
              icon: TDLoadingIcon.activity,
              text: '加载中(小)…',
              axis: Axis.horizontal,
            ),
          ],
        );
      }),

      ExampleItem(desc: '图标加文字竖向', builder: (_){
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            TDLoadingWidget(
              size: TDLoadingSize.large,
              icon: TDLoadingIcon.circle,
              text: '加载中(大)…',
            ),
            TDLoadingWidget(
              size: TDLoadingSize.medium,
              icon: TDLoadingIcon.circle,
              text: '加载中(中)…',
            ),
            TDLoadingWidget(
              size: TDLoadingSize.small,
              icon: TDLoadingIcon.circle,
              text: '加载中(小)…',
            ),
          ],
        );
      }),
    ]);
  }
}
