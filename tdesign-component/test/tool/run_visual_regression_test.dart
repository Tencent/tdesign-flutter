import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/component_test_manifest.dart';
import '../../tool/demo_golden_coverage.dart';
import '../../tool/run_component_regression.dart';
import '../../tool/run_visual_regression.dart';

void main() {
  test('every configured visual regression test file exists', () {
    for (final suite in visualTestSuites) {
      for (final testFile in suite.testFiles) {
        final path = '${suite.workingDirectory}/$testFile';
        expect(File(path).existsSync(), isTrue, reason: '${suite.name}: $path');
        final source = File(path).readAsStringSync();
        expect(
          source.contains('matchesGoldenFile') ||
              source.contains('registerDemoGoldenTests') ||
              source.contains('registerDemoPageTests'),
          isTrue,
          reason: '${suite.name}: $path does not register a Golden assertion',
        );
      }
    }
  });

  test('visual regression uses the exact default Golden comparator', () {
    final goldenTests = [
      for (final root in ['test', 'example/test'])
        ...Directory(root)
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart')),
    ];
    const comparatorAssignment =
        'goldenFileComparator'
        ' =';
    const listComparator =
        'GoldenFileComparator'
        '.compareLists';

    for (final file in goldenTests) {
      final source = file.readAsStringSync();
      expect(
        source,
        isNot(contains(comparatorAssignment)),
        reason: '${file.path} must keep Flutter exact pixel comparison',
      );
      expect(
        source,
        isNot(contains(listComparator)),
        reason: '${file.path} must not add a tolerant pixel comparator',
      );
    }
  });

  test('shared Demo font covers every declared and source CJK glyph', () {
    final glyphManifest = File('example/test/fonts/component_demo_glyphs.txt');
    final declaredGlyphs = glyphManifest
        .readAsStringSync()
        .runes
        .where((rune) => !_isWhitespace(rune))
        .toSet();
    final sourceGlyphs = <int>{};
    for (final root in ['lib', 'example/lib', 'example/test']) {
      for (final file
          in Directory(root)
              .listSync(recursive: true)
              .whereType<File>()
              .where((file) => file.path.endsWith('.dart'))) {
        sourceGlyphs.addAll(
          file.readAsStringSync().runes.where(_belongsInSharedCjkFont),
        );
      }
    }

    expect(
      declaredGlyphs,
      containsAll(sourceGlyphs),
      reason: 'component_demo_glyphs.txt must cover current visible sources',
    );

    final fontGlyphs = _readCmapCodePoints(
      File('example/test/fonts/TDesignGoldenCJK-Regular.otf'),
    );
    expect(
      fontGlyphs,
      containsAll(declaredGlyphs),
      reason: 'TDesignGoldenCJK-Regular.otf must contain every declared glyph',
    );
  });

  test('visual regression suite names are unique', () {
    final names = visualTestSuites.map((suite) => suite.name).toList();
    expect(names.toSet(), hasLength(names.length));
  });

  test('Demo and component Golden suites have explicit ownership', () {
    for (final suite in visualTestSuites) {
      switch (suite.kind) {
        case VisualTestKind.demo:
          expect(
            suite.workingDirectory,
            'example',
            reason: '${suite.name} must run from the example package',
          );
          expect(
            suite.testFiles,
            everyElement(startsWith('test/')),
            reason: '${suite.name} must only contain example tests',
          );
        case VisualTestKind.component:
          expect(
            suite.workingDirectory,
            '.',
            reason: '${suite.name} must run from the component package',
          );
          expect(
            suite.testFiles,
            everyElement(startsWith('test/components/')),
            reason: '${suite.name} must only contain component tests',
          );
      }
    }
  });

  test(
    'every public component owns a Demo Golden suite and light/dark PNGs',
    () {
      for (final component in componentTestSuites) {
        final demoSuites = visualTestSuites.where(
          (suite) =>
              suite.component == component.name &&
              suite.kind == VisualTestKind.demo,
        );
        expect(
          demoSuites,
          isNotEmpty,
          reason: '${component.name} is missing a Demo Golden suite',
        );

        final goldenDirectory = Directory(
          'example/test/${component.name}/goldens',
        );
        expect(
          goldenDirectory.existsSync(),
          isTrue,
          reason: '${component.name} is missing its Demo Golden directory',
        );
        final baselines = goldenDirectory
            .listSync()
            .whereType<File>()
            .map((file) => file.path)
            .toList();
        final lightStates = baselines
            .where((path) => path.endsWith('_light.png'))
            .map((path) => path.substring(0, path.length - '_light.png'.length))
            .toSet();
        final darkStates = baselines
            .where((path) => path.endsWith('_dark.png'))
            .map((path) => path.substring(0, path.length - '_dark.png'.length))
            .toSet();
        expect(
          lightStates,
          isNotEmpty,
          reason: '${component.name} is missing a light Demo Golden',
        );
        expect(
          darkStates,
          lightStates,
          reason: '${component.name} is missing a dark Demo Golden',
        );
      }
    },
  );

  test('every Golden test file is registered in visual regression', () {
    final registered = <String>{
      for (final suite in visualTestSuites)
        for (final testFile in suite.testFiles)
          suite.workingDirectory == '.'
              ? testFile
              : '${suite.workingDirectory}/$testFile',
    };
    final goldenTests = <String>{
      for (final root in ['test/components', 'example/test'])
        ...Directory(root)
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('_golden_test.dart'))
            .map((file) => file.path),
    };

    expect(
      registered,
      containsAll(goldenTests),
      reason: 'Golden test files must not exist outside the visual runner',
    );
  });

  test('every regression component owns a visual regression suite', () {
    final componentSuites = componentTestSuites
        .map((suite) => suite.name)
        .toSet();
    final visualSuites = visualTestSuites
        .map((suite) => suite.component)
        .toSet();

    expect(visualSuites, componentSuites);
  });

  test('every public API component has regression and Golden coverage', () {
    final apiManifest =
        jsonDecode(File('tool/components.json').readAsStringSync())
            as Map<String, dynamic>;
    final apiComponents = (apiManifest['components'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map((component) => component['slug'] as String)
        .toList();
    final componentNames = componentTestSuites
        .map((suite) => _publicComponentSlug(suite.name))
        .toList();
    final coverageNames = demoGoldenCoverage
        .map((coverage) => _publicComponentSlug(coverage.component))
        .toList();

    expect(apiComponents.toSet(), hasLength(apiComponents.length));
    expect(componentNames.toSet(), hasLength(componentNames.length));
    expect(coverageNames.toSet(), hasLength(coverageNames.length));
    expect(componentNames.toSet(), apiComponents.toSet());
    expect(coverageNames.toSet(), apiComponents.toSet());
    for (final coverage in demoGoldenCoverage) {
      expect(coverage.states, isNotEmpty, reason: coverage.component);
      expect(coverage.rationale.trim(), isNotEmpty, reason: coverage.component);
    }
  });
}

bool _isWhitespace(int rune) =>
    rune == 0x09 || rune == 0x0a || rune == 0x0d || rune == 0x20;

bool _belongsInSharedCjkFont(int rune) =>
    rune == 0x26 ||
    rune == 0xb7 ||
    rune == 0x2014 ||
    rune == 0x2026 ||
    rune == 0x2191 ||
    rune == 0x2192 ||
    (rune >= 0x3000 && rune <= 0x303f) ||
    (rune >= 0x3400 && rune <= 0x4dbf) ||
    (rune >= 0x4e00 && rune <= 0x9fff) ||
    (rune >= 0xff00 && rune <= 0xffef);

Set<int> _readCmapCodePoints(File font) {
  final data = ByteData.sublistView(font.readAsBytesSync());
  final tableCount = data.getUint16(4);
  int? cmapOffset;
  for (var index = 0; index < tableCount; index++) {
    final recordOffset = 12 + index * 16;
    if (data.getUint32(recordOffset) == 0x636d6170) {
      cmapOffset = data.getUint32(recordOffset + 8);
      break;
    }
  }
  if (cmapOffset == null) {
    throw const FormatException('Font does not contain a cmap table');
  }

  final codePoints = <int>{};
  final subtableCount = data.getUint16(cmapOffset + 2);
  for (var index = 0; index < subtableCount; index++) {
    final recordOffset = cmapOffset + 4 + index * 8;
    final subtableOffset = cmapOffset + data.getUint32(recordOffset + 4);
    switch (data.getUint16(subtableOffset)) {
      case 4:
        _readFormat4Cmap(data, subtableOffset, codePoints);
      case 12:
        _readFormat12Cmap(data, subtableOffset, codePoints);
    }
  }
  return codePoints;
}

void _readFormat4Cmap(ByteData data, int offset, Set<int> codePoints) {
  final length = data.getUint16(offset + 2);
  final end = offset + length;
  final segmentCount = data.getUint16(offset + 6) ~/ 2;
  final endCodeOffset = offset + 14;
  final startCodeOffset = endCodeOffset + segmentCount * 2 + 2;
  final deltaOffset = startCodeOffset + segmentCount * 2;
  final rangeOffset = deltaOffset + segmentCount * 2;

  for (var index = 0; index < segmentCount; index++) {
    final startCode = data.getUint16(startCodeOffset + index * 2);
    final endCode = data.getUint16(endCodeOffset + index * 2);
    final delta = data.getInt16(deltaOffset + index * 2);
    final rangeAddress = rangeOffset + index * 2;
    final idRangeOffset = data.getUint16(rangeAddress);
    for (var codePoint = startCode; codePoint <= endCode; codePoint++) {
      if (codePoint == 0xffff) {
        continue;
      }
      var glyph = 0;
      if (idRangeOffset == 0) {
        glyph = (codePoint + delta) & 0xffff;
      } else {
        final glyphAddress =
            rangeAddress + idRangeOffset + (codePoint - startCode) * 2;
        if (glyphAddress + 2 <= end) {
          glyph = data.getUint16(glyphAddress);
          if (glyph != 0) {
            glyph = (glyph + delta) & 0xffff;
          }
        }
      }
      if (glyph != 0) {
        codePoints.add(codePoint);
      }
    }
  }
}

void _readFormat12Cmap(ByteData data, int offset, Set<int> codePoints) {
  final groupCount = data.getUint32(offset + 12);
  for (var index = 0; index < groupCount; index++) {
    final groupOffset = offset + 16 + index * 12;
    final startCode = data.getUint32(groupOffset);
    final endCode = data.getUint32(groupOffset + 4);
    final startGlyph = data.getUint32(groupOffset + 8);
    for (var codePoint = startCode; codePoint <= endCode; codePoint++) {
      if (startGlyph + codePoint - startCode != 0) {
        codePoints.add(codePoint);
      }
    }
  }
}

String _publicComponentSlug(String name) {
  return switch (name) {
    'backtop' => 'back-top',
    'refresh' => 'pull-down-refresh',
    'sidebar' => 'side-bar',
    _ => name.replaceAll('_', '-'),
  };
}
