



///
/// 一些实用的迭代扩展函数
///
///
extension IterableExt<T> on Iterable<T> {

  ///
  /// 获取集合的前n个元素
  ///
  Iterable<T> firstCount(int count) {
    int c = count < length ? count : length;
    return Iterable.generate(c, elementAt);
  }

  ///
  /// 在列表中查找特定的值，如果找不到返回null
  ///
  T? firstWhereOrNull(bool test(T element)) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }

  ///
  /// 带index参数的map方法
  ///
  Iterable<E> mapWidthIndex<E>(E f(T e, int index)) {
    int index = 0;
    return this.map((e) {
      return f(e, index++);
    });
  }

  ///
  /// 带index参数的forEach方法
  ///
  void forEachWidthIndex(void f(T e, int index)) {
    int index = 0;
    this.forEach((e) {
      return f(e, index++);
    });
  }

  ///
  /// 把列表格式化成特定格式的字符串
  ///
  /// - divider 分割符
  /// - prefix 前缀
  /// - suffix 后缀
  /// - convert 元素格式化成字符串
  String join2({String divider = ", ", String? prefix, String? suffix , String Function(T element)? convert}){
    StringBuffer sb = StringBuffer();
    if (prefix != null) {
      sb.write(prefix);
    }

    for (int i=0; i<this.length; i++) {
      final e = this.elementAt(i);
      sb.write(convert != null ? convert(e) : e.toString());
      if (i != this.length - 1) {
        sb.write(divider);
      }
    }

    if (suffix != null) {
      sb.write(suffix);
    }

    return sb.toString();
  }

  ///
  /// 是否包含某个特定条件的颜色
  ///
  bool isContains(bool Function(T e) test) {
    return firstWhereOrNull((element) => test(element)) != null;
  }


}