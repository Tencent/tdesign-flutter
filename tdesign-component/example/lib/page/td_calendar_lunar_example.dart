import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../lunar_data_source_example.dart';

/// 农历日历示例页面
/// 
/// 展示如何使用 TCalendar 的农历功能
class TCalendarLunarExample extends StatefulWidget {
  const TCalendarLunarExample({Key? key}) : super(key: key);

  @override
  State<TCalendarLunarExample> createState() => _TCalendarLunarExampleState();
}

class _TCalendarLunarExampleState extends State<TCalendarLunarExample> {
  TCalendarDateType _dateType = TCalendarDateType.solar;
  bool _showLunarInfo = true; // 默认显示农历信息
  List<int> _selectedDates = [];
  final _dataSource = LunarDataSourceExample();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('农历日历示例'),
      ),
      body: Column(
        children: [
          // 控制面板
          _buildControlPanel(),
          
          // 日历组件
          Expanded(
            child: TCalendar(
              dateType: _dateType,
              dataSource: _dataSource,
              showLunarInfo: _showLunarInfo,
              value: _selectedDates,
              onChange: (dates) {
                setState(() {
                  _selectedDates = dates;
                });
              },
            ),
          ),
          
          // 选中日期显示
          _buildSelectedInfo(),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '日历类型:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: RadioListTile<TCalendarDateType>(
                  title: const Text('阳历'),
                  value: TCalendarDateType.solar,
                  groupValue: _dateType,
                  onChanged: (value) {
                    setState(() {
                      _dateType = value!;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<TCalendarDateType>(
                  title: const Text('农历'),
                  value: TCalendarDateType.lunar,
                  groupValue: _dateType,
                  onChanged: (value) {
                    setState(() {
                      _dateType = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('阳历模式下显示农历信息'),
            value: _showLunarInfo,
            onChanged: _dateType == TCalendarDateType.solar
                ? (value) {
                    setState(() {
                      _showLunarInfo = value;
                    });
                  }
                : null,
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildSelectedInfo() {
    if (_selectedDates.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Text('请选择日期'),
      );
    }

    final date = DateTime.fromMillisecondsSinceEpoch(_selectedDates.first);
    final dataSource = _SimpleLunarDataSource();
    final lunarInfo = dataSource.getLunarInfo(date);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '已选择日期：',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text('阳历：${date.year}年${date.month}月${date.day}日'),
          if (lunarInfo != null)
            Text('农历：${lunarInfo.yearText}年 ${lunarInfo.monthText}${lunarInfo.dayText}'),
        ],
      ),
    );
  }
}
