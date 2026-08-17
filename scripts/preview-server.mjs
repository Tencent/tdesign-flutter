// 仅预览模式（onlyPreview）下的静态文件服务器。
// 业务服务必须监听 8686 端口（CNB 仅预览模式硬约束）。
// 零依赖，仅用 Node 内置模块；支持 SPA 回退：未命中文件时返回 index.html。
//
// 用法：
//   node scripts/preview-server.mjs <静态目录> [端口]
//   示例：node scripts/preview-server.mjs tdesign-component/example/build/web 8686

import { createServer } from 'node:http';
import { readFile, stat } from 'node:fs/promises';
import { extname, join, normalize, resolve } from 'node:path';

const rootDir = resolve(process.argv[2] ?? '.');
const port = Number(process.argv[3] ?? 8686);

const MIME = {
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

const serveFile = async (res, filePath) => {
  const content = await readFile(filePath);
  const type = MIME[extname(filePath).toLowerCase()] ?? 'application/octet-stream';
  res.writeHead(200, {
    'Content-Type': type,
    'Cache-Control': 'no-cache',
  });
  res.end(content);
};

const server = createServer(async (req, res) => {
  try {
    const url = new URL(req.url, 'http://localhost');
    // 只允许 GET / HEAD；其他方法直接 405。
    if (req.method !== 'GET' && req.method !== 'HEAD') {
      res.writeHead(405, { 'Content-Type': 'text/plain; charset=utf-8' });
      res.end('Method Not Allowed');
      return;
    }

    // 归一化路径，防止路径穿越。
    const decoded = decodeURIComponent(url.pathname);
    let filePath = resolve(rootDir, `.${normalize(decoded)}`);
    if (!filePath.startsWith(rootDir)) {
      res.writeHead(403, { 'Content-Type': 'text/plain; charset=utf-8' });
      res.end('Forbidden');
      return;
    }

    try {
      const info = await stat(filePath);
      if (info.isDirectory()) {
        filePath = join(filePath, 'index.html');
      }
    } catch {
      // 文件不存在，走 SPA 回退。
    }

    try {
      await serveFile(res, filePath);
    } catch {
      // SPA 回退：静态目录下所有未命中的路由都返回 index.html。
      await serveFile(res, join(rootDir, 'index.html'));
    }
  } catch (error) {
    res.writeHead(500, { 'Content-Type': 'text/plain; charset=utf-8' });
    res.end(`Internal Server Error: ${error.message}`);
  }
});

server.listen(port, '0.0.0.0', () => {
  console.log(`preview server listening on http://0.0.0.0:${port} (root=${rootDir})`);
});
