import { RouteRecordRaw, createRouter, createWebHistory, RouterOptions } from 'vue-router';
// @ts-ignore
import siteConfig from './site.config';
import { documentNavigation } from './utils/documentAnchor.mjs';

const { docs } = siteConfig;

const getDocsRoutes = (docs: any[], type: string): RouteRecordRaw[] => {
  let docsRoutes: Array<RouteRecordRaw> = [];
  docs.forEach((item) => {
    const docType = item.type || type;
    if (docType === type) {
      const { children } = item;

      if (children) {
        docsRoutes = docsRoutes.concat(getDocsRoutes(children, docType));
      } else {
        docsRoutes.push({
          path: item.path,
          name: item.name,
          meta: item.meta || {},
          component: item.component,
        });
      }
    }
  });
  return docsRoutes;
};

const routes: Array<RouteRecordRaw> = [
  {
    path: '/',
    redirect: '/flutter/overview',
  },
  {
    path: '/:catchAll(.*)',
    redirect: '/flutter/overview',
  },
  ...siteConfig.standalone,
  ...getDocsRoutes(docs, 'document'),
  ...getDocsRoutes(docs, 'component'),
];

const routerConfig: RouterOptions = {
  routes,
  history: createWebHistory('/'),
  scrollBehavior(to, from, savedPosition) {
    return documentNavigation.scroll(to, savedPosition);
  },
};

const router = createRouter(routerConfig);

router.beforeEach((to, from, next) => {
  documentNavigation.begin(to, from);
  // @ts-ignore
  if (typeof NProgress !== 'undefined') {
    // @ts-ignore
    window.NProgress && window.NProgress.start();
  }
  next();
});

router.afterEach(() => {
  // @ts-ignore
  window.NProgress && window.NProgress.done();
  // @ts-ignore
  document.querySelector('td-stats')?.track?.();
});

export default router;
