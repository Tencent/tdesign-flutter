import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/fab/t_fab_layout.dart';

// TFabBounds 构造器覆盖补充
//
// 说明：源码中 TFabBounds 全部以 const 调用（编译期常量，运行期不执行构造器），
// 导致 t_fab_layout.dart 构造器行无覆盖。此处用非 const 调用触发构造器运行期执行。
void main() {
  group('TFabBounds 构造器', () {
    test('非 const 调用触发构造器运行期执行', () {
      // ignore: prefer_const_constructors
      final bounds = TFabBounds(start: 1.0, end: 2.0);
      expect(bounds.start, 1.0);
      expect(bounds.end, 2.0);
    });
  });
}
