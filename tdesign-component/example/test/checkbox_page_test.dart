import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_base.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/page/t_checkbox_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
  testWidgets('Checkbox Demo follows the official groups', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeModeProvider(),
        child: MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: ExamplePageInheritedTheme(
            model: ExamplePageModel(
              text: 'Checkbox 多选框',
              name: 'checkbox',
              pageBuilder: (_, __) => const TCheckboxPage(),
            ),
            child: const TCheckboxPage(),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('01 组件类型'), findsOneWidget);
    expect(find.text('纵向多选框'), findsOneWidget);

    final scrollState = tester.state<ScrollableState>(
      find.byType(Scrollable).first,
    );
    var foundStatus = false;
    var foundStyle = false;
    var foundSpec = false;
    var foundAll = false;
    for (
      var offset = 0.0;
      offset <= scrollState.position.maxScrollExtent;
      offset += 300
    ) {
      scrollState.position.jumpTo(offset);
      await tester.pump();
      foundStatus |= find.text('02 组件状态').evaluate().isNotEmpty;
      foundStyle |= find.text('03 组件样式').evaluate().isNotEmpty;
      foundSpec |= find.text('04 组件规格').evaluate().isNotEmpty;
      foundAll |= find.text('带全选多选框').evaluate().isNotEmpty;
    }
    expect(foundStatus, isTrue);
    expect(foundStyle, isTrue);
    expect(foundSpec, isTrue);
    expect(foundAll, isTrue);
  });
}
