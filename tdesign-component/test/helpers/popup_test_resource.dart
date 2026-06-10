import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// Popup 测试用文案资源：仅覆盖 cancel / confirm，其余与库内默认中文一致。
class PopupTestResourceDelegate extends TResourceDelegate {
  PopupTestResourceDelegate({
    required this.cancelText,
    required this.confirmText,
    required this.locale,
    String yearLabel = '年',
    String monthLabel = '月',
    String dateLabel = '日',
    String hours = '时',
    String minutes = '分',
    String seconds = '秒',
    String weeksLabel = '周',
    String monday = '一',
    String tuesday = '二',
    String wednesday = '三',
    String thursday = '四',
    String friday = '五',
    String saturday = '六',
    String sunday = '日',
  })  : _yearLabel = yearLabel,
        _monthLabel = monthLabel,
        _dateLabel = dateLabel,
        _hours = hours,
        _minutes = minutes,
        _seconds = seconds,
        _weeksLabel = weeksLabel,
        _monday = monday,
        _tuesday = tuesday,
        _wednesday = wednesday,
        _thursday = thursday,
        _friday = friday,
        _saturday = saturday,
        _sunday = sunday;

  factory PopupTestResourceDelegate.zh() => PopupTestResourceDelegate(
        cancelText: '取消',
        confirmText: '确定',
        locale: const Locale('zh'),
      );

  factory PopupTestResourceDelegate.en() => PopupTestResourceDelegate(
        cancelText: 'Cancel',
        confirmText: 'Confirm',
        locale: const Locale('en'),
        yearLabel: 'y',
        monthLabel: 'm',
        dateLabel: 'd',
        hours: 'h',
        minutes: 'min',
        seconds: 's',
        weeksLabel: 'w',
        monday: 'MON',
        tuesday: 'TUE',
        wednesday: 'WED',
        thursday: 'THU',
        friday: 'FRI',
        saturday: 'SAT',
        sunday: 'SUN',
      );

  final String cancelText;
  final String confirmText;
  final Locale locale;
  final String _yearLabel;
  final String _monthLabel;
  final String _dateLabel;
  final String _hours;
  final String _minutes;
  final String _seconds;
  final String _weeksLabel;
  final String _monday;
  final String _tuesday;
  final String _wednesday;
  final String _thursday;
  final String _friday;
  final String _saturday;
  final String _sunday;

  @override
  String get cancel => cancelText;

  @override
  String get confirm => confirmText;

  @override
  String get open => '开';

  @override
  String get close => '关';

  @override
  String get badgeZero => '0';

  @override
  String get other => '其它';

  @override
  String get reset => '重置';

  @override
  String get loading => '加载中';

  @override
  String get loadingWithPoint => '加载中...';

  @override
  String get knew => '知道了';

  @override
  String get refreshing => '正在刷新';

  @override
  String get releaseRefresh => '松开刷新';

  @override
  String get pullToRefresh => '下拉刷新';

  @override
  String get completeRefresh => '刷新完成';

  @override
  String get days => '天';

  @override
  String get hours => _hours;

  @override
  String get minutes => _minutes;

  @override
  String get seconds => _seconds;

  @override
  String get milliseconds => '毫秒';

  @override
  String get yearLabel => _yearLabel;

  @override
  String get monthLabel => _monthLabel;

  @override
  String get dateLabel => _dateLabel;

  @override
  String get weeksLabel => _weeksLabel;

  @override
  String get sunday => _sunday;

  @override
  String get monday => _monday;

  @override
  String get tuesday => _tuesday;

  @override
  String get wednesday => _wednesday;

  @override
  String get thursday => _thursday;

  @override
  String get friday => _friday;

  @override
  String get saturday => _saturday;

  @override
  String get year => ' 年';

  @override
  String get january => '1 月';

  @override
  String get february => '2 月';

  @override
  String get march => '3 月';

  @override
  String get april => '4 月';

  @override
  String get may => '5 月';

  @override
  String get june => '6 月';

  @override
  String get july => '7 月';

  @override
  String get august => '8 月';

  @override
  String get september => '9 月';

  @override
  String get october => '10 月';

  @override
  String get november => '11 月';

  @override
  String get december => '12 月';

  @override
  String get time => '时间';

  @override
  String get start => '开始';

  @override
  String get end => '结束';

  @override
  String get notRated => '未评分';

  @override
  String get cascadeLabel => '选择选项';

  @override
  String get back => '返回';

  @override
  String get top => '顶部';

  @override
  String get emptyData => '暂无数据';

  @override
  String get picker => '选择器';

  @override
  String pickerColumn(int colIndex) => '第 $colIndex 列';
}

/// 在测试中注入 [resource]；与业务侧 `TTheme.setResourceBuilder` 用法一致。
void bindPopupTestResource(PopupTestResourceDelegate resource) {
  TTheme.setResourceBuilder((_) => resource, needAlwaysBuild: true);
}

/// 恢复为库内默认资源（中文 cancel/confirm）。
void resetPopupTestResource() {
  TTheme.setResourceBuilder((_) => null, needAlwaysBuild: false);
}
