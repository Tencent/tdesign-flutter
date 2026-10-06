import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 非 Web 平台不监听浏览器消息；返回空操作释放函数。
VoidCallback listenToWebThemeUpdates({
  required void Function(TThemeData theme, ThemeMode? mode) onUpdate,
}) => _noop;

void _noop() {}
