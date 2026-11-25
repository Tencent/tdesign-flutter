import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  for (final destroy in [false, true]) {
    testWidgets('close state and navigator cleanup destroy=$destroy', (
      tester,
    ) async {
      late BuildContext context;
      var created = 0;
      var disposed = 0;
      var closed = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (value) {
              context = value;
              return const Scaffold();
            },
          ),
        ),
      );
      final handle = TPopup.show(
        context,
        options: TPopupOptions.center(
          child: _CloseRetentionProbe(
            onInit: () => created++,
            onDispose: () => disposed++,
          ),
          destroyOnClose: destroy,
          animationDuration: const Duration(milliseconds: 40),
          onClosed: () => closed++,
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'saved');
      final result = handle.result;
      handle.close('result');
      await tester.pumpAndSettle();
      expect(await result, 'result');
      expect(handle.isShowing, isFalse);
      expect(find.byType(TextField), findsNothing);
      expect(disposed, destroy ? 1 : 0);
      expect(closed, 1);
      handle.open();
      await tester.pumpAndSettle();
      expect(created, destroy ? 2 : 1);
      expect(find.text('saved'), destroy ? findsNothing : findsOneWidget);
      handle.close();
      await tester.pumpAndSettle();
      expect(closed, 2);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      expect(disposed, created);
      expect(tester.takeException(), isNull);
    });
  }

  for (final mode in [
    'zero',
    'system',
    'covered',
    'reopen',
    'active-unmount',
    'unpainted',
  ]) {
    testWidgets('retained popup boundary $mode', (tester) async {
      late BuildContext context;
      var created = 0;
      var disposed = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (value) {
              context = value;
              return const Scaffold();
            },
          ),
        ),
      );
      final navigator = Navigator.of(context);
      final handle = TPopup.show(
        context,
        options: TPopupOptions.center(
          child: _CloseRetentionProbe(
            onInit: () => created++,
            onDispose: () => disposed++,
          ),
          animationDuration: mode == 'zero'
              ? Duration.zero
              : const Duration(milliseconds: 40),
        ),
      );
      if (mode == 'unpainted') {
        handle.close();
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
        expect(created, disposed);
        expect(tester.takeException(), isNull);
        return;
      }
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'boundary');
      if (mode == 'active-unmount') {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
        expect(disposed, created);
        expect(tester.takeException(), isNull);
        return;
      }
      if (mode == 'system') {
        navigator.pop();
      } else if (mode == 'covered') {
        unawaited(
          navigator.push(
            MaterialPageRoute<void>(
              builder: (_) => const Scaffold(body: Text('cover')),
            ),
          ),
        );
        await tester.pumpAndSettle();
        handle.close();
      } else {
        handle.close();
      }
      if (mode == 'reopen') {
        await tester.pump(const Duration(milliseconds: 10));
        handle.open();
      }
      await tester.pumpAndSettle();
      expect(disposed, 0);
      if (mode == 'covered') {
        expect(find.text('cover'), findsOneWidget);
        navigator.pop();
        await tester.pumpAndSettle();
      }
      if (mode != 'reopen') {
        handle.open();
      }
      await tester.pumpAndSettle();
      expect(find.text('boundary'), findsOneWidget);
      expect(created, 1);
      handle.close();
      handle.close();
      await tester.pumpAndSettle();
      final hidden = tester.element(
        find.byType(_CloseRetentionProbe, skipOffstage: false),
      );
      // TickerMode.valuesOf is unavailable on Flutter 3.32.
      // ignore: deprecated_member_use
      expect(TickerMode.of(hidden), isFalse);
      expect(
        tester
            .widget<EditableText>(
              find.byType(EditableText, skipOffstage: false),
            )
            .focusNode
            .hasFocus,
        isFalse,
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      expect(disposed, created);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'retained handle changes Navigator without keeping the old subtree',
    (tester) async {
      late BuildContext first;
      late BuildContext second;
      var created = 0;
      var disposed = 0;
      Widget nested(ValueChanged<BuildContext> save) => Navigator(
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          builder: (value) {
            save(value);
            return const Scaffold();
          },
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Row(
            children: [
              Expanded(child: nested((value) => first = value)),
              Expanded(child: nested((value) => second = value)),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final handle = TPopup.show(
        first,
        options: TPopupOptions.center(
          animationDuration: Duration.zero,
          child: _CloseRetentionProbe(
            onInit: () => created++,
            onDispose: () => disposed++,
          ),
        ),
      );
      await tester.pumpAndSettle();
      handle.close();
      await tester.pumpAndSettle();
      expect(disposed, 0);
      handle.open(second);
      await tester.pumpAndSettle();
      expect(created, 2);
      expect(disposed, 1);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      expect(disposed, 2);
    },
  );

  testWidgets(
    'separate show calls retain separate states and release together',
    (tester) async {
      late BuildContext context;
      var created = 0;
      var disposed = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (value) {
              context = value;
              return const Scaffold();
            },
          ),
        ),
      );
      for (var i = 0; i < 2; i++) {
        final handle = TPopup.show(
          context,
          options: TPopupOptions.center(
            animationDuration: Duration.zero,
            child: _CloseRetentionProbe(
              onInit: () => created++,
              onDispose: () => disposed++,
            ),
          ),
        );
        await tester.pumpAndSettle();
        handle.close();
        await tester.pumpAndSettle();
      }
      expect(created, 2);
      expect(disposed, 0);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      expect(disposed, 2);
    },
  );

  for (final destroy in [false, true]) {
    testWidgets(
      'zero animation onOpened may close reentrantly destroy=$destroy',
      (tester) async {
        late BuildContext context;
        TPopupHandle? handle;
        var closed = 0;
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (value) {
                context = value;
                return const Scaffold();
              },
            ),
          ),
        );
        handle = TPopup.show(
          context,
          options: TPopupOptions.center(
            destroyOnClose: destroy,
            animationDuration: Duration.zero,
            onOpened: () => handle!.close(),
            onClosed: () => closed++,
            child: const Text('reentrant'),
          ),
        );
        await tester.pumpAndSettle();
        expect(handle.isShowing, isFalse);
        expect(closed, 1);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final destroy in <bool?>[null, false, true]) {
    for (final mode in ['handle', 'system', 'overlay', 'covered', 'remove']) {
      testWidgets('drawer legacy close $mode destroy=$destroy', (tester) async {
        late BuildContext context;
        late ModalRoute<dynamic> drawerRoute;
        var created = 0;
        var disposed = 0;
        var closed = 0;
        final observer = _RetentionRouteObserver();
        await tester.pumpWidget(
          MaterialApp(
            navigatorObservers: [observer],
            home: Builder(
              builder: (value) {
                context = value;
                return const Scaffold();
              },
            ),
          ),
        );
        final drawer = TDrawer(
          child: Builder(
            builder: (value) {
              drawerRoute = ModalRoute.of(value)!;
              return _CloseRetentionProbe(
                onInit: () => created++,
                onDispose: () => disposed++,
              );
            },
          ),
        );
        final handle = destroy == null
            ? showTDrawer(context, drawer: drawer, onClose: () => closed++)
            : showTDrawer(
                context,
                drawer: drawer,
                destroyOnClose: destroy,
                onClose: () => closed++,
              );
        await tester.pumpAndSettle();
        expect(drawerRoute.maintainState, destroy != true);
        final navigator = Navigator.of(context);
        if (mode == 'covered') {
          unawaited(
            navigator.push(
              MaterialPageRoute<void>(
                builder: (_) => const Scaffold(body: Text('cover')),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(disposed, destroy == true ? 1 : 0);
        }
        switch (mode) {
          case 'system':
            navigator.pop();
          case 'overlay':
            await tester.tapAt(const Offset(10, 300));
          case 'remove':
            navigator.removeRoute(drawerRoute);
          default:
            handle.close();
        }
        await tester.pumpAndSettle();
        expect(handle.isShowing, isFalse);
        expect(disposed, created);
        expect(created, 1);
        expect(closed, 1);
        expect(
          find.byType(_CloseRetentionProbe, skipOffstage: false),
          findsNothing,
        );
        // The home Navigator is still alive; no hidden Drawer session remains.
        expect(navigator.mounted, isTrue);
        expect(observer.pushes, mode == 'covered' ? 3 : 2);
        handle.close();
        await tester.pumpAndSettle();
        expect(closed, 1);
        await tester.pumpWidget(const SizedBox.shrink());
        expect(disposed, 1);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('drawer legacy opaque cover and return destroy=$destroy', (
      tester,
    ) async {
      late BuildContext context;
      var created = 0;
      var disposed = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (value) {
              context = value;
              return const Scaffold();
            },
          ),
        ),
      );
      final drawer = TDrawer(
        child: _CloseRetentionProbe(
          onInit: () => created++,
          onDispose: () => disposed++,
        ),
      );
      final handle = destroy == null
          ? showTDrawer(context, drawer: drawer)
          : showTDrawer(context, drawer: drawer, destroyOnClose: destroy);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'saved drawer');
      final navigator = Navigator.of(context);
      unawaited(
        navigator.push(
          MaterialPageRoute<void>(builder: (_) => const Scaffold()),
        ),
      );
      await tester.pumpAndSettle();
      expect(disposed, destroy == true ? 1 : 0);
      navigator.pop();
      await tester.pumpAndSettle();
      expect(created, destroy == true ? 2 : 1);
      expect(
        find.text('saved drawer'),
        destroy == true ? findsNothing : findsOneWidget,
      );
      handle.close();
      await tester.pump();
      // Normal close keeps content until the exit transition finishes.
      expect(disposed, destroy == true ? 1 : 0);
      await tester.pumpAndSettle();
      expect(disposed, created);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'discarded drawer handles do not retain sessions destroy=$destroy',
      (tester) async {
        late BuildContext context;
        var disposed = 0;
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (value) {
                context = value;
                return const Scaffold();
              },
            ),
          ),
        );
        for (var index = 0; index < 5; index++) {
          final drawer = TDrawer(
            child: _CloseRetentionProbe(
              onInit: () {},
              onDispose: () => disposed++,
            ),
          );
          if (destroy == null) {
            showTDrawer(context, drawer: drawer);
          } else {
            showTDrawer(context, drawer: drawer, destroyOnClose: destroy);
          }
          await tester.pumpAndSettle();
          Navigator.of(context).pop();
          await tester.pumpAndSettle();
          expect(disposed, index + 1);
          expect(
            find.byType(_CloseRetentionProbe, skipOffstage: false),
            findsNothing,
          );
        }
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'popup true keeps active state under opaque cover then destroys on close',
    (tester) async {
      late BuildContext context;
      var created = 0;
      var disposed = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (value) {
              context = value;
              return const Scaffold();
            },
          ),
        ),
      );
      final handle = TPopup.show(
        context,
        options: TPopupOptions.center(
          destroyOnClose: true,
          child: _CloseRetentionProbe(
            onInit: () => created++,
            onDispose: () => disposed++,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'saved popup');
      final navigator = Navigator.of(context);
      unawaited(
        navigator.push(
          MaterialPageRoute<void>(builder: (_) => const Scaffold()),
        ),
      );
      await tester.pumpAndSettle();
      expect(disposed, 0);
      navigator.pop();
      await tester.pumpAndSettle();
      expect(created, 1);
      expect(find.text('saved popup'), findsOneWidget);
      handle.close();
      await tester.pumpAndSettle();
      expect(disposed, 1);
      expect(tester.takeException(), isNull);
    },
  );

  for (final destroy in [false, true]) {
    testWidgets('picker handle reopens with expected state destroy=$destroy', (
      tester,
    ) async {
      late BuildContext context;
      var created = 0;
      var disposed = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (value) {
              context = value;
              return const Scaffold();
            },
          ),
        ),
      );
      final handle = TPickerPopup.show(
        context,
        child: _CloseRetentionProbe(
          onInit: () => created++,
          onDispose: () => disposed++,
        ),
        headerBuilder: (_, __) => const TPopupHeader(title: Text('header')),
        destroyOnClose: destroy,
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'saved picker');
      handle.close();
      await tester.pumpAndSettle();
      expect(disposed, destroy ? 1 : 0);
      handle.open();
      await tester.pumpAndSettle();
      expect(created, destroy ? 2 : 1);
      expect(
        find.text('saved picker'),
        destroy ? findsNothing : findsOneWidget,
      );
      handle.close();
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      expect(disposed, created);
      expect(tester.takeException(), isNull);
    });
  }

  for (final entry in ['popup', 'picker']) {
    testWidgets(
      '$entry same handle reuses GlobalKey and one controller binding',
      (tester) async {
        late BuildContext context;
        final contentKey = GlobalKey<FormState>();
        final scroll = ScrollController();
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (value) {
                context = value;
                return const Scaffold();
              },
            ),
          ),
        );
        final handle = _showReuseSession(
          context,
          entry,
          child: _reuseSessionContent(contentKey, scroll),
        );
        await tester.pumpAndSettle();
        final state = contentKey.currentState;
        scroll.jumpTo(80);
        await tester.pump();
        handle.close();
        await tester.pumpAndSettle();
        expect(contentKey.currentState, same(state));
        expect(scroll.positions, hasLength(1));
        expect(scroll.offset, 80);
        handle.open();
        await tester.pumpAndSettle();
        expect(contentKey.currentState, same(state));
        expect(scroll.positions, hasLength(1));
        expect(scroll.offset, 80);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
        expect(contentKey.currentState, isNull);
        expect(scroll.hasClients, isFalse);
        // Business-owned controllers remain usable after popup cleanup.
        scroll.addListener(_legacyTap);
        scroll.removeListener(_legacyTap);
        scroll.dispose();
        expect(tester.takeException(), isNull);
      },
    );

    for (final destroy in [false, true]) {
      testWidgets('$entry replacement GlobalKey boundary destroy=$destroy', (
        tester,
      ) async {
        late BuildContext context;
        final contentKey = GlobalKey<FormState>();
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (value) {
                context = value;
                return const Scaffold();
              },
            ),
          ),
        );
        TPopupHandle show() => _showReuseSession(
          context,
          entry,
          destroyOnClose: destroy,
          child: Form(key: contentKey, child: const Text('key reuse')),
        );
        final first = show();
        await tester.pumpAndSettle();
        final original = contentKey.currentState;
        first.close();
        await tester.pumpAndSettle();
        expect(contentKey.currentState, destroy ? isNull : same(original));
        show();
        await tester.pumpAndSettle();
        final error = tester.takeException();
        if (destroy) {
          expect(error, isNull);
          expect(contentKey.currentState, isNotNull);
          expect(contentKey.currentState, isNot(same(original)));
        } else {
          // Retained content is still mounted: this reuse violates GlobalKey uniqueness.
          expect(error, isA<FlutterError>());
          expect(error.toString(), contains('Duplicate GlobalKey'));
        }
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
        expect(contentKey.currentState, isNull);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
        '$entry replacement shared ScrollController boundary destroy=$destroy',
        (tester) async {
          late BuildContext context;
          final scroll = ScrollController();
          await tester.pumpWidget(
            MaterialApp(
              home: Builder(
                builder: (value) {
                  context = value;
                  return const Scaffold();
                },
              ),
            ),
          );
          TPopupHandle show() => _showReuseSession(
            context,
            entry,
            destroyOnClose: destroy,
            child: _reuseSessionContent(GlobalKey<FormState>(), scroll),
          );
          final first = show();
          await tester.pumpAndSettle();
          first.close();
          await tester.pumpAndSettle();
          expect(scroll.positions, hasLength(destroy ? 0 : 1));
          final second = show();
          await tester.pumpAndSettle();
          expect(scroll.positions, hasLength(destroy ? 1 : 2));
          if (destroy) {
            expect(scroll.position, isA<ScrollPosition>());
          } else {
            expect(() => scroll.position, throwsAssertionError);
          }
          second.close();
          await tester.pumpAndSettle();
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pump();
          expect(scroll.hasClients, isFalse);
          scroll.addListener(_legacyTap);
          scroll.removeListener(_legacyTap);
          scroll.dispose();
          expect(tester.takeException(), isNull);
        },
      );
    }

    testWidgets('$entry replacement uses independent keys and controllers', (
      tester,
    ) async {
      late BuildContext context;
      final firstKey = GlobalKey<FormState>();
      final secondKey = GlobalKey<FormState>();
      final firstScroll = ScrollController();
      final secondScroll = ScrollController();
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (value) {
              context = value;
              return const Scaffold();
            },
          ),
        ),
      );
      final first = _showReuseSession(
        context,
        entry,
        child: _reuseSessionContent(firstKey, firstScroll),
      );
      await tester.pumpAndSettle();
      final firstState = firstKey.currentState;
      first.close();
      await tester.pumpAndSettle();
      final second = _showReuseSession(
        context,
        entry,
        child: _reuseSessionContent(secondKey, secondScroll),
      );
      await tester.pumpAndSettle();
      expect(firstKey.currentState, same(firstState));
      expect(secondKey.currentState, isNotNull);
      expect(secondKey.currentState, isNot(same(firstState)));
      expect(firstScroll.positions, hasLength(1));
      expect(secondScroll.positions, hasLength(1));
      expect(firstScroll.position, isNot(same(secondScroll.position)));
      second.close();
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      expect(firstKey.currentState, isNull);
      expect(secondKey.currentState, isNull);
      expect(firstScroll.hasClients, isFalse);
      expect(secondScroll.hasClients, isFalse);
      firstScroll.dispose();
      secondScroll.dispose();
      expect(tester.takeException(), isNull);
    });
  }

  for (final entry in ['drawer', 'picker']) {
    for (final destroy in [false, true]) {
      testWidgets('$entry applies close destruction destroy=$destroy', (
        tester,
      ) async {
        late BuildContext context;
        var disposed = 0;
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (value) {
                context = value;
                return const Scaffold();
              },
            ),
          ),
        );
        final content = _CloseRetentionProbe(
          onInit: () {},
          onDispose: () => disposed++,
        );
        final VoidCallback close;
        if (entry == 'drawer') {
          final handle = showTDrawer(
            context,
            drawer: TDrawer(child: content),
            destroyOnClose: destroy,
          );
          close = handle.close;
        } else {
          final handle = TPickerPopup.show(
            context,
            child: content,
            headerBuilder: (_, __) => const TPopupHeader(title: Text('header')),
            destroyOnClose: destroy,
          );
          close = handle.close;
        }
        await tester.pumpAndSettle();
        close();
        await tester.pumpAndSettle();
        expect(disposed, entry == 'drawer' || destroy ? 1 : 0);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
        expect(disposed, 1);
      });
    }
  }

  testWidgets('retained popup keeps implicit primary scroll position', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (value) {
            context = value;
            return const Scaffold();
          },
        ),
      ),
    );
    final handle = TPopup.show(
      context,
      options: TPopupOptions.center(
        width: 260,
        height: 200,
        animationDuration: Duration.zero,
        child: ListView.builder(
          itemExtent: 40,
          itemCount: 50,
          itemBuilder: (_, i) => Text('row $i'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -320));
    await tester.pumpAndSettle();
    final before = tester
        .state<ScrollableState>(find.byType(Scrollable))
        .position
        .pixels;
    expect(before, greaterThan(0));
    handle.close();
    await tester.pumpAndSettle();
    handle.open();
    await tester.pumpAndSettle();
    expect(
      tester.state<ScrollableState>(find.byType(Scrollable)).position.pixels,
      before,
    );
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'retained content has a route context while hidden and after reopen',
    (tester) async {
      late BuildContext context;
      var created = 0;
      var disposed = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (value) {
              context = value;
              return const Scaffold();
            },
          ),
        ),
      );
      final handle = TPopup.show(
        context,
        options: TPopupOptions.center(
          animationDuration: Duration.zero,
          child: _RouteRetentionProbe(
            onInit: () => created++,
            onDispose: () => disposed++,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final visible = tester.element(find.byType(_RouteRetentionProbe));
      final navigator = Navigator.of(visible);
      handle.close();
      await tester.pumpAndSettle();
      final hidden = tester.element(
        find.byType(_RouteRetentionProbe, skipOffstage: false),
      );
      final hiddenRoute = ModalRoute.of(hidden)!;
      var parkingReleased = false;
      unawaited(hiddenRoute.popped.then((_) => parkingReleased = true));
      handle.open();
      await tester.pumpAndSettle();
      expect(created, 1);
      expect(
        Navigator.of(tester.element(find.byType(_RouteRetentionProbe))),
        same(navigator),
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      expect(disposed, 1);
      expect(parkingReleased, isTrue);
    },
  );

  for (final semanticsInitiallyEnabled in [false, true]) {
    testWidgets(
      'retained route preserves navigation and semantics enabled=$semanticsInitiallyEnabled',
      (tester) async {
        final observer = _RetentionRouteObserver();
        final navigatorKey = GlobalKey<NavigatorState>();
        final canPop = ValueNotifier<bool>(false);
        addTearDown(canPop.dispose);
        final notifications = <bool>[];
        var taps = 0;
        late BuildContext context;
        var created = 0;
        var disposed = 0;
        final semantics = semanticsInitiallyEnabled
            ? tester.ensureSemantics()
            : null;
        await tester.pumpWidget(
          NotificationListener<NavigationNotification>(
            onNotification: (notification) {
              notifications.add(notification.canHandlePop);
              return false;
            },
            child: MaterialApp(
              navigatorKey: navigatorKey,
              navigatorObservers: [observer],
              home: Builder(
                builder: (value) {
                  context = value;
                  return Scaffold(
                    body: TextButton(
                      onPressed: () => taps++,
                      child: const Text('underlying action'),
                    ),
                  );
                },
              ),
            ),
          ),
        );
        final owner = navigatorKey.currentState!;
        final handle = TPopup.show(
          context,
          options: TPopupOptions.center(
            animationDuration: const Duration(milliseconds: 40),
            child: ValueListenableBuilder<bool>(
              valueListenable: canPop,
              builder: (context, value, child) => PopScope(
                canPop: value,
                child: Semantics(
                  label: 'retained route content',
                  child: _RouteRetentionProbe(
                    onInit: () => created++,
                    onDispose: () => disposed++,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final extraSemantics = semanticsInitiallyEnabled
            ? null
            : tester.ensureSemantics();
        for (var cycle = 0; cycle < 3; cycle++) {
          final visible = tester.element(find.byType(_RouteRetentionProbe));
          expect(Navigator.of(visible), same(owner));
          final visibleRoute = ModalRoute.of(visible)!;
          expect(visibleRoute.isCurrent, isTrue);
          expect(visibleRoute.isActive, isTrue);
          expect(
            find.bySemanticsLabel(RegExp('retained route content')),
            findsOneWidget,
          );
          expect(owner.canPop(), isTrue);
          // A registered PopScope still vetoes native maybePop while visible.
          canPop.value = false;
          await tester.pumpAndSettle();
          expect(await owner.maybePop(), isTrue);
          await tester.pumpAndSettle();
          expect(handle.isShowing, isTrue);
          handle.close();
          await tester.pumpAndSettle();
          expect(owner.canPop(), isFalse);
          final hidden = tester.element(
            find.byType(_RouteRetentionProbe, skipOffstage: false),
          );
          final hiddenRoute = ModalRoute.of(hidden)!;
          expect(hiddenRoute.isCurrent, isFalse);
          expect(hiddenRoute.isActive, isFalse);
          expect(hiddenRoute.offstage, isTrue);
          expect(Navigator.of(hidden), same(owner));
          expect(
            find.bySemanticsLabel(RegExp('retained route content')),
            findsNothing,
          );
          await tester.tap(find.text('underlying action'));
          await tester.pump();
          expect(taps, cycle + 1);
          notifications.clear();
          canPop.value = true;
          await tester.pumpAndSettle();
          canPop.value = false;
          await tester.pumpAndSettle();
          expect(notifications, isEmpty);
          expect(await owner.maybePop(), isFalse);
          expect(observer.pushes, cycle + 2);
          expect(observer.pops, cycle + 1);
          if (cycle < 2) {
            handle.open();
            await tester.pumpAndSettle();
          }
        }
        expect(created, 1);
        expect(disposed, 0);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
        expect(disposed, 1);
        expect(tester.takeException(), isNull);
        extraSemantics?.dispose();
        semantics?.dispose();
      },
    );
  }

  testWidgets('retained panel survives local theme changes on reopen', (
    tester,
  ) async {
    late BuildContext outer;
    late BuildContext inner;
    var created = 0;
    var disposed = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            outer = context;
            return Theme(
              data: ThemeData.dark(),
              child: Builder(
                builder: (context) {
                  inner = context;
                  return const Scaffold();
                },
              ),
            );
          },
        ),
      ),
    );
    final handle = TPopup.show(
      outer,
      options: TPopupOptions.center(
        animationDuration: Duration.zero,
        child: _CloseRetentionProbe(
          onInit: () => created++,
          onDispose: () => disposed++,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'theme state');
    for (final context in [inner, outer, inner]) {
      handle.close();
      await tester.pumpAndSettle();
      handle.open(context);
      await tester.pumpAndSettle();
      expect(created, 1);
      expect(disposed, 0);
      expect(find.text('theme state'), findsOneWidget);
      expect(
        Theme.of(tester.element(find.byType(TextField))).brightness,
        Theme.of(context).brightness,
      );
    }
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    expect(disposed, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'retained content keeps its own nested Navigator and route stack',
    (tester) async {
      final semantics = tester.ensureSemantics();
      late BuildContext context;
      final nestedKey = GlobalKey<NavigatorState>();
      var created = 0;
      var disposed = 0;
      Widget probe() => _CloseRetentionProbe(
        onInit: () => created++,
        onDispose: () => disposed++,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (value) {
              context = value;
              return const Scaffold();
            },
          ),
        ),
      );
      final handle = TPopup.show(
        context,
        options: TPopupOptions.center(
          animationDuration: const Duration(milliseconds: 40),
          child: HeroControllerScope.none(
            child: Navigator(
              key: nestedKey,
              onGenerateRoute: (_) =>
                  MaterialPageRoute<void>(builder: (_) => probe()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final nested = nestedKey.currentState!;
      unawaited(nested.push(MaterialPageRoute<void>(builder: (_) => probe())));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'nested state');
      handle.close();
      await tester.pumpAndSettle();
      handle.open();
      await tester.pumpAndSettle();
      expect(nestedKey.currentState, same(nested));
      expect(nested.canPop(), isTrue);
      expect(find.text('nested state'), findsOneWidget);
      expect(created, 2);
      expect(disposed, 0);
      expect(await nested.maybePop(), isTrue);
      await tester.pumpAndSettle();
      expect(disposed, 1);
      expect(handle.isShowing, isTrue);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      expect(disposed, 2);
      expect(tester.takeException(), isNull);
      semantics.dispose();
    },
  );

  testWidgets('retained edge panel keeps viewport and end scroll position', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (value) {
            context = value;
            return const Scaffold();
          },
        ),
      ),
    );
    final handle = TPopup.show(
      context,
      options: TPopupOptions.bottom(
        height: 200,
        animationDuration: Duration.zero,
        child: ListView.builder(
          itemCount: 50,
          itemExtent: 40,
          itemBuilder: (_, i) => Text('row $i'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final initial = tester
        .state<ScrollableState>(find.byType(Scrollable))
        .position;
    initial.jumpTo(initial.maxScrollExtent);
    await tester.pumpAndSettle();
    final offset = initial.pixels;
    final viewport = initial.viewportDimension;
    expect(offset, greaterThan(0));
    handle.close();
    await tester.pumpAndSettle();
    final hidden = tester
        .state<ScrollableState>(find.byType(Scrollable, skipOffstage: false))
        .position;
    expect(hidden.viewportDimension, viewport);
    expect(hidden.pixels, offset);
    handle.open();
    await tester.pumpAndSettle();
    final reopened = tester
        .state<ScrollableState>(find.byType(Scrollable))
        .position;
    expect(reopened.viewportDimension, viewport);
    expect(reopened.pixels, offset);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  for (final mode in ['remove', 'non-top-remove', 'pop']) {
    testWidgets('local history consumption then $mode retains session', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      try {
        late BuildContext context;
        var created = 0;
        var disposed = 0;
        var closed = 0;
        var resultCompleted = false;
        final events = <String>[];
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (value) {
                context = value;
                return const Scaffold();
              },
            ),
          ),
        );
        final navigator = Navigator.of(context);
        final handle = TPopup.show(
          context,
          options: TPopupOptions.center(
            animationDuration: const Duration(milliseconds: 120),
            onVisibleChange: (visible, trigger) =>
                events.add('visible:$visible'),
            onOpened: () => events.add('opened'),
            onClosed: () {
              closed++;
              events.add('closed');
            },
            child: _CloseRetentionProbe(
              onInit: () => created++,
              onDispose: () => disposed++,
            ),
          ),
        );
        final result = handle.result;
        unawaited(result.then((_) => resultCompleted = true));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'local history state');
        final originalState = tester.state<_CloseRetentionProbeState>(
          find.byType(_CloseRetentionProbe),
        );
        final route = ModalRoute.of(
          tester.element(find.byType(_CloseRetentionProbe)),
        )!;
        route.addLocalHistoryEntry(
          LocalHistoryEntry(onRemove: () => events.add('history:1')),
        );
        route.addLocalHistoryEntry(
          LocalHistoryEntry(onRemove: () => events.add('history:2')),
        );
        for (var i = 0; i < 2; i++) {
          navigator.pop();
          await tester.pumpAndSettle();
          expect(route.isActive, isTrue);
          expect(handle.isShowing, isTrue);
          expect(disposed, 0);
          expect(closed, 0);
          expect(resultCompleted, isFalse);
        }
        // Preserve the existing close-start notification timing for consumed pops.
        expect(events, [
          'visible:true',
          'opened',
          'visible:false',
          'history:2',
          'history:1',
        ]);
        if (mode == 'non-top-remove') {
          unawaited(
            navigator.push(
              MaterialPageRoute<void>(
                builder: (_) => const Scaffold(body: Text('history cover')),
              ),
            ),
          );
          await tester.pumpAndSettle();
          handle.close('finished');
        } else if (mode == 'remove') {
          navigator.removeRoute(route, 'finished');
        } else {
          navigator.pop('finished');
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 30));
          expect(find.byType(_CloseRetentionProbe), findsOneWidget);
          final duringAnimation = tester.element(
            find.byType(_CloseRetentionProbe),
          );
          expect(ModalRoute.of(duringAnimation), same(route));
          expect(ModalRoute.of(duringAnimation)!.offstage, isFalse);
          expect(disposed, 0);
          expect(closed, 0);
          expect(resultCompleted, isTrue);
        }
        await tester.pumpAndSettle();
        expect(await result, 'finished');
        expect(resultCompleted, isTrue);
        expect(handle.isShowing, isFalse);
        expect(closed, 1);
        expect(disposed, 0);
        expect(events.where((event) => event == 'visible:false'), hasLength(1));
        if (mode == 'non-top-remove') {
          expect(find.text('history cover'), findsOneWidget);
          navigator.pop();
          await tester.pumpAndSettle();
        }
        handle.open();
        await tester.pumpAndSettle();
        expect(created, 1);
        expect(
          tester.state<_CloseRetentionProbeState>(
            find.byType(_CloseRetentionProbe),
          ),
          same(originalState),
        );
        expect(find.text('local history state'), findsOneWidget);
        expect(closed, 1);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
        expect(disposed, 1);
        expect(closed, 2);
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
      }
    });
  }

  testWidgets(
    'local history consumption then declarative replacement retains session',
    (tester) async {
      final page = ValueNotifier<int>(0);
      final navigatorKey = GlobalKey<NavigatorState>();
      late BuildContext context;
      var created = 0;
      var disposed = 0;
      var closed = 0;
      var resultCompleted = false;
      final semantics = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          MaterialApp(
            home: ValueListenableBuilder<int>(
              valueListenable: page,
              builder: (_, value, __) => Navigator(
                key: navigatorKey,
                pages: [
                  const MaterialPage<void>(
                    key: ValueKey('root'),
                    child: Scaffold(),
                  ),
                  MaterialPage<void>(
                    key: ValueKey(value),
                    child: Builder(
                      builder: (value) {
                        context = value;
                        return const Scaffold();
                      },
                    ),
                  ),
                ],
                onDidRemovePage: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final handle = TPopup.show(
          context,
          options: TPopupOptions.center(
            animationDuration: const Duration(milliseconds: 120),
            onClosed: () => closed++,
            child: _CloseRetentionProbe(
              onInit: () => created++,
              onDispose: () => disposed++,
            ),
          ),
        );
        unawaited(handle.result.then((_) => resultCompleted = true));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byType(TextField),
          'declarative history state',
        );
        final original = tester.state<_CloseRetentionProbeState>(
          find.byType(_CloseRetentionProbe),
        );
        final route = ModalRoute.of(
          tester.element(find.byType(_CloseRetentionProbe)),
        )!;
        route.addLocalHistoryEntry(LocalHistoryEntry());
        navigatorKey.currentState!.pop();
        await tester.pumpAndSettle();
        expect(route.isActive, isTrue);
        expect(closed, 0);
        expect(resultCompleted, isFalse);
        page.value = 1;
        await tester.pumpAndSettle();
        expect(handle.isShowing, isFalse);
        expect(closed, 1);
        expect(resultCompleted, isTrue);
        expect(disposed, 0);
        handle.open(context);
        await tester.pumpAndSettle();
        expect(created, 1);
        expect(closed, 1);
        expect(
          tester.state<_CloseRetentionProbeState>(
            find.byType(_CloseRetentionProbe),
          ),
          same(original),
        );
        expect(find.text('declarative history state'), findsOneWidget);
        expect(
          Navigator.of(tester.element(find.byType(_CloseRetentionProbe))),
          same(navigatorKey.currentState),
        );
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
        expect(disposed, 1);
        expect(closed, 2);
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
        page.dispose();
      }
    },
  );

  for (final mode in ['old', 'new', 'both', 'null-new']) {
    for (final closeOnClick in [false, true]) {
      testWidgets(
        'callback alias $mode notifies once before close=$closeOnClick',
        (tester) async {
          late BuildContext context;
          TPopupHandle? handle;
          final events = <String>[];
          void notify(String name) {
            expect(handle!.isShowing, isTrue);
            events.add(name);
          }

          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(
                extensions: const [TPopupThemeData(barrierColor: Colors.red)],
              ),
              home: Builder(
                builder: (value) {
                  context = value;
                  return const Scaffold();
                },
              ),
            ),
          );
          final oldCallback = mode == 'new' ? null : () => notify('old');
          final newCallback = mode == 'new' || mode == 'both'
              ? () => notify('new')
              : null;
          final overlay = mode == 'old'
              ? TPopupOverlayConfig(
                  closeOnClick: closeOnClick,
                  // ignore: deprecated_member_use_from_same_package
                  onClick: oldCallback,
                )
              : TPopupOverlayConfig(
                  closeOnClick: closeOnClick,
                  onTap: newCallback,
                  // ignore: deprecated_member_use_from_same_package
                  onClick: oldCallback,
                );
          handle = TPopup.show(
            context,
            options: TPopupOptions.bottom(
              child: const SizedBox(height: 100),
              overlay: overlay,
              onVisibleChange: (visible, _) {
                if (!visible) {
                  events.add('close');
                }
              },
            ),
          );
          expect(handle.options.overlayConfig.color, Colors.red);
          expect(
            handle.options.overlayConfig.onTap,
            same(newCallback ?? oldCallback),
          );
          expect(
            // ignore: deprecated_member_use_from_same_package
            handle.options.overlayConfig.onClick,
            same(newCallback ?? oldCallback),
          );
          await tester.pumpAndSettle();
          await tester.tapAt(const Offset(10, 10));
          await tester.pumpAndSettle();
          final expected = mode == 'new' || mode == 'both' ? 'new' : 'old';
          expect(events, closeOnClick ? [expected, 'close'] : [expected]);
          expect(handle.isShowing, !closeOnClick);
          handle.close();
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  test('callback alias retains const construction and null defaults', () {
    const current = TPopupOverlayConfig();
    // ignore: deprecated_member_use_from_same_package
    const legacy = TPopupOverlayConfig(onClick: _legacyTap, onTap: null);
    expect(current.onTap, isNull);
    // ignore: deprecated_member_use_from_same_package
    expect(current.onClick, isNull);
    expect(legacy.onTap, same(_legacyTap));
    // ignore: deprecated_member_use_from_same_package
    expect(legacy.onClick, same(_legacyTap));
  });

  group('TPopupOptions', () {
    test('默认 placement 为 bottom，内容 builder 默认均为空', () {
      final options = const TPopupOptions(child: SizedBox()).normalized();
      expect(options.placement, TPopupPlacement.bottom);
      expect(options.overlayConfig.showOverlay, isTrue);
      expect(options.overlayConfig.preventTap, isTrue);
      expect(options.useSafeArea, isFalse);
      expect(options.overlayConfig.effectiveCloseOnClick, isTrue);
      expect(options.headerBuilder, isNull);
      expect(options.closeBuilder, isNull);
    });

    test('showOverlay=false 且省略 closeOnClick 时默认按 false 解析', () {
      final options = const TPopupOptions(
        child: SizedBox(),
        overlay: TPopupOverlayConfig(showOverlay: false),
      ).normalized();
      expect(options.overlayConfig.effectiveCloseOnClick, isFalse);
    });

    test('蒙层组合矩阵均可通过校验并解析默认关闭行为', () {
      void expectValid(
        String reason,
        TPopupOptions options, {
        required bool expectedCloseOnClick,
      }) {
        expect(
          () => options.assertPlacementParams(),
          returnsNormally,
          reason: reason,
        );
        expect(
          options.overlayConfig.effectiveCloseOnClick,
          expectedCloseOnClick,
          reason: reason,
        );
      }

      expectValid(
        '标准模态 + 默认蒙层关闭',
        const TPopupOptions(
          child: SizedBox(),
          overlay: TPopupOverlayConfig(showOverlay: true, preventTap: true),
        ),
        expectedCloseOnClick: true,
      );
      expectValid(
        '标准模态 + 显式禁止蒙层关闭',
        const TPopupOptions(
          child: SizedBox(),
          overlay: TPopupOverlayConfig(
            showOverlay: true,
            preventTap: true,
            closeOnClick: false,
          ),
        ),
        expectedCloseOnClick: false,
      );
      expectValid(
        '透明模态 + 默认不允许蒙层关闭',
        const TPopupOptions(
          child: SizedBox(),
          overlay: TPopupOverlayConfig(showOverlay: false, preventTap: true),
        ),
        expectedCloseOnClick: false,
      );
      expectValid(
        '透明模态 + 显式 false 仍合法',
        const TPopupOptions(
          child: SizedBox(),
          overlay: TPopupOverlayConfig(
            showOverlay: false,
            preventTap: true,
            closeOnClick: false,
          ),
        ),
        expectedCloseOnClick: false,
      );
      expectValid(
        '非模态浮层 + 默认不允许蒙层关闭',
        const TPopupOptions(
          child: SizedBox(),
          overlay: TPopupOverlayConfig(showOverlay: false, preventTap: false),
        ),
        expectedCloseOnClick: false,
      );
      expectValid(
        '显示蒙层但不拦截交互',
        const TPopupOptions(
          child: SizedBox(),
          overlay: TPopupOverlayConfig(showOverlay: true, preventTap: false),
        ),
        expectedCloseOnClick: false,
      );
      expectValid(
        '显示蒙层但不拦截交互时显式关闭仍不生效',
        const TPopupOptions(
          child: SizedBox(),
          overlay: TPopupOverlayConfig(
            showOverlay: true,
            preventTap: false,
            closeOnClick: true,
          ),
        ),
        expectedCloseOnClick: false,
      );
      expectValid(
        '透明模态显式关闭仍不生效',
        const TPopupOptions(
          child: SizedBox(),
          overlay: TPopupOverlayConfig(
            showOverlay: false,
            preventTap: true,
            closeOnClick: true,
          ),
        ),
        expectedCloseOnClick: false,
      );
    });

    test('bottom 默认不显示头部', () {
      final options = const TPopupOptions(
        child: SizedBox(),
        placement: TPopupPlacement.bottom,
      ).normalized();
      expect(options.headerBuilder, isNull);
    });

    test('headerBuilder null 不显示头部', () {
      final options = const TPopupOptions(
        child: SizedBox(),
        placement: TPopupPlacement.bottom,
        headerBuilder: null,
      ).normalized();
      expect(options.headerBuilder, isNull);
    });

    test('headerBuilder 可显式提供整块头部', () {
      final options = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.bottom,
        headerBuilder: (_, __) => const SizedBox(),
      ).normalized();
      expect(options.headerBuilder, isNotNull);
    });

    test('normalized 忽略 bottom 的 closeBuilder', () {
      final options = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.bottom,
        closeBuilder: (_, __) => const Text('x'),
      ).normalized();
      expect(options.closeBuilder, isNull);
    });

    test('center 默认不显示关闭区', () {
      final options = const TPopupOptions(
        child: SizedBox(),
        placement: TPopupPlacement.center,
      ).normalized();
      expect(options.closeBuilder, isNull);
    });

    test('center closeBuilder=null 不显示关闭区', () {
      final options = const TPopupOptions(
        child: SizedBox(),
        placement: TPopupPlacement.center,
        closeBuilder: null,
      ).normalized();
      expect(options.closeBuilder, isNull);
    });

    test('top 剥离 headerBuilder', () {
      final options = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.top,
        headerBuilder: (_, __) => const Text('h'),
      ).normalized();
      expect(options.headerBuilder, isNull);
    });

    test('left/right 剥离 closeBuilder', () {
      final left = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.left,
        closeBuilder: (_, __) => const Text('x'),
      ).normalized();
      expect(left.closeBuilder, isNull);
    });

    test('assertPlacementParams debug 期对错位字段抛 FlutterError', () {
      // left 不该有 height
      expect(
        () => const TPopupOptions(
          child: SizedBox(),
          placement: TPopupPlacement.left,
          height: 100,
        ).assertPlacementParams(),
        throwsA(isA<FlutterError>()),
      );
      // center 不该有 bottom headerBuilder
      expect(
        () => TPopupOptions(
          child: const SizedBox(),
          placement: TPopupPlacement.center,
          headerBuilder: (_, __) => const Text('x'),
        ).assertPlacementParams(),
        throwsA(isA<FlutterError>()),
      );
    });

    test('assertPlacementParams 各 placement 的 inset 类型错位也抛错', () {
      expect(
        () => const TPopupOptions(
          child: SizedBox(),
          placement: TPopupPlacement.top,
          inset: TPopupBottomInset(left: 10),
        ).assertPlacementParams(),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => const TPopupOptions(
          child: SizedBox(),
          placement: TPopupPlacement.right,
          inset: TPopupLeftInset(top: 10),
        ).assertPlacementParams(),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => const TPopupOptions(
          child: SizedBox(),
          placement: TPopupPlacement.center,
          inset: TPopupTopInset(left: 10),
        ).assertPlacementParams(),
        throwsA(isA<FlutterError>()),
      );
    });

    test('assertPlacementParams 合法配置不抛错', () {
      // 各 placement 用对应合法字段
      expect(
        () => const TPopupOptions(child: SizedBox()).assertPlacementParams(),
        returnsNormally,
      );
      expect(
        () => const TPopupOptions(
          child: SizedBox(),
          placement: TPopupPlacement.center,
          width: 200,
          height: 200,
        ).assertPlacementParams(),
        returnsNormally,
      );
      expect(
        () => const TPopupOptions(
          child: SizedBox(),
          placement: TPopupPlacement.left,
          width: 280,
          inset: TPopupLeftInset(top: 10, bottom: 10),
        ).assertPlacementParams(),
        returnsNormally,
      );
      expect(
        () => const TPopupOptions(
          child: SizedBox(),
          overlay: TPopupOverlayConfig(showOverlay: false, preventTap: false),
        ).assertPlacementParams(),
        returnsNormally,
      );
    });

    test('copyWith 可更新 useSafeArea', () {
      final options = const TPopupOptions(
        child: SizedBox(),
      ).copyWith(useSafeArea: true);
      expect(options.useSafeArea, isTrue);
    });

    test('normalized 保留 useSafeArea', () {
      final options = const TPopupOptions(
        child: SizedBox(),
        useSafeArea: false,
      ).normalized();
      expect(options.useSafeArea, isFalse);
    });

    test('bottom 工厂可显式开启 useSafeArea', () {
      final options = TPopupOptions.bottom(
        child: const SizedBox(),
        useSafeArea: true,
      );
      expect(options.useSafeArea, isTrue);
    });

    group('useSafeArea 边界', () {
      test('各命名工厂默认 useSafeArea 为 false', () {
        const child = SizedBox();
        expect(TPopupOptions.bottom(child: child).useSafeArea, isFalse);
        expect(TPopupOptions.top(child: child).useSafeArea, isFalse);
        expect(TPopupOptions.left(child: child).useSafeArea, isFalse);
        expect(TPopupOptions.right(child: child).useSafeArea, isFalse);
        expect(TPopupOptions.center(child: child).useSafeArea, isFalse);
      });

      test('各命名工厂可显式开启 useSafeArea', () {
        const child = SizedBox();
        expect(
          TPopupOptions.top(child: child, useSafeArea: true).useSafeArea,
          isTrue,
        );
        expect(
          TPopupOptions.left(child: child, useSafeArea: true).useSafeArea,
          isTrue,
        );
        expect(
          TPopupOptions.right(child: child, useSafeArea: true).useSafeArea,
          isTrue,
        );
        expect(
          TPopupOptions.center(child: child, useSafeArea: true).useSafeArea,
          isTrue,
        );
      });

      test('copyWith 未传 useSafeArea 时保留原值', () {
        const original = TPopupOptions(child: SizedBox(), useSafeArea: false);
        final copied = original.copyWith(height: 100);
        expect(copied.useSafeArea, isFalse);
        expect(copied.height, 100);
      });

      test('copyWith 变更 placement 时仍保留 useSafeArea', () {
        final options = const TPopupOptions(
          child: SizedBox(),
          placement: TPopupPlacement.bottom,
          useSafeArea: false,
        ).copyWith(placement: TPopupPlacement.top);
        expect(options.placement, TPopupPlacement.top);
        expect(options.useSafeArea, isFalse);
      });
    });

    test('TPopupOverlayConfig.effectiveCloseOnClick 跟随 showOverlay', () {
      const config = TPopupOverlayConfig(showOverlay: true);
      expect(config.effectiveCloseOnClick, isTrue);
      const config2 = TPopupOverlayConfig(showOverlay: false);
      expect(config2.effectiveCloseOnClick, isFalse);
    });

    test('TPopupOverlayConfig 默认值与字段', () {
      const config = TPopupOverlayConfig();
      expect(config.showOverlay, isTrue);
      expect(config.color, isNull);
      expect(config.preventTap, isTrue);
      expect(config.closeOnClick, isNull);
      expect(config.onTap, isNull);
      expect(config.effectiveCloseOnClick, isTrue);
    });

    test('overlay 为 null 时 overlayConfig 返回默认配置', () {
      const options = TPopupOptions(child: SizedBox());
      expect(options.overlay, isNull);
      expect(options.overlayConfig.showOverlay, isTrue);
      expect(options.overlayConfig.preventTap, isTrue);
    });
  });
}

TPopupHandle _showReuseSession(
  BuildContext context,
  String entry, {
  required Widget child,
  bool destroyOnClose = false,
}) => entry == 'picker'
    ? TPickerPopup.show(
        context,
        child: child,
        headerBuilder: (_, __) => const TPopupHeader(title: Text('header')),
        destroyOnClose: destroyOnClose,
      )
    : TPopup.show(
        context,
        options: TPopupOptions.center(
          width: 240,
          height: 200,
          destroyOnClose: destroyOnClose,
          child: child,
        ),
      );

Widget _reuseSessionContent(
  GlobalKey<FormState> contentKey,
  ScrollController scroll,
) => Form(
  key: contentKey,
  child: ListView(
    controller: scroll,
    children: List.generate(
      20,
      (index) => SizedBox(height: 32, child: Text('row $index')),
    ),
  ),
);

class _CloseRetentionProbe extends StatefulWidget {
  const _CloseRetentionProbe({required this.onInit, required this.onDispose});
  final VoidCallback onInit;
  final VoidCallback onDispose;
  @override
  State<_CloseRetentionProbe> createState() => _CloseRetentionProbeState();
}

class _CloseRetentionProbeState extends State<_CloseRetentionProbe> {
  @override
  void initState() {
    super.initState();
    widget.onInit();
  }

  @override
  void dispose() {
    widget.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const Material(child: TextField());
}

class _RouteRetentionProbe extends StatefulWidget {
  const _RouteRetentionProbe({required this.onInit, required this.onDispose});
  final VoidCallback onInit;
  final VoidCallback onDispose;
  @override
  State<_RouteRetentionProbe> createState() => _RouteRetentionProbeState();
}

class _RouteRetentionProbeState extends State<_RouteRetentionProbe> {
  @override
  void initState() {
    super.initState();
    widget.onInit();
  }

  @override
  void dispose() {
    widget.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Text('route: ${ModalRoute.of(context)!.isCurrent}');
}

class _RetentionRouteObserver extends NavigatorObserver {
  int pushes = 0;
  int pops = 0;
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushes++;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pops++;
  }
}

void _legacyTap() {}
