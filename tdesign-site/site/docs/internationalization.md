---
title: 国际化
description: 通过当前资源代理与 Flutter Localizations 对接应用语言。
spline: explain
---

## 资源代理与应用语言

TDesign Flutter 通过 `TResourceDelegate` 提供组件内部文案，通过 `setTResourceBuilder` 注册资源代理。应用自身的翻译文件、支持语言及 Locale 切换由 Flutter `Localizations` 管理。未提供翻译的默认文案不会自动变成目标语言。

## 1. 生成应用本地化资源

以下示例要求 Flutter ≥ 3.32.0。请在应用中创建以下文件：

```text
lib/
  main.dart
  base/intl_resource_delegate.dart
  l10n/app_en.arb
  l10n/app_zh.arb
l10n.yaml
```

在 `pubspec.yaml` 中加入依赖，并开启生成：

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: any
  tdesign_flutter: ^1.0.0

flutter:
  generate: true
```

在应用根目录创建 `l10n.yaml`：

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-dir: lib/l10n
synthetic-package: false
```

将以下资源分别保存到 `lib/l10n/app_en.arb` 与 `lib/l10n/app_zh.arb`。资源包含下方代理引用的文案和占位符定义，可按业务需要添加其他字段。

<details>
<summary>app_en.arb（代理使用的英文资源）</summary>

<!-- documentation-resource:en:start -->
```json
{
  "cancel": "Cancel",
  "confirm": "Confirm",
  "uploading": "Uploading",
  "uploadSelect": "Select files",
  "uploadPending": "Pending upload",
  "uploadFailed": "Upload failed",
  "uploadRetry": "Retry upload",
  "uploadSuccess": "Upload successful",
  "switchClose": "C",
  "switchOpen": "O",
  "knew": "Knew",
  "loading": "Loading",
  "loadingWithPoint": "Loading...",
  "other": "Other",
  "refreshing": "Refreshing",
  "releaseRefresh": "Release to refresh",
  "pullToRefresh": "Pull to refresh",
  "completeRefresh": "Refresh completed",
  "reset": "Reset",
  "days": "d",
  "hours": "h",
  "milliseconds": "ms",
  "minutes": "min",
  "seconds": "s",
  "yearLabel": "y",
  "monthLabel": "m",
  "dateLabel": "d",
  "weeks": "w",
  "friday": "FRI",
  "monday": "MON",
  "saturday": "SAT",
  "sunday": "SUN",
  "thursday": "THU",
  "tuesday": "TUE",
  "wednesday": "WED",
  "year": "",
  "january": "January",
  "february": "February",
  "march": "March",
  "april": "April",
  "may": "May",
  "june": "June",
  "july": "July",
  "august": "August",
  "september": "September",
  "october": "October",
  "november": "November",
  "december": "December",
  "time": "Time",
  "start": "Start",
  "end": "End",
  "notRated": "Not rated",
  "cascadeLabel": "Select Item",
  "back": "BACK",
  "top": "TOP",
  "emptyData": "No Data",
  "picker": "Picker",
  "pickerColumn": "Column {colIndex}"
}
```
<!-- documentation-resource:en:end -->

</details>

<details>
<summary>app_zh.arb（代理使用的中文资源）</summary>

<!-- documentation-resource:zh:start -->
```json
{
  "cancel": "取消",
  "confirm": "确认",
  "uploading": "上传中",
  "uploadSelect": "选择文件",
  "uploadPending": "待上传",
  "uploadFailed": "上传失败",
  "uploadRetry": "重新上传",
  "uploadSuccess": "上传成功",
  "switchClose": "关",
  "switchOpen": "开",
  "knew": "知道了",
  "loading": "加载中",
  "loadingWithPoint": "加载中...",
  "other": "其它",
  "refreshing": "正在刷新",
  "releaseRefresh": "松手刷新",
  "pullToRefresh": "下拉刷新",
  "completeRefresh": "刷新完成",
  "reset": "重置",
  "days": "天",
  "hours": "时",
  "milliseconds": "毫秒",
  "minutes": "分",
  "seconds": "秒",
  "yearLabel": "年",
  "monthLabel": "月",
  "dateLabel": "日",
  "weeks": "周",
  "friday": "五",
  "monday": "一",
  "saturday": "六",
  "sunday": "日",
  "thursday": "四",
  "tuesday": "二",
  "wednesday": "三",
  "year": " 年",
  "january": "1 月",
  "february": "2 月",
  "march": "3 月",
  "april": "4 月",
  "may": "5 月",
  "june": "6 月",
  "july": "7 月",
  "august": "8 月",
  "september": "9 月",
  "october": "10 月",
  "november": "11 月",
  "december": "12 月",
  "time": "时间",
  "start": "开始",
  "end": "结束",
  "notRated": "未评分",
  "cascadeLabel": "选择选项",
  "back": "返回",
  "top": "顶部",
  "emptyData": "暂无数据",
  "picker": "选择器",
  "pickerColumn": "第 {colIndex} 列"
}
```
<!-- documentation-resource:zh:end -->

</details>

执行 `flutter pub get`、`flutter gen-l10n`，确认生成 `lib/l10n/app_localizations.dart` 及两个语言实现文件，再继续下列步骤。`synthetic-package: false` 明确从项目源码导入生成类；高版本 Flutter 提示该项已无作用时可以移除，仍保留上面的输出目录。

## 2. 实现资源代理

将以下代码保存为 `lib/base/intl_resource_delegate.dart`，并在文件顶部加入两个导入：

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../l10n/app_localizations.dart';
```

<details>
<summary>IntlResourceDelegate 示例</summary>

<!-- documentation-example:intl-delegate:start -->
```dart
/// 国际化资源代理
class IntlResourceDelegate extends TResourceDelegate {
  IntlResourceDelegate(this.context);

  BuildContext context;

  /// 复用同一个代理时，更新为当前 Localizations 子树的 context。
  /// 使用 needAlwaysBuild: true 并每次新建代理时，无需调用此方法。
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
  String get uploading => AppLocalizations.of(context)!.uploading;

  @override
  String get uploadSelect => AppLocalizations.of(context)!.uploadSelect;

  @override
  String get uploadPending => AppLocalizations.of(context)!.uploadPending;

  @override
  String get uploadFailed => AppLocalizations.of(context)!.uploadFailed;

  @override
  String get uploadRetry => AppLocalizations.of(context)!.uploadRetry;

  @override
  String get uploadSuccess => AppLocalizations.of(context)!.uploadSuccess;

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
  String get pullToRefresh => AppLocalizations.of(context)!.pullToRefresh;

  @override
  String get completeRefresh => AppLocalizations.of(context)!.completeRefresh;

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
  String get yearLabel => AppLocalizations.of(context)!.yearLabel;

  @override
  String get monthLabel => AppLocalizations.of(context)!.monthLabel;

  @override
  String get dateLabel => AppLocalizations.of(context)!.dateLabel;

  @override
  String get weeksLabel => AppLocalizations.of(context)!.weeks;

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
  String get cascadeLabel => AppLocalizations.of(context)!.cascadeLabel;

  @override
  String get back => AppLocalizations.of(context)!.back;

  @override
  String get top => AppLocalizations.of(context)!.top;

  @override
  String get emptyData => AppLocalizations.of(context)!.emptyData;

  @override
  String get picker => AppLocalizations.of(context)!.picker;

  @override
  String pickerColumn(int colIndex) =>
      AppLocalizations.of(context)!.pickerColumn(colIndex);
}
```
<!-- documentation-example:intl-delegate:end -->

</details>

示例覆盖确认、取消、日期、刷新、上传及选择器等文案。升级组件后，请检查新增资源字段，并为应用支持的语言补充翻译。

## 3. 注册并在运行中切换语言

在 `lib/main.dart` 导入：

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'base/intl_resource_delegate.dart';
import 'l10n/app_localizations.dart';
```

加入一次注册和本地化应用配置：

<!-- documentation-example:intl:start -->
```dart
void configureDocumentationResources() {
  setTResourceBuilder(IntlResourceDelegate.new, needAlwaysBuild: true);
}

Widget documentationLocalizedApp(Locale locale, Widget home) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: home,
  );
}
```
<!-- documentation-example:intl:end -->

再加入下面的实际应用。页面显示当前资源代理的“确认”文案；点击 English 后应变为 Confirm，点击中文后恢复“确认”。

<!-- documentation-example:intl-app:start -->
```dart
void runLocaleApp() {
  configureDocumentationResources();
  runApp(const LocaleApp());
}

class LocaleApp extends StatefulWidget {
  const LocaleApp({super.key});

  @override
  State<LocaleApp> createState() => _LocaleAppState();
}

class _LocaleAppState extends State<LocaleApp> {
  Locale _locale = const Locale('zh');

  @override
  Widget build(BuildContext context) => documentationLocalizedApp(
    _locale,
    Builder(
      builder: (context) => Scaffold(
        appBar: const TNavBar(title: Text('国际化')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(TResourceManager.instance.delegate(context).confirm),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TButton(
                  onPressed: () => setState(() => _locale = const Locale('zh')),
                  child: const Text('中文'),
                ),
                const SizedBox(width: 16),
                TButton(
                  onPressed: () => setState(() => _locale = const Locale('en')),
                  child: const Text('English'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
```
<!-- documentation-example:intl-app:end -->

使用 `void main() => runLocaleApp();` 作为入口，执行 `flutter run`。资源代理在启动时注册一次；切换语言只更新 `Locale`，不需要反复注册代理。

`needAlwaysBuild: true` 让读取资源时按当前 context 创建代理，避免持续复用首次语言。这个 context 必须位于配置了 `Localizations` 的应用子树中。

## 接入检查

- 首次进入、切换语言和恢复页面后，检查确认/取消、日期、刷新、上传及无障碍文案。
- 为 `supportedLocales` 中的每个语言提供资源；有默认实现的文案也需要按业务要求翻译。
- 一个应用有多个语言子树时，根据传入 context 创建代理，不保存全局 context。
- 应用自己的翻译资源与 TD 内部文案使用同一套生成类；生成配置的完整说明见 [Flutter 国际化文档](https://docs.flutter.dev/ui/internationalization)。
