import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 国际化资源代理
class IntlResourceDelegate extends TDResourceDelegate {
  IntlResourceDelegate(this.context);

  BuildContext context;

  /// 国际化需要每次更新context
  updateContext(BuildContext context) {
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

  @override
  String get friday => AppLocalizations.of(context)!.friday;

  @override
  String get monday => AppLocalizations.of(context)!.monday;

  @override
  String get saturday => AppLocalizations.of(context)!.saturday;

  @override
  String get sunday => AppLocalizations.of(context)!.sunday;

  @override
  String get thursday => AppLocalizations.of(context)!.thursday;

  @override
  String get tuesday => AppLocalizations.of(context)!.tuesday;

  @override
  String get wednesday => AppLocalizations.of(context)!.wednesday;

  @override
  String get year => AppLocalizations.of(context)!.year;

  @override
  String get january => AppLocalizations.of(context)!.january;

  @override
  String get february => AppLocalizations.of(context)!.february;

  @override
  String get march => AppLocalizations.of(context)!.march;

  @override
  String get april => AppLocalizations.of(context)!.april;

  @override
  String get may => AppLocalizations.of(context)!.may;

  @override
  String get june => AppLocalizations.of(context)!.june;

  @override
  String get july => AppLocalizations.of(context)!.july;

  @override
  String get august => AppLocalizations.of(context)!.august;

  @override
  String get september => AppLocalizations.of(context)!.september;

  @override
  String get october => AppLocalizations.of(context)!.october;

  @override
  String get november => AppLocalizations.of(context)!.november;

  @override
  String get december => AppLocalizations.of(context)!.december;

  @override
  String get time => AppLocalizations.of(context)!.time;

  @override
  String get start => AppLocalizations.of(context)!.start;

  @override
  String get end => AppLocalizations.of(context)!.end;

  @override
  String get notRated => AppLocalizations.of(context)!.notRated;

  @override
  String get cascadeLabel =>  AppLocalizations.of(context)!.cascadeLabel;
}
