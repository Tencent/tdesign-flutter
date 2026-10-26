# 044-ThemeController-import-and-preview 验证范围与结论

<a id="source-044"></a>
<a id="source-066"></a>
<a id="source-067"></a>
<a id="source-068"></a>
<a id="source-080"></a>

## 本次范围

2026-10-20 原记录整理；未重跑组件、Golden、设备或远端CI。以下结论仅限原候选与范围。

## 已有验证结论

| 原记录范围 | 原文可追溯标识与环境 | 有界结论 |
| --- | --- | --- |
| 既有记录 | 未绑定唯一完整候选 SHA；SDK 范围未完整标注 | 组件与布局：未提取到可独立确认的通过结论；Golden：未提取到可独立确认的通过结论；设备：仅按下文的实际操作与未覆盖范围解释 |

各标识可能对应不同阶段，不能合成一次完整验证；候选或日志缺失时仍需复核。

## 验证范围与未覆盖项

实际实现变更时，应记录候选 SHA、环境、所执行命令、结果及未覆盖项；不再保留过期的 PR 拆分记录。

## 必要证据与追溯

未绑定唯一候选的结果不作为当前通过证明；旧命令与流水由Git历史追溯。

当前待办见 [tasks.md](./tasks.md)；实际执行入口见[贡献规范](../../../CONTRIBUTING.md#组件测试与-ci-回归门禁)。清理不关闭未完成项。

## 2026-10-26 PR #1202 整合候选

基线 develop 673ddf8cc69d41632f68832a9079385623af7df1；包含 #1205 的 d5688e33afc299f52849778f06fa8478bf7a0d09 全部提交。相对基线的 git diff --binary --no-ext-diff origin/develop -- tdesign-site SHA-256：e7884d66243819bb703865b8dacd01b5769fe5bbb90988d098f7a94b26cbd710。该指纹涵盖最终站点源码与锁文件，不含本记录及证据。

依赖 @tdesign/theme-generator@1.3.0；Node 24.15.0 / macOS，Flutter 示例预览 3.47.7。npm run test:theme 19/19、npm run test:example-code 28/28（57 页、360 映射、6 份同步输出）及 Vite 生产构建通过；默认 CSS fixtures 未修改。另以本机 Flutter 3.32.0 执行 flutter analyze --fatal-infos，通过且无诊断。

本机浏览器验证：普通 device="mobile" 初始 6px，选择“大圆角”预设后 4px，确认重置后 6px；明暗切换和 Button → Divider → Button 后仍为 6px，Flutter iframe 正常显示。见[结构化观察](./evidence/pr1202-theme-observations.json)。导航见 [Spec 046](../046-Demo-experience/acceptance.md)。

仅为本地桌面浏览器及站点测试证据，未做 uni 官网完整回归、全部 Flutter 官网组件回归、真机或 Golden 验收。远端 CI 需按推送后的最终 head 独立核对。
