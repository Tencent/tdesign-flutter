import * as path from 'path';
import * as fs from 'fs';
import { defineConfig, Plugin } from 'vite';
import vue from '@vitejs/plugin-vue';
import vueJsx from '@vitejs/plugin-vue-jsx';
import rollupResolve from '@rollup/plugin-node-resolve';
import createTDesignPlugin from './plugin-tdoc';

const publicPathMap: Record<string, string> = {
  preview: '/',
  production: '/flutter/',
};

// 插件：为 /example/ 路径提供 index.html 默认文件
function serveExampleIndexPlugin(): Plugin {
  return {
    name: 'serve-example-index',
    configureServer(server) {
      server.middlewares.use((req, res, next) => {
        // 处理 /example/ 或 /example 请求，返回 index.html
        if (req.url === '/example' || req.url === '/example/' || req.url?.startsWith('/example/#')) {
          const indexPath = path.join(__dirname, 'public', 'example', 'index.html');
          if (fs.existsSync(indexPath)) {
            res.setHeader('Content-Type', 'text/html');
            res.end(fs.readFileSync(indexPath));
            return;
          }
        }
        next();
      });
    },
  };
}

// https://vitejs.dev/config/
export default ({ mode }: any) => {
  return defineConfig({
    base: publicPathMap[mode],
    root: path.resolve(__dirname),
    resolve: {
      alias: {
        '~': path.resolve(__dirname, '..'),
        '@': path.resolve(__dirname, '../src'),
        '@common': path.resolve(__dirname, '../common'),
        '@components': path.resolve(__dirname, './components'),
        '@docs': path.resolve(__dirname, './docs'),
        '@pages': path.resolve(__dirname, './pages'),
      },
    },
    server: {
      host: '127.0.0.1',
      port: 19000,
      open: '/',
    },
    publicDir: path.resolve(__dirname, 'public'),
    build: {
      outDir: '../_site',
      rollupOptions: {
        input: {
          site: path.resolve(__dirname, 'index.html'),
        },
        plugins: [
          rollupResolve({
            moduleDirectories: [path.resolve(__dirname, 'node_modules')],
          }),
        ],
      },
    },
    plugins: [
      serveExampleIndexPlugin(),
      vue({
        template: {
          compilerOptions: {
            isCustomElement: (tag) => tag.startsWith('td-'),
          },
        },
      }),
      vueJsx(),
      createTDesignPlugin(),
    ],
  });
};
