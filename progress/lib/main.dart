import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import './progress.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: Home(title: 'Flutter Demo Home Page'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('自定义百分比进度条')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSection("线形进度条", [
            _buildProgressItem("无确定值", Progress.linear(strokeWidth: 5)),
            _buildProgressItem("有确定值,小于等于10%", Progress.linear(value: 0.1)),
            _buildProgressItem("有确定值，大于10%", Progress.linear(value: 0.5)),
            _buildProgressItem("label靠左，大于10%", Progress.linear(
                value: 0.5, progressLabelPosition: ProgressLabelPosition.left)),
            _buildProgressItem("自定义label", Progress.linear(value: 0.5, label: TextLabel("百分之50"))),
            _buildProgressItem("label靠右，大于10%", Progress.linear(
                value: 0.5, progressLabelPosition: ProgressLabelPosition.right)),
            _buildProgressItem("更改status", Progress.linear(value: 0.5, progressStatus: ProgressStatus.warning)),
            _buildProgressItem("更改status,且Label在外", Progress.linear(
                value: 0.5,
                progressStatus: ProgressStatus.danger,
                progressLabelPosition: ProgressLabelPosition.right)),
          ]),
          _buildSection("环形进度条", [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Progress.circular(),
                Progress.circular(value: 0.5),
                Progress.circular(
                    value: 0.5, progressStatus: ProgressStatus.success),
                Progress.circular(
                    value: 0.7, progressStatus: ProgressStatus.warning),
              ],
            ),
          ]),
          _buildSection("微型进度条", [
            Progress.micro(value: 0.3, label: const IconLabel(TDIcons.arrow_down)),
          ]),
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