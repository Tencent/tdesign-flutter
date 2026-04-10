import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 农历日历演示页面
/// 这是一个独立的演示页面，展示农历功能的基本用法
class TCalendarLunarDemo extends StatefulWidget {
  const TCalendarLunarDemo({Key? key}) : super(key: key);

  @override
  State<TCalendarLunarDemo> createState() => _TCalendarLunarDemoState();
}

class _TCalendarLunarDemoState extends State<TCalendarLunarDemo> {
  TCalendarDateType _dateType = TCalendarDateType.solar;
  bool _showLunarInfo = false;
  List<int> _selectedDates = [DateTime.now().millisecondsSinceEpoch];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('农历日历演示'),
        backgroundColor: TTheme.of(context).brandNormalColor,
      ),
      body: Column(
        children: [
          // 控制面板
          Container(
            padding: const EdgeInsets.all(16),
            color: TTheme.of(context).grayColor1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '日历模式',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TRadio(
                        id: 'solar',
                        title: '阳历模式',
                        radioStyle: TRadioStyle.circle,
                        showDivider: false,
                        enable: true,
                        checked: _dateType == TCalendarDateType.solar,
                        onChanged: (checked) {
                          if (checked) {
                            setState(() {
                              _dateType = TCalendarDateType.solar;
                            });
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: TRadio(
                        id: 'lunar',
                        title: '农历模式',
                        radioStyle: TRadioStyle.circle,
                        showDivider: false,
                        enable: false, // 暂时禁用，因为需要实现数据源
                        checked: _dateType == TCalendarDateType.lunar,
                        onChanged: (checked) {
                          if (checked) {
                            setState(() {
                              _dateType = TCalendarDateType.lunar;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TSwitch(
                  enable: _dateType == TCalendarDateType.solar,
                  isOn: _showLunarInfo,
                  onChanged: (value) {
                    setState(() {
                      _showLunarInfo = value;
                    });
                  },
                  size: TSwitchSize.large,
                ),
                const SizedBox(height: 4),
                Text(
                  '阳历模式下显示农历副标题',
                  style: TextStyle(
                    fontSize: 14,
                    color: TTheme.of(context).fontGyColor3,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: TTheme.of(context).brandColor1,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '💡 提示',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _dateType == TCalendarDateType.lunar
                            ? '农历模式需要实现 TCalendarDataSource 接口\n请参考 lunar_data_source_example.dart'
                            : _showLunarInfo
                                ? '当前显示阳历日期，下方显示农历信息\n需要实现 TCalendarDataSource 接口'
                                : '当前仅显示阳历日期（默认模式）',
                        style: TextStyle(
                          fontSize: 12,
                          color: TTheme.of(context).fontGyColor3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 日历组件
          Expanded(
            child: TCalendar(
              type: CalendarType.single,
              value: _selectedDates,
              dateType: _dateType,
              // dataSource: null, // 实际使用时需要提供数据源
              showLunarInfo: _showLunarInfo,
              onChange: (dates) {
                setState(() {
                  _selectedDates = dates;
                });
              },
            ),
          ),
          // 选中日期显示
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '已选日期',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedDates.isEmpty
                      ? '未选择'
                      : _formatDate(
                          DateTime.fromMillisecondsSinceEpoch(_selectedDates[0])),
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日';
  }
}
