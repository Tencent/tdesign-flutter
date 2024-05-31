import 'package:flutter/cupertino.dart';

import '../components/badge/td_badge.dart';
import '../components/dialog/td_alert_dialog.dart';
import '../components/switch/td_switch.dart';

typedef TDTDResourceBuilder = TDResourceDelegate? Function(BuildContext context);

/// 资源管理器
class TDResourceManager {

  /// 代理构建器
  TDTDResourceBuilder? _builder;
  /// 每次都调用build方法
  bool _needAlwaysBuild = false;

  TDResourceDelegate? _delegate;

  /// 获取资源
  TDResourceDelegate delegate(BuildContext context){
    if(_builder == null){
      return _defaultDelegate;
    }
    if(_needAlwaysBuild){
      // 每次都调用,适用于全局有多个TDResourceDelegate的情况
      var delegate = _builder?.call(context);
      if(delegate != null){
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
  void setResourceBuilder(TDTDResourceBuilder delegate,needAlwaysBuild) {
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
}
