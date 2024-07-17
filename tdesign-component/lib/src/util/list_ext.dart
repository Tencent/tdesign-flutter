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
    return [for (int i = 0; i < length; i += size) sublist(i, i + size > length ? length : i + size)];
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

  /// 在列表中查找满足指定条件的第一个元素，可选地限制在指定的索引范围内。
  ///
  /// 此方法遍历列表，从索引`startIndex`开始至`endIndex`（包含）结束，
  /// 应用`test`函数于每个元素。当`test`函数对某个元素返回`true`时，该元素被返回。
  /// 如果没有元素满足条件，则返回`null`。
  ///
  /// 参数:
  /// - [test]: 用于测试列表元素是否满足条件的函数。
  /// - [startIndex]: 查找的起始索引，默认为0。
  /// - [endIndex]: 查找的结束索引，默认为列表的长度减一，意味着默认遍历整个列表。
  ///
  /// 示例：
  ///
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// int? firstEven = numbers.find((element) => element % 2 == 0);
  /// print(firstEven); // 输出：2
  ///
  /// int? inRangeEven = numbers.find((element) => element % 2 == 0, startIndex: 1, endIndex: 4);
  /// print(inRangeEven); // 输出：2，因为在1到4的范围内2是第一个偶数
  /// ```
  T? find(bool Function(T) test, {int startIndex = 0, int? endIndex}) {
    endIndex ??= length; // 如果endIndex没有提供，默认为列表长度
    for (var i = startIndex; i < endIndex && i < length; i++) {
      if (test(this[i])) {
        return this[i];
      }
    }
    return null;
  }
}
