// 仅在 Web 平台导入
import 'dart:html' as html if (dart.library.html) 'dart:html';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/src/util/log.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'base/example_route.dart';
import 'base/intl_resource_delegate.dart';
import 'config.dart';
import 'home.dart';
import 'l10n/app_localizations.dart';
import 'provider/locale_provider.dart';
import 'provider/theme_mode_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 禁止横屏
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  Log.setCustomLogPrinter((level, tag, msg) => print('[$level] $tag ==> $msg'));
  runApp(const MyApp());

  /*SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));*/

  exampleMap.forEach((key, value) {
    value.forEach((model) {
      examplePageList.add(model);
    });
  });
  sideBarExamplePage.forEach(examplePageList.add);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late TDThemeData _themeData;

  @override
  void initState() {
    super.initState();
    _themeData = TDThemeData.defaultData();
    print('_darkThemeData.bgColorPage： ${_themeData.bgColorPage}，_themeData.dark?.bgColorPage: ${_themeData.dark?.bgColorPage}');
  }

  @override
  Widget build(BuildContext context) {
    // 使用多套主题
    TDTheme.needMultiTheme();
    var delegate = IntlResourceDelegate(context);
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
        ChangeNotifierProvider(
          create: (_) {
            final provider = LocaleProvider();
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await provider.initLocale();
            });
            return provider;
          },
        ),
      ],
      child: Consumer2<ThemeModeProvider, LocaleProvider>(
        builder: (context, themeModeProvider, localeProvider, child) {
          // 在 Web 平台设置 postMessage 监听
          if (PlatformUtil.isWeb) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _setupThemeModeListener(context, themeModeProvider);
            });
          }

          return MaterialApp(
            title: 'TDesign Flutter Example',
            theme: _themeData.systemThemeDataLight,
            darkTheme: _themeData.systemThemeDataDark,
            themeMode: themeModeProvider.themeMode,
            home: PlatformUtil.isWeb
                ? null
                : Builder(
                    builder: (context) {
                      // 设置文案代理,国际化需要在MaterialApp初始化完成之后才生效,而且需要每次更新context
                      TDTheme.setResourceBuilder(
                        (context) => delegate..updateContext(context),
                        needAlwaysBuild: true,
                      );
                      return MyHomePage(
                        title: AppLocalizations.of(context)?.components ?? '',
                        onThemeChange: (themeData) {
                          setState(() {
                            _themeData = themeData;
                          });
                        },
                      );
                    },
                  ),
            // 设置国际化处理
            locale: localeProvider.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            onGenerateRoute: TDExampleRoute.onGenerateRoute,
            routes: _getRoutes(),
          );
        },
      ),
    );
  }

  Map<String, WidgetBuilder> _getRoutes() {
    if (PlatformUtil.isWeb) {
      return {
        for (var model in examplePageList)
          model.name: (context) => model.pageBuilder.call(context, model)
      }..putIfAbsent('/',
          () => (context) => const MyHomePage(title: 'TDesign Flutter 组件库'));
    } else {
      return const {};
    }
  }

  static bool _listenerSetup = false;

  void _setupThemeModeListener(
      BuildContext context, ThemeModeProvider themeModeProvider) {
    // 只设置一次监听器
    if (_listenerSetup) return;
    _listenerSetup = true;

    // 仅在 Web 平台执行
    if (!PlatformUtil.isWeb) return;

    // ignore: undefined_prefixed_name, avoid_web_libraries_in_flutter
    if (kIsWeb) {
      html.window.onMessage.listen((event) {
        if (event.data is Map) {
          final data = event.data as Map;
          if (data['type'] == 'theme-mode-change') {
            final themeMode = data['themeMode'] as String?;
            if (themeMode == 'dark') {
              themeModeProvider.themeMode = ThemeMode.dark;
            } else if (themeMode == 'light') {
              themeModeProvider.themeMode = ThemeMode.light;
            }
          }
        }
      });
    }
  }
}
