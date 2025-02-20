/*
 * Created by haozhicao@tencent.com on 6/28/22.
 * td_loading_page.dart
 * 
 */

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TdPullDownRefreshPage extends StatefulWidget {
  const TdPullDownRefreshPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TdPullDownRefreshPageState();
}

class _TdPullDownRefreshPageState extends State<TdPullDownRefreshPage> {
  var count = 0;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      exampleCodeGroup: 'refresh',
      desc: '用于快速刷新页面信息，刷新可以是整页刷新也可以是页面的局部刷新。',
      showSingleChild: true,
      singleChild: CodeWrapper(builder: _buildRefresh),
    );
  }

  @Demo(group: 'refresh')
  Widget _buildRefresh(BuildContext context) {
    return EasyRefresh(
      // 下拉样式
      header: TDRefreshHeader(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 171,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: TDTheme.of(context).grayColor1,
                  borderRadius: BorderRadius.all(Radius.circular(TDTheme.of(context).radiusLarge))),
              margin: const EdgeInsets.only(left: 16, right: 16),
              child: TDText(
                PlatformUtil.isWeb ? 'Web暂不支持下拉，请下载安装apk体验' : '拖拽该区域演示 顶部下拉刷新',
                font: TDTheme.of(context).fontBodyLarge,
                textColor: TDTheme.of(context).fontGyColor4,
              ),
            ),
            Container(
              height: 70,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: TDTheme.of(context).grayColor1,
                  borderRadius: BorderRadius.all(Radius.circular(TDTheme.of(context).radiusLarge))),
              margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TDText(
                '下拉刷新次数：${count}',
                font: TDTheme.of(context).fontBodyLarge,
                textColor: TDTheme.of(context).fontGyColor4,
              ),
            ),
            const SizedBox(height: 500),
          ],
        ),
      ),
      // 下拉刷新回调
      onRefresh: () {
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            count++;
          });
        });
      },
    );
  }
}
