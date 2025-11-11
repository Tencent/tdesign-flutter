import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../l10n/app_localizations.dart';
import '../provider/theme_mode_provider.dart';

late TDThemeData themeData;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 顶部状态栏
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  /// 禁止横屏
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  var themeJsonString = await rootBundle.loadString('assets/theme.json');
  /// 开启多套主题功能
  TDTheme.needMultiTheme(true);
  /// 默认浅色主题,dark为深色主题
  themeData = TDThemeData.fromJson('redLight', themeJsonString, darkName: 'dark') ??
      TDTheme.defaultData();

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
            theme: themeData.systemThemeDataLight!.copyWith(
              /// 根据自己的需求用 TD 颜色覆盖 Material/Cupertino 的颜色
              cupertinoOverrideTheme: const CupertinoThemeData().copyWith(
                barBackgroundColor: themeData.bgColorContainer.withValues(
                  alpha: 0.5,
                ),
              ),
              /// ... 更多重载主题
            ),

            /// 深色模式
            darkTheme: themeData.systemThemeDataDark?.copyWith(
              cupertinoOverrideTheme: const CupertinoThemeData().copyWith(
                barBackgroundColor: themeData.dark?.grayColor13.withValues(
                  alpha: 0.5,
                ),
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
    Brightness systemBrightness = MediaQuery.platformBrightnessOf(context);

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('深色主题切换'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            TDCellGroup(
              theme: TDCellGroupTheme.cardTheme,
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
              ],
            ),
            TDCellGroup(
              theme: TDCellGroupTheme.cardTheme,
              title: '手动选择',
              cells: [
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
          ],
        ),
      ),
    );
  }
}
