import mdToVue from '../scripts/md-to-vue';
import { replaceFlutterExampleDirectives } from '../flutter-example-docs/transform.mjs';
import { replaceFlutterApiDirectives } from '../flutter-example-docs/api.mjs';

export default {
  before({ source }: any) {
    // Flutter Web 文档直接读取 Example App 生成的唯一代码资产。
    source = replaceFlutterExampleDirectives(source);
    source = replaceFlutterApiDirectives(source);

    return source;
  },
  render({ source, file, md }: { source: string; file: string; md: any }) {
    const sfc = mdToVue({
      md,
      file,
      source,
    });

    return sfc;
  },
};
