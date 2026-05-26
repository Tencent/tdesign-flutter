import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// Popup 测试用文案资源：仅覆盖 cancel / confirm，其余与库内默认中文一致。
class PopupTestResourceDelegate extends TResourceDelegate {
  PopupTestResourceDelegate({
    required this.cancelText,
    required this.confirmText,
    required this.locale,
  });

  factory PopupTestResourceDelegate.zh() => PopupTestResourceDelegate(
        cancelText: '取消',
        confirmText: '确定',
        locale: const Locale('zh'),
      );

  factory PopupTestResourceDelegate.en() => PopupTestResourceDelegate(
        cancelText: 'Cancel',
        confirmText: 'Confirm',
        locale: const Locale('en'),
      );

  final String cancelText;
  final String confirmText;
  final Locale locale;

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

/// 在测试中注入 [resource]；与业务侧 `TTheme.setResourceBuilder` 用法一致。
void bindPopupTestResource(PopupTestResourceDelegate resource) {
  TTheme.setResourceBuilder((_) => resource, needAlwaysBuild: true);
}

/// 恢复为库内默认资源（中文 cancel/confirm）。
void resetPopupTestResource() {
  TTheme.setResourceBuilder((_) => null, needAlwaysBuild: false);
}
