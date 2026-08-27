import 'dart:io';

import 'check_component_coverage.dart' as coverage;

class ComponentTestSuite {
  const ComponentTestSuite(this.component, this.testFiles);

  final String component;
  final List<String> testFiles;
}

const componentTestSuites = <ComponentTestSuite>[
  ComponentTestSuite('button', [
    'test/components/button/t_button_test.dart',
    'test/components/button/t_button_theme_priority_test.dart',
    'test/components/button/t_button_theme_test.dart',
    'test/components/button/t_button_widget_test.dart',
  ]),
  ComponentTestSuite('divider', [
    'test/components/divider/t_divider_test.dart',
  ]),
  ComponentTestSuite('fab', [
    'test/components/fab/t_fab_layout_test.dart',
    'test/components/fab/t_fab_test.dart',
  ]),
  ComponentTestSuite('refresh', [
    'test/components/refresh/t_refresh_test.dart',
  ]),
  ComponentTestSuite('icon', ['test/components/icon/t_icon_test.dart']),
  ComponentTestSuite('link', [
    'test/components/link/t_link_resolve_test.dart',
    'test/components/link/t_link_test.dart',
    'test/components/link/t_link_theme_test.dart',
    'test/components/link/t_link_widget_test.dart',
  ]),
  ComponentTestSuite('radio', [
    'test/components/radio/t_radio_test.dart',
    'test/components/radio/t_radio_theme_contract_test.dart',
  ]),
  ComponentTestSuite('text', [
    'test/components/text/t_font_loader_test.dart',
    'test/components/text/t_text_resolve_test.dart',
    'test/components/text/t_text_test.dart',
  ]),
  ComponentTestSuite('search', ['test/components/search/t_search_test.dart']),
  ComponentTestSuite('switch', [
    'test/components/switch/t_switch_test.dart',
    'test/components/switch/t_cupertino_switch_test.dart',
  ]),
  ComponentTestSuite('upload', ['test/components/upload/t_upload_test.dart']),
  ComponentTestSuite('form', ['test/components/form/t_form_test.dart']),
  ComponentTestSuite('input', [
    'test/components/input/t_input_test.dart',
    'test/components/input/t_input_theme_test.dart',
  ]),
  ComponentTestSuite('textarea', [
    'test/components/textarea/t_textarea_test.dart',
  ]),
  ComponentTestSuite('toast', ['test/components/toast/t_toast_test.dart']),
  ComponentTestSuite('swipe_cell', [
    'test/components/swipe_cell/t_swipe_cell_auto_extent_test.dart',
    'test/components/swipe_cell/t_swipe_cell_inherited_test.dart',
    'test/components/swipe_cell/t_swipe_cell_test.dart',
  ]),
];

Future<int> runComponentRegression() async {
  final failedComponents = <String>[];

  for (final suite in componentTestSuites) {
    stdout.writeln('\n=== ${suite.component} component regression ===');
    final process = await Process.start('flutter', [
      'test',
      ...suite.testFiles,
      '--no-pub',
      '--exclude-tags',
      'demo',
      '--coverage',
    ], mode: ProcessStartMode.inheritStdio);
    final testExitCode = await process.exitCode;
    if (testExitCode != 0) {
      failedComponents.add(suite.component);
      continue;
    }

    final coverageExitCode = coverage.run([suite.component]);
    if (coverageExitCode != 0) {
      failedComponents.add(suite.component);
    }
  }

  if (failedComponents.isNotEmpty) {
    stderr.writeln(
      '\nComponent regression failed: ${failedComponents.join(', ')}',
    );
    return 1;
  }

  stdout.writeln('\nAll component regression suites passed.');
  return 0;
}

Future<void> main() async {
  exitCode = await runComponentRegression();
}
