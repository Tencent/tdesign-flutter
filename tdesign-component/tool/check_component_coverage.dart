import 'dart:io';

const componentTargets = <String, List<String>>{
  'form': ['lib/src/components/form/'],
  'input': ['lib/src/components/input/'],
  'refresh': [
    'lib/src/components/refresh/t_pull_down_refresh.dart',
    'lib/src/components/refresh/t_pull_down_refresh_controller.dart',
    'lib/src/components/refresh/t_pull_down_refresh_texts.dart',
  ],
  'switch': ['lib/src/components/switch/'],
  'textarea': ['lib/src/components/textarea/'],
  'upload': ['lib/src/components/upload/'],
};

class CoverageSummary {
  const CoverageSummary({
    required this.linesFound,
    required this.linesHit,
    required this.matchedFiles,
  });

  final int linesFound;
  final int linesHit;
  final List<String> matchedFiles;

  double get percentage => linesHit / linesFound * 100;
}

CoverageSummary parseLcov(String contents, List<String> targets) {
  var current = false;
  var linesFound = 0;
  var linesHit = 0;
  final matchedFiles = <String>[];

  for (final line in contents.split('\n')) {
    if (line.startsWith('SF:')) {
      final path = line.substring(3).replaceAll('\\', '/');
      current = targets.any((target) => _matchesTarget(path, target));
      if (current) {
        matchedFiles.add(path);
      }
    } else if (current && line.startsWith('LF:')) {
      linesFound += int.parse(line.substring(3));
    } else if (current && line.startsWith('LH:')) {
      linesHit += int.parse(line.substring(3));
    } else if (line == 'end_of_record') {
      current = false;
    }
  }

  return CoverageSummary(
    linesFound: linesFound,
    linesHit: linesHit,
    matchedFiles: matchedFiles,
  );
}

bool _matchesTarget(String path, String target) {
  final normalizedTarget = target.replaceAll('\\', '/');
  if (normalizedTarget.endsWith('/')) {
    return path.startsWith(normalizedTarget) ||
        path.contains('/$normalizedTarget');
  }
  return path == normalizedTarget || path.endsWith('/$normalizedTarget');
}

void printUsage() {
  stderr.writeln(
    'Usage: dart run tool/check_component_coverage.dart '
    '<${componentTargets.keys.join('|')}> '
    '[--threshold <percent>] [--lcov <path>]',
  );
}

int run(List<String> arguments) {
  if (arguments.isEmpty || !componentTargets.containsKey(arguments.first)) {
    printUsage();
    return 64;
  }

  final component = arguments.first;
  var threshold = 95.0;
  var lcovPath = 'coverage/lcov.info';

  for (var index = 1; index < arguments.length; index += 2) {
    if (index + 1 >= arguments.length) {
      printUsage();
      return 64;
    }
    final option = arguments[index];
    final value = arguments[index + 1];
    if (option == '--threshold') {
      threshold = double.tryParse(value) ?? -1;
    } else if (option == '--lcov') {
      lcovPath = value;
    } else {
      printUsage();
      return 64;
    }
  }

  if (threshold < 0 || threshold > 100) {
    stderr.writeln('ERROR: threshold must be between 0 and 100');
    return 64;
  }

  final file = File(lcovPath);
  if (!file.existsSync()) {
    stderr.writeln('ERROR: cannot read $lcovPath: file does not exist');
    return 1;
  }

  final summary = parseLcov(
    file.readAsStringSync(),
    componentTargets[component]!,
  );
  stdout.writeln('$component matched files:');
  for (final path in summary.matchedFiles) {
    stdout.writeln('  - $path');
  }

  if (summary.linesFound == 0) {
    stderr.writeln('NO $component coverage data found in $lcovPath');
    return 1;
  }

  stdout.writeln(
    '$component production LH/LF = '
    '${summary.linesHit}/${summary.linesFound} = '
    '${summary.percentage.toStringAsFixed(2)}%',
  );
  if (summary.percentage < threshold) {
    final formattedThreshold = threshold.truncateToDouble() == threshold
        ? threshold.toStringAsFixed(0)
        : threshold.toStringAsFixed(2);
    stderr.writeln(
      'ERROR: $component production coverage below '
      '$formattedThreshold% threshold',
    );
    return 1;
  }
  return 0;
}

void main(List<String> arguments) {
  exitCode = run(arguments);
}
