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
import 'util/web_theme_listener.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 禁止横屏
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  Log.setCustomLogPrinter((level, tag, msg) => print('[$level] $tag ==> $msg'));
  exampleMap.forEach((key, value) {
    value.forEach((model) {
      examplePageList.add(model);
    });
  });
  sideBarExamplePage.forEach(examplePageList.add);
  TExampleRoute.init();

  runApp(const MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late TThemeData _themeData;

  @override
  void initState() {
    super.initState();
    _themeData = TThemeData.defaultData();
    print(
        '_darkThemeData.bgColorPage： ${_themeData.bgColorPage}，_themeData.dark?.bgColorPage: ${_themeData.dark?.bgColorPage}');
  }

  @override
  Widget build(BuildContext context) {
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
              // 仅在 Web 平台执行
              if (!kIsWeb) {
                return;
              }
              setupThemeModeListener(themeModeProvider);
            });
          }

          return MaterialApp(
            title: 'TDesign Flutter Example',
            theme: TThemeBuilder.light(_themeData),
            darkTheme: TThemeBuilder.dark(_themeData),
            themeMode: themeModeProvider.themeMode,
            home: PlatformUtil.isWeb
                ? null
                : Builder(
                    builder: (context) {
                      // 设置文案代理,国际化需要在MaterialApp初始化完成之后才生效,而且需要每次更新context
                      setTResourceBuilder(
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
            onGenerateRoute: TExampleRoute.onGenerateRoute,
            routes: _getRoutes(delegate),
          );
        },
      ),
    );
  }

  Map<String, WidgetBuilder> _getRoutes(IntlResourceDelegate delegate) {
    if (PlatformUtil.isWeb) {
      return {
        for (var model in examplePageList)
          model.name: (context) => model.pageBuilder.call(context, model)
      }..putIfAbsent('/', () {
          // Web 模式下通过路由创建 MyHomePage，需要传入 onThemeChange 回调
          // 并设置文案代理（与非 Web 模式保持一致）
          return (context) => Builder(
                builder: (context) {
                  setTResourceBuilder(
                    (context) => delegate..updateContext(context),
                    needAlwaysBuild: true,
                  );
                  return MyHomePage(
                    title: AppLocalizations.of(context)?.components ??
                        'TDesign Flutter 组件库',
                    onThemeChange: (themeData) {
                      setState(() {
                        _themeData = themeData;
                      });
                    },
                  );
                },
              );
        });
    } else {
      return const {};
    }
  }
}
