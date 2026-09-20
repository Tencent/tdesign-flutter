import http from 'node:http';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { defineConfig, type ConfigEnv, type Plugin, type ViteDevServer } from 'vite';
import vue from '@vitejs/plugin-vue';
import vueJsx from '@vitejs/plugin-vue-jsx';
import createTDesignPlugin from './plugin-tdoc';

// 配置所在目录（等价于 __dirname，兼容 ESM / CJS 两种打包方式）
const rootDir = fileURLToPath(new URL('.', import.meta.url));

const publicPathMap: Record<string, string> = {
  preview: '/',
  production: '/flutter/',
};

function flutterExampleDevServer(): Plugin {
  return {
    name: 'flutter-example-dev-server',
    configureServer(server: ViteDevServer) {
      server.middlewares.use('/flutter/example', (req, res, next) => {
        const requestUrl = req.url || '/';
        const targetPath = requestUrl.startsWith('/flutter/example')
          ? requestUrl.slice('/flutter/example'.length) || '/'
          : requestUrl;
        const proxyRequest = http.request(
          {
            hostname: '127.0.0.1',
            port: 19001,
            path: targetPath,
            method: req.method,
            headers: { ...req.headers, host: '127.0.0.1:19001' },
          },
          (proxyResponse) => {
            const contentType = proxyResponse.headers['content-type'] || '';
            const chunks: Buffer[] = [];
            proxyResponse.on('data', (chunk) => chunks.push(Buffer.from(chunk)));
            proxyResponse.on('end', () => {
              let body = Buffer.concat(chunks);
              if (contentType.includes('text/html')) {
                body = Buffer.from(body.toString('utf8').replace('<base href="/">', '<base href="/flutter/example/">'));
              }
              const headers = { ...proxyResponse.headers, 'content-length': body.length };
              delete headers['transfer-encoding'];
              res.writeHead(proxyResponse.statusCode || 502, headers);
              res.end(body);
            });
          },
        );
        proxyRequest.on('error', () => {
          next();
        });
        req.pipe(proxyRequest);
      });
    },
  };
}

// https://vitejs.dev/config/
export default ({ mode }: ConfigEnv) => {
  return defineConfig({
    // 未知 mode（如自定义环境）时兜底为相对路径部署
    base: publicPathMap[mode] ?? '/',
    root: rootDir,
    resolve: {
      alias: {
        '~': path.resolve(rootDir, '..'),
        '@': path.resolve(rootDir, '../src'),
        '@component-docs': path.resolve(rootDir, '../docs/components'),
        '@components': path.resolve(rootDir, './components'),
        '@docs': path.resolve(rootDir, './docs'),
        '@pages': path.resolve(rootDir, './pages'),
      },
    },
    server: {
      // 监听所有网卡，便于容器 / 远程开发环境通过端口转发访问
      host: '0.0.0.0',
      port: 19000,
      open: '/',
      allowedHosts: true,
    },
    build: {
      outDir: '../_site',
      rollupOptions: {
        input: {
          site: path.resolve(rootDir, 'index.html'),
        },
      },
    },
    plugins: [
      vue({
        template: {
          compilerOptions: {
            isCustomElement: (tag) => tag.startsWith('td-'),
          },
        },
      }),
      vueJsx(),
      flutterExampleDevServer(),
      createTDesignPlugin(),
    ],
  });
};
