import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() async {
  runApp(const TagTestApp());
}

class TagTestApp extends StatelessWidget {
  const TagTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TTag 宽度测试',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TestPage(),
    );
  }
}

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const TText('TTag 宽度测试')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(context),
            _buildFixedWidthSection(context),
            _buildEdgeCaseSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TText(
          '不带宽度测试',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            TTag(
              '1',
              colorPreset: TTagColorPreset.primary,
              size: TTagSize.medium,
            ),
            TTag('1000', colorPreset: TTagColorPreset.warning),
            TTag('文本', colorPreset: TTagColorPreset.success),
          ],
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildFixedWidthSection(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TText(
          '基础固定宽度测试',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            TTag(
              '1',
              colorPreset: TTagColorPreset.primary,
              size: TTagSize.medium,
            ),
            TTag('1000', colorPreset: TTagColorPreset.warning),
            TTag('文本', colorPreset: TTagColorPreset.success),
          ],
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildEdgeCaseSection(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TText(
          '边界情况测试',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        TTag('超长文本测试超长文本测试超长文本测试超长文本测试', colorPreset: TTagColorPreset.warning),
        SizedBox(height: 12),
        TTag('带关闭按钮', colorPreset: TTagColorPreset.danger),
        SizedBox(height: 12),
        TTag('动态宽度', colorPreset: TTagColorPreset.success),
        SizedBox(height: 12),
        TTag('极小宽度', colorPreset: TTagColorPreset.primary),
      ],
    );
  }
}
