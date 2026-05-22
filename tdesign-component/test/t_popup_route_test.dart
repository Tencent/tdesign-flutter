import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/popup/_popup_route.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'helpers/popup_test_helpers.dart';
import 'helpers/popup_test_resource.dart';

void main() {
  tearDown(resetPopupTestResource);

  group('TPopupNavigatorRoute', () {
    testWidgets('buildPage 返回占位', (tester) async {
      late TPopupNavigatorRoute<dynamic> route;
      await tester.pumpWidget(
        wrapPopupTest(
          Builder(
            builder: (context) {
              route = TPopupNavigatorRoute<dynamic>(
                options: TPopupOptions(
                  child: const SizedBox(),
                  placement: TPopupPlacement.bottom,
                ).normalized(),
                onCloseWithTrigger: (_, [__]) {},
              );
              return route.buildPage(
                context,
                kAlwaysCompleteAnimation,
                kAlwaysCompleteAnimation,
              );
            },
          ),
        ),
      );
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('蒙层 ScrollNotification 被拦截', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 120,
                preventScrollThrough: true,
                child: const SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();

      var intercepted = false;
      for (final element in tester.elementList(
        find.byType(NotificationListener<ScrollNotification>),
      )) {
        final widget =
            element.widget as NotificationListener<ScrollNotification>;
        if (widget.onNotification?.call(
              ScrollStartNotification(
                metrics: FixedScrollMetrics(
                  minScrollExtent: 0,
                  maxScrollExtent: 100,
                  pixels: 0,
                  viewportDimension: 100,
                  axisDirection: AxisDirection.down,
                  devicePixelRatio: 1,
                ),
                context: element,
              ),
            ) ==
            true) {
          intercepted = true;
          break;
        }
      }
      expect(intercepted, isTrue);
    });

    testWidgets('无蒙层时透明层拦截滚动', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 120,
                showOverlay: false,
                preventScrollThrough: true,
                cancelBuilder: null,
                confirmBuilder: null,
                child: const SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(
        find.byType(NotificationListener<ScrollNotification>),
        findsWidgets,
      );
    });

    testWidgets('fireCloseStart 仅触发一次 onClose', (tester) async {
      var closeCount = 0;
      late BuildContext hostContext;
      TPopupHandle? handle;

      await openPopup(
        tester,
        onPressed: () {
          hostContext = tester.element(find.text('open'));
          handle = TPopup.show(
            hostContext,
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 100,
                onClose: () => closeCount++,
                child: const SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      handle!.close();
      await tester.pumpAndSettle();
      expect(closeCount, 1);
    });
  });
}
