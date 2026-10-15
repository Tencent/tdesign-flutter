import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter_example/base/demo_build_info.dart';

import '../../tool/write_demo_build_info.dart';

void main() {
  test('构建工具写入当前包版本与实际构建时间', () {
    final directory = Directory.systemTemp.createTempSync('demo-build-info-');
    addTearDown(() => directory.deleteSync(recursive: true));
    File(
      '${directory.path}/pubspec.yaml',
    ).writeAsStringSync('name: example\nversion: 1.2.3-beta.1\n');
    final builtAt = DateTime.utc(2026, 10, 15, 18, 30);
    writeDemoBuildInfo(componentDirectory: directory, builtAt: builtAt);
    final assets = '${directory.path}/example/assets';
    expect(File('$assets/version').readAsStringSync(), '1.2.3-beta.1\n');
    final timestamp = File('$assets/publish_time').readAsStringSync();
    expect(int.parse(timestamp.trim()), builtAt.millisecondsSinceEpoch);
    expect(formatDemoBuildDate(timestamp), '2026-10-16');

    final nextBuild = DateTime.utc(2026, 10, 20);
    writeDemoBuildInfo(componentDirectory: directory, builtAt: nextBuild);
    expect(
      formatDemoBuildDate(File('$assets/publish_time').readAsStringSync()),
      '2026-10-20',
    );
  });

  test('无效时间显示未知，不使用打开应用时的日期', () {
    expect(formatDemoBuildDate(''), '未知');
    expect(formatDemoBuildDate('not-a-timestamp'), '未知');
    expect(formatDemoBuildDate('9223372036854775807'), '未知');
  });
}
