/*
 * Created by dorayhong@tencent.com on 6/8/23.
 */
import 'package:flutter/cupertino.dart';

class TCollapseSaltedKey<S, V> extends LocalKey {
  const TCollapseSaltedKey(this.salt, this.value);

  final S salt;
  final V value;

  @override
  bool operator ==(Object other) {
    if (other is! TCollapseSaltedKey<S, V>) {
      return false;
    }
    return salt == other.salt && value == other.value;
  }

  @override
  int get hashCode => Object.hash(runtimeType, salt, value);

  @override
  String toString() {
    final saltString = S == String ? '<\'$salt\'>' : '<$salt>';
    final valueString = V == String ? '<\'$value\'>' : '<$value>';
    return '[$saltString $valueString]';
  }
}
