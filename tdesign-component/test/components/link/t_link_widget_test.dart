import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('basic / underline / prefix / suffix 官方类型可构建', (tester) async {
    await tester.pumpWidget(
      wrap(
        const Column(
          children: [
            TLink(child: Text('基础'), onPressed: _noop),
            TLink(child: Text('下划线'), underline: true, onPressed: _noop),
            TLink(
              child: Text('前置'),
              prefixIcon: Icon(Icons.arrow_back),
              onPressed: _noop,
            ),
            TLink(
              child: Text('后置'),
              suffixIcon: Icon(Icons.arrow_forward),
              onPressed: _noop,
            ),
          ],
        ),
      ),
    );

    expect(find.byType(TLink), findsNWidgets(4));
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
  });

  testWidgets('五种主题、三种尺寸与禁用态可构建', (tester) async {
    await tester.pumpWidget(
      wrap(
        Column(
          children: [
            for (final scheme in TLinkColorScheme.values)
              TLink(
                child: Text(scheme.name),
                colorScheme: scheme,
                onPressed: _noop,
              ),
            for (final size in TLinkSize.values)
              TLink(child: Text(size.name), size: size, onPressed: _noop),
            const TLink(child: Text('禁用')),
          ],
        ),
      ),
    );

    expect(
      find.byType(TLink),
      findsNWidgets(
        TLinkColorScheme.values.length + TLinkSize.values.length + 1,
      ),
    );
  });
}

void _noop() {}
