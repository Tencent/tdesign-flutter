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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TestPage(),
    );
  }
}

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TText('TTag 宽度测试'),
      ),
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
        TText('不带宽度测试', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            TTag('1',
              theme: TTagTheme.primary,
              size: TTagSize.medium,
            ),
            TTag('1000',
              theme: TTagTheme.warning,
            ),
            TTag('文本',
              theme: TTagTheme.success,
            ),
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
        TText('基础固定宽度测试', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            TTag('1',
              fixedWidth: 80,
              theme: TTagTheme.primary,
              size: TTagSize.medium,
            ),
            TTag('1000',
              fixedWidth: 80,
              theme: TTagTheme.warning,
            ),
            TTag('文本',
              fixedWidth: 80,
              theme: TTagTheme.success,
            ),
          ],
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildEdgeCaseSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TText('边界情况测试', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        const TTag('超长文本测试超长文本测试超长文本测试超长文本测试',
          fixedWidth: 100,
          theme: TTagTheme.warning,
        ),
        const SizedBox(height: 12),
        const TTag('带关闭按钮',
          fixedWidth: 150,
          needCloseIcon: true,
          theme: TTagTheme.danger,
        ),
        const SizedBox(height: 12),
        TTag('动态宽度',
          fixedWidth: MediaQuery.of(context).size.width * 0.5,
          theme: TTagTheme.success,
        ),
        const SizedBox(height: 12),
        const TTag('极小宽度',
          fixedWidth: 50,
          theme: TTagTheme.primary,
        ),
      ],
    );
  }
}