<template>
  <td-doc-layout>
    <td-header ref="tdHeader" slot="header">
      <td-doc-search slot="search" ref="tdDocSearch"></td-doc-search>
    </td-header>
    <td-doc-aside ref="tdDocAside" title="Flutter"></td-doc-aside>

    <router-view :style="contentStyle" @loaded="contentLoaded" :docType="docType" />
    <td-theme-generator device="mobile"></td-theme-generator>
  </td-doc-layout>
</template>

<script>
import siteConfig from './site.config';
import '@tdesign/theme-generator';
import {
  createFlutterThemeMessage,
  ensureFlutterThemeTokenCoverage,
  generateFlutterThemeFromParts,
} from './utils/flutterThemeBridge.mjs';

import { defineComponent } from 'vue';

const { docs: routerList } = JSON.parse(JSON.stringify(siteConfig).replace(/component:.+/g, ''));

routerList.forEach((item) => {
  if (item.type === 'component') {
    item.children = item.children.sort((a, b) => {
      const nameA = a.name.toUpperCase();
      const nameB = b.name.toUpperCase();
      if (nameA < nameB) return -1;
      if (nameA > nameB) return 1;
      return 0;
    });
  }
});

export default defineComponent({
  data() {
    return {
      docType: '',
      loaded: false,
      themeObservers: {},
      themeStyles: { light: '', dark: '', extra: '' },
      themeBaselines: { light: '', dark: '', extra: '' },
      themeUpdateTimer: null,
      lastThemeJson: null,
      demoReadyHandler: null,
      themeModeObserver: null,
    };
  },

  computed: {
    contentStyle() {
      const { loaded } = this;
      return { visibility: loaded ? 'visible' : 'hidden' };
    },
  },

  mounted() {
    this.docType = this.$route.meta.docType;
    this.$refs.tdHeader.framework = 'flutter';
    this.$refs.tdDocAside.routerList = routerList;
    this.$refs.tdDocAside.onchange = ({ detail }) => {
      console.log('detail: ' + JSON.stringify(detail));
      if (this.$route.path === detail) return;
      this.loaded = false;
      this.$router.push({ path: detail });
      window.scrollTo(0, 0);
    };
    this.$refs.tdDocSearch.docsearchInfo = { indexName: 'tdesign_doc_flutter' };

    this.observeThemeStyle('custom-theme', 'light');
    this.observeThemeStyle('custom-theme-dark', 'dark');
    this.observeThemeStyle('custom-theme-extra', 'extra');
    this.themeModeObserver = new MutationObserver(() => this.scheduleThemeUpdate());
    this.themeModeObserver.observe(document.documentElement, {
      attributes: true,
      attributeFilter: ['theme-mode'],
    });
    this.demoReadyHandler = (event) => {
      this.sendThemeToFlutterIframe(event.detail?.iframe);
    };
    window.addEventListener('flutter-demo-ready', this.demoReadyHandler);
  },

  beforeUnmount() {
    Object.values(this.themeObservers).forEach((observer) => observer?.disconnect());
    this.themeModeObserver?.disconnect();
    if (this.themeUpdateTimer) clearTimeout(this.themeUpdateTimer);
    if (this.demoReadyHandler) {
      window.removeEventListener('flutter-demo-ready', this.demoReadyHandler);
    }
  },

  watch: {
    $route(route) {
      if (!route.meta.docType) return;
      this.docType = route.meta.docType;
    },
  },

  methods: {
    contentLoaded(callback) {
      requestAnimationFrame(() => {
        this.loaded = true;
        callback();
      });
    },
    observeThemeStyle(styleId, themePart) {
      const attach = (styleElement) => {
        const update = () => {
          let cssText = styleElement.textContent || '';
          if (themePart === 'extra') {
            const completedCss = ensureFlutterThemeTokenCoverage(cssText);
            if (completedCss !== cssText) {
              styleElement.textContent = completedCss;
              cssText = completedCss;
            }
          }
          if (!this.themeBaselines[themePart]) {
            this.themeBaselines[themePart] = cssText;
          }
          this.themeStyles[themePart] = cssText;
          this.scheduleThemeUpdate();
        };
        update();
        const observer = new MutationObserver(update);
        observer.observe(styleElement, {
          childList: true,
          characterData: true,
          subtree: true,
        });
        this.themeObservers[styleId] = observer;
      };

      const styleElement = document.getElementById(styleId);
      if (styleElement) {
        attach(styleElement);
        return;
      }
      const headObserver = new MutationObserver(() => {
        const addedStyle = document.getElementById(styleId);
        if (!addedStyle) return;
        headObserver.disconnect();
        attach(addedStyle);
      });
      headObserver.observe(document.head, { childList: true });
      this.themeObservers[`${styleId}-head`] = headObserver;
    },
    scheduleThemeUpdate() {
      if (this.themeUpdateTimer) clearTimeout(this.themeUpdateTimer);
      this.themeUpdateTimer = setTimeout(() => {
        if (!this.themeStyles.light || !this.themeStyles.dark) return;
        const themeJson = generateFlutterThemeFromParts(
          this.themeStyles.light,
          this.themeStyles.dark,
          this.themeStyles.extra,
          this.themeBaselines,
        );
        const message = createFlutterThemeMessage(
          themeJson,
          document.documentElement.getAttribute('theme-mode') === 'dark' ? 'dark' : 'light',
        );
        const serialized = JSON.stringify(message);
        if (serialized === this.lastThemeJson) return;
        this.lastThemeJson = serialized;
        document.querySelectorAll('iframe[src*="/example/"]').forEach((iframe) => {
          this.sendThemeToFlutterIframe(iframe, message);
        });
      }, 80);
    },
    sendThemeToFlutterIframe(iframe, message = null) {
      if (!iframe?.contentWindow) return;
      const currentMessage = message || (this.lastThemeJson && JSON.parse(this.lastThemeJson));
      if (!currentMessage) return;
      iframe.contentWindow.postMessage(
        JSON.stringify(currentMessage),
        window.location.origin,
      );
    },
  },
});
</script>

<style lang="less">
:root,
:root[theme-mode='light'] {
  --td-brand-color-1: #f2f3ff;
  --td-brand-color-2: #d9e1ff;
  --td-brand-color-3: #b5c7ff;
  --td-brand-color-4: #8eabff;
  --td-brand-color-5: #618dff;
  --td-brand-color-6: #366ef4;
  --td-brand-color-7: #0052d9;
  --td-brand-color-8: #003cab;
  --td-brand-color-9: #002a7c;
  --td-brand-color-10: #001a57;
  --td-brand-color: var(--td-brand-color-7);
  --td-brand-color-focus: var(--td-brand-color-1);
  --td-brand-color-active: var(--td-brand-color-8);
  --td-brand-color-disabled: var(--td-brand-color-3) #b5c7ff;
  --td-brand-color-light: var(--td-brand-color-1);
  --td-brand-color-light-active: var(--td-brand-color-2);
}

:root[theme-mode='dark'] {
  --td-brand-color-1: #1b2f51;
  --td-brand-color-2: #173463;
  --td-brand-color-3: #143975;
  --td-brand-color-4: #103d88;
  --td-brand-color-5: #0d429a;
  --td-brand-color-6: #054bbe;
  --td-brand-color-7: #2667d4;
  --td-brand-color-8: #4582e6;
  --td-brand-color-9: #699ef5;
  --td-brand-color-10: #96bbf8;
  --td-brand-color: var(--td-brand-color-8);
  --td-brand-color-focus: var(--td-brand-color-1);
  --td-brand-color-active: var(--td-brand-color-9);
  --td-brand-color-disabled: var(--td-brand-color-3);
  --td-brand-color-light: var(--td-brand-color-1);
  --td-brand-color-light-active: var(--td-brand-color-2);
}
</style>
