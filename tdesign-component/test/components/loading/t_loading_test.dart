import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/loading/t_circle_indicator.dart';
import 'package:tdesign_flutter/src/components/loading/t_point_indicator.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TLoading Widget 测试
///
/// Tier1 组件：覆盖 Theme 子树 mergeExtension(TLoadingThemeData)。
/// 覆盖 size 三档、icon 三种、text、axis 方向。
void main() {
  Widget wrapWithTheme(Widget child, {TLoadingThemeData? loadingTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (loadingTheme != null) {
      theme = theme.mergeExtension(loadingTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: child),
      ),
    );
  }

  // ============================================================
  // 基础渲染
  // ============================================================
  group('TLoading 基础渲染', () {
    testWidgets('size=small 正常渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TLoading(size: TLoadingSize.small)),
      );
      expect(find.byType(TLoading), findsOneWidget);
    });

    testWidgets('size=medium 正常渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TLoading(size: TLoadingSize.medium)),
      );
      expect(find.byType(TLoading), findsOneWidget);
      final indicator = tester.widget<TCircleIndicator>(
        find.byType(TCircleIndicator),
      );
      expect(indicator.size, 21);
      expect(indicator.lineWidth, 3 * 7 / 6);
      expect(indicator.duration, 2000);
    });

    testWidgets('size=large 正常渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TLoading(size: TLoadingSize.large)),
      );
      expect(find.byType(TLoading), findsOneWidget);
    });
  });

  // ============================================================
  // icon 图标类型
  // ============================================================
  group('TLoading icon 类型', () {
    testWidgets('circle 图标正常渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TLoading(size: TLoadingSize.medium, icon: TLoadingIcon.circle),
        ),
      );
      expect(find.byType(TLoading), findsOneWidget);
    });

    testWidgets('point 点状图标正常渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TLoading(size: TLoadingSize.medium, icon: TLoadingIcon.point),
        ),
      );
      expect(find.byType(TLoading), findsOneWidget);
    });

    testWidgets('activity 菊花状图标正常渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TLoading(
            size: TLoadingSize.medium,
            icon: TLoadingIcon.activity,
          ),
        ),
      );
      expect(find.byType(TLoading), findsOneWidget);
    });
  });

  // ============================================================
  // text 文案
  // ============================================================
  group('TLoading 文案', () {
    testWidgets('text 显示加载文案', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TLoading(size: TLoadingSize.medium, text: '加载中...'),
        ),
      );
      expect(find.text('加载中...'), findsOneWidget);
    });

    testWidgets('无 text 时正常渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TLoading(size: TLoadingSize.medium)),
      );
      expect(find.byType(TLoading), findsOneWidget);
    });
  });

  // ============================================================
  // Tier1：Theme 子树 mergeExtension
  // ============================================================
  group('TLoading Theme 子树 mergeExtension', () {
    testWidgets('mergeExtension 覆盖 axis 方向', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TLoading(size: TLoadingSize.medium, text: '横向加载'),
          loadingTheme: const TLoadingThemeData(axis: Axis.horizontal),
        ),
      );
      expect(find.text('横向加载'), findsOneWidget);
      expect(find.byType(TLoading), findsOneWidget);
      expect(tester.widget<Flex>(find.byType(Flex)).direction, Axis.horizontal);
    });

    testWidgets('mergeExtension 覆盖 iconColor 颜色', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TLoading(size: TLoadingSize.medium),
          loadingTheme: const TLoadingThemeData(iconColor: Colors.red),
        ),
      );
      expect(find.byType(TLoading), findsOneWidget);
      expect(
        tester.widget<TCircleIndicator>(find.byType(TCircleIndicator)).color,
        Colors.red,
      );
    });

    testWidgets('mergeExtension 覆盖 textColor 颜色', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TLoading(size: TLoadingSize.medium, text: '颜色测试'),
          loadingTheme: const TLoadingThemeData(textColor: Colors.blue),
        ),
      );
      expect(find.text('颜色测试'), findsOneWidget);
      expect(
        tester.widget<TText>(_loadingTextFinder('颜色测试')).textColor,
        Colors.blue,
      );
    });

    testWidgets('mergeExtension 覆盖 duration 动画速度', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TLoading(size: TLoadingSize.medium),
          loadingTheme: const TLoadingThemeData(duration: 1000),
        ),
      );
      expect(find.byType(TLoading), findsOneWidget);
    });

    testWidgets('实例 customIcon 自定义图标', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TLoading(
            size: TLoadingSize.medium,
            customIcon: Icon(Icons.refresh, size: 24),
          ),
        ),
      );
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('未注入 Theme 时使用默认值', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        wrapWithTheme(const TLoading(size: TLoadingSize.medium, text: '默认')),
      );
      expect(find.text('默认'), findsOneWidget);
      expect(find.byType(TLoading), findsOneWidget);
      final text = tester.widget<TText>(_loadingTextFinder('默认'));
      expect(text.textColor, token.textColorPrimary);
      expect(text.font, token.fontBodyMedium);
      expect(text.fontWeight, FontWeight.w400);
      expect(text.textAlign, TextAlign.center);
    });
  });

  // ============================================================
  // TLoadingController
  // ============================================================
  group('TLoadingController', () {
    testWidgets('缺少 Overlay 时不污染后续显示状态', (tester) async {
      late BuildContext bareContext;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) {
              bareContext = context;
              return const SizedBox();
            },
          ),
        ),
      );

      TLoadingController.show(bareContext, text: '不可显示');
      expect(tester.takeException(), isNull);

      late BuildContext overlayContext;
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              overlayContext = context;
              return const SizedBox();
            },
          ),
        ),
      );
      TLoadingController.show(overlayContext, text: '可以显示');
      await tester.pump();
      expect(find.text('可以显示'), findsOneWidget);
      TLoadingController.dismiss();
      await tester.pump();
    });

    testWidgets('show + dismiss', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );
      TLoadingController.show(ctx, text: '加载中');
      await tester.pump();
      expect(find.text('加载中'), findsOneWidget);
      TLoadingController.dismiss();
      await tester.pump();
      expect(find.text('加载中'), findsNothing);
    });

    testWidgets('show 带 theme', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );
      TLoadingController.show(ctx, theme: const TLoadingThemeData());
      await tester.pump();
      expect(find.byType(TLoading), findsOneWidget);
      TLoadingController.dismiss();
      await tester.pump();
    });

    testWidgets('保留触发子树的 ThemeExtension', (tester) async {
      late BuildContext ctx;
      final base = TThemeBuilder.light(TThemeData.defaultData());
      await tester.pumpWidget(
        MaterialApp(
          theme: base,
          home: Theme(
            data: base.mergeExtension(
              const TLoadingThemeData(iconColor: Colors.purple),
            ),
            child: Builder(
              builder: (context) {
                ctx = context;
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      TLoadingController.show(ctx, text: '局部主题');
      await tester.pump();
      final indicator = tester.widget<TCircleIndicator>(
        find.byType(TCircleIndicator),
      );
      expect(indicator.color, Colors.purple);
      TLoadingController.dismiss();
      await tester.pump();
    });

    testWidgets('重复 show 打印 warning', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );
      TLoadingController.show(ctx, text: '第一次');
      await tester.pump();
      TLoadingController.show(ctx, text: '第二次');
      await tester.pump();
      expect(find.text('第一次'), findsOneWidget);
      TLoadingController.dismiss();
      await tester.pump();
    });
  });

  // ============================================================
  // 覆盖率补充
  // ============================================================

  // TLoading icon=null 覆盖 _textWidget 分支
  group('TLoading 覆盖率补充', () {
    testWidgets('icon=null + size=small 走 _textWidget', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TLoading(size: TLoadingSize.small, icon: null, text: '加载中'),
        ),
      );
      expect(find.text('加载中'), findsOneWidget);
    });

    testWidgets('icon=null + size=large 走 _textWidget', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TLoading(size: TLoadingSize.large, icon: null, text: '加载中'),
        ),
      );
      expect(find.text('加载中'), findsOneWidget);
    });

    testWidgets('icon=null + refreshWidget 走 Row', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: const Scaffold(
            body: TLoading(
              size: TLoadingSize.medium,
              icon: null,
              text: '加载中',
              refreshWidget: Text('刷新'),
            ),
          ),
        ),
      );
      expect(find.text('加载中'), findsOneWidget);
      expect(find.text('刷新'), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets('icon=point + size=small 覆盖 _getPaddingSize', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TLoading(
            size: TLoadingSize.small,
            icon: TLoadingIcon.point,
            text: '加载中',
          ),
        ),
      );
      // point indicator 有无限动画，用 pump 而非 pumpAndSettle
      await tester.pump();
      expect(find.text('加载中'), findsOneWidget);
    });
  });

  // TPointBounceIndicator didUpdateWidget 覆盖
  group('TPointBounceIndicator 覆盖率补充', () {
    testWidgets('didUpdateWidget duration 变化触发更新', (tester) async {
      var duration = 1000;
      late StateSetter setState;
      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setter) {
              setState = setter;
              return TPointBounceIndicator(duration: duration);
            },
          ),
        ),
      );
      await tester.pump();
      // 改变 duration 触发 didUpdateWidget
      setState(() => duration = 2000);
      await tester.pump();
      expect(find.byType(TPointBounceIndicator), findsOneWidget);
    });
  });

  // TCircleIndicator 非正方形尺寸覆盖 paint else 分支
  group('TCircleIndicator 覆盖率补充', () {
    testWidgets('非正方形尺寸渲染覆盖 else 分支', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const SizedBox(width: 100, height: 50, child: TCircleIndicator()),
        ),
      );
      await tester.pump();
      expect(find.byType(TCircleIndicator), findsOneWidget);
    });
  });
}

Finder _loadingTextFinder(String data) {
  return find.byWidgetPredicate(
    (widget) => widget is TText && widget.data == data,
  );
}
