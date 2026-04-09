import 'package:flutter/material.dart';
import 'page/td_calendar_lunar_test.dart';

/// 农历日历功能快速测试入口
/// 
/// 运行方式：
/// cd /Users/JamesLiauw/Works/WorksMobile/tdesign-flutter/tdesign-component/example
/// ~/flutter/bin/flutter run -d chrome lib/lunar_test_main.dart
void main() {
  runApp(const LunarTestApp());
}

class LunarTestApp extends StatelessWidget {
  const LunarTestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '农历日历测试',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TCalendarLunarTest(),
    );
  }
}
