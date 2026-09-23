/*
 * Created by haozhicao@tencent.com on 6/28/22.
 * t_loading_page.dart
 *
 */

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'custom_speed_loading_example.dart';
import 'loading_sizes_example.dart';
import 'pure_icon_loading_example.dart';
import 'pure_text_loading_example.dart';
import 'text_icon_horizontal_loading_example.dart';
import 'text_icon_vertical_loading_example.dart';

@ExampleCodeManifest()
class TLoadingPage extends StatefulWidget {
  const TLoadingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TLoadingPageState();
}

class _TLoadingPageState extends State<TLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      exampleCodeGroup: 'loading',
      desc: '用于表示页面或操作的加载状态，给予用户反馈的同时减缓等待的焦虑感，由一个或一组反馈动效组成。',
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '纯图标',
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'PureIconLoadingExample',
              builder: (_) => const PureIconLoadingExample(),
            ),
            ExampleItem(
              desc: '图标加文字横向',
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'TextIconHorizontalLoadingExample',
              builder: (_) => const TextIconHorizontalLoadingExample(),
            ),
            ExampleItem(
              desc: '图标加文字竖向',
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'TextIconVerticalLoadingExample',
              builder: (_) => const TextIconVerticalLoadingExample(),
            ),
            ExampleItem(
              desc: '纯文字',
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'PureTextLoadingExample',
              builder: (_) => const PureTextLoadingExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件尺寸',
          children: [
            ExampleItem(
              desc: '大尺寸',
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'LoadingSizesExample',
              builder: (_) => const LoadingSizesExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '加载速度',
          children: [
            ExampleItem(
              desc: '加载速度调整',
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'CustomSpeedLoadingExample',
              builder: (_) => const CustomSpeedLoadingExample(),
            ),
          ],
        ),
      ],
      test: [
        ExampleItem(
          desc: '带图标的失败横向Loading',
          ignoreCode: true,
          builder: (_) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Theme(
                data: Theme.of(context).mergeExtension(
                  const TLoadingThemeData(axis: Axis.horizontal),
                ),
                child: const TLoading(
                  icon: TLoadingIcon.circle,
                  text: '加载失败',
                  refreshWidget: Text('刷新'),
                ),
              ),
            );
          },
        ),
        ExampleItem(
          desc: '带图标的失败竖向Loading',
          ignoreCode: true,
          builder: (_) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Theme(
                data: Theme.of(
                  context,
                ).mergeExtension(const TLoadingThemeData()),
                child: const TLoading(
                  icon: TLoadingIcon.circle,
                  text: '加载失败',
                  refreshWidget: Text('刷新'),
                ),
              ),
            );
          },
        ),
        ExampleItem(
          desc: '验证居中问题',
          ignoreCode: true,
          builder: (context) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Theme(
                  data: Theme.of(context).mergeExtension(
                    const TLoadingThemeData(axis: Axis.vertical),
                  ),
                  child: const TLoading(
                    size: 32,
                    icon: TLoadingIcon.circle,
                    text: '加载中...',
                  ),
                ),
                const SizedBox(width: 36),
                Theme(
                  data: Theme.of(context).mergeExtension(
                    const TLoadingThemeData(axis: Axis.vertical),
                  ),
                  child: const TLoading(
                    size: 32,
                    icon: TLoadingIcon.activity,
                    text: '加载中...',
                  ),
                ),
              ],
            );
          },
        ),
        ExampleItem(
          desc: '展示/隐藏Loading',
          ignoreCode: true,
          builder: (_) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TButton(
                  child: const Text('展示Loading'),
                  colorScheme: TButtonColorScheme.primary,
                  onPressed: () {
                    TLoadingController.show(context);
                  },
                ),
                const SizedBox(width: 36),
                const TButton(
                  child: Text('隐藏Loading'),
                  colorScheme: TButtonColorScheme.primary,
                  onPressed: TLoadingController.dismiss,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  /// 纯图标

  /// 图标加文字横向

  /// 图标加文字竖向

  /// 纯文字

  /// 组件尺寸

  /// 加载速度
}
