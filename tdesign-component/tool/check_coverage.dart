import 'dart:io';

/// 解析 `flutter test --coverage` 生成的 lcov.info，计算总行覆盖率。
///
/// 用法：`dart run tool/check_coverage.dart [阈值] [lcov路径]`
///   - 阈值：覆盖率最低要求（百分比，默认 95），低于该值脚本以非 0 退出。
///   - lcov 路径：lcov.info 路径（默认 `coverage/lcov.info`）。
///
/// lcov.info 关键字段：
///   - `LF:<n>` 当前文件记录到的可执行行总数（lines found）
///   - `LH:<n>` 当前文件被覆盖到的行数（lines hit）
/// 总行覆盖率 = ΣLH / ΣLF。
void main(List<String> args) {
  final threshold = args.isNotEmpty ? double.tryParse(args[0]) : 95.0;
  if (threshold == null || threshold < 0 || threshold > 100) {
    stderr.writeln('Error: 阈值必须为 0~100 之间的数字，当前值: ${args.first}');
    exit(2);
  }

  final lcovPath = args.length > 1 ? args[1] : 'coverage/lcov.info';
  final file = File(lcovPath);
  if (!file.existsSync()) {
    stderr.writeln('Error: 未找到 lcov 数据文件 $lcovPath');
    stderr.writeln('请先执行 flutter test --coverage 生成覆盖率数据。');
    exit(2);
  }

  var linesFound = 0;
  var linesHit = 0;
  var recordCount = 0;

  for (final line in file.readAsLinesSync()) {
    if (line.startsWith('LF:')) {
      linesFound += int.parse(line.substring(3));
    } else if (line.startsWith('LH:')) {
      linesHit += int.parse(line.substring(3));
    } else if (line == 'end_of_record') {
      recordCount++;
    }
  }

  if (linesFound == 0) {
    stderr.writeln('Error: lcov.info 中未解析到可执行行（LF=0），请检查测试是否产生覆盖率数据。');
    exit(2);
  }

  final coverage = linesHit / linesFound * 100;
  stdout.writeln('覆盖率统计（共 $recordCount 个记录）：');
  stdout.writeln('  可执行行(lines found)  = $linesFound');
  stdout.writeln('  已覆盖行(lines hit)    = $linesHit');
  stdout.writeln('  行覆盖率                = ${coverage.toStringAsFixed(2)}%');

  if (coverage >= threshold - 1e-9) {
    stdout.writeln('PASS：覆盖率 ${coverage.toStringAsFixed(2)}% >= 目标 ${threshold.toStringAsFixed(1)}%');
    exit(0);
  } else {
    stdout.writeln('FAIL：覆盖率 ${coverage.toStringAsFixed(2)}% < 目标 ${threshold.toStringAsFixed(1)}%');
    exit(1);
  }
}
