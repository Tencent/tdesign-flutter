import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() => runApp(const ConfirmDialogTestApp());

class ConfirmDialogTestApp extends StatelessWidget {
  const ConfirmDialogTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'confirmDialog 测试示例',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TestPage(),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final TextEditingController _searchNameController = TextEditingController();
  final TextEditingController _searchRemarkController = TextEditingController();

  void _showProblemDialog() {
    showDialog(
      context: context,
      builder: (context) => TDConfirmDialog(
        title: '搜索设备',
        contentWidget: Column(
          children: [
            TDInput(
              leftIcon: const Icon(TDIcons.device),
              controller: _searchNameController,
              hintText: '设备名称',
            ),
            TDInput(
              leftIcon: const Icon(TDIcons.pen_quill),
              controller: _searchRemarkController,
              hintText: '设备备注',
            ),
          ],
        ),
        buttonText: '确认',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TDConfirmDialog测试')),
      body: Center(
        child: TDButton(
          child: const Text('显示问题弹窗'),
          onTap: _showProblemDialog,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchNameController.dispose();
    _searchRemarkController.dispose();
    super.dispose();
  }
}