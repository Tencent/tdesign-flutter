import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:web/web.dart' as web;

import 'web_theme_message.dart';

/// 接收同源父窗口的主题更新；调用返回的函数可取消本次监听。
///
/// 独立打开 Example 时不注册监听，也不向自身发送 ready 消息。
VoidCallback listenToWebThemeUpdates({
  required void Function(TThemeData theme, ThemeMode? mode) onUpdate,
}) {
  final parent = web.window.parent;
  if (parent == null || parent == web.window) {
    return _noop;
  }
  final origin = web.window.location.origin;

  void handleMessage(web.Event event) {
    final message = event as web.MessageEvent;
    if (message.origin != origin || message.source != parent) {
      return;
    }
    final Object? rawData;
    try {
      rawData = message.data.dartify();
    } on Object {
      return;
    }
    final data = decodeWebThemeMessageData(rawData);
    final theme = parseWebThemeUpdateMessage(data);
    if (theme != null) {
      onUpdate(theme, parseWebThemeMode(data));
    }
  }

  final listener = handleMessage.toJS;
  web.window.addEventListener('message', listener);
  parent.postMessage(
    jsonEncode({'type': 'flutter-demo-ready'}).toJS,
    origin.toJS,
  );
  return () => web.window.removeEventListener('message', listener);
}

void _noop() {}
