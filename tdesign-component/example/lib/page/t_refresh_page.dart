/*
 * Created by haozhicao@tencent.com on 6/28/22.
 * t_loading_page.dart
 * 
 */

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/example_code.dart';

class TPullDownRefreshPage extends StatefulWidget {
  const TPullDownRefreshPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TPullDownRefreshPageState();
}

class _TPullDownRefreshPageState extends State<TPullDownRefreshPage> {
  var count = 0;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      exampleCodeGroup: 'refresh',
      desc: '用于快速刷新页面信息，刷新可以是整页刷新也可以是页面的局部刷新。',
      showSingleChild: true,
      singleChild: CodeWrapper(builder: _buildRefresh),
    );
  }

  @ExampleCode(group: 'refresh')
  Widget _buildRefresh(BuildContext context) {
    return EasyRefresh(
      // 下拉样式
      header: TRefreshHeader(),
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          // spacing: 16,
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: context.tTheme.bgColorContainer,
                  borderRadius: BorderRadius.all(
                      Radius.circular(context.tTheme.radiusLarge))),
              child: TText(
                PlatformUtil.isWeb ? 'Web暂不支持下拉，请下载安装apk体验' : '拖拽该区域演示 顶部下拉刷新',
                font: context.tTheme.fontBodyLarge,
                textColor: context.tTheme.textColorPlaceholder,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: context.tTheme.bgColorContainer,
                  borderRadius: BorderRadius.all(
                      Radius.circular(context.tTheme.radiusLarge))),
              child: TText(
                '下拉刷新次数：${count}',
                font: context.tTheme.fontBodyLarge,
                textColor: context.tTheme.textColorPlaceholder,
              ),
            ),
            const SizedBox(height: 500),
          ],
        ),
      )),
      // 下拉刷新回调
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          count++;
        });
      },
    );
  }
}
