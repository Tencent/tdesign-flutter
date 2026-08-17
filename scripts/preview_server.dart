// 仅预览模式（onlyPreview）下的静态文件服务器。
// 业务服务必须监听 8686 端口（CNB 仅预览模式硬约束）。
// 使用 Dart 实现（Flutter 镜像内保证自带 dart，不依赖 node/python）。
// 零第三方依赖，仅用 SDK 内置库；支持 SPA 回退：未命中文件时返回 index.html。
//
// 用法：
//   dart run scripts/preview_server.dart <静态目录> [端口]
//   示例：dart run scripts/preview_server.dart tdesign-component/example/build/web 8686

import 'dart:async';
import 'dart:io';

const Map<String, String> _mime = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.mjs': 'text/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.webp': 'image/webp',
  '.ico': 'image/x-icon',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
  '.ttf': 'font/ttf',
  '.map': 'application/json; charset=utf-8',
};

String _contentType(String path) {
  final dot = path.lastIndexOf('.');
  if (dot < 0) return 'application/octet-stream';
  return _mime[path.substring(dot).toLowerCase()] ?? 'application/octet-stream';
}

/// 归一化绝对路径，去除 `.`/`..`/重复分隔符，用于路径穿越防护。
String _normalize(String p) {
  final isRoot = p.startsWith('/');
  final parts = <String>[];
  for (final seg in p.split('/')) {
    if (seg.isEmpty || seg == '.') continue;
    if (seg == '..') {
      if (parts.isNotEmpty) parts.removeLast();
    } else {
      parts.add(seg);
    }
  }
  return '${isRoot ? '/' : ''}${parts.join('/')}';
}

/// 判定 path 是否位于 rootDir 目录树内（含 rootDir 本身），防止路径穿越。
bool _within(String rootDir, String path) {
  return path == rootDir || path.startsWith('$rootDir/');
}

Future<void> _send(HttpResponse res, String path, {required bool headOnly}) async {
  final file = File(path);
  final bytes = await file.readAsBytes();
  res.headers.contentType = ContentType.parse(_contentType(path));
  res.headers.set('Cache-Control', 'no-cache');
  res.statusCode = HttpStatus.ok;
  if (!headOnly) {
    res.add(bytes);
  }
  await res.close();
}

Future<void> _handle(HttpRequest req, String rootDir) async {
  final res = req.response;
  final headOnly = req.method == 'HEAD';
  try {
    if (req.method != 'GET' && req.method != 'HEAD') {
      res.statusCode = HttpStatus.methodNotAllowed;
      res.write('Method Not Allowed');
      await res.close();
      return;
    }

    final decoded = Uri.decodeComponent(req.uri.path);
    // 归一化并限定在 rootDir 内，防止路径穿越。
    final normalized = _normalize('$rootDir/.$decoded');
    if (!_within(rootDir, normalized)) {
      res.statusCode = HttpStatus.forbidden;
      res.write('Forbidden');
      await res.close();
      return;
    }

    var target = normalized;
    if (Directory(target).existsSync()) {
      target = '$target/index.html';
    }

    if (File(target).existsSync()) {
      await _send(res, target, headOnly: headOnly);
    } else {
      // SPA 回退：静态目录下所有未命中的路由都返回 index.html。
      final fallback = '$rootDir/index.html';
      if (File(fallback).existsSync()) {
        await _send(res, fallback, headOnly: headOnly);
      } else {
        res.statusCode = HttpStatus.notFound;
        res.write('Not Found');
        await res.close();
      }
    }
  } catch (e) {
    try {
      res.statusCode = HttpStatus.internalServerError;
      res.write('Internal Server Error: $e');
      await res.close();
    } catch (_) {
      // 连接可能已关闭，忽略。
    }
  }
}

Future<void> main(List<String> args) async {
  final rootArg = args.isNotEmpty ? args[0] : '.';
  final rootDir = _normalize(Directory(rootArg).absolute.path);
  final port = args.length > 1 ? int.parse(args[1]) : 8686;

  final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
  // ignore: avoid_print
  print('preview server listening on http://0.0.0.0:$port (root=$rootDir)');

  await for (final req in server) {
    // 并发处理请求，避免阻塞事件循环。
    unawaited(_handle(req, rootDir));
  }
}
