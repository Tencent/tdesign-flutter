




import 'dart:convert';

///
/// Map的一些扩展工具方法
///
extension MapExt<K, V> on Map<K, V> {


  /// 获取整形值
  int getInt(String key, {int defaultValue = 0}) {
    var r =  getNum(key, defaultValue: defaultValue);
    if (r is int) {
      return r;
    }
    return r.toInt();
  }

  /// 获取一个数字字段
  num getNum(String key, {num defaultValue = 0}) {
    try {
      final value = this[key];

      if (value != null && value is num) {
        return value;
      }

      return num.parse(value.toString());
    } catch (e) {
      return defaultValue;
    }
  }

  /// get double value from map
  double getDouble(String key, {double defaultValue = 0}) {
    final value = this[key];
    try {
      if (value != null && value is double) {
        return value;
      }

      return double.parse(value.toString());
    } catch (e) {
      return defaultValue;
    }
  }

  ///
  /// get bool value from map
  ///
  /// 该方法兼容字符串'true'和'false'
  ///
  bool getBool(String key, {bool defaultValue = false}) {
    final value = this[key];
    try {
      if (value != null && value is bool) {
        return value;
      }

      if (value is num) {
        if (value > 0) {
          return true;
        } else if (value == 0) {
          return false;
        }
      }

      if ('true' == value){
        return true;
      }
      if ('false' == value) {
        return false;
      }


    } catch (e) {
      return defaultValue;
    }
    return defaultValue;
  }

  ///
  /// 从map中获取一个字符串
  ///
  String? getString(String key, {String? defaultValue}) {
    try {
      final value = this[key];
      // print('getStringValue:key :$key, value:$value, valueType:${value.runtimeType}');
      if (value == null) {
        return defaultValue;
      }
      return value.toString();
    } catch (e) {
      return defaultValue;
    }
  }

  ///
  /// 从map中获取一个字符串,默认返回空字符串。
  /// 用于解决getString函数返回值可空而导致调用端代码不简洁的问题。
  ///
  String optString(String key, [String defaultValue = '']) {
    try {
      final value = this[key];
      // print('getStringValue:key :$key, value:$value, valueType:${value.runtimeType}');
      if (value == null) {
        return defaultValue;
      }
      return value.toString();
    } catch (e) {
      return defaultValue;
    }
  }

  /// 获取一个List字段
  List<T>? getList<T>(String key, {List<T>? defaultValue}) {
    final value = this[key];

    if (value is List<T>) {
      return value;
    }

    if (value is List) {
      // 如果是数字，需要逐个转换
      return value.map((e) {
        // print('e is num:${e is num}, T is double:${T is double}');

        if (e is num) {
          if (T == double) {
            return e.toDouble() as T;
          } else if (T == int) {
            return e.toInt() as T;
          }
        }
        return e as T;
      }).toList();
    }

    if (value != null && value is String) {
      final json = jsonDecode(value);
      if (json is List<T>) {
        return json;
      }
    }


    return defaultValue;
  }

  /// 获取一个Map字段
  Map? getMap(String key) {
    final value = this[key];
    if (value is Map) {
      return value;
    }
    if (value != null && value is String) {
      final json = jsonDecode(value);
      if (json is Map) {
        return json;
      }
    }
    return null;
  }

  /// 获取一个value值
  T? getValue<T>(String? key, {T? defaultValue}) {
    var r = defaultValue;
    try {
      dynamic value = this[key];
      if (value is T) {
        r = value;
      }
    } catch(e) {
      // ignore
    }
    return r;
  }


  ///
  /// 格式化map
  ///
  /// -  divider 分割符
  /// -
  ///
  String join2({String divider = ', ', String? prefix, String? suffix , String Function(K key, V? value)? convert}){
    var sb = StringBuffer();
    if (prefix != null) {
      sb.write(prefix);
    }

    final keys = this.keys;
    for (var i=0; i<keys.length; i++) {
      final key = keys.elementAt(i);
      final value = this[key];
      sb.write(convert != null ? convert(key, value) : value.toString());
      if (i != length - 1) {
        sb.write(divider);
      }
    }

    if (suffix != null) {
      sb.write(suffix);
    }

    return sb.toString();
  }



  ///
  /// 获取字典中满足条件的元素的个数
  ///
  int count(bool Function(K k, V v) test) {
    var count = 0;
    forEach((key, value) {
      if (test(key, value)) {
        count ++;
      }
    });
    return count;
  }

  ///
  ///  条件过滤
  ///
  Map<K, V> where(bool Function(K k, V v) test) {
    var r = <K, V>{};
    forEach((key, value) {
      if (test(key, value)) {
        r[key] = value;
      }
    });
    return r;
  }

  ///
  /// 可中断遍历，如果action返回true，表示中断遍历
  ///
  void forEachCanBreak(bool Function(K k, V v) action) {
    final it = keys.iterator;
    while (it.moveNext()) {
      final k = it.current;
      if (action(k, this[k]!)) {
        break;
      }
    }
  }
}
