import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'l10n/app_localizations.dart';
import 'provider/locale_provider.dart';
import 'provider/theme_mode_provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String? version;

  String? publishTime;

  late ThemeModeProvider themeModeProvider;

  Brightness? systemBrightness;

  @override
  void initState() {
    super.initState();
    _getVersion();
    _getPublishTime();
  }

  Future<void> _getVersion() async {
    version = await rootBundle.loadString('assets/version');
    setState(() {});
  }

  Future<void> _getPublishTime() async {
    var timeStamp = await rootBundle.loadString('assets/publish_time');
    var exactTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp.trim()));
    publishTime = '${exactTime.year}-${exactTime.month}-${exactTime.day}';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    themeModeProvider = Provider.of<ThemeModeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    /// 获取系统主题
    systemBrightness = MediaQuery.platformBrightnessOf(context);
    return Scaffold(
      appBar:
          AppBar(title: Text(AppLocalizations.of(context)?.setting ?? '设置')),
      body: Column(
        children: [
          TDCellGroup(
            title: '语言设置',
            theme: TDCellGroupTheme.cardTheme,
            cells: [
              TDCell(
                  title: '当前语言（点击切换）',
                  // 获取系统locale
                  note: localeProvider.currentLanguageName,
                  onClick: (cell) {
                    localeProvider.toggleLocale();
                  }),
            ],
          ),
        TDCellGroup(
          theme: TDCellGroupTheme.cardTheme,
          title: '暗色模式',
          cells: [
            TDCell(
              title: '跟随系统',
              description: '开启后，将跟随系统打开或关闭深色模式。',
              rightIconWidget: TDSwitch(
                isOn: themeModeProvider.themeMode == ThemeMode.system,
                onChanged: (isOn) {
                  if (isOn) {
                    themeModeProvider.themeMode = ThemeMode.system;
                  } else if (systemBrightness == Brightness.dark) {
                    themeModeProvider.themeMode = ThemeMode.dark;
                  } else {
                    themeModeProvider.themeMode = ThemeMode.light;
                  }
                  return isOn;
                },
              ),
              disabled: true,
            ),
            TDCell(
              title: '浅色模式',
              leftIcon: TDIcons.mode_light,
              rightIcon: enabledModeCheckIcon(ThemeMode.light),
              onClick: (cell) {
                themeModeProvider.themeMode = ThemeMode.light;
              },
            ),
            TDCell(
              title: '深色模式',
              leftIcon: TDIcons.mode_dark,
              rightIcon: enabledModeCheckIcon(ThemeMode.dark),
              onClick: (cell) {
                themeModeProvider.themeMode = ThemeMode.dark;
              },
            ),
          ],
        ),
          TDCellGroup(
            title: AppLocalizations.of(context)?.about ?? '关于我们',
            theme: TDCellGroupTheme.cardTheme,
            cells: [
              TDCell(
                  title: AppLocalizations.of(context)?.version ?? '版本号',
                  note: version),
              TDCell(
                  title: AppLocalizations.of(context)?.publishDate ?? '发版日期',
                  note: publishTime),
            ],
          )
        ],
      ),
    );
  }

  enabledModeCheckIcon(ThemeMode mode) {
    return themeModeProvider.themeMode == mode ||
        (themeModeProvider.themeMode == ThemeMode.system &&
            systemBrightness ==
                (mode == ThemeMode.light
                    ? Brightness.light
                    : Brightness.dark))
        ? TDIcons.check
        : null;
  }
}
