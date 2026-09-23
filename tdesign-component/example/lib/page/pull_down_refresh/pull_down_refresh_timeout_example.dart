import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'PullDownRefresh')
class PullDownRefreshTimeoutExample extends StatefulWidget {
  const PullDownRefreshTimeoutExample({super.key});

  @override
  State<PullDownRefreshTimeoutExample> createState() =>
      _PullDownRefreshTimeoutExampleState();
}

class _PullDownRefreshTimeoutExampleState
    extends State<PullDownRefreshTimeoutExample> {
  Widget _buildTimeout(BuildContext context) {
    return SizedBox(
      height: 300,
      child: TPullDownRefresh(
        refreshTimeout: const Duration(seconds: 1),
        onStateChanged: (state) {
          if (state == TPullDownRefreshState.timeout) {
            setState(() => _timeoutCount++);
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
            _demoHint(context, '超时刷新次数：$_timeoutCount'),
          ],
        ),
      ),
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
        textColor: context.tTheme.textColorSecondary,
      ),
    );
  }

  var _timeoutCount = 0;

  @override
  Widget build(BuildContext context) {
    return _buildTimeout(context);
  }
}
