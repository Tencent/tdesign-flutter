import 'package:flutter/material.dart';
// 假设Progress组件在一个单独的文件中
import 'td_progress.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '进度条演示',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(title: '进度条演示主页'),
    );
  }
}

class Home extends StatefulWidget {
  final String title;

  const Home({super.key, required this.title});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TDLabelWidget buttonLabel = const TDTextLabel("0%");
  double progressValue = 0.0;
  Timer? _timer;
  bool isProgressing = false;

  // 新增：用于微型按钮进度条的状态
  bool isPlaying = false;
  double microProgressValue = 0.0;
  Timer? _microTimer;

  @override
  void dispose() {
    _timer?.cancel();
    _microTimer?.cancel();
    super.dispose();
  }

  void _toggleProgress() {
    if (isProgressing) {
      // 暂停进度
      _timer?.cancel();
      setState(() {
        buttonLabel = const TDTextLabel("继续");
        isProgressing = false;
      });
    } else {
      // 开始或继续进度
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() {
          if (progressValue < 1.0) {
            progressValue += 0.01;
            buttonLabel = TDTextLabel("${(progressValue * 100).toInt()}%");
          } else {
            _timer?.cancel();
            buttonLabel = const TDTextLabel("完成");
            isProgressing = false;
          }
        });
      });
      setState(() {
        isProgressing = true;
      });
    }
  }

  void _resetProgress() {
    _timer?.cancel();
    setState(() {
      progressValue = 0.0;
      buttonLabel = const TDTextLabel("开始");
      isProgressing = false;
    });
  }
  // 新增：控制微型按钮进度条的方法
  void _toggleMicroProgress() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      _microTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() {
          if (microProgressValue < 1.0) {
            microProgressValue += 0.01;
          } else {
            _microTimer?.cancel();
            isPlaying = false;
            microProgressValue = 0.0;
          }
        });
      });
    } else {
      _microTimer?.cancel();
    }
  }

  void _resetMicroProgress() {
    _microTimer?.cancel();
    setState(() {
      isPlaying = false;
      microProgressValue = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('自定义百分比进度条')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSection("线性进度条", [
            _buildProgressItem("不确定", const TDProgress(type: TDProgressType.linear, strokeWidth: 5)),
            _buildProgressItem("确定, ≤ 10%", const TDProgress(type: TDProgressType.linear, value: 0.1)),
            _buildProgressItem("确定, > 10%", const TDProgress(type: TDProgressType.linear, value: 0.5)),
            _buildProgressItem("左侧标签, > 10%", const TDProgress(
                type: TDProgressType.linear, value: 0.5, progressLabelPosition: TDProgressLabelPosition.left)),
            _buildProgressItem("自定义标签", const TDProgress(type: TDProgressType.linear, value: 0.5, label: TDTextLabel("百分之50"))),
            _buildProgressItem("右侧标签, > 10%", const TDProgress(
                type: TDProgressType.linear, value: 0.5, progressLabelPosition: TDProgressLabelPosition.right)),
            _buildProgressItem("警告状态", const TDProgress(type: TDProgressType.linear, value: 0.5, progressStatus: TDProgressStatus.warning)),
            _buildProgressItem("危险状态, 外部标签", const TDProgress(
                type: TDProgressType.linear,
                value: 0.5,
                progressStatus: TDProgressStatus.danger,
                progressLabelPosition: TDProgressLabelPosition.right)),
          ]),
          _buildSection("圆形进度条", [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TDProgress(type: TDProgressType.circular),
                TDProgress(type: TDProgressType.circular, value: 0.5),
                TDProgress(
                    type: TDProgressType.circular, value: 0.5, progressStatus: TDProgressStatus.success),
                TDProgress(
                    type: TDProgressType.circular, value: 0.7, progressStatus: TDProgressStatus.warning),
              ],
            ),
          ]),
          _buildSection("微型进度条", [
            const TDProgress(type: TDProgressType.micro, value: 0.3),
          ]),
          _buildSection("微型按钮进度条", [
            Row(
                children: [
                  TDProgress(type: TDProgressType.micro, value: 0.3, onTap: (){}, label: const TDIconLabel(Icons.play_arrow, color: Colors.blue)),
                  const SizedBox(width: 10),
                  TDProgress(type: TDProgressType.micro, value: 0.3, onTap: (){}, label: const TDIconLabel(Icons.pause, color: Colors.blue)),
                  const SizedBox(width: 10),
                  TDProgress(type: TDProgressType.micro, value: 0.3, onTap: (){}, label: const TDIconLabel(Icons.stop, color: Colors.blue))
                ]
            )
          ]),
          _buildSection("交互式微型按钮进度条", [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TDProgress(
                  type: TDProgressType.micro,
                  value: microProgressValue,
                  onTap: _toggleMicroProgress,
                  label: TDIconLabel(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.blue),
                ),
                const SizedBox(width: 10),
                TDProgress(
                  type: TDProgressType.micro,
                  value: microProgressValue,
                  onTap: _resetMicroProgress,
                  label: const TDIconLabel(Icons.stop, color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('点击播放/暂停，点击停止重置进度', style: Theme.of(context).textTheme.bodyMedium),
          ]),
          _buildSection("按钮进度条", [
            TDProgress(
              type: TDProgressType.button,
              onTap: _toggleProgress,
              onLongPress: _resetProgress,
              value: progressValue,
              label: buttonLabel,
            ),
            const SizedBox(height: 10),
            Text('点击开始/暂停进度，长按重置进度', style: Theme.of(context).textTheme.bodyMedium),
          ])
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        ...children,
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildProgressItem(String label, Widget progressWidget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 5),
        progressWidget,
        const SizedBox(height: 15),
      ],
    );
  }
}