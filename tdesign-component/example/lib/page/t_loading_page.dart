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
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '纯图标',
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              builder: _buildPureIconLoading,
            ),
            ExampleItem(
              desc: '图标加文字横向',
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              builder: _buildTextIconHorizontalLoading,
            ),
            ExampleItem(
              desc: '图标加文字竖向',
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              builder: _buildTextIconVerticalLoading,
            ),
            ExampleItem(
              desc: '纯文字',
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              builder: _buildPureTextLoading,
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
              builder: _buildLoadingSizes,
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
              builder: _buildCustomSpeedLoading,
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
  @ExampleCode(group: 'loading')
  Widget _buildPureIconLoading(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const TLoading(icon: TLoadingIcon.circle),
        const SizedBox(width: 40),
        const TLoading(icon: TLoadingIcon.activity),
        const SizedBox(width: 40),
        Theme(
          data: Theme.of(context).mergeExtension(
            TLoadingThemeData(iconColor: context.tTheme.brandNormalColor),
          ),
          child: const TLoading(size: 40, icon: TLoadingIcon.point),
        ),
        const SizedBox(width: 40),
        Theme(
          data: Theme.of(context).mergeExtension(
            TLoadingThemeData(iconColor: context.tTheme.brandNormalColor),
          ),
          child: const TLoading(
            customIcon: Image(
              image: AssetImage('assets/img/loading-logo2.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  /// 图标加文字横向
  @ExampleCode(group: 'loading')
  Widget _buildTextIconHorizontalLoading(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Theme(
          data: Theme.of(
            context,
          ).mergeExtension(const TLoadingThemeData(axis: Axis.horizontal)),
          child: const TLoading(icon: TLoadingIcon.circle, text: '加载中...'),
        ),
        const SizedBox(width: 64),
        Theme(
          data: Theme.of(
            context,
          ).mergeExtension(const TLoadingThemeData(axis: Axis.horizontal)),
          child: const TLoading(icon: TLoadingIcon.activity, text: '加载中...'),
        ),
      ],
    );
  }

  /// 图标加文字竖向
  @ExampleCode(group: 'loading')
  Widget _buildTextIconVerticalLoading(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Theme(
          data: Theme.of(
            context,
          ).mergeExtension(const TLoadingThemeData(axis: Axis.vertical)),
          child: const TLoading(icon: TLoadingIcon.circle, text: '加载中'),
        ),
        const SizedBox(width: 64),
        Theme(
          data: Theme.of(
            context,
          ).mergeExtension(const TLoadingThemeData(axis: Axis.vertical)),
          child: const TLoading(icon: TLoadingIcon.activity, text: '加载中'),
        ),
      ],
    );
  }

  /// 纯文字
  @ExampleCode(group: 'loading')
  Widget _buildPureTextLoading(BuildContext context) =>
      const TLoading(icon: null, text: '加载中...');

  /// 组件尺寸
  @ExampleCode(group: 'loading')
  Widget _buildLoadingSizes(BuildContext context) {
    Widget loading(double size) => Theme(
      data: Theme.of(
        context,
      ).mergeExtension(const TLoadingThemeData(axis: Axis.horizontal)),
      child: TLoading(size: size, icon: TLoadingIcon.circle, text: '加载中...'),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        loading(32),
        const SizedBox(height: 24),
        const Text('中尺寸'),
        const SizedBox(height: 16),
        loading(28),
        const SizedBox(height: 24),
        const Text('小尺寸'),
        const SizedBox(height: 16),
        loading(24),
      ],
    );
  }

  double _currentSliderValue = 800;

  /// 加载速度
  @ExampleCode(group: 'loading')
  Widget _buildCustomSpeedLoading(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Theme(
          data: Theme.of(context).mergeExtension(
            TLoadingThemeData(
              axis: Axis.horizontal,
              duration: (2000 - _currentSliderValue).round(),
            ),
          ),
          child: const TLoading(
            size: 26,
            icon: TLoadingIcon.circle,
            text: '加载中...',
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            const min = 100.0;
            const max = 1500.0;
            const trackInset = 24.0;
            const labelWidth = 48.0;
            final progress = (_currentSliderValue - min) / (max - min);
            final trackWidth = constraints.maxWidth - trackInset * 2;
            final thumbCenter = trackInset + trackWidth * progress;
            final labelLeft = (thumbCenter - labelWidth / 2).clamp(
              0.0,
              constraints.maxWidth - labelWidth,
            );
            return SizedBox(
              height: 64,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: labelLeft,
                    width: labelWidth,
                    child: Text(
                      '${_currentSliderValue.round()}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: TSlider(
                      value: _currentSliderValue,
                      min: min,
                      max: max,
                      divisions: 100,
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
