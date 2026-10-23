// Historical API calls are intentional compatibility fixtures.
// Explicit function types verify source compatibility, rather than inferred new types.
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, omit_local_variable_types

import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/popover/t_popover_widget.dart';
import 'package:tdesign_flutter/src/components/steps/t_steps_horizontal.dart';
import 'package:tdesign_flutter/src/components/steps/t_steps_mode.dart';
import 'package:tdesign_flutter/src/components/steps/t_steps_vertical.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void _target(TNoticeBarTapTarget _) {}
void _void() {}
void _index(int _) {}
void _item(int _, TDrawerItem __) {}

void _otherVoid() {}
void _otherTarget(TNoticeBarTapTarget _) {}
void _otherIndex(int _) {}
void _otherItem(int _, TDrawerItem __) {}
void _string(String _) {}
void _otherString(String _) {}
Widget _anchor(
  BuildContext context,
  TPopoverController controller,
  Widget? child,
) => const Text('anchor');

class _LegacyNotice extends TNoticeBar {
  const _LegacyNotice({super.onTargetTap}) : super(content: 'legacy notice');
  @override
  ValueChanged<TNoticeBarTapTarget>? get onPressed => _target;
}

class _LegacyCheckbox extends TCheckboxGroup<int> {
  const _LegacyCheckbox({super.onSelectionLimitExceeded})
    : super(value: const [], options: const []);
  @override
  VoidCallback? get onMaxSelected => _void;
}

class _LegacyDrawer extends TDrawer {
  const _LegacyDrawer({this.callback = _item, super.onItemTap})
    : super(items: const [TDrawerItem(title: 'legacy item')]);
  final TDrawerItemClickCallback callback;
  @override
  TDrawerItemClickCallback? get onItemClick => callback;
}

class _LegacyAnchor extends TPopoverAnchor {
  const _LegacyAnchor({super.onLongPress})
    : super(content: const Text('content'), builder: _anchor);
  @override
  VoidCallback? get onLongTap => _void;
}

class _LegacyPopoverWidget extends TPopoverWidget {
  const _LegacyPopoverWidget({required super.context, super.onLongPress})
    : super(content: const Text('content'));
  @override
  VoidCallback? get onLongTap => _void;
}

class _LegacyOverlay extends TPopupOverlayConfig {
  const _LegacyOverlay({super.onTap});
  @override
  VoidCallback? get onClick => _void;
}

class _LegacySteps extends TSteps {
  const _LegacySteps({super.onStepTapped}) : super.progress(steps: const []);
  const _LegacySteps.selectable({super.onStepTapped})
    : super.selectable(steps: const [], value: 0, onChange: _otherIndex);
  @override
  ValueChanged<int>? get onChange => _index;
}

class _LegacyHorizontal extends TStepsHorizontal {
  const _LegacyHorizontal({super.onStepTapped})
    : super(
        steps: const [],
        activeIndex: 0,
        status: TStepsStatus.process,
        indicator: TStepsIndicator.standard,
        mode: TStepsMode.progress,
      );
  @override
  ValueChanged<int>? get onChange => _index;
}

class _LegacyVertical extends TStepsVertical {
  const _LegacyVertical({super.onStepTapped})
    : super(
        steps: const [],
        activeIndex: 0,
        status: TStepsStatus.process,
        indicator: TStepsIndicator.standard,
        mode: TStepsMode.progress,
      );
  @override
  ValueChanged<int>? get onChange => _index;
}

class _LegacyTab extends TTabBarItemConfig {
  const _LegacyTab({super.notifyOnReselect});
  @override
  bool get allowMultipleTaps => true;
}

class _LegacyMenu extends TTabBarPopUpBtnConfig {
  _LegacyMenu({super.onSelected})
    : super(items: const [], onChanged: _otherString);
  @override
  ValueChanged<String> get onChanged => _string;
}

class _LegacyPopup extends TPopupOptions {
  const _LegacyPopup({super.maintainState})
    : super(child: const Text('legacy panel'));
  @override
  bool get destroyOnClose => true;
}

const Object _legacyUnset = Object();

class _AdaptedCopyWithOptions extends TPopupOptions {
  _AdaptedCopyWithOptions({
    required this.onCopy,
    required this.onArgument,
    required this.onMaintainState,
  }) : super(
         child: const Text('legacy copy'),
         width: 120,
         destroyOnClose: true,
       );

  final VoidCallback onCopy;
  final ValueChanged<bool?> onArgument;
  final ValueChanged<bool?> onMaintainState;

  @override
  TPopupOptions copyWith({
    Widget? child,
    TPopupPlacement? placement,
    Object? width = _legacyUnset,
    Object? height = _legacyUnset,
    Object? inset = _legacyUnset,
    Object? radius = _legacyUnset,
    Object? backgroundColor = _legacyUnset,
    Object? overlay = _legacyUnset,
    bool? destroyOnClose,
    bool? maintainState,
    Duration? animationDuration,
    Object? headerBuilder = _legacyUnset,
    Object? closeBuilder = _legacyUnset,
    Object? onOpened = _legacyUnset,
    Object? onClosed = _legacyUnset,
    Object? onVisibleChange = _legacyUnset,
    bool? useSafeArea,
  }) {
    onCopy();
    onArgument(destroyOnClose);
    onMaintainState(maintainState);
    return super.copyWith(
      child: child,
      placement: placement,
      width: identical(width, _legacyUnset) ? this.width : width,
      height: identical(height, _legacyUnset) ? this.height : height,
      inset: identical(inset, _legacyUnset) ? this.inset : inset,
      radius: identical(radius, _legacyUnset) ? this.radius : radius,
      backgroundColor: identical(backgroundColor, _legacyUnset)
          ? this.backgroundColor
          : backgroundColor,
      overlay: identical(overlay, _legacyUnset) ? this.overlay : overlay,
      destroyOnClose: destroyOnClose,
      maintainState: maintainState,
      animationDuration: animationDuration,
      headerBuilder: identical(headerBuilder, _legacyUnset)
          ? this.headerBuilder
          : headerBuilder,
      closeBuilder: identical(closeBuilder, _legacyUnset)
          ? this.closeBuilder
          : closeBuilder,
      onOpened: identical(onOpened, _legacyUnset) ? this.onOpened : onOpened,
      onClosed: identical(onClosed, _legacyUnset) ? this.onClosed : onClosed,
      onVisibleChange: identical(onVisibleChange, _legacyUnset)
          ? this.onVisibleChange
          : onVisibleChange,
      useSafeArea: useSafeArea,
    );
  }
}

class _LifetimeProbe extends StatefulWidget {
  const _LifetimeProbe({required this.onDispose});
  final VoidCallback onDispose;
  @override
  State<_LifetimeProbe> createState() => _LifetimeProbeState();
}

class _LifetimeProbeState extends State<_LifetimeProbe> {
  @override
  void dispose() {
    widget.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const Text('lifetime content');
}

void main() {
  final inheritedContracts = <String, VoidCallback>{
    'NoticeBar': () {
      expect(const _LegacyNotice().onTargetTap, same(_target));
      expect(
        const _LegacyNotice(onTargetTap: _otherTarget).onTargetTap,
        same(_otherTarget),
      );
    },
    'CheckboxGroup': () {
      expect(const _LegacyCheckbox().onSelectionLimitExceeded, same(_void));
      expect(
        const _LegacyCheckbox(
          onSelectionLimitExceeded: _otherVoid,
        ).onSelectionLimitExceeded,
        same(_otherVoid),
      );
    },
    'Drawer': () {
      expect(const _LegacyDrawer().onItemTap, same(_item));
      expect(
        const _LegacyDrawer(onItemTap: _otherItem).onItemTap,
        same(_otherItem),
      );
    },
    'PopoverAnchor': () {
      expect(const _LegacyAnchor().onLongPress, same(_void));
      expect(
        const _LegacyAnchor(onLongPress: _otherVoid).onLongPress,
        same(_otherVoid),
      );
    },
    'PopupOverlay': () {
      expect(const _LegacyOverlay().onTap, same(_void));
      expect(const _LegacyOverlay(onTap: _otherVoid).onTap, same(_otherVoid));
    },
    'Steps progress': () {
      expect(const _LegacySteps().onStepTapped, same(_index));
      expect(
        const _LegacySteps(onStepTapped: _otherIndex).onStepTapped,
        same(_otherIndex),
      );
    },
    'Steps selectable': () {
      expect(const _LegacySteps.selectable().onStepTapped, same(_index));
      expect(
        const _LegacySteps.selectable(onStepTapped: _otherIndex).onStepTapped,
        same(_otherIndex),
      );
    },
    'Steps horizontal': () {
      expect(const _LegacyHorizontal().onStepTapped, same(_index));
      expect(
        const _LegacyHorizontal(onStepTapped: _otherIndex).onStepTapped,
        same(_otherIndex),
      );
    },
    'Steps vertical': () {
      expect(const _LegacyVertical().onStepTapped, same(_index));
      expect(
        const _LegacyVertical(onStepTapped: _otherIndex).onStepTapped,
        same(_otherIndex),
      );
    },
    'Tab reselect': () {
      expect(const _LegacyTab().notifyOnReselect, isTrue);
      expect(
        const _LegacyTab(notifyOnReselect: false).notifyOnReselect,
        isFalse,
      );
    },
    'Tab menu': () {
      expect(_LegacyMenu().onSelected, same(_string));
      expect(
        _LegacyMenu(onSelected: _otherString).onSelected,
        same(_otherString),
      );
    },
    'Popup options': () {
      expect(const _LegacyPopup().maintainState, isFalse);
      expect(const _LegacyPopup().copyWith().maintainState, isFalse);
      expect(const _LegacyPopup().normalized().maintainState, isFalse);
      expect(const _LegacyPopup(maintainState: true).maintainState, isTrue);
    },
  };
  for (final entry in inheritedContracts.entries) {
    test(
      'legacy override and explicit new precedence: ${entry.key}',
      entry.value,
    );
  }
  testWidgets(
    'direct PopoverWidget retains legacy override and new precedence',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(
                _LegacyPopoverWidget(context: context).onLongPress,
                same(_void),
              );
              expect(
                _LegacyPopoverWidget(
                  context: context,
                  onLongPress: _otherVoid,
                ).onLongPress,
                same(_otherVoid),
              );
              return const SizedBox();
            },
          ),
        ),
      );
    },
  );
  testWidgets('legacy Drawer subclass dispatches actual item taps once', (
    tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: _LegacyDrawer(callback: (_, __) => calls++)),
      ),
    );
    await tester.tap(find.text('legacy item'));
    expect(calls, 1);
  });
  testWidgets('legacy Popup subclass lifecycle override reaches the route', (
    tester,
  ) async {
    late BuildContext host;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              host = context;
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    final handle = TPopup.show(host, options: const _LegacyPopup());
    await tester.pumpAndSettle();
    expect(
      ModalRoute.of(tester.element(find.text('legacy panel')))!.maintainState,
      isFalse,
    );
    handle.close();
    await tester.pumpAndSettle();
  });

  test('legacy const constructors and readonly properties remain usable', () {
    const notice = TNoticeBar(onPressed: _target);
    const checkbox = TCheckboxGroup<int>(
      value: [],
      options: [],
      onMaxSelected: _void,
    );
    const drawer = TDrawer(onItemClick: _item);
    const overlay = TPopupOverlayConfig(onClick: _void);
    const tab = TTabBarItemConfig(allowMultipleTaps: true);
    const steps = TSteps.selectable(steps: [], value: 0, onChange: _index);
    const horizontal = TStepsHorizontal(
      steps: [],
      activeIndex: 0,
      status: TStepsStatus.process,
      indicator: TStepsIndicator.standard,
      mode: TStepsMode.progress,
      onChange: _index,
    );
    const vertical = TStepsVertical(
      steps: [],
      activeIndex: 0,
      status: TStepsStatus.process,
      indicator: TStepsIndicator.standard,
      mode: TStepsMode.progress,
      onChange: _index,
    );
    expect(notice.onPressed, same(notice.onTargetTap));
    expect(checkbox.onMaxSelected, same(checkbox.onSelectionLimitExceeded));
    expect(drawer.onItemClick, same(drawer.onItemTap));
    expect(overlay.onClick, same(overlay.onTap));
    expect(tab.allowMultipleTaps, tab.notifyOnReselect);
    expect(steps.onChange, same(steps.onStepTapped));
    expect(horizontal.onChange, same(horizontal.onStepTapped));
    expect(vertical.onChange, same(vertical.onStepTapped));
    const TDrawerItemClickCallback oldType = _item;
    const TDrawerItemTapCallback newType = oldType;
    expect(newType, same(_item));
  });

  test(
    'historical required-callback constructor tear-offs retain assignability',
    () {
      const TSteps Function({
        Key? key,
        required List<TStepsItemData> steps,
        required int value,
        required ValueChanged<int> onChange,
      })
      oldSteps = TSteps.selectable;
      const TTabBarPopUpBtnConfig Function({
        required List<TTabBarMenuItem> items,
        required ValueChanged<String> onChanged,
        TTabBarPopUpShapeConfig? popUpDialogConfig,
      })
      oldMenu = TTabBarPopUpBtnConfig.new;
      expect(
        oldSteps(steps: const [], value: 0, onChange: _index).onChange,
        same(_index),
      );
      expect(oldMenu(items: const [], onChanged: (_) {}).onChanged, isNotNull);
    },
  );

  test(
    'adapted copyWith override forwards both names and preserves old calls',
    () {
      var calls = 0;
      final arguments = <bool?>[];
      final newArguments = <bool?>[];
      final options = _AdaptedCopyWithOptions(
        onCopy: () => calls++,
        onArgument: arguments.add,
        onMaintainState: newArguments.add,
      );
      final originalCopy = options.copyWith();
      expect(originalCopy.maintainState, isFalse);
      expect(originalCopy.width, 120);
      expect(options.copyWith(maintainState: true).maintainState, isTrue);
      expect(options.copyWith(maintainState: false).maintainState, isFalse);
      expect(options.copyWith(destroyOnClose: false).maintainState, isTrue);
      expect(
        options
            .copyWith(maintainState: false, destroyOnClose: false)
            .maintainState,
        isFalse,
      );
      expect(
        options
            .copyWith(maintainState: true, destroyOnClose: true)
            .maintainState,
        isTrue,
      );
      expect(
        options
            .copyWith(maintainState: null, destroyOnClose: false)
            .maintainState,
        isTrue,
      );
      expect(
        options
            .copyWith(maintainState: null, destroyOnClose: null)
            .maintainState,
        isFalse,
      );
      expect(calls, 8);
      expect(arguments, [null, null, null, false, false, true, false, null]);
      expect(newArguments, [null, true, false, null, false, true, null, null]);
      expect(options.maintainState, isFalse);
      expect(options.width, 120);
      expect(identical(originalCopy, options), isFalse);
    },
  );

  test(
    'copyWith state parameter retains all other options and the original',
    () {
      const child = Text('state copy');
      const overlay = TPopupOverlayConfig(onTap: _void);
      final options = TPopupOptions.bottom(
        child: child,
        height: 321,
        inset: const TPopupBottomInset(left: 7, right: 9),
        radius: 12,
        backgroundColor: Colors.red,
        overlay: overlay,
        animationDuration: const Duration(milliseconds: 123),
        useSafeArea: true,
        onOpened: _void,
        onClosed: _otherVoid,
        onVisibleChange: (_, __) {},
        headerBuilder: (_, __) => const Text('header'),
      );
      final copy = options.copyWith(maintainState: false, radius: 20);
      expect(copy.maintainState, isFalse);
      expect(copy.destroyOnClose, isTrue);
      expect(copy.child, same(child));
      expect(copy.placement, options.placement);
      expect(copy.width, options.width);
      expect(copy.height, options.height);
      expect(copy.inset, same(options.inset));
      expect(copy.radius, 20);
      expect(options.radius, 12);
      expect(copy.backgroundColor, options.backgroundColor);
      expect(copy.overlay, same(overlay));
      expect(copy.animationDuration, options.animationDuration);
      expect(copy.headerBuilder, same(options.headerBuilder));
      expect(copy.closeBuilder, same(options.closeBuilder));
      expect(copy.onOpened, same(options.onOpened));
      expect(copy.onClosed, same(options.onClosed));
      expect(copy.onVisibleChange, same(options.onVisibleChange));
      expect(copy.useSafeArea, options.useSafeArea);
      expect(options.maintainState, isTrue);
      expect(identical(copy, options), isFalse);
      final center = TPopupOptions.center(
        child: child,
        width: 200,
        height: 160,
        closeBuilder: (_, __) => const Text('close'),
      );
      final centerCopy = center.copyWith(maintainState: false);
      expect(centerCopy.width, 200);
      expect(centerCopy.closeBuilder, same(center.closeBuilder));
      expect(centerCopy.child, same(child));
      expect(centerCopy.maintainState, isFalse);
    },
  );

  for (final value in [false, true]) {
    test(
      'copyWith state parameter preserves getter overrides and normalization: $value',
      () {
        final options = _LegacyPopup(maintainState: !value);
        final copy = options.copyWith(maintainState: value);
        expect(copy.maintainState, value);
        expect(copy.destroyOnClose, !value);
        expect(copy.copyWith().maintainState, value);
        expect(copy.copyWith(destroyOnClose: null).maintainState, value);
        expect(copy.normalized().maintainState, value);
        expect(options.maintainState, !value);
      },
    );
  }

  for (final initial in [false, true]) {
    for (final newValue in <bool?>[null, false, true]) {
      for (final oldValue in <bool?>[null, false, true]) {
        test(
          'copyWith state matrix initial=$initial new=$newValue old=$oldValue',
          () {
            final original = TPopupOptions(
              child: const Text('matrix'),
              maintainState: initial,
              radius: 8,
            );
            final expected =
                newValue ?? (oldValue == null ? initial : !oldValue);
            final copy = original.copyWith(
              maintainState: newValue,
              destroyOnClose: oldValue,
              radius: 16,
            );
            expect(copy.maintainState, expected);
            expect(copy.destroyOnClose, !expected);
            expect(copy.normalized().maintainState, expected);
            expect(copy.copyWith().maintainState, expected);
            expect(copy.radius, 16);
            expect(copy.child, same(original.child));
            expect(original.maintainState, initial);
            expect(original.radius, 8);
            expect(identical(copy, original), isFalse);
          },
        );
      }
    }
  }

  for (final oldValue in [false, true]) {
    for (final newValue in <bool?>[null, false, true]) {
      test('popup compatibility mapping old=$oldValue new=$newValue', () {
        const child = SizedBox();
        final effective = newValue ?? !oldValue;
        final options = [
          TPopupOptions(
            child: child,
            destroyOnClose: oldValue,
            maintainState: newValue,
          ),
          TPopupOptions.bottom(
            child: child,
            destroyOnClose: oldValue,
            maintainState: newValue,
          ),
          TPopupOptions.center(
            child: child,
            destroyOnClose: oldValue,
            maintainState: newValue,
          ),
          TPopupOptions.top(
            child: child,
            destroyOnClose: oldValue,
            maintainState: newValue,
          ),
          TPopupOptions.left(
            child: child,
            destroyOnClose: oldValue,
            maintainState: newValue,
          ),
          TPopupOptions.right(
            child: child,
            destroyOnClose: oldValue,
            maintainState: newValue,
          ),
        ];
        for (final option in options) {
          expect(option.maintainState, effective);
          expect(option.destroyOnClose, !effective);
          expect(option.normalized().maintainState, effective);
          expect(option.copyWith().maintainState, effective);
          expect(
            option.copyWith(destroyOnClose: null).maintainState,
            effective,
          );
          expect(
            option.copyWith(destroyOnClose: oldValue).maintainState,
            !oldValue,
          );
          expect(
            option.copyWith(maintainState: effective).maintainState,
            effective,
          );
          expect(
            option.copyWith(destroyOnClose: !oldValue).maintainState,
            oldValue,
          );
        }
      });
    }
  }

  for (final entryPoint in ['popup', 'popup-copy', 'drawer', 'picker']) {
    for (final oldValue in [false, true]) {
      for (final newValue in <bool?>[null, false, true]) {
        testWidgets(
          '$entryPoint keeps lifecycle mapping old=$oldValue new=$newValue',
          (tester) async {
            late BuildContext host;
            var disposals = 0;
            await tester.pumpWidget(
              MaterialApp(
                home: Builder(
                  builder: (context) {
                    host = context;
                    return const Scaffold();
                  },
                ),
              ),
            );
            final content = _LifetimeProbe(onDispose: () => disposals++);
            final TPopupHandle? popup;
            final TDrawerHandle? drawer;
            switch (entryPoint) {
              case 'drawer':
                popup = null;
                drawer = showTDrawer(
                  host,
                  drawer: TDrawer(child: content),
                  destroyOnClose: oldValue,
                  maintainState: newValue,
                );
              case 'picker':
                drawer = null;
                popup = TPickerPopup.show(
                  host,
                  child: content,
                  headerBuilder: (_, __) =>
                      const TPopupHeader(title: Text('header')),
                  destroyOnClose: oldValue,
                  maintainState: newValue,
                );
              case 'popup-copy':
                drawer = null;
                popup = TPopup.show(
                  host,
                  options: TPopupOptions(
                    child: content,
                    maintainState: !(newValue ?? !oldValue),
                  ).copyWith(maintainState: newValue, destroyOnClose: oldValue),
                );
              default:
                drawer = null;
                popup = TPopup.show(
                  host,
                  options: TPopupOptions(
                    child: content,
                    destroyOnClose: oldValue,
                    maintainState: newValue,
                  ),
                );
            }
            await tester.pumpAndSettle();
            final effective = newValue ?? !oldValue;
            expect(
              ModalRoute.of(
                tester.element(find.text('lifetime content')),
              )!.maintainState,
              effective,
            );
            final covered = Navigator.of(host).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => const Scaffold(body: Text('cover')),
              ),
            );
            await tester.pumpAndSettle();
            expect(disposals, effective ? 0 : 1);
            Navigator.of(host).pop();
            await tester.pumpAndSettle();
            await covered;
            expect(find.text('lifetime content'), findsOneWidget);
            popup?.close();
            drawer?.close();
            await tester.pumpAndSettle();
            expect(disposals, effective ? 1 : 2);
          },
        );
      }
    }
  }

  testWidgets(
    'explicit false reselect and disabled bar suppress notifications',
    (tester) async {
      var taps = 0;
      var changes = 0;
      Future<void> mount({required bool enabled}) => tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TTabBar(
              type: TTabBarType.text,
              value: 0,
              navigationTabs: [
                TTabBarItemConfig(
                  tabText: 'same',
                  allowMultipleTaps: true,
                  notifyOnReselect: false,
                  onTap: () => taps++,
                ),
                const TTabBarItemConfig(tabText: 'next'),
              ],
              onChanged: enabled ? (_) => changes++ : null,
            ),
          ),
        ),
      );
      await mount(enabled: true);
      await tester.tap(find.text('same'));
      expect(taps, 0);
      expect(changes, 0);
      await mount(enabled: false);
      await tester.tap(find.text('same'), warnIfMissed: false);
      await tester.tap(find.text('next'), warnIfMissed: false);
      expect(taps, 0);
      expect(changes, 0);
    },
  );

  test('route and reselection defaults remain unchanged for old callers', () {
    const option = TPopupOptions(child: SizedBox());
    expect(option.maintainState, isTrue);
    expect(option.destroyOnClose, isFalse);
    expect(const TTabBarItemConfig().allowMultipleTaps, isFalse);
    expect(const TTabBarItemConfig().notifyOnReselect, isFalse);
    expect(
      const TTabBarItemConfig(
        allowMultipleTaps: true,
        notifyOnReselect: false,
      ).allowMultipleTaps,
      isFalse,
    );
  });

  testWidgets('new NoticeBar callback wins without duplicate notification', (
    tester,
  ) async {
    var oldCalls = 0;
    var newCalls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TNoticeBar(
            content: 'compat target',
            onPressed: (_) => oldCalls++,
            onTargetTap: (_) => newCalls++,
          ),
        ),
      ),
    );
    await tester.tap(find.text('compat target'));
    expect(oldCalls, 0);
    expect(newCalls, 1);
  });

  testWidgets('new Drawer callback wins and retains item payload', (
    tester,
  ) async {
    final indexes = <int>[];
    var oldCalls = 0;
    const item = TDrawerItem(title: 'compat item');
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TDrawer(
            items: const [item],
            onItemClick: (_, __) => oldCalls++,
            onItemTap: (index, value) {
              indexes.add(index);
              expect(value, same(item));
            },
          ),
        ),
      ),
    );
    await tester.tap(find.text('compat item'));
    expect(oldCalls, 0);
    expect(indexes, [0]);
  });

  for (final selectable in [false, true]) {
    testWidgets('new Steps callback works in vertical selectable=$selectable', (
      tester,
    ) async {
      final values = <int>[];
      const data = [
        TStepsItemData(title: 'current'),
        TStepsItemData(title: 'next'),
      ];
      final widget = selectable
          ? TSteps.selectable(steps: data, value: 0, onStepTapped: values.add)
          : TSteps.progress(
              steps: data,
              value: 0,
              direction: TStepsDirection.vertical,
              onStepTapped: values.add,
            );
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));
      await tester.tap(find.text('current'));
      await tester.tap(find.text('next'));
      expect(values, [0, 1]);
      expect(tester.widget<TSteps>(find.byType(TSteps)).value, 0);
    });
  }

  testWidgets(
    'reaching the selection limit only notifies when another choice is blocked',
    (tester) async {
      final values = <int>[];
      var limits = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => TCheckboxGroup<int>(
                value: values,
                maxSelected: 1,
                options: const [
                  TCheckboxOption(value: 1, label: 'first'),
                  TCheckboxOption(value: 2, label: 'second'),
                ],
                onChanged: (next) => setState(() {
                  values
                    ..clear()
                    ..addAll(next);
                }),
                onSelectionLimitExceeded: () => limits++,
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('first'));
      await tester.pump();
      expect(values, [1]);
      expect(limits, 0);
      await tester.tap(find.text('second'));
      expect(values, [1]);
      expect(limits, 1);
      await tester.tap(find.text('first'));
      await tester.pump();
      expect(values, isEmpty);
      expect(limits, 1);
    },
  );

  testWidgets('new Steps callback retains reselection and controlled value', (
    tester,
  ) async {
    var oldCalls = 0;
    final values = <int>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TSteps.progress(
            steps: const [
              TStepsItemData(title: 'first step'),
              TStepsItemData(title: 'next step'),
            ],
            value: 0,
            onChange: (_) => oldCalls++,
            onStepTapped: values.add,
          ),
        ),
      ),
    );
    await tester.tap(find.text('first step'));
    await tester.tap(find.text('next step'));
    expect(oldCalls, 0);
    expect(values, [0, 1]);
    expect(tester.widget<TSteps>(find.byType(TSteps)).value, 0);
  });

  testWidgets(
    'selection limit alias preserves controlled value and precedence',
    (tester) async {
      var oldCalls = 0;
      var newCalls = 0;
      var changes = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TCheckboxGroup<int>(
              value: const [1],
              options: const [
                TCheckboxOption(value: 1, label: 'one'),
                TCheckboxOption(value: 2, label: 'two'),
              ],
              maxSelected: 1,
              onChanged: (_) => changes++,
              onMaxSelected: () => oldCalls++,
              onSelectionLimitExceeded: () => newCalls++,
            ),
          ),
        ),
      );
      await tester.tap(find.text('two'));
      expect(oldCalls, 0);
      expect(newCalls, 1);
      expect(changes, 0);
      expect(
        tester
            .widget<TCheckboxGroup<int>>(find.byType(TCheckboxGroup<int>))
            .value,
        [1],
      );
    },
  );

  testWidgets('popover long press alias does not notify both callbacks', (
    tester,
  ) async {
    var oldCalls = 0;
    var newCalls = 0;
    late BuildContext host;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              host = context;
              return const Center(child: Text('anchor'));
            },
          ),
        ),
      ),
    );
    final closed = TPopover.showPopover(
      context: host,
      content: const Text('compat bubble'),
      onLongTap: () => oldCalls++,
      onLongPress: () => newCalls++,
    );
    await tester.pumpAndSettle();
    await tester.longPress(find.text('compat bubble'));
    expect(oldCalls, 0);
    expect(newCalls, 1);
    Navigator.of(host).pop();
    await tester.pumpAndSettle();
    await closed;
  });

  testWidgets('tab reselect notifies item without changing controlled index', (
    tester,
  ) async {
    var taps = 0;
    var changes = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TTabBar(
            type: TTabBarType.text,
            value: 0,
            navigationTabs: [
              TTabBarItemConfig(
                tabText: 'selected',
                notifyOnReselect: true,
                onTap: () => taps++,
              ),
              const TTabBarItemConfig(tabText: 'other'),
            ],
            onChanged: (_) => changes++,
          ),
        ),
      ),
    );
    await tester.tap(find.text('selected'));
    await tester.tap(find.text('selected'));
    expect(taps, 2);
    expect(changes, 0);
  });

  testWidgets('menu selection alias wins once and retains payload', (
    tester,
  ) async {
    var oldCalls = 0;
    final selections = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TTabBar(
            type: TTabBarType.text,
            value: 0,
            navigationTabs: [
              TTabBarItemConfig(
                tabText: 'menu',
                popUpButtonConfig: TTabBarPopUpBtnConfig(
                  items: const [TTabBarMenuItem(value: 'choice')],
                  onChanged: (_) => oldCalls++,
                  onSelected: selections.add,
                ),
              ),
            ],
            onChanged: (_) {},
          ),
        ),
      ),
    );
    await tester.tap(find.text('menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('choice'));
    await tester.pumpAndSettle();
    expect(oldCalls, 0);
    expect(selections, ['choice']);
    await tester.tap(find.text('menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('choice'));
    await tester.pumpAndSettle();
    expect(oldCalls, 0);
    expect(selections, ['choice', 'choice']);
  });

  testWidgets('overlay alias keeps close behavior and single notification', (
    tester,
  ) async {
    var oldCalls = 0;
    var newCalls = 0;
    late BuildContext host;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              host = context;
              return const SizedBox.expand();
            },
          ),
        ),
      ),
    );
    final handle = TPopup.show(
      host,
      options: TPopupOptions.bottom(
        height: 100,
        child: const Text('compat panel'),
        overlay: TPopupOverlayConfig(
          onClick: () => oldCalls++,
          onTap: () => newCalls++,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(oldCalls, 0);
    expect(newCalls, 1);
    expect(handle.isShowing, isFalse);
  });

  test(
    'all deprecated public accessors name their replacement and removal version',
    () {
      final contracts = <String, Map<String, String>>{
        'notice_bar/t_notice_bar.dart': {'onPressed': 'onTargetTap'},
        'checkbox/t_check_box_group.dart': {
          'onMaxSelected': 'onSelectionLimitExceeded',
        },
        'drawer/t_drawer.dart': {'onItemClick': 'onItemTap'},
        'drawer/t_drawer_content.dart': {
          'TDrawerItemClickCallback': 'TDrawerItemTapCallback',
        },
        'popover/t_popover.dart': {'onLongTap': 'onLongPress'},
        'popover/t_popover_widget.dart': {'onLongTap': 'onLongPress'},
        'popup/t_popup_types.dart': {'onClick': 'onTap'},
        'popup/t_popup_options.dart': {'destroyOnClose': 'maintainState'},
        'tabbar/t_tab_bar.dart': {
          'allowMultipleTaps': 'notifyOnReselect',
          'onChanged': 'onSelected',
        },
        'steps/t_steps.dart': {'onChange': 'onStepTapped'},
        'steps/t_steps_horizontal.dart': {'onChange': 'onStepTapped'},
        'steps/t_steps_vertical.dart': {'onChange': 'onStepTapped'},
      };
      for (final entry in contracts.entries) {
        final unit = parseString(
          content: File('lib/src/components/${entry.key}').readAsStringSync(),
        ).unit;
        final annotated = <String, List<Annotation>>{};
        for (final declaration in unit.declarations) {
          if (declaration is ClassDeclaration) {
            for (final member
                in declaration.members.whereType<MethodDeclaration>()) {
              if (member.isGetter) {
                annotated[member.name.lexeme] = member.metadata;
              }
            }
          } else if (declaration is GenericTypeAlias) {
            annotated[declaration.name.lexeme] = declaration.metadata;
          }
        }
        for (final contract in entry.value.entries) {
          final annotations = annotated[contract.key];
          expect(
            annotations,
            isNotNull,
            reason: '${entry.key} ${contract.key}',
          );
          final deprecated = annotations!
              .where((a) => a.name.name == 'Deprecated')
              .single;
          final message = deprecated.arguments!.arguments
              .whereType<StringLiteral>()
              .single
              .stringValue!;
          expect(message, contains(contract.value));
          expect(message, contains('1.0.1'));
          expect(message, contains('2.0.0'));
        }
      }
    },
  );
}
