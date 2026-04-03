/**
 * 主题转换相关配置
 */
export const config = {
  /** 主题缓存 localStorage key */
  themeCacheKey: 'tdesign-flutter-theme-cache',

  /** 主题缓存过期时间（7天） */
  themeCacheMaxAge: 7 * 24 * 60 * 60 * 1000,

  /** 主题变更防抖延迟（ms） */
  debounceDelay: 300,

  /** postMessage 目标源 */
  postMessageOrigin: '*',
};

const LOG_LEVEL = import.meta.env.PROD ? 'warn' : 'debug';
const LOG_LEVELS = ['debug', 'info', 'warn', 'error'] as const;

function shouldLog(level: typeof LOG_LEVELS[number]) {
  return LOG_LEVELS.indexOf(level) >= LOG_LEVELS.indexOf(LOG_LEVEL as any);
}

/** 日志工具，生产环境仅输出 warn 及以上 */
export const logger = {
  debug: (...args: any[]) => shouldLog('debug') && console.log('[TDesign Theme]', ...args),
  info: (...args: any[]) => shouldLog('info') && console.info('[TDesign Theme]', ...args),
  warn: (...args: any[]) => shouldLog('warn') && console.warn('[TDesign Theme]', ...args),
  error: (...args: any[]) => shouldLog('error') && console.error('[TDesign Theme]', ...args),
};
