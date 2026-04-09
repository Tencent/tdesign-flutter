/*
 * Created by haozhicao@tencent.com on 6/28/22.
 * td_loading_page.dart
 * 
 */

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TLoadingPage extends StatefulWidget {
  const TLoadingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TLoadingPageState();
}

class _TLoadingPageState extends State<TLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      exampleCodeGroup: 'loading',
      desc: '用于表示页面或操作的加载状态，给予用户反馈的同时减缓等待的焦虑感，由一个或一组反馈动效组成。',
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '纯图标', builder: _buildPureIconLoading),
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
                child: TLoading(
                  icon: TLoadingIcon.circle,
                  size: TLoadingSize.small,
                  axis: Axis.horizontal,
                  text: '加载失败',
                  refreshWidget: GestureDetector(
                    child: TText(
                      '刷新',
                      font: TTheme.of(context).fontBodySmall,
                      textColor: TTheme.of(context).brandNormalColor,
                    ),
                    onTap: () {
                      TToast.showText('刷新', context: context);
                    },
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
                child: TLoading(
                  icon: TLoadingIcon.circle,
                  size: TLoadingSize.small,
                  text: '加载失败',
                  refreshWidget: GestureDetector(
                    child: TText(
                      '刷新',
                      font: TTheme.of(context).fontBodySmall,
                      textColor: TTheme.of(context).brandNormalColor,
                    ),
                    onTap: () {
                      TToast.showText('刷新', context: context);
                    },
                  ),
                ),
              );
            }),
        ExampleItem(
            desc: '验证居中问题',
            ignoreCode: true,
            builder: (_) {
              return const Row(
                  // spacing: 36,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TLoading(
                      size: TLoadingSize.large,
                      icon: TLoadingIcon.circle,
                      text: '加载中…',
                      axis: Axis.vertical,
                    ),
                    SizedBox(width: 36),
                    TLoading(
                      size: TLoadingSize.large,
                      icon: TLoadingIcon.activity,
                      text: '加载中…',
                      axis: Axis.vertical,
                    ),
                  ]);
            }),
        ExampleItem(
            desc: '展示/隐藏Loading',
            ignoreCode: true,
            builder: (_) {
              return Row(
                // spacing: 36,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TButton(
                    text: '展示Loading',
                    theme: TButtonTheme.primary,
                    onTap: () {
                      TLoadingController.show(context);
                    },
                  ),
                  const SizedBox(width: 36),
                  const TButton(
                    text: '隐藏Loading',
                    theme: TButtonTheme.primary,
                    onTap: TLoadingController.dismiss,
                  ),
                ],
              );
            })
      ],
    );
  }

  /// 纯图标
  @Demo(group: 'loading')
  Widget _buildPureIconLoading(BuildContext context) {
    return Row(
      // spacing: 36,
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
        TLoading(
          size: TLoadingSize.small,
          icon: TLoadingIcon.point,
          iconColor: TTheme.of(context).brandNormalColor,
        ),
      ],
    );
  }

  /// 图标加文字横向
  @Demo(group: 'loading')
  Widget _buildTextIconHorizontalLoading(BuildContext context) {
    return const Row(
      // spacing: 36,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TLoading(
          size: TLoadingSize.small,
          icon: TLoadingIcon.circle,
          text: '加载中…',
          axis: Axis.horizontal,
        ),
        const SizedBox(width: 36),
        TLoading(
          size: TLoadingSize.small,
          icon: TLoadingIcon.activity,
          text: '加载中…',
          axis: Axis.horizontal,
        ),
      ],
    );
  }

  /// 图标加文字竖向
  @Demo(group: 'loading')
  Widget _buildTextIconVerticalLoading(BuildContext context) {
    return const Row(
      // spacing: 36,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TLoading(
          size: TLoadingSize.small,
          icon: TLoadingIcon.circle,
          text: '加载中…',
          axis: Axis.vertical,
        ),
        SizedBox(width: 36),
        TLoading(
          size: TLoadingSize.small,
          icon: TLoadingIcon.activity,
          text: '加载中…',
          axis: Axis.vertical,
        ),
      ],
    );
  }

  /// 纯文字
  @Demo(group: 'loading')
  Widget _buildPureTextLoading(BuildContext context) {
    return Row(
      // spacing: 36,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const TLoading(
          size: TLoadingSize.small,
          text: '加载中…',
        ),
        const SizedBox(width: 36),
        TLoading(
          size: TLoadingSize.small,
          text: '加载失败',
          textColor: TTheme.of(context).textColorPlaceholder,
        ),
        const SizedBox(width: 36),
        TLoading(
          size: TLoadingSize.small,
          text: '加载失败',
          refreshWidget: GestureDetector(
            child: TText(
              '刷新',
              font: TTheme.of(context).fontBodySmall,
              textColor: TTheme.of(context).brandNormalColor,
            ),
            onTap: () {
              TToast.showText('刷新', context: context);
            },
          ),
        ),
      ],
    );
  }

  /// 大尺寸
  @Demo(group: 'loading')
  Widget _buildLargeLoading(BuildContext context) {
    return const TLoading(
      size: TLoadingSize.large,
      icon: TLoadingIcon.circle,
      text: '加载中…',
      axis: Axis.horizontal,
    );
  }

  /// 中尺寸
  @Demo(group: 'loading')
  Widget _buildMediumLoading(BuildContext context) {
    return const TLoading(
      size: TLoadingSize.medium,
      icon: TLoadingIcon.circle,
      text: '加载中…',
      axis: Axis.horizontal,
    );
  }

  /// 小尺寸
  @Demo(group: 'loading')
  Widget _buildSmallLoading(BuildContext context) {
    return const TLoading(
      size: TLoadingSize.small,
      icon: TLoadingIcon.circle,
      text: '加载中…',
      axis: Axis.horizontal,
    );
  }

  double _currentSliderValue = 1000;

  /// 自定义尺寸
  @Demo(group: 'loading')
  Widget _buildCustomSpeedLoading(BuildContext context) {
    return Column(
      // spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TLoading(
          size: TLoadingSize.small,
          icon: TLoadingIcon.circle,
          axis: Axis.horizontal,
          text: '加载中…',
          duration: _currentSliderValue.round(),
        ),
        const SizedBox(height: 16),
        TSlider(
          value: _currentSliderValue,
          sliderThemeData: TSliderThemeData(
            context: context,
            max: 2000,
            min: -20,
            divisions: 100,
            showThumbValue: true,
            scaleFormatter: (value) => value.toInt().toString(),
          ),
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
