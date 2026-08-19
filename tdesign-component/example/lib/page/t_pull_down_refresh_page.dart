/*
 * Created by haozhicao@tencent.com on 6/28/22.
 * t_pull_down_refresh_page.dart
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
  final _controller = TPullDownRefreshController();
  var loadingTextsCount = 0;
  var timeoutCount = 0;

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
              builder: _buildRefresh,
            ),
          ],
        ),
        ExampleModule(
          title: '自定义提示语',
          children: [
            ExampleItem(
              desc:
                  'loadingTexts（小程序已有公开 props 的新增 API 演示，Demo 形态仅参考 Mobile Vue）',
              builder: _buildLoadingTexts,
            ),
          ],
        ),
        ExampleModule(
          title: '刷新超时',
          children: [
            ExampleItem(
              desc:
                  'refreshTimeout（小程序已有公开 props 的新增 API 演示，Demo 形态仅参考 Mobile Vue）',
              builder: _buildTimeout,
            ),
          ],
        ),
      ],
    );
  }

  Widget _demoHint(BuildContext context, String message) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.tTheme.bgColorContainer,
        borderRadius: BorderRadius.all(
          Radius.circular(context.tTheme.radiusLarge),
        ),
      ),
      child: TText(
        message,
        font: context.tTheme.fontBodyLarge,
        textColor: context.tTheme.textColorPlaceholder,
      ),
    );
  }

  @ExampleCode(group: 'PullDownRefresh')
  Widget _buildRefresh(BuildContext context) {
    return SizedBox(
      height: 620,
      child: TPullDownRefresh(
        controller: _controller,
        // 下拉刷新回调
        onRefresh: () =>
            Future<void>.delayed(const Duration(milliseconds: 1500)),
        child: _buildOfficialDemoContent(context),
      ),
    );
  }

  Widget _buildOfficialDemoContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 28),
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            const TSkeleton.custom(
              layout: TSkeletonLayout(
                rows: [
                  [
                    TSkeletonBlock(
                      height: 171,
                      style: TSkeletonBlockStyle(borderRadius: 12),
                    ),
                  ],
                ],
              ),
              animation: TSkeletonAnimation.flashed,
            ),
            Positioned(
              top: 76,
              left: 0,
              right: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _controller.refresh,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: TText(
                    PlatformUtil.isWeb ? '点击该区域演示 顶部下拉刷新' : '拖拽该区域演示 顶部下拉刷新',
                    textAlign: TextAlign.center,
                    font: context.tTheme.fontBodyLarge,
                    textColor: context.tTheme.textColorPlaceholder,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        for (var index = 0; index < 3; index++) ...[
          const _PullDownRefreshSkeletonRow(),
          if (index < 2) const SizedBox(height: 16),
        ],
      ],
    );
  }

  @ExampleCode(group: 'PullDownRefresh')
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

  @ExampleCode(group: 'PullDownRefresh')
  Widget _buildTimeout(BuildContext context) {
    return SizedBox(
      height: 300,
      child: TPullDownRefresh(
        refreshTimeout: const Duration(seconds: 1),
        onStateChanged: (state) {
          if (state == TPullDownRefreshState.timeout) {
            TToast.showText('已超时', context: context);
          }
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

class _PullDownRefreshSkeletonRow extends StatelessWidget {
  const _PullDownRefreshSkeletonRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _PullDownRefreshSkeletonCard()),
        SizedBox(width: 16),
        Expanded(child: _PullDownRefreshSkeletonCard()),
      ],
    );
  }
}

class _PullDownRefreshSkeletonCard extends StatelessWidget {
  const _PullDownRefreshSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return const TSkeleton.custom(
      layout: TSkeletonLayout(
        rowSpacing: 8,
        rows: [
          [TSkeletonBlock.line()],
          [TSkeletonBlock.line(flex: 5), TSkeletonBlock.spacer(flex: 3)],
          [
            TSkeletonBlock(
              height: 164,
              style: TSkeletonBlockStyle(borderRadius: 12),
            ),
          ],
        ],
      ),
      animation: TSkeletonAnimation.flashed,
    );
  }
}
