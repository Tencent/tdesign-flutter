import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() async {
  runApp(const StepTestApp());
}

class StepTestApp extends StatelessWidget {
  const StepTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Step Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TestPage(),
    );
  }
}

class TestPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 创建水平步骤条的数据
    List<TStepsItemData> horizontalSteps = [
      TStepsItemData(title: 'Step 1', content: 'Horizontal Step 1'),
      TStepsItemData(title: 'Step 2', content: 'Horizontal Step 2'),
      TStepsItemData(title: 'Step 3', content: 'Horizontal Step 3'),
    ];

    // 创建垂直步骤条的数据
    List<TStepsItemData> verticalSteps = [
      TStepsItemData(
        title: '2025-01-11',
        content: '今天是星期六',
        customContent: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TText(
              '今天是星期六，下面是拍摄的照片',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: TTheme.of(context).fontGyColor3,
                fontSize: 12,
              ),
            ),
            Image.asset('assets/img/image.png', width: 100, height: 100),
          ],
        ),
      ),
      TStepsItemData(title: '2025-01-12', content: '今天是星期天'),
      TStepsItemData(content: '今天是星期一'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const TText('TSteps Test Page'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // 水平步骤条
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TSteps(
                  steps: horizontalSteps,
                  activeIndex: 1, // 设置当前激活的步骤索引
                  direction: TStepsDirection.horizontal, // 设置步骤条方向为水平
                  status: TStepsStatus.success, // 设置步骤条状态
                ),
              ),
            ),
            // 垂直步骤条
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TSteps(
                  steps: verticalSteps,
                  activeIndex: 1, // 设置当前激活的步骤索引
                  direction: TStepsDirection.vertical, // 设置步骤条方向为垂直
                  status: TStepsStatus.success, // 设置步骤条状态
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
