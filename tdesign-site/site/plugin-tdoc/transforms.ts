import mdToVue from '../scripts/md-to-vue';
import { replaceFlutterExampleDirectives } from '../flutter-example-docs/transform.mjs';
import { replaceFlutterApiDirectives } from '../flutter-example-docs/api.mjs';
import { adaptGuideLinks, adaptRepositoryDocument } from '../flutter-example-docs/repository-document.mjs';

export default {
  before({ source, file }: any) {
    source = adaptGuideLinks(adaptRepositoryDocument(source, file), file);

    // Flutter Web 文档直接读取 Example App 生成的唯一代码资产。
    source = replaceFlutterExampleDirectives(source);
    source = replaceFlutterApiDirectives(source);

    return source;
  },
  render({ source, file, md }: { source: string; file: string; md: any }) {
    return mdToVue({ md, file, source });
  },
};
