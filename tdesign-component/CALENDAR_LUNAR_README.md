# TCalendar 农历支持功能

## 概述

本功能为 TCalendar 组件增加了对农历（阴历）的支持，允许用户在阳历和农历之间切换显示，并可在阳历模式下同时显示农历信息。

## 设计原则

- **数据与视图分离**：组件内部不包含农历算法和数据，完全依赖外部数据源
- **扩展性强**：通过抽象接口 `TCalendarDataSource`，开发者可自由选择任何农历转换库
- **向后兼容**：不影响现有 API，新功能为可选参数
- **轻量化**：保持组件库的轻量，避免内置大量数据文件

## 核心 API

### 1. TCalendarDateType (枚举)

日历显示类型：

```dart
enum TCalendarDateType {
  solar,  // 阳历（公历）
  lunar,  // 阴历（农历）
}
```

### 2. TLunarInfo (模型)

农历日期信息模型：

```dart
class TLunarInfo {
  final int year;           // 农历年份（数字）
  final int month;          // 农历月份（1-12）
  final int day;            // 农历日期（1-30）
  final bool isLeapMonth;   // 是否闰月
  final String yearText;    // 年份文本（如：二〇二五）
  final String monthText;   // 月份文本（如：三月、闰三月）
  final String dayText;     // 日期文本（如：初七）
  
  String get fullText;      // 完整文本：二〇二五年 三月初七
}
```

### 3. TCalendarDataSource (抽象接口)

数据源接口，开发者需要实现此接口来提供农历转换能力：

```dart
abstract class TCalendarDataSource {
  /// 获取指定阳历日期的农历信息
  TLunarInfo? getLunarInfo(DateTime solarDate);
  
  /// 格式化日期文本
  String formatDate(DateTime date, TCalendarDateType type, [TLunarInfo? lunarInfo]);
  
  /// 获取节气信息（可选）
  String? getSolarTerm(DateTime date);
  
  /// 获取节日信息（可选）
  String? getFestival(DateTime date, [TLunarInfo? lunarInfo]);
  
  /// 格式化年份/月份/日期文本（已提供默认实现）
  String formatYear(int year, TCalendarDateType type);
  String formatMonth(int month, TCalendarDateType type, [bool isLeapMonth = false]);
  String formatDay(int day, TCalendarDateType type);
}
```

### 4. TCalendar 新增参数

```dart
TCalendar(
  // 新增参数
  dateType: TCalendarDateType.solar,      // 日历显示类型（默认阳历）
  dataSource: myDataSource,                 // 外部数据源
  showLunarInfo: false,                     // 阳历模式下是否显示农历副标题
  
  // 原有参数...
  type: CalendarType.single,
  onChange: (dates) { },
  // ...
)
```

## 使用方法

### 基础用法（仅阳历）

不提供 `dataSource`，功能与原有 API 完全一致：

```dart
TCalendar(
  type: CalendarType.single,
  onChange: (dates) {
    print('选择了：$dates');
  },
)
```

### 阳历模式下显示农历信息

```dart
TCalendar(
  dateType: TCalendarDateType.solar,     // 阳历模式
  dataSource: MyLunarDataSource(),         // 提供数据源
  showLunarInfo: true,                     // 显示农历作为副标题
  onChange: (dates) {
    print('选择了：$dates');
  },
)
```

效果：
```
┌─────┐
│  7  │  <- 阳历（主显示）
│ 初七 │  <- 农历（副标题）
└─────┘
```

### 农历模式

```dart
TCalendar(
  dateType: TCalendarDateType.lunar,     // 农历模式
  dataSource: MyLunarDataSource(),
  onChange: (dates) {
    print('选择了：$dates');
  },
)
```

效果：
```
┌─────┐
│ 初七 │  <- 农历（主显示）
│  7  │  <- 阳历（副显示）
└─────┘
```

## 实现数据源

### 方案一：使用第三方库（推荐）

使用 [lunar](https://pub.dev/packages/lunar) 库实现：

```yaml
# pubspec.yaml
dependencies:
  lunar: ^1.5.0
```

```dart
import 'package:lunar/lunar.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class LunarDataSourceImpl extends TCalendarDataSource {
  @override
  TLunarInfo? getLunarInfo(DateTime solarDate) {
    final solar = Solar.fromDate(solarDate);
    final lunar = solar.getLunar();
    
    return TLunarInfo(
      year: lunar.getYear(),
      month: lunar.getMonth().abs(),
      day: lunar.getDay(),
      isLeapMonth: lunar.getMonth() < 0,
      yearText: _convertToChineseNumber(lunar.getYear()),
      monthText: lunar.getMonthInChinese(),
      dayText: lunar.getDayInChinese(),
    );
  }

  @override
  String formatDate(DateTime date, TCalendarDateType type, [TLunarInfo? lunarInfo]) {
    if (type == TCalendarDateType.solar) {
      return '${date.year}年${date.month}月${date.day}日';
    } else {
      return lunarInfo != null 
          ? '${lunarInfo.yearText}年 ${lunarInfo.monthText}${lunarInfo.dayText}'
          : formatDate(date, TCalendarDateType.solar);
    }
  }

  @override
  String? getSolarTerm(DateTime date) {
    final solar = Solar.fromDate(date);
    final jieQi = solar.getJieQi();
    return jieQi.isEmpty ? null : jieQi;
  }

  String _convertToChineseNumber(int number) {
    const digits = ['〇', '一', '二', '三', '四', '五', '六', '七', '八', '九'];
    return number.toString().split('').map((d) => digits[int.parse(d)]).join();
  }
}
```

### 方案二：查表法（自行实现）

适合对依赖包体积敏感的项目：

```dart
class LunarDataSourceTable extends TCalendarDataSource {
  // 农历数据表（1900-2100年）
  static const List<int> _lunarYearData = [
    0x04bd8, // 1900年
    0x04ae0, // 1901年
    // ... 更多年份数据
  ];
  
  @override
  TLunarInfo? getLunarInfo(DateTime solarDate) {
    // 使用查表法转换
    // 详细实现请参考项目文档
    return _convertSolarToLunar(solarDate);
  }
  
  // ... 其他实现
}
```

## 完整示例

```dart
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:lunar/lunar.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  TCalendarDateType _dateType = TCalendarDateType.solar;
  bool _showLunarInfo = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('日历示例')),
      body: Column(
        children: [
          // 切换按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _dateType = TCalendarDateType.solar;
                  });
                },
                child: Text('阳历'),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _dateType = TCalendarDateType.lunar;
                  });
                },
                child: Text('农历'),
              ),
            ],
          ),
          
          // 日历
          Expanded(
            child: TCalendar(
              dateType: _dateType,
              dataSource: LunarDataSourceImpl(),
              showLunarInfo: _showLunarInfo,
              onChange: (dates) {
                final date = DateTime.fromMillisecondsSinceEpoch(dates.first);
                print('选择了：${date.year}-${date.month}-${date.day}');
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

## 测试

项目包含完整的单元测试，覆盖：

- ✅ TLunarInfo 模型创建和比较
- ✅ TCalendarDataSource 格式化方法
- ✅ TDate 与农历信息的集成
- ✅ 闰月处理
- ✅ 边界条件

运行测试：

```bash
flutter test test/td_calendar_lunar_test.dart
```

## API 文档更新

已更新 `calendar_api.md`，新增参数：

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| dateType | TCalendarDateType? | TCalendarDateType.solar | 日历显示类型：阳历或农历 |
| dataSource | TCalendarDataSource? | - | 外部数据源，提供农历转换能力 |
| showLunarInfo | bool? | false | 阳历模式下是否显示农历信息作为副标题 |

## 注意事项

1. **必须提供数据源**：使用农历功能时，必须提供 `dataSource` 参数
2. **性能考虑**：建议在数据源内部实现缓存机制，避免重复计算
3. **数据准确性**：使用可靠的农历算法或数据源，确保转换准确
4. **国际化**：`TCalendarDataSource` 提供的格式化方法可根据需要自定义

## 贡献

欢迎提交 PR 改进此功能！请确保：

- ✅ 遵循项目代码规范
- ✅ 添加必要的测试用例
- ✅ 更新相关文档

## 相关 Issue

- [#717](https://github.com/Tencent/tdesign-flutter/issues/717) - [TCalendar] 支持阴历、阳历类型
