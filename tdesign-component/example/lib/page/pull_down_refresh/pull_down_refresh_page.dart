/*
 * Created by haozhicao@tencent.com on 6/28/22.
 * t_pullDownRefresh_page.dart
 *
 */

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'pull_down_refresh_loading_texts_example.dart';
import 'pull_down_refresh_refresh_example.dart';
import 'pull_down_refresh_timeout_example.dart';

@ExampleCodeManifest()
class TPullDownRefreshPage extends StatefulWidget {
  const TPullDownRefreshPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TPullDownRefreshPageState();
}

class _TPullDownRefreshPageState extends State<TPullDownRefreshPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      exampleCodeGroup: 'PullDownRefresh',
      desc: '用于快速刷新页面信息，刷新可以是整页刷新也可以是页面的局部刷新。',
      children: [
        ExampleModule(
          title: '顶部下拉刷新',
          children: [
            ExampleItem(
              desc: '基础用法',
              center: false,
              padding: EdgeInsets.zero,
              methodName: 'PullDownRefreshRefreshExample',
              builder: (_) => const PullDownRefreshRefreshExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '自定义提示语',
          children: [
            ExampleItem(
              desc:
                  'loadingTexts（小程序已有公开 props 的新增 API 演示，Demo 形态仅参考 Mobile Vue）',
              methodName: 'PullDownRefreshLoadingTextsExample',
              builder: (_) => const PullDownRefreshLoadingTextsExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '刷新超时',
          children: [
            ExampleItem(
              desc:
                  'refreshTimeout（小程序已有公开 props 的新增 API 演示，Demo 形态仅参考 Mobile Vue）',
              methodName: 'PullDownRefreshTimeoutExample',
              builder: (_) => const PullDownRefreshTimeoutExample(),
            ),
          ],
        ),
      ],
    );
  }
}
