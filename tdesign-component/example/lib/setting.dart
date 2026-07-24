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
  String version = '';

  String publishTime = '';

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
          TCellGroup(
            title: const Text('语言设置'),
            variant: TCellGroupVariant.card,
            cells: [
              TCell(
                  title: const Text('当前语言（点击切换）'),
                  // 获取系统locale
                  note: Text(localeProvider.currentLanguageName),
                  onTap: localeProvider.toggleLocale),
            ],
          ),
          TCellGroup(
            variant: TCellGroupVariant.card,
            title: const Text('暗色模式'),
            cells: [
              TCell(
                title: const Text('跟随系统'),
                subtitle: const Text('开启后，将跟随系统打开或关闭深色模式。'),
                trailing: TSwitch(
                  value: themeModeProvider.themeMode == ThemeMode.system,
                  onChanged: (isOn) {
                    if (isOn) {
                      themeModeProvider.themeMode = ThemeMode.system;
                    } else if (systemBrightness == Brightness.dark) {
                      themeModeProvider.themeMode = ThemeMode.dark;
                    } else {
                      themeModeProvider.themeMode = ThemeMode.light;
                    }
                  },
                ),
              ),
              TCell(
                title: const Text('浅色模式'),
                prefix: const Icon(TIcons.mode_light),
                trailing: Icon(enabledModeCheckIcon(ThemeMode.light)),
                onTap: () {
                  themeModeProvider.themeMode = ThemeMode.light;
                },
              ),
              TCell(
                title: const Text('深色模式'),
                prefix: const Icon(TIcons.mode_dark),
                trailing: Icon(enabledModeCheckIcon(ThemeMode.dark)),
                onTap: () {
                  themeModeProvider.themeMode = ThemeMode.dark;
                },
              ),
            ],
          ),
          TCellGroup(
            title: Text(AppLocalizations.of(context)?.about ?? '关于我们'),
            variant: TCellGroupVariant.card,
            cells: [
              TCell(
                  title: Text(AppLocalizations.of(context)?.version ?? '版本号'),
                  note: Text(version)),
              TCell(
                  title:
                      Text(AppLocalizations.of(context)?.publishDate ?? '发版日期'),
                  note: Text(publishTime)),
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
        ? TIcons.check
        : null;
  }
}
