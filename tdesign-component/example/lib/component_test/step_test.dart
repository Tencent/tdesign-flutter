import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() async {
  runApp(StepTestApp());
}

class StepTestApp extends StatelessWidget {
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
  @override
  Widget build(BuildContext context) {
    // 创建水平步骤条的数据
    List<TDStepsItemData> horizontalSteps = [
      TDStepsItemData(title: Text('Step 1'), content: Text('Horizontal Step 1')),
      TDStepsItemData(title: Text('Step 2'), content: Text('Horizontal Step 2')),
      TDStepsItemData(title: Text('Step 3'), content: Text('Horizontal Step 3')),
    ];

    // 创建垂直步骤条的数据
    List<TDStepsItemData> verticalSteps = [
      TDStepsItemData(
        title: Text('2024-12-28'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 隐藏内容 实际可以展示Text
            Text('今天是星期六，下面是拍摄的照片'),
            Image.asset('assets/img/image.png', width: 100, height: 100),
          ],
        ),
      ),
      TDStepsItemData(title: Text('2024-12-29'), content: Text('今天是星期天')),
      TDStepsItemData(title: Text('2024-12-30'), content: Text('')),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('TDSteps Test Page'),
      ),
      body: Column(
        children: [
          // 水平步骤条
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TDSteps(
                steps: horizontalSteps,
                activeIndex: 1, // 设置当前激活的步骤索引
                direction: TDStepsDirection.horizontal, // 设置步骤条方向为水平
                status: TDStepsStatus.success, // 设置步骤条状态
              ),
            ),
          ),
          // 垂直步骤条
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TDSteps(
                steps: verticalSteps,
                activeIndex: 1, // 设置当前激活的步骤索引
                direction: TDStepsDirection.vertical, // 设置步骤条方向为垂直
                status: TDStepsStatus.success, // 设置步骤条状态
              ),
            ),
          ),
        ],
      ),
    );
  }
}