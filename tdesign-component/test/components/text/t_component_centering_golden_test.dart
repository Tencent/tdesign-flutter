import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  _calendarIndexesScenes();
  _remainingComponentScenes();
  setUpAll(() async {
    await (FontLoader('TDesignGoldenCJK')..addFont(
          File(
            'example/test/fonts/TDesignGoldenCJK-Regular.otf',
          ).readAsBytes().then(ByteData.sublistView),
        ))
        .load();
    await (FontLoader('packages/tdesign_flutter/TCloudNumber')..addFont(
          File(
            'assets/tdesign/TCloudNumberVF.ttf',
          ).readAsBytes().then(ByteData.sublistView),
        ))
        .load();
    final flutterBin = File(
      Platform.resolvedExecutable,
    ).parent.parent.parent.parent.parent;
    await (FontLoader('Roboto')..addFont(
          File(
            '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
          ).readAsBytes().then(ByteData.sublistView),
        ))
        .load();
    await (FontLoader('MaterialIcons')..addFont(
          File(
            '${flutterBin.path}/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
          ).readAsBytes().then(ByteData.sublistView),
        ))
        .load();
    await (FontLoader('packages/tdesign_flutter_icons/TIcons')..addFont(
          rootBundle.load('packages/tdesign_flutter_icons/fonts/t.ttf'),
        ))
        .load();
    await (FontLoader('TDesignAlignmentCJK')..addFont(
          File(
            'example/test/fonts/TDesignAlignmentCJK-Regular.otf',
          ).readAsBytes().then(ByteData.sublistView),
        ))
        .load();
  });
  for (final brightness in Brightness.values) {
    for (final scale in [1.0, 1.5, 2.0]) {
      testWidgets('centering states ${brightness.name} scale $scale', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(800, 5000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final base = TThemeData.defaultData();
        final token = (brightness == Brightness.light ? base : base.dark!)
            .copyWith(
              fontFamilyMap: {
                'fontFamily': FontFamily(
                  fontFamily: 'Roboto',
                  fallback: ['TDesignAlignmentCJK', 'TDesignGoldenCJK'],
                ),
              },
            );
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(brightness: brightness, extensions: [token]),
            home: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: Scaffold(
                body: Align(
                  alignment: Alignment.topLeft,
                  child: RepaintBoundary(
                    key: const Key('centering-states'),
                    child: ColoredBox(
                      color: token.bgColorContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                TSwitch(
                                  value: true,
                                  variant: TSwitchVariant.text,
                                  onChanged: (_) {},
                                ),
                                const SizedBox(width: 20),
                                TSwitch(
                                  value: false,
                                  variant: TSwitchVariant.text,
                                  closeText: 'Ag8 long',
                                  onChanged: (_) {},
                                ),
                                const SizedBox(width: 20),
                                const TTimeCounter(
                                  time: 5000,
                                  format: 'ss',
                                  variant: TTimeCounterVariant.round,
                                  autoStart: false,
                                ),
                                const SizedBox(width: 20),
                                const TTimeCounter(
                                  time: 5000,
                                  format: 'ss',
                                  variant: TTimeCounterVariant.square,
                                  autoStart: false,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TProgress.plump(value: .5),
                            const SizedBox(height: 12),
                            TProgress.button(value: .5),
                            const SizedBox(height: 12),
                            const TSteps.progress(
                              steps: [
                                TStepsItemData(title: 'Ag8'),
                                TStepsItemData(title: 'Label'),
                              ],
                              value: 0,
                            ),
                            const SizedBox(height: 12),
                            TPicker(
                              items: const TPickerColumns([
                                [
                                  TPickerOption(label: 'Ag8', value: 0),
                                  TPickerOption(label: 'Label', value: 1),
                                  TPickerOption(label: 'Long label', value: 2),
                                ],
                              ]),
                              value: const [1],
                              onChanged: (_) {},
                            ),
                            const SizedBox(height: 12),
                            for (final variant in TTagVariant.values)
                              for (final enabled in [true, false])
                                for (final icons in [false, true])
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        for (final size
                                            in TTagSize.values.where(
                                              (size) => size != TTagSize.custom,
                                            ))
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 12,
                                            ),
                                            child: TTag(
                                              '标签8',
                                              size: size,
                                              variant: variant,
                                              enabled: enabled,
                                              icon: icons ? Icons.add : null,
                                              needCloseIcon: icons,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                            for (final variant in TSwitchVariant.values)
                              for (final value in [true, false])
                                for (final enabled in [true, false])
                                  for (final loading in [false, true])
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          for (final size in TSwitchSize.values)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                right: 16,
                                              ),
                                              child: TSwitch(
                                                size: size,
                                                value: value,
                                                variant: variant,
                                                loading: loading,
                                                onChanged: enabled
                                                    ? (_) {}
                                                    : null,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                            for (final size in TBadgeSize.values)
                              for (final border in [false, true])
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (final variant
                                          in TBadgeVariant.values)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 16,
                                          ),
                                          child: TBadge(
                                            label: '8',
                                            variant: variant,
                                            size: size,
                                            border: border,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byKey(const Key('centering-states')),
          matchesGoldenFile('goldens/centering_${brightness.name}_$scale.png'),
        );
      }, tags: 'golden');
    }
  }
}

void _calendarIndexesScenes() {
  for (final brightness in Brightness.values) {
    for (final scale in [1.0, 3.0]) {
      testWidgets('calendar indexes ${brightness.name} scale $scale', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(800, 1100);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final active = ValueNotifier('A');
        addTearDown(active.dispose);
        final base = TThemeData.defaultData();
        final token = (brightness == Brightness.light ? base : base.dark!)
            .copyWith(
              fontFamilyMap: {
                'fontFamily': FontFamily(
                  fontFamily: 'Roboto',
                  fallback: ['TDesignAlignmentCJK', 'TDesignGoldenCJK'],
                ),
              },
            );
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              brightness: brightness,
              extensions: [
                token,
                TCalendarThemeData(
                  // 本场景只验证居中，不让真实“今天”改变固定日期的截图。
                  // 今日状态的颜色由 Calendar 独立状态测试覆盖。
                  todayDayStyle: TextStyle(color: token.textColorPrimary),
                  height: 550,
                  monthTitleStyle: const TextStyle(
                    fontSize: 24,
                    height: 2,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            home: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: Scaffold(
                body: Align(
                  alignment: Alignment.topLeft,
                  child: RepaintBoundary(
                    key: const Key('calendar-indexes-states'),
                    child: ColoredBox(
                      color: token.bgColorContainer,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TCalendar(
                            value: [DateTime(2026, 10, 14)],
                            minDate: DateTime(2026, 10, 1),
                            maxDate: DateTime(2026, 10, 31),
                            onChanged: (_) {},
                          ),
                          SizedBox(
                            width: 800,
                            height: 350,
                            child: Stack(
                              children: [
                                TIndexesList(
                                  indexList: List.generate(
                                    26,
                                    (i) => String.fromCharCode(65 + i),
                                  ),
                                  activeIndex: active,
                                  onSelect: (_, __) {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        if (scale > 1) {
          active.value = 'Z';
          await tester.pumpAndSettle();
          await tester.tap(find.text('Y'));
          await tester.pump(const Duration(milliseconds: 20));
        }
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byKey(const Key('calendar-indexes-states')),
          matchesGoldenFile(
            'goldens/calendar_indexes_${brightness.name}_$scale.png',
          ),
        );
        await tester.pump(const Duration(milliseconds: 400));
      }, tags: 'golden');
    }
  }
}

void _remainingComponentScenes() {
  for (final brightness in Brightness.values) {
    for (final scale in [1.0, 3.0]) {
      for (final group in ['editing', 'navigation', 'menus']) {
        testWidgets('remaining $group ${brightness.name} scale $scale', (
          tester,
        ) async {
          tester.view.physicalSize = const Size(375, 2100);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          final base = TThemeData.defaultData();
          final token = (brightness == Brightness.light ? base : base.dark!)
              .copyWith(
                fontFamilyMap: {
                  'fontFamily': FontFamily(
                    fontFamily: 'Roboto',
                    fallback: ['TDesignAlignmentCJK', 'TDesignGoldenCJK'],
                  ),
                },
              );
          final textController = TextEditingController(text: 'Ag8');
          addTearDown(textController.dispose);
          late List<Widget> children;
          if (group == 'editing') {
            children = [
              TSearchBar(controller: textController, actionText: '搜索'),
              TStepper(value: 2, onChanged: (_) {}),
              TCheckboxGroup<String>(
                value: const ['a'],
                cardMode: true,
                options: const [
                  TCheckboxOption(
                    value: 'a',
                    label: '选项 Ag8',
                    subTitle: '说明 Ag8',
                  ),
                ],
                onChanged: (_) {},
              ),
              TRadioGroup<String>(
                value: 'a',
                onChanged: (_) {},
                child: const TRadio<String>(
                  value: 'a',
                  title: '选项 Ag8',
                  subTitle: '说明 Ag8',
                  variant: TRadioVariant.card,
                ),
              ),
              const TTextarea(
                minLines: 1,
                indicator: true,
                maxLength: 20,
                hintText: '文字 Ag8',
              ),
              const SizedBox(
                height: 128,
                child: TTextarea(
                  indicator: true,
                  maxLength: 20,
                  hintText: '文字 Ag8',
                ),
              ),
              TUpload(
                files: const [
                  TUploadFile(
                    id: 'golden',
                    name: 'document.txt',
                    status: TUploadFileStatus.uploading,
                    progress: .5,
                  ),
                ],
                onChanged: (_) {},
              ),
            ];
          } else if (group == 'navigation') {
            children = [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TBackTop(showText: true),
                  TBackTop(showText: true, shape: TBackTopShape.halfCircle),
                ],
              ),
              const SizedBox(
                height: 160,
                child: Stack(children: [TFab(text: 'Ag8')]),
              ),
              const DefaultTabController(
                length: 2,
                child: TTabsBar(
                  tabs: [
                    TTab(text: 'Ag8'),
                    TTab(text: '标签'),
                  ],
                  variant: TTabsBarVariant.tag,
                ),
              ),
              TTabBar(
                type: TTabBarType.text,
                navigationTabs: const [
                  TTabBarItemConfig(tabText: 'Ag8'),
                  TTabBarItemConfig(tabText: '标签'),
                ],
                value: 0,
                onChanged: (_) {},
              ),
              const SizedBox(
                height: 180,
                child: TSwiper(
                  autoplay: false,
                  pagination: TSwiperPaginationVariant.fraction,
                  children: [
                    ColoredBox(color: Colors.blue),
                    ColoredBox(color: Colors.orange),
                  ],
                ),
              ),
            ];
          } else {
            children = [
              const TNoticeBar(content: '提示 Ag8', marquee: false),
              const TNoticeBar(content: '多行文案 Ag8，保持原有段落换行。', maxLines: 3),
              TCascader(
                options: const [
                  TCascaderOption(
                    label: '选项 Ag8',
                    value: 'a',
                    children: [TCascaderOption(label: '第二级 Ag8', value: 'b')],
                  ),
                ],
                value: const ['a'],
                onChanged: (_) {},
              ),
              TTreeSelect(
                options: const [
                  TTreeSelectOption(
                    label: '选项 Ag8',
                    value: 'a',
                    children: [TTreeSelectOption(label: '第二级 Ag8', value: 'b')],
                  ),
                ],
                value: const [
                  ['a', 'b'],
                ],
                onChanged: (_) {},
              ),
            ];
          }
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(brightness: brightness, extensions: [token]),
              home: MediaQuery(
                data: MediaQueryData(
                  size: const Size(375, 2100),
                  textScaler: TextScaler.linear(scale),
                ),
                child: Scaffold(
                  body: Align(
                    alignment: Alignment.topLeft,
                    child: RepaintBoundary(
                      key: const Key('remaining-scene'),
                      child: ColoredBox(
                        color: token.bgColorContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (final child in children)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: child,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pump(const Duration(milliseconds: 400));
          expect(tester.takeException(), isNull);
          await expectLater(
            find.byKey(const Key('remaining-scene')),
            matchesGoldenFile(
              'goldens/remaining_${group}_${brightness.name}_${scale.toString().replaceAll('.', '_')}.png',
            ),
          );
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pump();
        }, tags: 'golden');
      }
    }
  }
}
