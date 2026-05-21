import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/popup/_popup_route.dart';
import 'package:tdesign_flutter/src/components/popup/t_popup_config.dart';
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
                config: TPopupConfig.create(
                  child: const SizedBox(),
                  placement: TPopupPlacement.bottom,
                ),
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
            context: tester.element(find.text('open')),
            placement: TPopupPlacement.bottom,
            height: 120,
            preventScrollThrough: true,
            child: const SizedBox(height: 60),
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
            context: tester.element(find.text('open')),
            placement: TPopupPlacement.bottom,
            height: 120,
            showOverlay: false,
            preventScrollThrough: true,
            cancel: null,
            confirm: null,
            child: const SizedBox(height: 60),
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

      await openPopup(
        tester,
        onPressed: () {
          hostContext = tester.element(find.text('open'));
          TPopup.show(
            context: hostContext,
            placement: TPopupPlacement.bottom,
            height: 100,
            onClose: () => closeCount++,
            child: const SizedBox(height: 60),
          );
        },
      );
      await tester.pumpAndSettle();
      TPopup.close(hostContext);
      await tester.pumpAndSettle();
      expect(closeCount, 1);
    });
  });
}
