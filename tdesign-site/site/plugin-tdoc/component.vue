<template>
  <td-doc-content
    ref="tdDocContent"
    platform="mobile"
    :class="{ 'flutter-preview-layout': info.isComponent || info.flutterPreview }"
    page-status="hidden"
  >
    <td-doc-header v-if="info.tdDocHeader" platform="mobile" slot="doc-header" ref="tdDocHeader" changelog="false"></td-doc-header>
    <template v-if="info.isComponent">
      <td-doc-tabs ref="tdDocTabs" :tab="tab"></td-doc-tabs>
      <div class="td-doc-main" v-show="tab === 'demo'">
        <div name="DEMO" v-html="info.demoMd"></div>
        <FlutterPreview :src="liveUrl" :title="info.title" />
        <td-contributors platform="flutter" framework="flutter" :component-name="name"></td-contributors>
      </div>
      <div v-show="tab === 'api'" name="API" v-html="info.apiMd"></div>
      <div v-show="tab === 'design'" name="DESIGN" v-html="info.designMd"></div>
    </template>
    <div v-else-if="info.flutterPreview" class="td-doc-main">
      <div name="DOC" :class="info.docClass" v-html="info.docMd"></div>
      <FlutterPreview :src="liveUrl" :title="info.title" />
    </div>
    <div name="DOC" :class="info.docClass" v-else v-html="info.docMd"></div>
    <div style="margin-top: 48px">
      <td-doc-history :time="info.lastUpdated"></td-doc-history>
    </div>
    <td-doc-footer slot="doc-footer" platform="mobile"></td-doc-footer>
  </td-doc-content>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import Prismjs from 'prismjs';
import 'prismjs/components/prism-bash.js';
import 'prismjs/components/prism-json.js';
import 'prismjs/components/prism-dart.js';
import 'prismjs/components/prism-yaml.js';

import FlutterPreview from './flutter-preview.vue';
import { flutterExampleLiveUrl } from '../flutter-example-docs/live-url.mjs';

export default defineComponent({
  inject: ['info', 'demos'],

  components: {
    FlutterPreview,
  },

  computed: {
    tab: {
      get() {
        return this.$route.query.tab || 'demo';
      },
      set(v) {
        if (this.$route.query.tab !== v) {
          this.$router.push({ query: { tab: v } });
        }
      },
    },
    name() {
      const { path } = this.$route;
      return path.slice(path.lastIndexOf('/') + 1);
    },
    liveUrl() {
      return flutterExampleLiveUrl(this.info.flutterPreview || this.name, {
        dev: import.meta.env.DEV,
        hostname: window.location.hostname,
        devServerPort: import.meta.env.VITE_FLUTTER_WEB_PORT || '19001',
      });
    },
  },

  mounted() {
    const { info } = this;
    const { tdDocContent, tdDocHeader, tdDocTabs } = this.$refs;

    if (info.isComponent) {
      tdDocTabs.onchange = ({ detail: currentTab }) => (this.tab = currentTab);
      tdDocHeader.componentName = info.componentName;
    }
    Prismjs.highlightAll();
    tdDocHeader.spline = info.spline;
    tdDocHeader.docInfo = { title: info.title, desc: info.description };

    this.$emit('loaded', () => {
      tdDocContent.pageStatus = 'show';
    });
  },
});
</script>

<style lang="less">
// site-components reserves phone space by /components/ URL; guides share it here.
td-doc-content.flutter-preview-layout {
  --content-padding-right: 400px;
}

@media screen and (max-width: 959px) {
  td-doc-content.flutter-preview-layout {
    --content-padding-right: 0px;
  }
}

div[name='API'] {
  h6 {
    font-size: 1em;
    line-height: 1.5;
  }

  table:has(th:nth-child(5):last-child) {
    width: 100%;
    table-layout: fixed;
    overflow-wrap: anywhere;

    :is(th, td):nth-child(1) {
      width: 18%;
    }
    :is(th, td):nth-child(2) {
      width: 22%;
    }
    :is(th, td):nth-child(3) {
      width: 12%;
    }
    :is(th, td):nth-child(4) {
      width: 40%;
    }
    :is(th, td):nth-child(5) {
      width: 8%;
    }
  }
}

.td-doc {
  // &-main {
  //   position: relative;
  // }

  &__image-wrapper {
    margin: 16px 0 -1px;
    padding: 24px 0;
    text-align: center;
    background-color: #fff;
    border-radius: 6px 6px 0 0;
    border: 1px solid #dcdcdc;

    &--gray {
      background-color: #eee;
    }

    :root[theme-mode='dark'] & img {
      filter: unset;
    }

    div[name='DEMO'] & + pre {
      margin-top: 0;
      border-top-left-radius: 0;
      border-top-right-radius: 0;
    }
  }
}

</style>
