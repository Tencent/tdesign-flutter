import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../lunar_data_source_example.dart';

/// 农历日历功能快速测试页面
class TDCalendarLunarTest extends StatefulWidget {
  const TDCalendarLunarTest({Key? key}) : super(key: key);

  @override
  State<TDCalendarLunarTest> createState() => _TDCalendarLunarTestState();
}

class _TDCalendarLunarTestState extends State<TDCalendarLunarTest> {
  bool _showLunarInfo = true;
  final _dataSource = LunarDataSourceExample();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '农历日历测试',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0052D9),
      ),
      body: Column(
        children: [
          // 快速切换
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '显示农历信息',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: _showLunarInfo,
                  onChanged: (value) {
                    setState(() {
                      _showLunarInfo = value;
                    });
                  },
                  activeColor: const Color(0xFF0052D9),
                ),
              ],
            ),
          ),
          
          // 提示信息
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F3FF),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFF0052D9).withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFF0052D9), size: 20),
                    SizedBox(width: 8),
                    Text(
                      '功能说明',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0052D9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _showLunarInfo
                      ? '✅ 农历信息已启用\n每个日期下方会显示对应的农历日期'
                      : '❌ 农历信息已关闭\n仅显示阳历日期（默认模式）',
                  style: const TextStyle(fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),

          // 日历组件
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TDCalendar(
                type: CalendarType.single,
                dateType: TDCalendarDateType.solar,
                dataSource: _dataSource,
                showLunarInfo: _showLunarInfo,
                cellHeight: _showLunarInfo ? 80 : 60, // 增加到 80 以完全避免溢出
                value: [DateTime.now().millisecondsSinceEpoch],
                onChange: (dates) {
                  if (dates.isNotEmpty) {
                    final date = DateTime.fromMillisecondsSinceEpoch(dates[0]);
                    final lunarInfo = _dataSource.getLunarInfo(date);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '选中日期：\n'
                          '阳历：${date.year}年${date.month}月${date.day}日\n'
                          '农历：${lunarInfo?.yearText ?? ""}年${lunarInfo?.monthText ?? ""}${lunarInfo?.dayText ?? ""}',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
