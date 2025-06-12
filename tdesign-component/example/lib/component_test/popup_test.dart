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

    Navigator.of(context).push(
      TDSlidePopupRoute(
        slideTransitionFrom: SlideTransitionFrom.bottom,
        builder: (context) {
          return TDPopupBottomDisplayPanel(
            title: "title",
            radius: 20,
            backgroundColor: Color(0xFFFAFFFC),
            closeClick: () {
              Navigator.maybePop(context);
            },
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 33),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  Center(
                    child: Text("立即拨打"),
                  ),
                ],
              ),
            ),
          );
        },
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