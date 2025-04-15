import 'package:flutter/cupertino.dart';

import '../../tdesign_flutter.dart';

typedef TDTDResourceBuilder = TDResourceDelegate? Function(BuildContext context);

/// 资源管理器
class TDResourceManager {
  /// 代理构建器
  TDTDResourceBuilder? _builder;

  /// 每次都调用build方法
  bool _needAlwaysBuild = false;

  TDResourceDelegate? _delegate;

  /// 获取资源
  TDResourceDelegate delegate(BuildContext context) {
    if (_builder == null) {
      return _defaultDelegate;
    }
    if (_needAlwaysBuild) {
      // 每次都调用,适用于全局有多个TDResourceDelegate的情况
      var delegate = _builder?.call(context);
      if (delegate != null) {
        return delegate;
      }
    }
    _delegate ??= _builder?.call(context);
    return _delegate ?? _defaultDelegate;
  }

  static TDResourceManager? _instance;

  /// 单例对象
  static TDResourceManager get instance {
    _instance ??= TDResourceManager();
    return _instance!;
  }

  /// 获取资源
  static final _defaultDelegate = _DefaultResourceDelegate();

  /// 设置资源代理
  void setResourceBuilder(TDTDResourceBuilder delegate, needAlwaysBuild) {
    _builder = delegate;
    _needAlwaysBuild = needAlwaysBuild;
  }
}

/// 资源管理器,允许外部重写,设计成抽象类,防止有新增字段时,用户没有感知
abstract class TDResourceDelegate {
  /// [TDSwitch]的打开状态文案
  String get open;

  /// [TDSwitch]的关闭状态文案
  String get close;

  /// [TDBadge]为0时的默认文案
  String get badgeZero;

  /// [TDAlertDialog]等 取消
  String get cancel;

  /// [TDAlertDialog]等 确认
  String get confirm;

  /// [TDDropdownMenu] 其他
  String get other;

  /// [TDDropdownMenu] 重置
  String get reset;

  /// [TDLoading] 加载中
  String get loading;

  /// [TDToast] 加载中...
  String get loadingWithPoint;

  /// [TDConfirmDialog] 知道了
  String get knew;

  /// [TDRefreshHeader] 正在刷新
  String get refreshing;

  /// [TDRefreshHeader] 松开刷新
  String get releaseRefresh;

  /// [TDRefreshHeader] 下拉刷新
  String get pullToRefresh;

  /// [TDRefreshHeader] 刷新完成
  String get completeRefresh;

  /// [TDTimeCounter] 天
  String get days;

  /// [TDTimeCounter] 时
  String get hours;

  /// [TDTimeCounter] 分
  String get minutes;

  /// [TDTimeCounter] 秒
  String get seconds;

  /// [TDTimeCounter] 毫秒
  String get milliseconds;

  /// [TDDatePicker]  年
  String get yearLabel;

  /// [TDDatePicker]  月
  String get monthLabel;

  /// [TDDatePicker] 日
  String get dateLabel;

  /// [TDDatePicker] 周
  String get weeksLabel;
  
  /// [TDCalendarHeader] 星期日
  String get sunday;

  /// [TDCalendarHeader] 星期一
  String get monday;

  /// [TDCalendarHeader] 星期二
  String get tuesday;

  /// [TDCalendarHeader] 星期三
  String get wednesday;

  /// [TDCalendarHeader] 星期四
  String get thursday;

  /// [TDCalendarHeader] 星期五
  String get friday;

  /// [TDCalendarHeader] 星期六
  String get saturday;

  /// [TDCalendarBody] 年
  String get year;

  /// [TDCalendarBody] 一月
  String get january;

  /// [TDCalendarBody] 二月
  String get february;

  /// [TDCalendarBody] 三月
  String get march;

  /// [TDCalendarBody] 四月
  String get april;

  /// [TDCalendarBody] 五月
  String get may;

  /// [TDCalendarBody] 六月
  String get june;

  /// [TDCalendarBody] 七月
  String get july;

  /// [TDCalendarBody] 八月
  String get august;

  /// [TDCalendarBody] 九月
  String get september;

  /// [TDCalendarBody] 十月
  String get october;

  /// [TDCalendarBody] 十一月
  String get november;

  /// [TDCalendarBody] 十二月
  String get december;

  /// [TDCalendar] 时间
  String get time;

  /// [TDCalendar] 开始
  String get start;

  /// [TDCalendar] 结束
  String get end;

  /// [TDRate] 未评分
  String get notRated;

  /// [TDRate] 选择选项
  String get cascadeLabel;

  /// [TDBackTop] 返回
  String get back;

  /// [TDBackTop] 顶部
  String get top;

}

/// 如果用户要重写,就应该全部重写,不开放只重新部分资源
class _DefaultResourceDelegate extends TDResourceDelegate {
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
  String get dateLabel=>'日';

  @override
  String get weeksLabel=>'周';
  
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
}
