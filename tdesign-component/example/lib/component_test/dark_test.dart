import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../l10n/app_localizations.dart';
import '../provider/theme_mode_provider.dart';

late TThemeData themeData;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 顶部状态栏
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  /// 禁止横屏
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  var themeJsonString = await rootBundle.loadString('assets/theme.json');

  /// 默认浅色主题,dark为深色主题
  themeData =
      TThemeData.fromJson('red', themeJsonString, darkName: 'redDark') ??
          TThemeData.defaultData();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final provider = ThemeModeProvider();
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (provider.themeMode == ThemeMode.system) {
                await provider.initThemeMode();
              }
            });
            return provider;
          },
        ),
      ],
      child: Consumer<ThemeModeProvider>(
        builder: (context, themeModeProvider, child) {
          return MaterialApp(
            title: '深色模式切换测试',

            /// 默认浅色模式
            theme: TThemeBuilder.light(themeData).copyWith(
              /// 根据自己的需求用 TD 颜色覆盖 Material/Cupertino 的颜色
              cupertinoOverrideTheme: const CupertinoThemeData().copyWith(
                barBackgroundColor:
                    themeData.bgColorContainer.withValues(alpha: 0.5),
              ),

              /// ... 更多重载主题
            ),

            /// 深色模式
            darkTheme: TThemeBuilder.dark(themeData).copyWith(
              cupertinoOverrideTheme: const CupertinoThemeData().copyWith(
                barBackgroundColor:
                    themeData.dark?.grayColor13.withValues(alpha: 0.5),
              ),

              /// ... 更多重载主题
            ),
            themeMode: themeModeProvider.themeMode,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const ThemeModeSettingsPage(),
          );
        },
      ),
    );
  }
}

class ThemeModeSettingsPage extends StatefulWidget {
  const ThemeModeSettingsPage({super.key});

  @override
  State<ThemeModeSettingsPage> createState() => _ThemeModeSettingsPageState();
}

class _ThemeModeSettingsPageState extends State<ThemeModeSettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeModeProvider = Provider.of<ThemeModeProvider>(context);

    /// 获取系统主题
    var systemBrightness = MediaQuery.platformBrightnessOf(context);

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('深色主题切换'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            TCellGroup(
              variant: TCellGroupVariant.card,
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
              ],
            ),
            TCellGroup(
              variant: TCellGroupVariant.card,
              title: const Text('手动选择'),
              cells: [
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
          ],
        ),
      ),
    );
  }
}
