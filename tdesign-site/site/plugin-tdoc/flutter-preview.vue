<template>
  <td-doc-phone headless>
    <iframe
      ref="demoIframe"
      :title="title + ' Flutter Web 演示'"
      :src="src"
      frameborder="0"
      width="100%"
      height="100%"
      style="box-sizing: border-box; border-radius: 0 0 6px 6px; overflow: hidden;"
    ></iframe>
    <div>Web 预览用于体验交互效果；设备端运行方式见<a href="/flutter/getting-started">快速开始</a></div>
  </td-doc-phone>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import { setupFlutterPreviewReadyListener } from '../utils/flutterPreviewReady.mjs';

export default defineComponent({
  props: {
    src: { type: String, required: true },
    title: { type: String, required: true },
  },
  data() {
    return { disposeReadyListener: null as (() => void) | null };
  },
  mounted() {
    this.disposeReadyListener = setupFlutterPreviewReadyListener(
      this.$refs.demoIframe as HTMLIFrameElement,
    );
  },
  beforeUnmount() {
    this.disposeReadyListener?.();
  },
});
</script>
