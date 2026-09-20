import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'cover_toast_example.dart';
import 'fail_toast_example.dart';
import 'hide_toast_example.dart';
import 'horizontal_icon_toast_example.dart';
import 'loading_toast_example.dart';
import 'multiple_text_toast_example.dart';
import 'show_toast_example.dart';
import 'success_toast_example.dart';
import 'text_toast_example.dart';
import 'vertical_icon_toast_example.dart';
import 'warning_toast_example.dart';

@ExampleCodeManifest()
/// Toast 轻提示示例页面
class TToastPage extends StatelessWidget {
  const TToastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '轻量级反馈/提示，可快速在屏幕中间展示简要信息并自动消失。',
      exampleCodeGroup: 'toast',
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        ExampleModule(
          title: '基础提示',
          children: [
            ExampleItem(
              desc: '纯文本',
              methodName: 'TextToastExample',
              builder: (_) => const TextToastExample(),
            ),
            ExampleItem(
              desc: '多行文字',
              methodName: 'MultipleTextToastExample',
              builder: (_) => const MultipleTextToastExample(),
            ),
            ExampleItem(
              desc: '带横向图标',
              methodName: 'HorizontalIconToastExample',
              builder: (_) => const HorizontalIconToastExample(),
            ),
            ExampleItem(
              desc: '带竖向图标',
              methodName: 'VerticalIconToastExample',
              builder: (_) => const VerticalIconToastExample(),
            ),
            ExampleItem(
              desc: '加载状态',
              methodName: 'LoadingToastExample',
              builder: (_) => const LoadingToastExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(
              desc: '成功提示',
              methodName: 'SuccessToastExample',
              builder: (_) => const SuccessToastExample(),
            ),
            ExampleItem(
              desc: '警告提示',
              methodName: 'WarningToastExample',
              builder: (_) => const WarningToastExample(),
            ),
            ExampleItem(
              desc: '错误提示',
              methodName: 'FailToastExample',
              builder: (_) => const FailToastExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '显示遮罩',
          children: [
            ExampleItem(
              desc: '禁止滑动和点击',
              methodName: 'CoverToastExample',
              builder: (_) => const CoverToastExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '手动关闭',
          children: [
            ExampleItem(
              desc: '显示提示',
              methodName: 'ShowToastExample',
              builder: (_) => const ShowToastExample(),
            ),
            ExampleItem(
              desc: '关闭提示',
              methodName: 'HideToastExample',
              builder: (_) => const HideToastExample(),
            ),
          ],
        ),
      ],
    );
  }
}
