/*
 * Created by haozhicao@tencent.com on 6/28/22.
 * t_loading_page.dart
 *
 */

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/example_code.dart';

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
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '纯图标', builder: _buildPureIconLoading),
          ExampleItem(desc: '自定义图标', builder: _buildCustomIconLoading),
          ExampleItem(
              desc: '图标加文字横向', builder: _buildTextIconHorizontalLoading),
          ExampleItem(desc: '图标加文字竖向', builder: _buildTextIconVerticalLoading),
          ExampleItem(desc: '纯文字', builder: _buildPureTextLoading),
        ]),
        ExampleModule(title: '组件尺寸', children: [
          ExampleItem(desc: '大尺寸', builder: _buildLargeLoading),
          ExampleItem(desc: '中尺寸', builder: _buildMediumLoading),
          ExampleItem(desc: '小尺寸', builder: _buildSmallLoading),
        ]),
        ExampleModule(title: '加载速度', children: [
          ExampleItem(desc: '调整加载速度', builder: _buildCustomSpeedLoading),
        ]),
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
                    const TLoadingThemeData(
                      axis: Axis.horizontal,
                    ),
                  ),
                  child: const TLoading(
                    icon: TLoadingIcon.circle,
                    size: TLoadingSize.small,
                    text: '加载失败',
                    refreshWidget: Text('刷新'),
                  ),
                ),
              );
            }),
        ExampleItem(
            desc: '带图标的失败竖向Loading',
            ignoreCode: true,
            builder: (_) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Theme(
                  data: Theme.of(context).mergeExtension(
                    const TLoadingThemeData(),
                  ),
                  child: const TLoading(
                    icon: TLoadingIcon.circle,
                    size: TLoadingSize.small,
                    text: '加载失败',
                    refreshWidget: Text('刷新'),
                  ),
                ),
              );
            }),
        ExampleItem(
            desc: '验证居中问题',
            ignoreCode: true,
            builder: (context) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Theme(
                      data: Theme.of(context).mergeExtension(
                          const TLoadingThemeData(axis: Axis.vertical)),
                      child: const TLoading(
                        size: TLoadingSize.large,
                        icon: TLoadingIcon.circle,
                        text: '加载中…',
                      ),
                    ),
                    const SizedBox(width: 36),
                    Theme(
                      data: Theme.of(context).mergeExtension(
                          const TLoadingThemeData(axis: Axis.vertical)),
                      child: const TLoading(
                        size: TLoadingSize.large,
                        icon: TLoadingIcon.activity,
                        text: '加载中…',
                      ),
                    ),
                  ]);
            }),
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
            })
      ],
    );
  }

  /// 纯图标
  @ExampleCode(group: 'loading')
  Widget _buildPureIconLoading(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const TLoading(
          size: TLoadingSize.small,
          icon: TLoadingIcon.circle,
        ),
        const SizedBox(width: 36),
        const TLoading(
          size: TLoadingSize.small,
          icon: TLoadingIcon.activity,
        ),
        const SizedBox(width: 36),
        Theme(
          data: Theme.of(context).mergeExtension(
            TLoadingThemeData(
              iconColor: context.tTheme.brandNormalColor,
            ),
          ),
          child: const TLoading(
            size: TLoadingSize.small,
            icon: TLoadingIcon.point,
          ),
        ),
      ],
    );
  }

  /// 自定义图标
  @ExampleCode(group: 'loading')
  Widget _buildCustomIconLoading(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(
        TLoadingThemeData(
          iconColor: context.tTheme.brandNormalColor,
        ),
      ),
      child: const TLoading(
        size: TLoadingSize.small,
        customIcon: SizedBox(
          width: 20,
          height: 20,
          child: Icon(
            Icons.sync_rounded,
            size: 20,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  /// 图标加文字横向
  @ExampleCode(group: 'loading')
  Widget _buildTextIconHorizontalLoading(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Theme(
          data: Theme.of(context)
              .mergeExtension(const TLoadingThemeData(axis: Axis.horizontal)),
          child: const TLoading(
            size: TLoadingSize.small,
            icon: TLoadingIcon.circle,
            text: '加载中…',
          ),
        ),
        const SizedBox(width: 36),
        Theme(
          data: Theme.of(context)
              .mergeExtension(const TLoadingThemeData(axis: Axis.horizontal)),
          child: const TLoading(
            size: TLoadingSize.small,
            icon: TLoadingIcon.activity,
            text: '加载中…',
          ),
        ),
      ],
    );
  }

  /// 图标加文字竖向
  @ExampleCode(group: 'loading')
  Widget _buildTextIconVerticalLoading(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Theme(
          data: Theme.of(context)
              .mergeExtension(const TLoadingThemeData(axis: Axis.vertical)),
          child: const TLoading(
            size: TLoadingSize.small,
            icon: TLoadingIcon.circle,
            text: '加载中…',
          ),
        ),
        const SizedBox(width: 36),
        Theme(
          data: Theme.of(context)
              .mergeExtension(const TLoadingThemeData(axis: Axis.vertical)),
          child: const TLoading(
            size: TLoadingSize.small,
            icon: TLoadingIcon.activity,
            text: '加载中…',
          ),
        ),
      ],
    );
  }

  /// 纯文字
  @ExampleCode(group: 'loading')
  Widget _buildPureTextLoading(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const TLoading(
          size: TLoadingSize.small,
          text: '加载中…',
        ),
        const SizedBox(width: 36),
        Theme(
          data: Theme.of(context).mergeExtension(
            TLoadingThemeData(
              textColor: context.tTheme.textColorPlaceholder,
            ),
          ),
          child: const TLoading(
            size: TLoadingSize.small,
            text: '加载失败',
          ),
        ),
        const SizedBox(width: 36),
        Theme(
          data: Theme.of(context).mergeExtension(
            const TLoadingThemeData(),
          ),
          child: const TLoading(
            size: TLoadingSize.small,
            text: '加载失败',
            refreshWidget: Text('刷新'),
          ),
        ),
      ],
    );
  }

  /// 大尺寸
  @ExampleCode(group: 'loading')
  Widget _buildLargeLoading(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .mergeExtension(const TLoadingThemeData(axis: Axis.horizontal)),
      child: const TLoading(
        size: TLoadingSize.large,
        icon: TLoadingIcon.circle,
        text: '加载中…',
      ),
    );
  }

  /// 中尺寸
  @ExampleCode(group: 'loading')
  Widget _buildMediumLoading(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .mergeExtension(const TLoadingThemeData(axis: Axis.horizontal)),
      child: const TLoading(
        size: TLoadingSize.medium,
        icon: TLoadingIcon.circle,
        text: '加载中…',
      ),
    );
  }

  /// 小尺寸
  @ExampleCode(group: 'loading')
  Widget _buildSmallLoading(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .mergeExtension(const TLoadingThemeData(axis: Axis.horizontal)),
      child: const TLoading(
        size: TLoadingSize.small,
        icon: TLoadingIcon.circle,
        text: '加载中…',
      ),
    );
  }

  double _currentSliderValue = 1000;

  /// 自定义尺寸
  @ExampleCode(group: 'loading')
  Widget _buildCustomSpeedLoading(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Theme(
          data: Theme.of(context).mergeExtension(
            TLoadingThemeData(
              axis: Axis.horizontal,
              duration: _currentSliderValue.round(),
            ),
          ),
          child: const TLoading(
            size: TLoadingSize.small,
            icon: TLoadingIcon.circle,
            text: '加载中…',
          ),
        ),
        const SizedBox(height: 16),
        TSlider(
          value: _currentSliderValue,
          min: -20,
          max: 2000,
          divisions: 100,
          onChanged: (double value) {
            setState(() {
              _currentSliderValue = value;
            });
          },
        )
      ],
    );
  }
}
