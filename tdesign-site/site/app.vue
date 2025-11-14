<template>
  <td-doc-layout>
    <td-header ref="tdHeader" slot="header">
      <td-doc-search slot="search" ref="tdDocSearch"></td-doc-search>
    </td-header>
    <td-doc-aside ref="tdDocAside" title="Flutter"></td-doc-aside>

    <router-view :style="contentStyle" @loaded="contentLoaded" :docType="docType" />
  </td-doc-layout>
</template>

<script>
import siteConfig from './site.config';

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
