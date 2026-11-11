import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

/// 共享 Demo CJK 字体需要覆盖的字符集合。
///
/// 与 Golden 字体使用的子集保持一致：ASCII 的 &、间隔号、破折号、省略号、
/// 箭头、CJK 标点、部首扩展、基本汉字与全角形式。
bool isSharedCjkFontRune(int rune) =>
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

/// 收集一段 Dart 源码里可能显示出来的字形。
///
/// 只读取字符串字面量（含插值与原始字符串），普通注释、块注释和 dartdoc
/// 都不参与，因此仅在文档注释里改动文字不会要求扩充共享字体。
/// 源码无法解析时退回全文扫描，宁可多要求字形也不放过真实缺口。
Set<int> collectDisplayedGlyphs(String source) {
  final parsed = parseString(content: source, throwIfDiagnostics: false);
  if (parsed.errors.isNotEmpty) {
    return source.runes.where(isSharedCjkFontRune).toSet();
  }
  final collector = _StringGlyphCollector();
  parsed.unit.accept(collector);
  return collector.glyphs;
}

class _StringGlyphCollector extends RecursiveAstVisitor<void> {
  final Set<int> glyphs = <int>{};

  @override
  void visitSimpleStringLiteral(SimpleStringLiteral node) {
    glyphs.addAll(node.value.runes.where(isSharedCjkFontRune));
    super.visitSimpleStringLiteral(node);
  }

  @override
  void visitStringInterpolation(StringInterpolation node) {
    for (final element in node.elements) {
      if (element is InterpolationString) {
        glyphs.addAll(element.value.runes.where(isSharedCjkFontRune));
      }
    }
    super.visitStringInterpolation(node);
  }
}
