/*
 * Created by haozhicao@tencent.com on 6/28/22.
 * t_refresh_page.dart
 * 
 */

import 'dart:async';

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
  var loadingTextsCount = 0;
  var timeoutCount = 0;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      exampleCodeGroup: 'refresh',
      desc: '用于快速刷新页面信息，刷新可以是整页刷新也可以是页面的局部刷新。',
      children: [
        ExampleModule(title: '顶部下拉刷新', children: [
          ExampleItem(desc: '基础用法', builder: _buildRefresh),
        ]),
        ExampleModule(title: '自定义提示语', children: [
          ExampleItem(desc: 'loadingTexts', builder: _buildLoadingTexts),
        ]),
        ExampleModule(title: '刷新超时', children: [
          ExampleItem(desc: 'refreshTimeout', builder: _buildTimeout),
        ]),
      ],
    );
  }

  Widget _demoHint(BuildContext context, String message) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.tTheme.bgColorContainer,
        borderRadius: BorderRadius.all(Radius.circular(context.tTheme.radiusLarge)),
      ),
      child: TText(
        PlatformUtil.isWeb ? 'Web暂不支持下拉，请下载安装apk体验' : message,
        font: context.tTheme.fontBodyLarge,
        textColor: context.tTheme.textColorPlaceholder,
      ),
    );
  }

  @ExampleCode(group: 'refresh')
  Widget _buildRefresh(BuildContext context) {
    return SizedBox(
      height: 300,
      child: TPullDownRefresh(
        // 下拉刷新回调
        onRefresh: () {
          return Future<void>.delayed(const Duration(seconds: 2), () {
            setState(() {
              count++;
            });
          });
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _demoHint(context, '拖拽该区域演示 顶部下拉刷新'),
            const SizedBox(height: 16),
            _demoHint(context, '下拉刷新次数：${count}'),
          ],
        ),
      ),
    );
  }

  @ExampleCode(group: 'refresh')
  Widget _buildLoadingTexts(BuildContext context) {
    return SizedBox(
      height: 300,
      child: TPullDownRefresh(
        loadingBarHeight: 70,
        maxBarHeight: 100,
        texts: const TPullDownRefreshTexts(
          pullToRefresh: '下拉即可刷新...',
          releaseToRefresh: '释放即可刷新...',
          refreshing: '加载中...',
          refreshComplete: '刷新成功',
        ),
        onRefresh: () {
          return Future<void>.delayed(const Duration(seconds: 1), () {
            setState(() {
              loadingTextsCount++;
            });
          });
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _demoHint(context, '下拉刷新'),
            const SizedBox(height: 16),
            _demoHint(context, '自定义提示语刷新次数：${loadingTextsCount}'),
          ],
        ),
      ),
    );
  }

  @ExampleCode(group: 'refresh')
  Widget _buildTimeout(BuildContext context) {
    return SizedBox(
      height: 300,
      child: TPullDownRefresh(
        refreshTimeout: const Duration(seconds: 1),
        onTimeout: () {
          TToast.showText('已超时', context: context);
        },
        onRefresh: () {
          // 模拟长时间未完成的刷新，等待超时回调。
          return Completer<void>().future;
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _demoHint(context, '下拉刷新'),
            const SizedBox(height: 16),
            _demoHint(context, '超时刷新次数：${timeoutCount}'),
          ],
        ),
      ),
    );
  }
}
