import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../../tdesign_flutter.dart';

typedef TResourceBuilder = TResourceDelegate? Function(
  BuildContext context,
);

/// 资源管理器
class TResourceManager {
  /// 代理构建器
  TResourceBuilder? _builder;

  /// 每次都调用build方法
  bool _needAlwaysBuild = false;

  TResourceDelegate? _delegate;

  /// 获取资源
  TResourceDelegate delegate(BuildContext context) {
    if (_builder == null) {
      return _defaultDelegate;
    }
    if (_needAlwaysBuild) {
      // 每次都调用，适用于全局有多个TResourceDelegate的情况
      var delegate = _builder?.call(context);
      if (delegate != null) {
        return delegate;
      }
    }
    _delegate ??= _builder?.call(context);
    return _delegate ?? _defaultDelegate;
  }

  static TResourceManager? _instance;

  /// 单例对象
  static TResourceManager get instance {
    _instance ??= TResourceManager();
    return _instance!;
  }

  /// 获取资源
  static final _defaultDelegate = _DefaultResourceDelegate();

  /// 库内未注入 [setResourceBuilder] 时使用的默认文案（中文）。
  @internal
  static TResourceDelegate get defaultDelegate => _defaultDelegate;

  /// 设置资源代理
  void setResourceBuilder(TResourceBuilder delegate, needAlwaysBuild) {
    _builder = delegate;
    _needAlwaysBuild = needAlwaysBuild;
  }
}

/// 资源管理器，允许外部重写，设计成抽象类，防止有新增字段时，用户没有感知
abstract class TResourceDelegate {
  /// [TSwitch]的打开状态文案
  String get open;

  /// [TSwitch]的关闭状态文案
  String get close;

  /// [TBadge]为0时的默认文案
  String get badgeZero;

  /// [TAlertDialog]等 取消
  String get cancel;

  /// [TAlertDialog]等 确认
  String get confirm;

  /// [TDropdownMenu] 其他
  String get other;

  /// [TDropdownMenu] 重置
  String get reset;

  /// [TLoading] 加载中
  String get loading;

  /// [TToast] 加载中...
  String get loadingWithPoint;

  /// [TConfirmDialog] 知道了
  String get knew;

  /// [TRefreshHeader] 正在刷新
  String get refreshing;

  /// [TRefreshHeader] 松开刷新
  String get releaseRefresh;

  /// [TRefreshHeader] 下拉刷新
  String get pullToRefresh;

  /// [TRefreshHeader] 刷新完成
  String get completeRefresh;

  /// [TTimeCounter] 天
  String get days;

  /// [TTimeCounter] 时 / [TDateTimePicker] 时列
  String get hours;

  /// [TTimeCounter] 分 / [TDateTimePicker] 分列
  String get minutes;

  /// [TTimeCounter] 秒 / [TDateTimePicker] 秒列
  String get seconds;

  /// [TTimeCounter] 毫秒
  String get milliseconds;

  /// [TDatePicker] / [TDateTimePicker] 年
  String get yearLabel;

  /// [TDatePicker] / [TDateTimePicker] 月
  String get monthLabel;

  /// [TDatePicker] / [TDateTimePicker] 日
  String get dateLabel;

  /// [TDatePicker] / [TDateTimePicker.showWeek] 周前缀
  String get weeksLabel;

  /// [TCalendarHeader] / [TDateTimePicker.showWeek] 星期日
  String get sunday;

  /// [TCalendarHeader] / [TDateTimePicker.showWeek] 星期一
  String get monday;

  /// [TCalendarHeader] / [TDateTimePicker.showWeek] 星期二
  String get tuesday;

  /// [TCalendarHeader] / [TDateTimePicker.showWeek] 星期三
  String get wednesday;

  /// [TCalendarHeader] / [TDateTimePicker.showWeek] 星期四
  String get thursday;

  /// [TCalendarHeader] / [TDateTimePicker.showWeek] 星期五
  String get friday;

  /// [TCalendarHeader] / [TDateTimePicker.showWeek] 星期六
  String get saturday;

  /// [TCalendarBody] 年
  String get year;

  /// [TCalendarBody] 一月
  String get january;

  /// [TCalendarBody] 二月
  String get february;

  /// [TCalendarBody] 三月
  String get march;

  /// [TCalendarBody] 四月
  String get april;

  /// [TCalendarBody] 五月
  String get may;

  /// [TCalendarBody] 六月
  String get june;

  /// [TCalendarBody] 七月
  String get july;

  /// [TCalendarBody] 八月
  String get august;

  /// [TCalendarBody] 九月
  String get september;

  /// [TCalendarBody] 十月
  String get october;

  /// [TCalendarBody] 十一月
  String get november;

  /// [TCalendarBody] 十二月
  String get december;

  /// [TCalendar] 时间
  String get time;

  /// [TCalendar] 开始
  String get start;

  /// [TCalendar] 结束
  String get end;

  /// [TRate] 未评分
  String get notRated;

  /// [TRate] 选择选项
  String get cascadeLabel;

  /// [TBackTop] 返回
  String get back;

  /// [TBackTop] 顶部
  String get top;

  /// [TTable] 空数据
  String get emptyData;
}

/// 如果用户要重写，就应该全部重写，不开放只重新部分资源
/// todo 这里默认为中文，推荐使用 Material 本地化作为备用，如 MaterialLocalizations.of(context).cancelButtonLabel
class _DefaultResourceDelegate extends TResourceDelegate {
  @override
  String get open => '开';

  @override
  String get close => '关';

  @override
  String get badgeZero => '0';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确定';

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
  String get hours => '时';

  @override
  String get minutes => '分';

  @override
  String get seconds => '秒';

  @override
  String get milliseconds => '毫秒';

  @override
  String get yearLabel => '年';

  @override
  String get monthLabel => '月';

  @override
  String get dateLabel => '日';

  @override
  String get weeksLabel => '周';

  @override
  String get sunday => '日';

  @override
  String get monday => '一';

  @override
  String get tuesday => '二';

  @override
  String get wednesday => '三';

  @override
  String get thursday => '四';

  @override
  String get friday => '五';

  @override
  String get saturday => '六';

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
}
