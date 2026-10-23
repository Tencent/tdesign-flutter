import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'base/intl_resource_delegate.dart';
import 'l10n/app_localizations.dart';

// documentation:theme-json:start
TThemeData documentationThemeTokens() {
  const json = '''
{
  "ocean": {"color": {"brandColor": "#0052D9"}},
  "oceanDark": {"color": {"brandColor": "#699EF5"}}
}
''';
  return TThemeData.fromJson('ocean', json, darkName: 'oceanDark') ??
      TThemeData.defaultData();
}
// documentation:theme-json:end

// documentation:theme-mode:start
Widget documentationThemeApp(ThemeMode mode, Widget home) {
  final tokens = documentationThemeTokens();
  return MaterialApp(
    theme: TThemeBuilder.light(tokens),
    darkTheme: TThemeBuilder.dark(tokens),
    themeMode: mode,
    home: home,
  );
}
// documentation:theme-mode:end

// documentation:theme-local:start
Widget documentationLocalTheme(BuildContext context, Widget child) {
  return Theme(
    data: Theme.of(
      context,
    ).mergeExtension(const TTagThemeData(squareBorderRadius: 6)),
    child: child,
  );
}
// documentation:theme-local:end

// documentation:intl:start
void configureDocumentationResources() {
  setTResourceBuilder(
    IntlResourceDelegate.new,
    needAlwaysBuild: true,
  );
}

Widget documentationLocalizedApp(Locale locale, Widget home) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: home,
  );
}

// documentation:intl:end
