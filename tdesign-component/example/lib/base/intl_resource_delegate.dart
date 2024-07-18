import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 国际化资源代理
class IntlResourceDelegate extends TDResourceDelegate {
  IntlResourceDelegate(this.context);

  BuildContext context;

  /// 国际化需要每次更新context
  updateContext(BuildContext context){
    this.context = context;
  }

  @override
  String get badgeZero => '0';

  @override
  String get cancel => AppLocalizations.of(context)!.cancel;

  @override
  String get confirm => AppLocalizations.of(context)!.confirm;

  @override
  String get close => AppLocalizations.of(context)!.switchClose;

  @override
  String get open => AppLocalizations.of(context)!.switchOpen;

  @override
  String get knew => AppLocalizations.of(context)!.knew;

  @override
  String get loading => AppLocalizations.of(context)!.loading;

  @override
  String get loadingWithPoint => AppLocalizations.of(context)!.loadingWithPoint;

  @override
  String get other => AppLocalizations.of(context)!.other;

  @override
  String get refreshing => AppLocalizations.of(context)!.refreshing;

  @override
  String get releaseRefresh => AppLocalizations.of(context)!.releaseRefresh;

  @override
  String get reset => AppLocalizations.of(context)!.reset;
  
  @override
  String get days => AppLocalizations.of(context)!.days;
  
  @override
  String get hours => AppLocalizations.of(context)!.hours;
  
  @override
  String get milliseconds => AppLocalizations.of(context)!.milliseconds;
  
  @override
  String get minutes => AppLocalizations.of(context)!.minutes;
  
  @override
  String get seconds => AppLocalizations.of(context)!.seconds;

}