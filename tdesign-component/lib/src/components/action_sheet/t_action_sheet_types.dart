import 't_action_sheet_item.dart';

/// 选择动作面板项目时触发
typedef TActionSheetOnSelected<T> = void Function(TActionSheetItem<T> item);

/// 宫格布局模式
enum TActionSheetGridMode {
  /// 固定宫格
  fixed,

  /// 分页宫格
  paged,

  /// 横向滚动宫格
  scroll,
}

/// 动作面板宫格布局
///
/// 使用 [TActionSheetGridLayout.fixed]、[TActionSheetGridLayout.paged] 或
/// [TActionSheetGridLayout.scroll] 创建互斥的布局配置。
sealed class TActionSheetGridLayout {
  const TActionSheetGridLayout._({
    required this.mode,
    required this.count,
    required this.rows,
  }) : assert(count > 0, 'count must be greater than 0'),
       assert(rows > 0, 'rows must be greater than 0'),
       assert(count >= rows, 'count must be greater than or equal to rows'),
       assert(count % rows == 0, 'count must be divisible by rows');

  /// 普通固定宫格
  const factory TActionSheetGridLayout.fixed({int count, int rows}) =
      _TActionSheetFixedGridLayout;

  /// 整页切换并显示分页指示器的宫格
  const factory TActionSheetGridLayout.paged({int count, int rows}) =
      _TActionSheetPagedGridLayout;

  /// 可连续横向滚动的宫格
  const factory TActionSheetGridLayout.scroll({
    int count,
    int rows,
    double? itemMinWidth,
  }) = _TActionSheetScrollGridLayout;

  /// 布局模式
  final TActionSheetGridMode mode;

  /// 一个可视面板期望容纳的项目数
  final int count;

  /// 行数
  final int rows;

  /// 横向滚动项目的最小宽度；仅滚动布局可能返回非空值。
  double? get itemMinWidth => null;
}

/// 普通固定宫格布局
final class _TActionSheetFixedGridLayout extends TActionSheetGridLayout {
  const _TActionSheetFixedGridLayout({this.count = 8, this.rows = 2})
    : super._(mode: TActionSheetGridMode.fixed, count: count, rows: rows);

  @override
  final int count;

  @override
  final int rows;
}

/// 分页宫格布局
final class _TActionSheetPagedGridLayout extends TActionSheetGridLayout {
  const _TActionSheetPagedGridLayout({this.count = 8, this.rows = 2})
    : super._(mode: TActionSheetGridMode.paged, count: count, rows: rows);

  @override
  final int count;

  @override
  final int rows;
}

/// 横向滚动宫格布局
final class _TActionSheetScrollGridLayout extends TActionSheetGridLayout {
  const _TActionSheetScrollGridLayout({
    this.count = 8,
    this.rows = 2,
    this.itemMinWidth,
  }) : assert(
         itemMinWidth == null || itemMinWidth > 0,
         'itemMinWidth must be greater than 0',
       ),
       super._(mode: TActionSheetGridMode.scroll, count: count, rows: rows);

  @override
  final int count;

  @override
  final int rows;

  @override
  final double? itemMinWidth;
}

/// 动作面板内容对齐方式
enum TActionSheetAlign {
  /// 居中对齐
  center,

  /// 左对齐
  left,

  /// 右对齐
  right,
}
