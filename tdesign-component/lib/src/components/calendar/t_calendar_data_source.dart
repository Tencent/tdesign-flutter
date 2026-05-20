/// 日历可选数据源：仅提供副标题文案（无 [subtitleBuilder] 时使用）。
///
/// 农历、节气、节日等均由接入方在 [TCalendar.subtitleBuilder] 或
/// [getSubtitle] 中自行处理；组件主区默认只渲染阳历日数字。
abstract class TCalendarDataSource {
  /// 副标题文案；返回 null 或空字符串时不显示副标题行。
  String? getSubtitle(DateTime date) => null;
}
