import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/check_component_coverage.dart';

void main() {
  test('aggregates exact files and component directory files', () {
    const lcov = r'''
SF:/workspace/lib/src/components/refresh/t_pull_down_refresh.dart
LF:10
LH:9
end_of_record
SF:lib/src/components/switch/t_switch.dart
LF:20
LH:19
end_of_record
SF:lib/src/components/switch/internal/state.dart
LF:5
LH:5
end_of_record
''';

    final refresh = parseLcov(lcov, componentTargets['refresh']!);
    final switchCoverage = parseLcov(lcov, componentTargets['switch']!);

    expect(refresh.linesFound, 10);
    expect(refresh.linesHit, 9);
    expect(refresh.matchedFiles, hasLength(1));
    expect(switchCoverage.linesFound, 25);
    expect(switchCoverage.linesHit, 24);
    expect(switchCoverage.matchedFiles, hasLength(2));
  });

  test('normalizes Windows paths without accepting similar directories', () {
    const lcov = r'''
SF:C:\workspace\lib\src\components\switch\t_switch.dart
LF:10
LH:10
end_of_record
SF:/workspace/lib/src/components/switch_backup/not_switch.dart
LF:100
LH:0
end_of_record
''';

    final summary = parseLcov(lcov, componentTargets['switch']!);

    expect(summary.linesFound, 10);
    expect(summary.linesHit, 10);
    expect(summary.matchedFiles, hasLength(1));
  });

  test('returns no coverage when LCOV has no configured target', () {
    const lcov = '''
SF:lib/src/components/button/t_button.dart
LF:10
LH:10
end_of_record
''';

    final summary = parseLcov(lcov, componentTargets['switch']!);

    expect(summary.linesFound, 0);
    expect(summary.linesHit, 0);
    expect(summary.matchedFiles, isEmpty);
  });

  test('defines every component covered by the regression matrix', () {
    expect(
      componentTargets.keys,
      containsAll(['form', 'input', 'refresh', 'switch', 'textarea', 'upload']),
    );
  });

  test('CLI fails when coverage is below the configured threshold', () {
    final directory = Directory.systemTemp.createTempSync('coverage-check-');
    addTearDown(() => directory.deleteSync(recursive: true));
    final lcov = File('${directory.path}/lcov.info')
      ..writeAsStringSync('''
SF:lib/src/components/switch/t_switch.dart
LF:10
LH:9
end_of_record
''');

    expect(run(['switch', '--threshold', '95', '--lcov', lcov.path]), 1);
    expect(run(['switch', '--threshold', '90', '--lcov', lcov.path]), 0);
  });
}
