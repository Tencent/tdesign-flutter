#!/usr/bin/env node
// onlyPreview 预览服务器：单一进程从启动即常驻 8686，避免进程切换导致的平台转发失效。
// - 构建前（_site/index.html 未就绪）返回占位页；
// - 构建后作为静态文件服务提供 _site（含 SPA fallback 与正确 MIME）。
// 用法：node preview-server.js <siteOutDir> <port> [logFile]
'use strict';

const http = require('http');
const fs = require('fs');
const path = require('path');

const SITE_OUT = path.resolve(process.argv[2] || '.');
const PORT = Number(process.argv[3] || 8686);
const LOG = process.argv[4] ? path.resolve(process.argv[4]) : null;

const READY_FLAG = path.join(SITE_OUT, 'index.html');

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
  '.ico': 'image/x-icon',
  '.webp': 'image/webp',
  '.wasm': 'application/wasm',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
  '.ttf': 'font/ttf',
  '.otf': 'font/otf',
  '.eot': 'application/vnd.ms-fontobject',
  '.pdf': 'application/pdf',
  '.txt': 'text/plain; charset=utf-8',
  '.map': 'application/json; charset=utf-8',
};

function log(msg) {
  const line = `[preview-server] ${new Date().toISOString()} ${msg}`;
  // eslint-disable-next-line no-console
  console.log(line);
  if (LOG) {
    try { fs.appendFileSync(LOG, line + '\n'); } catch (_) { /* ignore */ }
  }
}

function placeholderHtml() {
  return '<!DOCTYPE html><html lang="zh"><head><meta charset="utf-8">'
    + '<meta http-equiv="refresh" content="5"><title>TDesign Flutter Preview</title></head>'
    + '<body style="font-family:sans-serif;display:flex;align-items:center;justify-content:center;'
    + 'height:100vh;margin:0;background:#f4f4f5;color:#333">'
    + '<div style="text-align:center"><h1>TDesign Flutter Preview</h1>'
    + '<p>构建中，请稍候自动刷新…</p></div></body></html>';
}

function send(res, status, contentType, body) {
  res.writeHead(status, {
    'Content-Type': contentType,
    'Cache-Control': 'no-cache',
    'X-Content-Type-Options': 'nosniff',
  });
  res.end(body);
}

function safeJoin(base, urlPath) {
  // 去掉 query / hash，并 URL 解码
  const clean = decodeURIComponent(urlPath.split('?')[0].split('#')[0]);
  const filePath = path.join(base, clean);
  const rel = path.relative(base, filePath);
  if (rel.startsWith('..') || path.isAbsolute(rel)) {
    return null; // 目录穿越
  }
  return filePath;
}

const server = http.createServer((req, res) => {
  if (req.method !== 'GET' && req.method !== 'HEAD') {
    send(res, 405, 'text/plain; charset=utf-8', 'Method Not Allowed');
    return;
  }

  const urlPath = req.url || '/';
  const raw = safeJoin(SITE_OUT, urlPath);

  // 目录穿越被拦截：直接 404，不参与 SPA fallback。
  if (!raw) {
    send(res, 404, 'text/plain; charset=utf-8', 'Not Found');
    return;
  }

  // 构建未就绪：统一返回占位页（并定期刷新），让平台转发在构建期间稳定可用。
  if (!fs.existsSync(READY_FLAG)) {
    send(res, 200, 'text/html; charset=utf-8', placeholderHtml());
    return;
  }

  let filePath = raw;
  // 目录 / 末尾斜杠 → index.html
  if (filePath && (fs.existsSync(filePath) && fs.statSync(filePath).isDirectory())) {
    filePath = path.join(filePath, 'index.html');
  }
  // 精确文件命中
  if (filePath && fs.existsSync(filePath) && fs.statSync(filePath).isFile()) {
    const ext = path.extname(filePath).toLowerCase();
    const body = fs.readFileSync(filePath);
    send(res, 200, MIME[ext] || 'application/octet-stream', body);
    return;
  }

  // SPA fallback：请求的路径无对应文件时回退到站点入口 index.html。
  // 但 /flutter/example/ 子路径下的资源若不存在，不应 fallback 到站点入口，
  // 因此仅当请求落在站点根（非 /flutter 前缀）时才回退。
  const siteIndex = path.join(SITE_OUT, 'index.html');
  if (!urlPath.startsWith('/flutter') && fs.existsSync(siteIndex)) {
    const body = fs.readFileSync(siteIndex);
    send(res, 200, 'text/html; charset=utf-8', body);
    return;
  }

  send(res, 404, 'text/plain; charset=utf-8', 'Not Found');
});

server.listen(PORT, '0.0.0.0', () => {
  log(`listening on 0.0.0.0:${PORT}, serving ${SITE_OUT} (ready=${fs.existsSync(READY_FLAG)})`);
});
