import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { defineConfig, type ConfigEnv } from 'vite';
import vue from '@vitejs/plugin-vue';
import vueJsx from '@vitejs/plugin-vue-jsx';
import createTDesignPlugin from './plugin-tdoc';

// 配置所在目录（等价于 __dirname，兼容 ESM / CJS 两种打包方式）
const rootDir = fileURLToPath(new URL('.', import.meta.url));

const publicPathMap: Record<string, string> = {
  preview: '/',
  production: 'https://static.tdesign.tencent.com/flutter/',
};

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
      createTDesignPlugin(),
    ],
  });
};
