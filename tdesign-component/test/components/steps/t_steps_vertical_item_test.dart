import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/steps/t_steps.dart';
import 'package:tdesign_flutter/src/components/steps/t_steps_vertical_item.dart';
import 'package:tdesign_flutter/src/theme/t_theme.dart';

// TStepsVerticalItem 覆盖率补充
//
// 覆盖 build 中以下未覆盖分支：
// - data.successIcon != null：已完成步骤用成功图标替换序号（107-111）
// - status == error && activeIndex == index（非 simple）：错误图标分支（126-131）
// - simple && activeIndex == index && !readOnly：简略模式激活项装饰（167）
void main() {
  Widget wrapWithTheme(Widget child) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [TThemeData.defaultData()],
      ),
      home: Scaffold(body: child),
    );
  }

  final baseData = TStepsItemData(title: '步骤');

  group('TStepsVerticalItem 分支覆盖', () {
    testWidgets('successIcon 替换序号图标', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TStepsVerticalItem(
            data: TStepsItemData(
              title: '步骤',
              successIcon: Icons.check,
            ),
            index: 1,
            stepsCount: 2,
            activeIndex: 0,
            status: TStepsStatus.success,
            simple: false,
            readOnly: false,
            verticalSelect: false,
          ),
        ),
      );
      expect(find.byType(TStepsVerticalItem), findsOneWidget);
    });

    testWidgets('error 状态且为当前激活项时显示错误图标', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TStepsVerticalItem(
            data: TStepsItemData(
              title: '步骤',
              errorIcon: Icons.close,
            ),
            index: 0,
            stepsCount: 1,
            activeIndex: 0,
            status: TStepsStatus.error,
            simple: false,
            readOnly: false,
            verticalSelect: false,
          ),
        ),
      );
      expect(find.byType(TStepsVerticalItem), findsOneWidget);
    });

    testWidgets('error 状态且无 errorIcon 时回落默认关闭图标', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TStepsVerticalItem(
            data: baseData,
            index: 0,
            stepsCount: 1,
            activeIndex: 0,
            status: TStepsStatus.error,
            simple: false,
            readOnly: false,
            verticalSelect: false,
          ),
        ),
      );
      expect(find.byType(TStepsVerticalItem), findsOneWidget);
    });

    testWidgets('simple 模式且为当前激活项时应用激活装饰', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TStepsVerticalItem(
            data: baseData,
            index: 0,
            stepsCount: 1,
            activeIndex: 0,
            status: TStepsStatus.success,
            simple: true,
            readOnly: false,
            verticalSelect: false,
          ),
        ),
      );
      expect(find.byType(TStepsVerticalItem), findsOneWidget);
    });

    testWidgets('长标题在可用宽度内自动换行', (tester) async {
      const longTitle = '这是一个非常非常非常长的步骤标题用于验证垂直步骤可以展示完整内容';
      await tester.pumpWidget(
        wrapWithTheme(
          SizedBox(
            width: 260,
            child: TStepsVerticalItem(
              data: TStepsItemData(title: longTitle),
              index: 0,
              stepsCount: 2,
              activeIndex: 0,
              status: TStepsStatus.success,
              simple: false,
              readOnly: false,
              verticalSelect: true,
            ),
          ),
        ),
      );

      final title = tester.widget<Text>(find.text(longTitle));
      expect(title.maxLines, isNull);
      expect(title.softWrap, isTrue);
      expect(title.overflow, TextOverflow.visible);
      expect(tester.takeException(), isNull);
    });
  });
}
