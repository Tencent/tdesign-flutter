import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 覆盖 [TResourceDelegate] 默认实现的全部 getter（含 @override 行）。
void main() {
  group('TResourceDelegate 默认实现', () {
    test('默认资源代理所有 getter 均可访问（覆盖 @override 行）', () {
      final d = TResourceManager.defaultDelegate;
      expect(d.open, '开');
      expect(d.close, '关');
      expect(d.badgeZero, '0');
      expect(d.cancel, '取消');
      expect(d.confirm, '确定');
      expect(d.other, '其它');
      expect(d.reset, '重置');
      expect(d.loading, '加载中');
      expect(d.loadingWithPoint, '加载中...');
      expect(d.knew, '知道了');
      expect(d.refreshing, '正在刷新');
      expect(d.releaseRefresh, '松开刷新');
      expect(d.pullToRefresh, '下拉刷新');
      expect(d.completeRefresh, '刷新完成');
      expect(d.days, '天');
      expect(d.hours, '时');
      expect(d.minutes, '分');
      expect(d.seconds, '秒');
      expect(d.milliseconds, '毫秒');
      expect(d.yearLabel, '年');
      expect(d.monthLabel, '月');
      expect(d.dateLabel, '日');
      expect(d.weeksLabel, '周');
      expect(d.sunday, '日');
      expect(d.monday, '一');
      expect(d.tuesday, '二');
      expect(d.wednesday, '三');
      expect(d.thursday, '四');
      expect(d.friday, '五');
      expect(d.saturday, '六');
      expect(d.year, ' 年');
      expect(d.january, '1 月');
      expect(d.february, '2 月');
      expect(d.march, '3 月');
      expect(d.april, '4 月');
      expect(d.may, '5 月');
      expect(d.june, '6 月');
      expect(d.july, '7 月');
      expect(d.august, '8 月');
      expect(d.september, '9 月');
      expect(d.october, '10 月');
      expect(d.november, '11 月');
      expect(d.december, '12 月');
      expect(d.time, '时间');
      expect(d.start, '开始');
      expect(d.end, '结束');
      expect(d.notRated, '未评分');
      expect(d.cascadeLabel, '选择选项');
      expect(d.back, '返回');
      expect(d.top, '顶部');
      expect(d.emptyData, '暂无数据');
      expect(d.picker, '选择器');
      expect(d.pickerColumn(2), '第 2 列');
    });

    testWidgets('TResourceManager 单例返回默认代理', (tester) async {
      // _builder 为 null 时直接回退默认代理；使用真实 BuildContext 调用
      await tester.pumpWidget(const SizedBox());
      final context = tester.element(find.byType(SizedBox));
      expect(TResourceManager.instance.delegate(context),
          isA<TResourceDelegate>());
    });
  });
}
