/*
 * Created by haozhicao@tencent.com on 6/28/22.
 * td_loading_page.dart
 * 
 */

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';
import '../example_widget.dart';

class TDLoadingPage extends StatefulWidget {

  const TDLoadingPage({Key? key}):super(key: key);

  @override
  State<StatefulWidget> createState() => _TDLoadingPageState();
}

class _TDLoadingPageState extends State<TDLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: '加载 Loading',
        children: [

      TDText('类型', font: TDTheme.of(context).fontXL,),
      ExampleModule(desc: '纯图标', builder: (_){
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const TDLoading(
              size: TDLoadingSize.medium,
              icon: TDLoadingIcon.circle,
            ),
            const TDLoading(
              size: TDLoadingSize.medium,
              icon: TDLoadingIcon.activity,
            ),
            TDLoading(
              size: TDLoadingSize.medium,
              icon: TDLoadingIcon.point,
              iconColor: TDTheme.of(context).brandColor8,
            ),
          ],
        );
      }),
      ExampleModule(desc: '图标加文字横向', builder: (_){
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const TDLoading(
              size: TDLoadingSize.medium,
              icon: TDLoadingIcon.circle,
              text: '加载中…',
              axis: Axis.horizontal,
            ),
            const TDLoading(
              size: TDLoadingSize.medium,
              icon: TDLoadingIcon.activity,
              text: '加载中…',
              axis: Axis.horizontal,
            ),
            TDLoading(
              size: TDLoadingSize.medium,
              icon: TDLoadingIcon.circle,
              text: '加载中…',
              axis: Axis.horizontal,
              textColor: TDTheme.of(context).brandHoverColor,
            ),
          ],
        );
      }),
      ExampleModule(desc: '图标加文字竖向', builder: (_){
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const TDLoading(
              size: TDLoadingSize.medium,
              icon: TDLoadingIcon.circle,
              text: '加载中…',
              axis: Axis.vertical,
            ),
            const TDLoading(
              size: TDLoadingSize.medium,
              icon: TDLoadingIcon.activity,
              text: '加载中…',
              axis: Axis.vertical,
            ),
            TDLoading(
              size: TDLoadingSize.medium,
              icon: TDLoadingIcon.circle,
              text: '加载中…',
              axis: Axis.vertical,
              textColor: TDTheme.of(context).brandHoverColor,
            ),
          ],
        );
      }),
      ExampleModule(desc: '纯文字', builder: (_){
        // TODO: 加载失败和刷新
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
             TDLoading(
              size: TDLoadingSize.medium,
              text: '加载中…',
            ),
          ],
        );
      }),

      TDText('规格', font: TDTheme.of(context).fontXL,),

      ExampleModule(desc: '图标加文字横向-circle', builder: (_){
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
             TDLoading(
              size: TDLoadingSize.large,
              icon: TDLoadingIcon.circle,
              text: '加载中(大)…',
              axis: Axis.horizontal,
            ),
             TDLoading(
              size: TDLoadingSize.medium,
              icon: TDLoadingIcon.circle,
              text: '加载中(中)…',
              axis: Axis.horizontal,
            ),
             TDLoading(
              size: TDLoadingSize.small,
              icon: TDLoadingIcon.circle,
              text: '加载中(小)…',
              axis: Axis.horizontal,
            ),
          ],
        );
      }),
      ExampleModule(desc: '图标加文字横向-activity', builder: (_){
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
             TDLoading(
              size: TDLoadingSize.large,
              icon: TDLoadingIcon.activity,
              text: '加载中(大)…',
               iconColor: TDTheme.of(context).brandColor8 ,
              axis: Axis.horizontal,
            ),
             TDLoading(
              size: TDLoadingSize.medium,
              icon: TDLoadingIcon.activity,
              text: '加载中(中)…',
              iconColor: TDTheme.of(context).brandColor8 ,
              axis: Axis.horizontal,
            ),
             TDLoading(
              size: TDLoadingSize.small,
              icon: TDLoadingIcon.activity,
              text: '加载中(小)…',
               iconColor: TDTheme.of(context).brandColor8 ,
              axis: Axis.horizontal,
            ),
          ],
        );
      }),

      ExampleModule(desc: '图标加文字竖向', builder: (_){
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            TDLoading(
              size: TDLoadingSize.large,
              icon: TDLoadingIcon.circle,
              text: '加载中(大)…',
            ),
            TDLoading(
              size: TDLoadingSize.medium,
              icon: TDLoadingIcon.circle,
              text: '加载中(中)…',
            ),
            TDLoading(
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
