import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() => runApp(const ConfirmDialogTestApp());

class ConfirmDialogTestApp extends StatelessWidget {
  const ConfirmDialogTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TPopup 测试示例',
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
  void _showProblemDialog() {
    TPopup.show(
      context,
      options: TPopupOptions.bottom(
        headerBuilder: (_, __) => const TPopupHeader(title: TText('title')),
        radius: 20,
        backgroundColor: const Color(0xFFFAFFFC),
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 33),
          decoration: const BoxDecoration(color: Colors.white),
          child: const Column(children: [Center(child: Text('立即拨打'))]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TPopup测试')),
      body: Center(
        child: TButton(
          child: const Text('显示问题弹窗'),
          onPressed: _showProblemDialog,
        ),
      ),
    );
  }
}
