import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 农历日历示例页面
/// 
/// 展示如何使用 TDCalendar 的农历功能
class TDCalendarLunarExample extends StatefulWidget {
  const TDCalendarLunarExample({Key? key}) : super(key: key);

  @override
  State<TDCalendarLunarExample> createState() => _TDCalendarLunarExampleState();
}

class _TDCalendarLunarExampleState extends State<TDCalendarLunarExample> {
  TDCalendarDateType _dateType = TDCalendarDateType.solar;
  bool _showLunarInfo = false;
  List<int> _selectedDates = [];

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
            child: TDCalendar(
              dateType: _dateType,
              dataSource: _SimpleLunarDataSource(),
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
                child: RadioListTile<TDCalendarDateType>(
                  title: const Text('阳历'),
                  value: TDCalendarDateType.solar,
                  groupValue: _dateType,
                  onChanged: (value) {
                    setState(() {
                      _dateType = value!;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<TDCalendarDateType>(
                  title: const Text('农历'),
                  value: TDCalendarDateType.lunar,
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
            onChanged: _dateType == TDCalendarDateType.solar
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

/// 简单的农历数据源实现（仅用于演示）
/// 
/// 实际项目中建议使用专业的农历转换库，如 lunar
class _SimpleLunarDataSource extends TDCalendarDataSource {
  // 简化的农历数据（仅用于演示）
  // 实际应使用完整的农历算法或查表法
  final Map<String, TDLunarInfo> _mockData = {
    '2025-03-21': TDLunarInfo(
      year: 2025,
      month: 2,
      day: 22,
      yearText: '二〇二五',
      monthText: '二月',
      dayText: '廿二',
    ),
    '2025-04-05': TDLunarInfo(
      year: 2025,
      month: 3,
      day: 7,
      yearText: '二〇二五',
      monthText: '三月',
      dayText: '初七',
    ),
    // 更多日期数据...
  };

  @override
  TDLunarInfo? getLunarInfo(DateTime solarDate) {
    final key = '${solarDate.year}-${solarDate.month.toString().padLeft(2, '0')}-${solarDate.day.toString().padLeft(2, '0')}';
    
    // 从 mock 数据获取，实际应使用算法转换
    if (_mockData.containsKey(key)) {
      return _mockData[key];
    }

    // 返回一个默认值用于演示
    return TDLunarInfo(
      year: solarDate.year,
      month: (solarDate.month + 1) % 12 + 1,
      day: (solarDate.day + 5) % 30 + 1,
      yearText: _convertToChineseNumber(solarDate.year),
      monthText: _getLunarMonthName((solarDate.month + 1) % 12 + 1),
      dayText: _getLunarDayName((solarDate.day + 5) % 30 + 1),
    );
  }

  @override
  String formatDate(
    DateTime date,
    TDCalendarDateType type, [
    TDLunarInfo? lunarInfo,
  ]) {
    if (type == TDCalendarDateType.solar) {
      return '${date.year}年${date.month}月${date.day}日';
    } else {
      if (lunarInfo != null) {
        return '${lunarInfo.yearText}年 ${lunarInfo.monthText}${lunarInfo.dayText}';
      }
      return '${date.year}年${date.month}月${date.day}日';
    }
  }

  String _convertToChineseNumber(int number) {
    const digits = ['〇', '一', '二', '三', '四', '五', '六', '七', '八', '九'];
    return number
        .toString()
        .split('')
        .map((d) => digits[int.parse(d)])
        .join();
  }

  String _getLunarMonthName(int month) {
    const months = ['正月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '冬月', '腊月'];
    return months[(month - 1) % 12];
  }

  String _getLunarDayName(int day) {
    const days = [
      '初一', '初二', '初三', '初四', '初五', '初六', '初七', '初八', '初九', '初十',
      '十一', '十二', '十三', '十四', '十五', '十六', '十七', '十八', '十九', '二十',
      '廿一', '廿二', '廿三', '廿四', '廿五', '廿六', '廿七', '廿八', '廿九', '三十'
    ];
    return days[(day - 1) % 30];
  }
}
