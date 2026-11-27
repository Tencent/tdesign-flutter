import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../helpers/text_slot_regression.dart';

void main() {
  registerNativeParagraphContractTests(
    'Link brand slot',
    (child) => TLink(
      colorPreset: TLinkColorPreset.primary,
      onPressed: () {},
      child: child,
    ),
    reset: false,
  );
  registerNativeParagraphContractTests(
    'Link disabled slot',
    (child) => TLink(colorPreset: TLinkColorPreset.primary, child: child),
    reset: false,
  );
  registerNativeParagraphContractTests(
    'Link danger slot',
    (child) => TLink(
      colorPreset: TLinkColorPreset.danger,
      onPressed: () {},
      child: child,
    ),
    reset: false,
  );

  registerTextSlotParityTests(
    'Link brand slot',
    (child) => TLink(
      colorPreset: TLinkColorPreset.primary,
      onPressed: () {},
      child: child,
    ),
  );
  registerTextSlotParityTests(
    'Link disabled slot',
    (child) => TLink(colorPreset: TLinkColorPreset.primary, child: child),
  );
  registerTextSlotParityTests(
    'Link danger slot',
    (child) => TLink(
      colorPreset: TLinkColorPreset.danger,
      onPressed: () {},
      child: child,
    ),
  );

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('basic / underline / prefix / suffix 官方类型可构建', (tester) async {
    await tester.pumpWidget(
      wrap(
        const Column(
          children: [
            TLink(onPressed: _noop, child: Text('基础')),
            TLink(underline: true, onPressed: _noop, child: Text('下划线')),
            TLink(
              prefixIcon: Icon(Icons.arrow_back),
              onPressed: _noop,
              child: Text('前置'),
            ),
            TLink(
              suffixIcon: Icon(Icons.arrow_forward),
              onPressed: _noop,
              child: Text('后置'),
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
            for (final scheme in TLinkColorPreset.values)
              TLink(
                colorPreset: scheme,
                onPressed: _noop,
                child: Text(scheme.name),
              ),
            for (final size in TLinkSize.values)
              TLink(size: size, onPressed: _noop, child: Text(size.name)),
            const TLink(child: Text('禁用')),
          ],
        ),
      ),
    );

    expect(
      find.byType(TLink),
      findsNWidgets(
        TLinkColorPreset.values.length + TLinkSize.values.length + 1,
      ),
    );
  });
}

void _noop() {}
