import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'base/intl_resource_delegate.dart';
import 'l10n/app_localizations.dart';

// documentation:theme-json:start
const themeJson = '''
{
  "green": {"color": {
    "brandColor": "#16875D", "brandColorLight": "#E5F5ED",
    "brandColorFocus": "#C5E8D6", "brandColorActive": "#106B49",
    "brandColorDisabled": "#A6D6BF", "bgColorPage": "#EFF7F2",
    "bgColorContainer": "#FFFFFF", "textColorPrimary": "#183C2C",
    "textColorSecondary": "#526E60", "componentBorder": "#A8CDBA",
    "componentStroke": "#D4E8DD"
  }},
  "greenDark": {"color": {
    "brandColor": "#56C08D", "brandColorLight": "#183D2D",
    "brandColorFocus": "#24543D", "brandColorActive": "#78D4A6",
    "brandColorDisabled": "#315B45", "bgColorPage": "#101F18",
    "bgColorContainer": "#192E23", "textColorPrimary": "#E2F3E9",
    "textColorSecondary": "#A5C6B3", "componentBorder": "#537A64",
    "componentStroke": "#304C3D", "textColorAnti": "#102B1B"
  }}
}
''';

TThemeData createTheme() =>
    TThemeData.fromJson('green', themeJson, darkName: 'greenDark')!;
// documentation:theme-json:end

// documentation:theme-mode:start
Widget buildThemeApp(ThemeMode mode, Widget home, {TThemeData? tokens}) {
  tokens ??= createTheme();
  return MaterialApp(
    theme: TThemeBuilder.light(tokens),
    darkTheme: TThemeBuilder.dark(tokens),
    themeMode: mode,
    home: home,
  );
}
// documentation:theme-mode:end

// documentation:theme-local:start
Widget wrapLocalTheme(BuildContext context, Widget child) {
  return Theme(
    data: Theme.of(
      context,
    ).mergeExtension(const TTagThemeData(squareBorderRadius: 6)),
    child: child,
  );
}
// documentation:theme-local:end

// documentation:intl:start
void configureResources() {
  setTResourceBuilder(IntlResourceDelegate.new, needAlwaysBuild: true);
}

Widget buildLocalizedApp(Locale locale, Widget home) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: home,
  );
}

// documentation:intl:end

// documentation:theme-asset:start
Future<TThemeData> loadTheme() async {
  final json = await rootBundle.loadString('assets/custom_theme.json');
  final tokens = TThemeData.fromJson('green', json, darkName: 'greenDark');
  if (tokens == null) {
    throw const FormatException('主题 JSON 缺少 green 配置或格式错误');
  }
  return tokens;
}

Future<void> runThemeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  final tokens = await loadTheme();
  runApp(
    MaterialApp(
      theme: TThemeBuilder.light(tokens),
      darkTheme: TThemeBuilder.dark(tokens),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: const TNavBar(title: Text('资源主题')),
        body: Center(
          child: TButton(
            colorPreset: TButtonColorPreset.primary,
            onPressed: () {},
            child: const Text('主题按钮'),
          ),
        ),
      ),
    ),
  );
}
// documentation:theme-asset:end

// documentation:intl-app:start
void runLocaleApp() {
  configureResources();
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
  Widget build(BuildContext context) => buildLocalizedApp(
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

// documentation:intl-app:end
