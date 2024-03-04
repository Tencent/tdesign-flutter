import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

///
/// TDProgressPage演示
///
class TDProgressPage extends StatefulWidget {
  const TDProgressPage({super.key});

  @override
  State<TDProgressPage> createState() => _TDProgressPageState();
}

class _TDProgressPageState extends State<TDProgressPage> {
  double percentage = 88;

  @override
  Widget build(BuildContext context) {
    var current = ExamplePage(title: tdTitle(), exampleCodeGroup: 'progress', desc: '用于展示任务当前的进度。', children: [
      ExampleModule(
        title: '组件类型',
        children: [
          ExampleItem(desc: '基础进度条', builder: _buildProgressWithBase),
          ExampleItem(desc: '过渡样式', builder: _buildTransition),
          ExampleItem(desc: '自定义颜色/圆角', builder: _buildCustomColorAndRadius),
        ],
      ),
      ExampleModule(title: '组件状态', children: [
        ExampleItem(desc: '线性进度条', builder: _buildLineStatus),
        ExampleItem(desc: '线性运动状态/渐变色', builder: _buildLineActionAndGradient),
        ExampleItem(desc: '百分比内显进度条', builder: _buildPlumpStatus),
        ExampleItem(desc: '环形进度条', builder: _buildCircleStatus),
        ExampleItem(desc: '不同尺寸', builder: _buildCircleSize),
      ]),
    ]);
    return current;
  }

  @Demo(group: 'progress')
  Widget _buildProgressWithBase(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TDProgress(
            percentage: 80,
            theme: TDProgressTheme.line,
          ),
          SizedBox(height: 8),
          TDProgress(
            percentage: 80,
            theme: TDProgressTheme.plump,
          ),
          SizedBox(height: 8),
          TDProgress(
            percentage: 30,
            theme: TDProgressTheme.circle,
          ),
        ],
      ),
    );
  }

  @Demo(group: 'progress')
  Widget _buildTransition(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TDProgress(
            percentage: percentage,
            theme: TDProgressTheme.line,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TDButton(
                text: '减少',
                size: TDButtonSize.small,
                type: TDButtonType.outline,
                shape: TDButtonShape.rectangle,
                theme: TDButtonTheme.primary,
                onTap: () => setState(() {
                  percentage = max(percentage - 10, 0);
                }),
              ),
              const SizedBox(width: 8),
              TDButton(
                text: '增加',
                size: TDButtonSize.small,
                type: TDButtonType.fill,
                shape: TDButtonShape.rectangle,
                theme: TDButtonTheme.primary,
                onTap: () => setState(() {
                  percentage = min(percentage + 10, 100);
                }),
              ),
            ],
          )
        ],
      ),
    );
  }

  @Demo(group: 'progress')
  Widget _buildCustomColorAndRadius(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TDProgress(
            percentage: 88,
            textStyle: const TextStyle(color: Colors.purpleAccent),
            color: const [Colors.purpleAccent],
            trackColor: Colors.purpleAccent.withOpacity(0.2),
          ),
          const TDProgress(
            percentage: 88,
            strokeCap: StrokeCap.square,
          ),
        ],
      ),
    );
  }

  @Demo(group: 'progress')
  Widget _buildLineStatus(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TDProgress(percentage: 80),
          SizedBox(height: 8),
          TDProgress(percentage: 80, status: TDProgressStatus.warning),
          SizedBox(height: 8),
          TDProgress(percentage: 80, status: TDProgressStatus.error),
          SizedBox(height: 8),
          TDProgress(percentage: 80, status: TDProgressStatus.success),
        ],
      ),
    );
  }

  @Demo(group: 'progress')
  Widget _buildLineActionAndGradient(BuildContext context){
    return  Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TDProgress(percentage: 80, status: TDProgressStatus.active),
          SizedBox(height: 8),
          TDProgress(
            color: [Color.fromRGBO(0, 82, 217, 1), Color(0xFF00A870)],
            percentage: 80,
            status: TDProgressStatus.active,
          ),
        ],
      ),
    );
  }

  @Demo(group: 'progress')
  Widget _buildPlumpStatus(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TDProgress(percentage: 80, theme: TDProgressTheme.plump),
          SizedBox(height: 8),
          TDProgress(percentage: 88, theme: TDProgressTheme.plump, status: TDProgressStatus.warning),
          SizedBox(height: 8),
          TDProgress(percentage: 88, theme: TDProgressTheme.plump, status: TDProgressStatus.error),
          SizedBox(height: 8),
          TDProgress(percentage: 88, theme: TDProgressTheme.plump, status: TDProgressStatus.success),
        ],
      ),
    );
  }

  @Demo(group: 'progress')
  Widget _buildCircleStatus(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(),
          TDProgress(percentage: 80, theme: TDProgressTheme.circle),
          SizedBox(height: 8),
          TDProgress(percentage: 80, theme: TDProgressTheme.circle, status: TDProgressStatus.warning),
          SizedBox(height: 8),
          TDProgress(percentage: 80, theme: TDProgressTheme.circle, status: TDProgressStatus.error),
          SizedBox(height: 8),
          TDProgress(percentage: 80, theme: TDProgressTheme.circle, status: TDProgressStatus.success),
        ],
      ),
    );
  }

  @Demo(group: 'progress')
  Widget _buildCircleSize(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TDProgress(percentage: 30, theme: TDProgressTheme.circle, size: TDProgressSize.small),
          SizedBox(width: 8),
          TDProgress(percentage: 30, theme: TDProgressTheme.circle, size: TDProgressSize.medium),
          SizedBox(width: 8),
          TDProgress(percentage: 75, theme: TDProgressTheme.circle, size: TDProgressSize.large),
        ],
      ),
    );
  }
}
