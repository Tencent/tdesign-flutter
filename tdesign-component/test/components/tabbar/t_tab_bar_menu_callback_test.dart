// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class _RouteObserver extends NavigatorObserver {
  final events = <(String, Route<dynamic>)>[];

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    events.add(('pop', route));
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    events.add(('remove', route));
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) {
      events.add(('replace', oldRoute));
    }
  }
}

void main() {
  for (final custom in [false, true]) {
    for (final nested in [false, true]) {
      for (final action in [
        'none',
        'navigate',
        'close',
        'unmount',
        'removeMenu',
        'replaceMenu',
        'removeHost',
        'unmountNavigator',
        'throw',
        'closeNavigate',
        'resetStack',
        'replaceDirect',
      ]) {
        testWidgets('menu custom=$custom nested=$nested callback=$action', (
          tester,
        ) async {
          final navigatorKey = GlobalKey<NavigatorState>();
          final outerKey = GlobalKey<NavigatorState>();
          final observer = _RouteObserver();
          final outerObserver = _RouteObserver();
          final showTab = ValueNotifier(true);
          final showNavigator = ValueNotifier(true);
          addTearDown(showTab.dispose);
          addTearDown(showNavigator.dispose);
          var calls = 0;
          bool? menuWasCurrent;
          late Route<dynamic> menuRoute;
          late Route<dynamic> hostRoute;
          final payloads = <String>[];
          final callbackError = StateError('selection failed');

          Route<void> target() => MaterialPageRoute<void>(
            settings: const RouteSettings(name: '/target'),
            builder: (_) => const Scaffold(body: Text('target page')),
          );

          void onSelection(String value) {
            calls++;
            payloads.add(value);
            menuWasCurrent = menuRoute.isCurrent;
            final navigator = navigatorKey.currentState!;
            switch (action) {
              case 'navigate':
                unawaited(navigator.push<void>(target()));
              case 'closeNavigate':
                navigator.pop();
                unawaited(navigator.push<void>(target()));
              case 'resetStack':
                unawaited(
                  navigator.pushAndRemoveUntil<void>(target(), (_) => false),
                );
              case 'replaceDirect':
                navigator.replace<void>(
                  oldRoute: menuRoute,
                  newRoute: target(),
                );
              case 'close':
                navigator.pop();
              case 'unmount':
                showTab.value = false;
              case 'removeMenu':
                navigator.removeRoute(menuRoute);
              case 'replaceMenu':
                unawaited(navigator.pushReplacement<void, void>(target()));
              case 'removeHost':
                navigator.removeRoute(hostRoute);
              case 'unmountNavigator':
                showNavigator.value = false;
              case 'throw':
                throw callbackError;
              case 'none':
                break;
            }
          }

          Widget nestedNavigator() => ValueListenableBuilder<bool>(
            valueListenable: showNavigator,
            builder: (_, visible, __) => visible
                ? Navigator(
                    key: navigatorKey,
                    observers: [observer],
                    onGenerateRoute: (_) => MaterialPageRoute<void>(
                      settings: const RouteSettings(name: '/base'),
                      builder: (_) => const Scaffold(body: Text('base page')),
                    ),
                  )
                : const Text('navigator removed'),
          );

          await tester.pumpWidget(
            nested
                ? MaterialApp(
                    navigatorKey: outerKey,
                    navigatorObservers: [outerObserver],
                    home: nestedNavigator(),
                  )
                : ValueListenableBuilder<bool>(
                    valueListenable: showNavigator,
                    builder: (_, visible, __) => visible
                        ? MaterialApp(
                            navigatorKey: navigatorKey,
                            navigatorObservers: [observer],
                            home: const Scaffold(body: Text('base page')),
                          )
                        : const SizedBox(),
                  ),
          );
          hostRoute = MaterialPageRoute<void>(
            settings: const RouteSettings(name: '/host'),
            builder: (_) => Scaffold(
              body: ValueListenableBuilder<bool>(
                valueListenable: showTab,
                builder: (_, visible, __) => visible
                    ? TTabBar(
                        type: TTabBarType.text,
                        value: 0,
                        navigationTabs: [
                          TTabBarItemConfig(
                            tabText: 'menu entry',
                            popUpButtonConfig: TTabBarPopUpBtnConfig(
                              items: [
                                TTabBarMenuItem(
                                  value: 'choice',
                                  itemWidget: custom
                                      ? const Text('custom choice')
                                      : null,
                                ),
                              ],
                              onChanged: onSelection,
                            ),
                          ),
                        ],
                        onChanged: (_) {},
                      )
                    : const Text('tab removed'),
              ),
            ),
          );
          final baseRoute = ModalRoute.of(
            tester.element(find.text('base page')),
          )!;
          unawaited(navigatorKey.currentState!.push<void>(hostRoute));
          await tester.pumpAndSettle();
          await tester.tap(find.text('menu entry'));
          await tester.pumpAndSettle();
          menuRoute = ModalRoute.of(
            tester.element(find.byType(TTabBarMenuItem)),
          )!;
          observer.events.clear();
          outerObserver.events.clear();

          await tester.tap(find.text(custom ? 'custom choice' : 'choice'));
          expect(calls, 1);
          expect(payloads, ['choice']);
          // Both APIs retain the synchronous callback-before-close phase.
          expect(menuWasCurrent, isTrue);
          if (action == 'throw') {
            expect(tester.takeException(), same(callbackError));
            expect(menuRoute.isCurrent, isTrue);
            expect(observer.events, isEmpty);
            navigatorKey.currentState!.pop();
          }
          if (action == 'none') {
            // A normal selection still pops with its reverse transition.
            expect(observer.events, [('pop', menuRoute)]);
            expect(menuRoute.navigator, isNotNull);
            await tester.pump(const Duration(milliseconds: 20));
            expect(menuRoute.navigator, isNotNull);
          }
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(menuRoute.isActive, isFalse);
          expect(outerObserver.events, isEmpty);
          if (action == 'unmountNavigator') {
            expect(navigatorKey.currentState, isNull);
            expect(find.byType(TTabBar), findsNothing);
            return;
          }
          final expectedEvents = switch (action) {
            'navigate' => [('remove', menuRoute)],
            'removeMenu' => [('remove', menuRoute)],
            'replaceMenu' || 'replaceDirect' => [('replace', menuRoute)],
            'resetStack' => [
              ('remove', menuRoute),
              ('remove', hostRoute),
              ('remove', baseRoute),
            ],
            'removeHost' => [('remove', hostRoute), ('pop', menuRoute)],
            _ => [('pop', menuRoute)],
          };
          expect(
            observer.events,
            action == 'resetStack'
                ? unorderedEquals(expectedEvents)
                : expectedEvents,
          );
          expect(
            hostRoute.isActive,
            action != 'removeHost' && action != 'resetStack',
          );
          if (action == 'resetStack') {
            expect(find.text('target page'), findsOneWidget);
            expect(navigatorKey.currentState!.canPop(), isFalse);
            expect(find.byType(TTabBarMenuItem), findsNothing);
          } else if (action == 'navigate' ||
              action == 'replaceMenu' ||
              action == 'replaceDirect' ||
              action == 'closeNavigate') {
            expect(find.text('target page'), findsOneWidget);
            navigatorKey.currentState!.pop();
            await tester.pumpAndSettle();
            expect(hostRoute.isCurrent, isTrue);
            expect(find.byType(TTabBarMenuItem), findsNothing);
          } else if (action == 'removeHost') {
            expect(find.text('base page'), findsOneWidget);
          } else {
            expect(hostRoute.isCurrent, isTrue);
          }
          if (action == 'unmount') {
            expect(find.byType(TTabBar), findsNothing);
            expect(find.text('tab removed'), findsOneWidget);
          }
        });
      }
    }
  }
}
