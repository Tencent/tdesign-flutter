<template>
  <td-doc-layout>
    <td-header ref="tdHeader" slot="header">
      <td-doc-search slot="search" ref="tdDocSearch"></td-doc-search>
    </td-header>
    <td-doc-aside ref="tdDocAside" title="Flutter"></td-doc-aside>

    <router-view :style="contentStyle" @loaded="contentLoaded" :docType="docType" />
    <td-theme-generator/>
  </td-doc-layout>
</template>

<script>
import siteConfig from "./site.config";
import "@tdesign/theme-generator";
import { generateFlutterThemeFromParts } from "./utils/cssToFlutterTheme";

import { defineComponent } from "vue";

const { docs: routerList } = JSON.parse(JSON.stringify(siteConfig).replace(/component:.+/g, ""));

routerList.forEach((item) => {
  if (item.type === "component") {
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
      docType: "",
      loaded: false,
      themeObservers: {},
      // 存储各个 style 的内容
      themeStyles: {
        light: "",   // custom-theme (light)
        dark: "",    // custom-theme-dark
        extra: "",   // custom-theme-extra (共用)
      },
    };
  },

  computed: {
    contentStyle() {
      const { loaded } = this;
      return { visibility: loaded ? "visible" : "hidden" };
    },
  },

  mounted() {
    this.docType = this.$route.meta.docType;
    this.$refs.tdHeader.framework = "flutter";
    this.$refs.tdDocAside.routerList = routerList;
    this.$refs.tdDocAside.onchange = ({ detail }) => {
      if (this.$route.path === detail) return;
      this.loaded = false;
      this.$router.push({ path: detail });
      window.scrollTo(0, 0);
    };
    this.$refs.tdDocSearch.docsearchInfo = { indexName: "tdesign_doc_flutter" };

    // 监听三个 custom-theme style 元素
    this.observeCustomTheme("custom-theme");       // light 主题
    this.observeCustomTheme("custom-theme-dark");  // dark 主题
    this.observeCustomTheme("custom-theme-extra"); // 共用额外样式
  },

  beforeUnmount() {
    // 组件销毁时断开所有观察器
    Object.values(this.themeObservers).forEach((observer) => {
      if (observer) observer.disconnect();
    });
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
    observeCustomTheme(styleId) {
      // 查找或等待指定 id 的元素
      const findAndObserve = () => {
        const styleElement = document.getElementById(styleId);
        if (styleElement) {
          // 读取初始内容
          this.handleThemeChange(styleId, styleElement.textContent);

          // 创建 MutationObserver 监听变化
          const observer = new MutationObserver(() => {
            this.handleThemeChange(styleId, styleElement.textContent);
          });

          // 配置观察选项
          observer.observe(styleElement, {
            childList: true,      // 监听子节点变化
            characterData: true,  // 监听文本内容变化
            subtree: true,        // 监听所有后代节点
          });

          // 存储观察器
          this.themeObservers[styleId] = observer;
        } else {
          // 如果元素还不存在，监听 head 等待元素被添加
          const headObserver = new MutationObserver((mutations, obs) => {
            const styleElement = document.getElementById(styleId);
            if (styleElement) {
              obs.disconnect();
              findAndObserve();
            }
          });
          headObserver.observe(document.head, { childList: true });
          // 存储 head 观察器以便清理
          this.themeObservers[`${styleId}-head`] = headObserver;
        }
      };

      findAndObserve();
    },
    handleThemeChange(styleId, cssContent) {

      // 更新对应的样式内容
      if (styleId === "custom-theme") {
        this.themeStyles.light = cssContent;
      } else if (styleId === "custom-theme-dark") {
        this.themeStyles.dark = cssContent;
      } else if (styleId === "custom-theme-extra") {
        this.themeStyles.extra = cssContent;
      }

      // 输出组合后的主题
      this.onThemeUpdated();
    },
    onThemeUpdated() {
      const { light, dark, extra } = this.themeStyles;

      // 使用工具函数生成 Flutter 主题配置
      const themeJson = generateFlutterThemeFromParts(light, dark, extra);

      // console.log("Flutter 主题 JSON:", JSON.stringify(themeJson, null, 2));

      // 将主题 JSON 发送给所有 Flutter iframe
      this.sendThemeToFlutterIframes(themeJson);
    },
    sendThemeToFlutterIframes(themeJson) {
      // 查找所有 Flutter iframe (在 component.vue 中)
      const iframes = document.querySelectorAll('iframe[src*="/example/"]');
      iframes.forEach((iframe) => {
        if (iframe.contentWindow) {
          iframe.contentWindow.postMessage(
            {
              type: 'flutter-theme-update',
              theme: themeJson,
            },
            '*'
          );
        }
      });
    },
  },
});
</script>

<style lang="less">
:root,
:root[theme-mode="light"] {
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

:root[theme-mode="dark"] {
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
