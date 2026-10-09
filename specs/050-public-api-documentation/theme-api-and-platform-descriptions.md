# Theme API 职责与平台描述核查（2026-10-09）

初始核查描述收敛前的 API；当前收敛结果已单独提交 PR #1152，见文末同步记录。

## 收敛前的 Theme API 判断

Theme 页当前收录 27 个声明，不等同于 TThemeData 自身提供 27 个功能。TThemeData 自身有 12 个公开方法：

| 方法 | 当前职责 | 收敛判断 |
| --- | --- | --- |
| defaultData | 缓存并返回全局默认 Token | 保留；无上下文读取有实际用途 |
| fromJson / parseThemeData | JSON 字符串解析与解码后配置读取 | 两层职责；parseThemeData 可作为未来兼容迁移候选，不直接删除 |
| copyWith / lerp | Flutter ThemeExtension 契约 | 必须保留契约；lerp 当前忽略进度且不保留 extraThemeData，是另一个实现议题 |
| copyWithTThemeData | 转发 copyWith，并返回具体 TThemeData | 主要冗余；copyWith 可未来收窄返回类型到 TThemeData，再按公开 API 兼容策略逐步弃用包装入口 |
| ofColor / ofFont / ofCorner / ofFontFamily / ofShadow | 动态键读取对应 Token Map | 薄封装；已知 Token 推荐命名 getter，动态键场景仍有用途 |
| ofExtra | 泛型读取业务扩展数据并处理类型不匹配 | 独立用途，保留 |

TThemeBuilder 的 light/dark 是接入入口，内部委托 TMaterialThemeBuilder；后者负责 Material ThemeData 的具体构建，并非两套不同算法。TStyleResolver 处理组件 Theme 和 Token 的读取，不负责构建。资源委托、TMap、字体类型及平台/工具栏辅助类型也在同页，导致页面承担过多职责；未来适合按主题接入、Token 查询、构建与解析、资源/辅助类型分组展示。公开能力不能仅为缩短文档而删除或隐藏。

本轮新增“按使用场景选择入口”说明，并纠正 copyWithTThemeData 的“从父类拷贝”描述。未实施 API 重构、删除或弃用。

## 平台描述清理

完整文本检索覆盖 git 跟踪文件和未忽略的新文件，中文“小程序”、英文 mini-program/miniprogram 及 weapp；不将构建缓存或二进制资产当作文档源。逐项清单见 platform-description-inventory.json。

- 组件库公开 dartdoc、内部行为注释及 57 页生成 API 不再描述小程序迁移来源。
- Token 文档直接说明 Flutter 逻辑像素、默认值、字体解析、阴影边线与回退，移除 CSS/rpx 对照表达。
- 下拉刷新 Demo 的两处可见说明改为真实功能描述，相关页面契约同步；Input 生成示例片段同步。
- 既有测试名称改为描述 Flutter 行为，不改断言、输入和预期；官网 custom-theme 说明改为主题注入方式。
- 保留历史 Spec、来源审计脚本及协作约定中的参考证据；保留 README 生态仓库列表、Search 示例项目名/对应测试，以及未引用的官网案例数据中的真实仓库与资产地址。这些记录并不声明 Flutter 使用方式依赖该平台。官网共用页脚还有 MiniProgram 生态入口。

## 验收与边界

公开 API 与组件源码注释检索零命中；Theme 本地浏览器已确认新入口说明出现，中文平台引用消失。115 个生产 Dart 文件非注释 token 与当前 HEAD 一致，不改公开签名、默认值和运行实现；本轮 Demo 只调整说明文字。

最终验证：latest 文档专项 124 项通过；最终两版全页展示各 57 项通过，刷新 Demo 两版各 5 项通过；两版严格 analyze 无问题，独立 AST 369 声明、0 issue。最终四份变化文档以两 SDK 重新生成，另外 53 份与上一轮生成快照相同，最终 57 页字节一致。候选工具最终 --check 检查 57 页通过。示例代码生成同步 Input 片段及 manifest；latest Web 构建成功。本地官网已实际显示新的 Theme 入口说明及两处刷新功能说明。

本轮日志：/tmp/tdesign-platform-doc-tests-latest.log、/tmp/tdesign-platform-presentation-final-latest.log、/tmp/tdesign-platform-presentation-332.log、/tmp/tdesign-platform-refresh-demo-{latest,332}.log、/tmp/tdesign-platform-analyze-{latest,332}.log、/tmp/tdesign-platform-api-audit.json、/tmp/tdesign-platform-generate-332.log、/tmp/tdesign-platform-doc-check-final.log、/tmp/tdesign-platform-web-build.log。消费仓库仍用正式工具 ref: main，本轮生成和 --check 使用本地候选工具；正式工具交付/远端 CI/autofix 状态不据本地结果推定。全部修改仍为本地未提交状态。

## API PR 后的文档同步

独立 API PR：https://github.com/Tencent/tdesign-flutter/pull/1152 ，初始提交 b1ab91f4。按维护者明确的 1.0 无兼容要求，公开操作从 12 个减少到 5 个：defaultData、fromJson、copyWith、lerp、ofExtra；删除复制包装和五个 Map 查询包装，解码解析收私有，间距复制参数改为 spacerMap。copyWith 保留原名称，两个 Flutter 操作返回具体 TThemeData。

文档工作区已按新契约同步调用、源码文档和全部 57 页生成资产。Theme 指南不再推荐被删除的入口，动态查询直接使用相应 Token Map。TThemeData 的实现与独立 API PR 一致（只存在文档与可选尾逗号格式差异）；公开 API 与生成说明无平台迁移引用。该同步仍为本地修改，API PR 尚未合并，后续文档提交需以该 API 契约为基线。

本地同步验收：57 页生成完成；全部展示与 Theme 功能测试共 87 项通过，独立 AST 369 声明、0 issue，严格 analyze 无问题。源码契约核对只存在文档与尾逗号格式差异。

维护者补充：上一个对外版本为 0.2.7，1.0 文档只描述最终公开契约，不为本次未发布的内部 API 演变编写迁移指南，不额外增加职责区分章节。已移除过渡入口说明；Spec 中的前后对照仅作为内部实施证据。

## TThemeData 最终插值契约同步

公开操作收敛为 defaultData/fromJson/copyWith/lerp 四项；ofExtra 已移除。lerp 对有效 Token 连续插值，保留引用与回退，业务扩展按中点切换。文档工作区同步源码与生成 API，57 项呈现测试通过；双版组件回归各 2736 项、生产覆盖率 97.99% 见独立 PR #1152 的 Spec 验收。此处不添加公开迁移章节。
