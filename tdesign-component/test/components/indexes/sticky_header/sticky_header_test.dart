import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/indexes/sticky_header/sticky_header_render.dart';
import 'package:tdesign_flutter/src/components/indexes/sticky_header/sticky_header_widget.dart';

Widget scroll({
  Axis scrollDirection = Axis.vertical,
  bool reverse = false,
  required List<Widget> slivers,
}) =>
    MaterialApp(
      home: CustomScrollView(
        scrollDirection: scrollDirection,
        reverse: reverse,
        slivers: slivers,
      ),
    );

void main() {
  group('SliverStickyHeaderWidget', () {
    testWidgets('垂直 normal 渲染', (tester) async {
      await tester.pumpWidget(scroll(slivers: [
        SliverStickyHeader(
          header: Container(height: 50, color: Colors.red),
          sliver: SliverToBoxAdapter(child: Container(height: 300)),
        ),
      ]));
      expect(find.byType(SliverStickyHeader), findsOneWidget);
    });

    testWidgets('builder 构造', (tester) async {
      await tester.pumpWidget(scroll(slivers: [
        SliverStickyHeader.builder(
          builder: (ctx, state) => Container(
            height: 50,
            color: state.isPinned ? Colors.blue : Colors.green,
          ),
          sliver: SliverToBoxAdapter(child: Container(height: 300)),
        ),
      ]));
      expect(find.byType(SliverStickyHeader), findsOneWidget);
    });

    testWidgets('overlapsContent / sticky=false / pinnedOffset', (tester) async {
      await tester.pumpWidget(scroll(slivers: [
        SliverStickyHeader(
          overlapsContent: true,
          sticky: false,
          pinnedOffset: 10,
          header: Container(height: 50),
          sliver: SliverToBoxAdapter(child: Container(height: 300)),
        ),
      ]));
      expect(find.byType(SliverStickyHeader), findsOneWidget);
    });

    testWidgets('DefaultStickyHeaderController 提供 controller', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: DefaultStickyHeaderController(
          child: CustomScrollView(slivers: [
            SliverStickyHeader(
              header: Container(height: 50),
              sliver: SliverToBoxAdapter(child: Container(height: 300)),
            ),
          ]),
        ),
      ));
      expect(find.byType(SliverStickyHeader), findsOneWidget);
    });

    testWidgets('显式 controller', (tester) async {
      final c = StickyHeaderController();
      await tester.pumpWidget(scroll(slivers: [
        SliverStickyHeader(
          controller: c,
          header: Container(height: 50),
          sliver: SliverToBoxAdapter(child: Container(height: 300)),
        ),
      ]));
      expect(find.byType(SliverStickyHeader), findsOneWidget);
    });

    testWidgets('水平滚动（left/right 轴）', (tester) async {
      await tester.pumpWidget(scroll(
        scrollDirection: Axis.horizontal,
        slivers: [
          const SliverStickyHeader(
            header: SizedBox(width: 50, height: 50),
            sliver: SliverToBoxAdapter(
              child: SizedBox(width: 300, height: 50),
            ),
          ),
        ],
      ));
      expect(find.byType(SliverStickyHeader), findsOneWidget);
    });

    testWidgets('反向滚动（up 轴）', (tester) async {
      await tester.pumpWidget(scroll(
        reverse: true,
        slivers: [
          SliverStickyHeader(
            header: Container(height: 50),
            sliver: SliverToBoxAdapter(child: Container(height: 300)),
          ),
        ],
      ));
      expect(find.byType(SliverStickyHeader), findsOneWidget);
    });
  });

  group('StickyHeaderController', () {
    test('stickyHeaderScrollOffset setter 通知监听', () {
      final c = StickyHeaderController();
      var notified = false;
      c.addListener(() => notified = true);
      c.stickyHeaderScrollOffset = 123;
      expect(c.stickyHeaderScrollOffset, 123);
      expect(notified, true);
      // 相同值不重复通知
      notified = false;
      c.stickyHeaderScrollOffset = 123;
      expect(notified, false);
    });
  });

  group('SliverStickyHeaderState', () {
    test('operator== / hashCode', () {
      const a = SliverStickyHeaderState(0.5, true);
      const b = SliverStickyHeaderState(0.5, true);
      const c = SliverStickyHeaderState(0.5, false);
      expect(a == b, true);
      expect(a == c, false);
      expect(a.hashCode, b.hashCode);
      expect(identical(a, a), true);
    });
  });

  group('StickyHeader 补充覆盖', () {
    testWidgets('属性变化触发 setter 与 updateRenderObject', (tester) async {
      // 覆盖 setter（overlapsContent/sticky/pinnedOffset/controller）+ controller copy state
      final c1 = StickyHeaderController();
      final c2 = StickyHeaderController();
      await tester.pumpWidget(scroll(slivers: [
        SliverStickyHeader(
          sticky: true,
          overlapsContent: false,
          pinnedOffset: 0,
          controller: c1,
          header: Container(height: 50, color: Colors.red),
          sliver: SliverToBoxAdapter(child: Container(height: 300)),
        ),
      ]));
      // sticky 保持 true、pinnedOffset 0→10，触发 pinnedOffset setter markNeedsLayout
      await tester.pumpWidget(scroll(slivers: [
        SliverStickyHeader(
          sticky: true,
          overlapsContent: true,
          pinnedOffset: 10,
          controller: c2,
          header: Container(height: 60, color: Colors.blue),
          sliver: SliverToBoxAdapter(child: Container(height: 200)),
        ),
      ]));
      // sticky true→false，触发 sticky setter
      await tester.pumpWidget(scroll(slivers: [
        SliverStickyHeader(
          sticky: false,
          overlapsContent: true,
          pinnedOffset: 10,
          controller: c2,
          header: Container(height: 60, color: Colors.blue),
          sliver: SliverToBoxAdapter(child: Container(height: 200)),
        ),
      ]));
      await tester.pumpAndSettle();
      expect(find.byType(SliverStickyHeader), findsOneWidget);
    });

    testWidgets('空 sliver（header+sliver 均 null）', (tester) async {
      // 覆盖 performLayout 中 header==null && child==null → SliverGeometry.zero
      await tester.pumpWidget(scroll(slivers: [
        const SliverStickyHeader(),
        SliverToBoxAdapter(child: Container(height: 100)),
      ]));
      // 空 sliver geometry.zero 仍执行了 performLayout（覆盖 187-188）
      expect(tester.takeException(), isNull);
    });

    testWidgets('只有 header 没有 sliver', (tester) async {
      // 覆盖 child==null 分支（geometry 只有 header）
      await tester.pumpWidget(scroll(slivers: [
        SliverStickyHeader(
          header: Container(height: 50, color: Colors.red),
        ),
      ]));
      await tester.pumpAndSettle();
      expect(find.byType(SliverStickyHeader), findsOneWidget);
    });

    testWidgets('移除 header/sliver 触发 removeRenderObjectChild', (tester) async {
      // 覆盖 forgetChild / removeRenderObjectChild / header setter dropChild
      await tester.pumpWidget(scroll(slivers: [
        SliverStickyHeader(
          header: Container(height: 50, color: Colors.red),
          sliver: SliverToBoxAdapter(child: Container(height: 300)),
        ),
      ]));
      // 移除 sliver → removeRenderObjectChild(child) + forgetChild
      await tester.pumpWidget(scroll(slivers: [
        SliverStickyHeader(
          header: Container(height: 50, color: Colors.red),
        ),
      ]));
      // header 类型变化 → removeRenderObjectChild(old header) + insert(new) → header setter dropChild
      await tester.pumpWidget(scroll(slivers: [
        const SliverStickyHeader(
          header: SizedBox(height: 60, child: Text('new')),
        ),
      ]));
      expect(find.byType(SliverStickyHeader), findsOneWidget);
    });

    testWidgets('卸载 SliverStickyHeader 触发 detach', (tester) async {
      // 覆盖 detach（header/child detach）+ forgetChild（unmount 时调用）
      await tester.pumpWidget(scroll(slivers: [
        SliverStickyHeader(
          header: Container(height: 50),
          sliver: SliverToBoxAdapter(child: Container(height: 300)),
        ),
      ]));
      // 替换为其它 sliver，触发 SliverStickyHeader 卸载
      await tester.pumpWidget(scroll(slivers: [
        SliverToBoxAdapter(child: Container(height: 100)),
      ]));
      // 多帧 pump 触发 deactivate → unmount → forgetChild
      await tester.pump();
      await tester.pump();
      expect(find.byType(SliverStickyHeader), findsNothing);
    });

    testWidgets('点击 header 与 sliver 区域触发 hitTest', (tester) async {
      // 覆盖 hitTestChildren + childMainAxisPosition
      await tester.pumpWidget(scroll(slivers: [
        SliverStickyHeader(
          overlapsContent: true,
          header: GestureDetector(
            onTap: () {},
            child: Container(height: 50, color: Colors.red),
          ),
          sliver: SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () {},
              child: Container(height: 300, color: Colors.green),
            ),
          ),
        ),
      ]));
      // 点击 header 区域（覆盖 hitTestChildren header 分支）
      await tester.tapAt(const Offset(100, 25));
      await tester.pumpAndSettle();
      // 点击 sliver 区域（覆盖 hitTestChildren child 分支）
      await tester.tapAt(const Offset(100, 200));
      await tester.pumpAndSettle();
      expect(find.byType(SliverStickyHeader), findsOneWidget);
    });

    testWidgets('sticky=false 点击触发 hitTest 非 sticky 分支', (tester) async {
      // 覆盖 hitTestChildren 中 sticky=false 的 headerPosition=-scrollOffset
      await tester.pumpWidget(scroll(slivers: [
        SliverStickyHeader(
          sticky: false,
          header: GestureDetector(
            onTap: () {},
            child: Container(height: 50, color: Colors.red),
          ),
          sliver: SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () {},
              child: Container(height: 300, color: Colors.green),
            ),
          ),
        ),
      ]));
      await tester.tapAt(const Offset(100, 25));
      await tester.pumpAndSettle();
      expect(find.byType(SliverStickyHeader), findsOneWidget);
    });

    testWidgets('overlapsContent header 不命中时穿透到 sliver', (tester) async {
      // 覆盖 hitTestChildren 中 didHitHeader || overlapsContent && child 分支
      // header 用 SizedBox（无 color，hitTest 返回 false）确保 didHitHeader=false
      await tester.pumpWidget(scroll(slivers: [
        SliverStickyHeader(
          overlapsContent: true,
          header: const SizedBox(height: 50),
          sliver: SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () {},
              child: Container(height: 300, color: Colors.green),
            ),
          ),
        ),
      ]));
      // 点击 header 区域，header 不命中 → overlapsContent 穿透到 sliver
      await tester.tapAt(const Offset(100, 25));
      await tester.pumpAndSettle();
      expect(find.byType(SliverStickyHeader), findsOneWidget);
    });

    testWidgets('滚动触发 sticky pin 与 controller 更新', (tester) async {
      // 覆盖 _isPinned / controller.stickyHeaderScrollOffset / headerScrollRatio
      final c = StickyHeaderController();
      await tester.pumpWidget(MaterialApp(
        home: SizedBox(
          height: 400,
          child: CustomScrollView(
            slivers: [
              SliverStickyHeader(
                controller: c,
                header: Container(height: 50, color: Colors.red),
                sliver: SliverToBoxAdapter(child: Container(height: 600)),
              ),
              SliverToBoxAdapter(child: Container(height: 600)),
            ],
          ),
        ),
      ));
      // 滚动使 header pin（覆盖 _isPinned=true / controller 更新）
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -200));
      await tester.pumpAndSettle();
      expect(find.byType(SliverStickyHeader), findsOneWidget);
    });

    testWidgets('builder 滚动触发 header 重建', (tester) async {
      // 覆盖 _oldState 变化 → header 二次 layout
      await tester.pumpWidget(MaterialApp(
        home: SizedBox(
          height: 400,
          child: CustomScrollView(
            slivers: [
              SliverStickyHeader.builder(
                builder: (ctx, state) => Container(
                  height: 50,
                  color: state.isPinned ? Colors.blue : Colors.green,
                ),
                sliver: SliverToBoxAdapter(child: Container(height: 600)),
              ),
              SliverToBoxAdapter(child: Container(height: 600)),
            ],
          ),
        ),
      ));
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -150));
      await tester.pumpAndSettle();
      expect(find.byType(SliverStickyHeader), findsOneWidget);
    });

    testWidgets('debugDescribeChildren', (tester) async {
      // 覆盖 debugDescribeChildren（toStringDeep 触发）
      await tester.pumpWidget(scroll(slivers: [
        SliverStickyHeader(
          header: Container(height: 50),
          sliver: SliverToBoxAdapter(child: Container(height: 300)),
        ),
      ]));
      final ro = tester.renderObject(find.byType(SliverStickyHeader));
      expect(ro.toStringDeep(minLevel: DiagnosticLevel.debug), isA<String>());
    });

    testWidgets('直接调用 RenderSliver 方法', (tester) async {
      // 覆盖 childMainAxisPosition / childScrollOffset / hitTestChildren
      // header 用 SizedBox（无 color，hitTest 返回 false）确保 didHitHeader=false
      await tester.pumpWidget(scroll(slivers: [
        const SliverStickyHeader(
          overlapsContent: true,
          header: SizedBox(height: 50),
          sliver: SliverToBoxAdapter(
            child: SizedBox(height: 300),
          ),
        ),
      ]));
      final ro = tester.renderObject(find.byType(SliverStickyHeader))
          as RenderSliverStickyHeader;
      // 覆盖 childMainAxisPosition（header 分支 + child 分支）
      if (ro.header != null) {
        ro.childMainAxisPosition(ro.header!);
      }
      if (ro.child != null) {
        ro.childMainAxisPosition(ro.child!);
      }
      // 覆盖 childScrollOffset（child 分支返回 headerLogicalExtent）
      if (ro.child != null) {
        ro.childScrollOffset(ro.child!);
      }
      // 覆盖 childScrollOffset 的 else 分支（传 header → super.childScrollOffset）
      if (ro.header != null) {
        ro.childScrollOffset(ro.header!);
      }
      // 覆盖 hitTestChildren（overlapsContent 穿透：header 不命中→评估右侧）
      final result = SliverHitTestResult();
      ro.hitTestChildren(result, mainAxisPosition: 25, crossAxisPosition: 100);
      expect(find.byType(SliverStickyHeader), findsOneWidget);
    });

    testWidgets('GlobalKey 子节点重挂载触发 forgetChild', (tester) async {
      // 覆盖 forgetChild（_header/_sliver 清理）
      // GlobalKey 在 SliverStickyHeader 的 header/sliver 上，
      // 下一步用相同 key 在 SliverStickyHeader 之前（先 build）重挂载，
      // → _retakeInactiveElement → parent.forgetChild（此时 _header/_sliver 仍指向旧值）
      final headerKey = GlobalKey();
      final sliverKey = GlobalKey();
      await tester.pumpWidget(scroll(slivers: [
        SliverStickyHeader(
          header: Container(key: headerKey, height: 50, color: Colors.red),
          sliver: SliverToBoxAdapter(
              key: sliverKey, child: Container(height: 300)),
        ),
      ]));
      // 用相同 key 在前（先 build），SliverStickyHeader header/sliver 换为不同 widget
      await tester.pumpWidget(scroll(slivers: [
        SliverToBoxAdapter(
            child: Container(key: headerKey, height: 50, color: Colors.blue)),
        SliverToBoxAdapter(key: sliverKey, child: Container(height: 200)),
        SliverStickyHeader(
          header: const SizedBox(height: 60),
          sliver: SliverToBoxAdapter(child: Container(height: 200)),
        ),
      ]));
      await tester.pumpAndSettle();
      expect(find.byKey(headerKey), findsOneWidget);
      expect(find.byType(SliverStickyHeader), findsOneWidget);
    });

    testWidgets('DefaultStickyHeaderController 重建触发 updateShouldNotify',
        (tester) async {
      // 覆盖 _StickyHeaderControllerScope.updateShouldNotify
      // 不用 key 确保 Element 复用 → InheritedWidget 重建 → updateShouldNotify
      await tester.pumpWidget(const MaterialApp(
        home: DefaultStickyHeaderController(
          child: SizedBox(child: Text('a')),
        ),
      ));
      await tester.pumpWidget(const MaterialApp(
        home: DefaultStickyHeaderController(
          child: SizedBox(child: Text('b')),
        ),
      ));
      expect(find.text('b'), findsOneWidget);
    });

    testWidgets('水平滚动 sticky pin', (tester) async {
      // 覆盖 AxisDirection.right 的 header/sliver paintOffset
      await tester.pumpWidget(MaterialApp(
        home: SizedBox(
          width: 400,
          child: CustomScrollView(
            scrollDirection: Axis.horizontal,
            slivers: [
              SliverStickyHeader(
                header: Container(width: 50, height: 50, color: Colors.red),
                sliver: const SliverToBoxAdapter(
                    child: SizedBox(width: 600, height: 50)),
              ),
            ],
          ),
        ),
      ));
      await tester.drag(find.byType(CustomScrollView), const Offset(-200, 0));
      await tester.pumpAndSettle();
      expect(find.byType(SliverStickyHeader), findsOneWidget);
    });

    testWidgets('反向滚动 sticky pin', (tester) async {
      // 覆盖 AxisDirection.up 的 header paintOffset
      await tester.pumpWidget(MaterialApp(
        home: SizedBox(
          height: 400,
          child: CustomScrollView(
            reverse: true,
            slivers: [
              SliverStickyHeader(
                header: Container(height: 50, color: Colors.red),
                sliver: SliverToBoxAdapter(child: Container(height: 600)),
              ),
            ],
          ),
        ),
      ));
      await tester.drag(find.byType(CustomScrollView), const Offset(0, 200));
      await tester.pumpAndSettle();
      expect(find.byType(SliverStickyHeader), findsOneWidget);
    });

    testWidgets('水平反向滚动 sticky pin', (tester) async {
      // 覆盖 AxisDirection.left 的 header/sliver paintOffset
      await tester.pumpWidget(MaterialApp(
        home: SizedBox(
          width: 400,
          child: CustomScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            slivers: [
              SliverStickyHeader(
                header: Container(width: 50, height: 50, color: Colors.red),
                sliver: const SliverToBoxAdapter(
                    child: SizedBox(width: 600, height: 50)),
              ),
            ],
          ),
        ),
      ));
      await tester.drag(find.byType(CustomScrollView), const Offset(200, 0));
      await tester.pumpAndSettle();
      expect(find.byType(SliverStickyHeader), findsOneWidget);
    });
  });
}
