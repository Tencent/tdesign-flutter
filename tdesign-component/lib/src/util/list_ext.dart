/// 扩展 [List] 类
extension ListExt<T> on List<T> {
  /// 将当前列表分割成大小为 [size] 的子列表。
  ///
  /// 如果原始列表的长度不能被 [size] 整除，则最后一个子列表可能会包含少于 [size] 个元素。
  ///
  /// 示例：
  ///
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  /// List<List<int>> chunks = numbers.chunk(3);
  /// print(chunks); // 输出：[[1, 2, 3], [4, 5, 6], [7, 8, 9]]
  /// ```
  List<List<T>> chunk(int size) {
    return [
      for (int i = 0; i < length; i += size)
        sublist(i, i + size > length ? length : i + size)
    ];
  }

  /// 根据 [keySelector] 函数从列表中的每个元素中提取键，并将元素按键分组。
  ///
  /// 返回一个 [Map]，其中键是 [keySelector] 函数返回的键，值是包含具有相同键的所有元素的列表。
  ///
  /// 示例：
  ///
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  /// Map<int, List<int>> evenOdd = numbers.groupBy<int>((number) => number % 2);
  /// print(evenOdd); // 输出：{0: [2, 4, 6, 8], 1: [1, 3, 5, 7, 9]}
  /// ```
  Map<E, List<T>> groupBy<E>(E Function(T) keySelector) {
    var groupedItems = <E, List<T>>{};

    for (var item in this) {
      var key = keySelector(item);
      if (groupedItems[key] == null) {
        groupedItems[key] = [];
      }
      groupedItems[key]!.add(item);
    }

    return groupedItems;
  }
}
