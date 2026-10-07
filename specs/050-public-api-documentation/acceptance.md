# 验收记录

## 当前交付状态

组件基础 develop@dacc279e；本地分支 `rss1102/docs/component-api-completeness`。生成器基础 main@86b5cf0；候选提交 `b956df93cc0837fcb1d50516ca32b7cf086f5a17`，独立 [工具 PR #28](https://github.com/TDesignOteam/tdesign-flutter-tools/pull/28)。

以下为最终源码与候选工具的本地验收。消费仓库仍声明正式 `main`，无临时 override / PR 分支依赖。工具 PR 尚未合并；**正式 main 重新解析、全量生成与 `--check` 尚待完成**。本地候选结果不代表正式生成链已完成。

工具 b956df9 的远端 [多平台构建](https://github.com/TDesignOteam/tdesign-flutter-tools/actions/runs/37656523787)（Linux / Windows / macOS Intel / macOS ARM）与 [预览站构建](https://github.com/TDesignOteam/tdesign-flutter-tools/actions/runs/37656523376) 全部通过，PR 已转为可审核状态。

## 全量结果

- 57 个组件（含全局 Theme）、369 个本仓库公开声明；递归导出、part、show/hide 与命名扩展均纳入。
- 补全 238 项声明/字段/枚举/方法注释及 72 项参数注释；修正已发现的默认值、生效条件、引用回退与字体行高说明。
- 缺注释、失效/重复/错误归属、输出类型/成员/构造缺口、空白说明/类型检查均为 0。
- 候选工具重复生成 57 份 API，字节完全一致；资产只来自源码和工具。
- 36 个改动组件源码文件经 analyzer token 对比，与基础代码一致（排除注释及格式化逗号），无签名或行为变动。
- 官方 Flutter 3.32.0 / Dart 3.8.0 与当前官方 stable Flutter 3.47.6@5fc346839b / Dart 3.13.5 均严格 analyze 零问题；文档检查两版本均 0 issue。检查前分别重新 pub get，避免混用 SDK 配置。
- 工具两版本均 45 项测试通过、严格 analyze 零问题。
- `pnpm site` 通过，文档测试 12 项通过（含所有页面路由、共享资产和重复标题）；构建仅有现存体积提示。
- 浏览器逐页打开 API 标签：57/57 页通过；可见公开声明标题共 369，与每页 manifest 数量对应。泛型 `List<TDrawerItem>?` 真实可见，Popup 旧表已去重，Theme 有导航/路由入口。
- 检查器负例试验：干净副本通过；人为制造缺注释、失效/重复/错误归属、导出未登记和空白说明时，全部被识别且退出码为 1。GitHub 与 CNB analyze 均登记该检查。
- 组件契约检查通过：57 个官网入口均有源码、示例注册与 API 资产；现有 Theme 示例页已注册。Demo 结构检查与示例代码 `--check` 通过。
- Flutter 3.32 临时 widget smoke test 实际加载 Drawer / Theme API，确认泛型完整、句柄方法与全局 Theme 文档可渲染且无异常。

## 注释语义与验证边界

新增说明依据实现核对：Theme 空值合并与 Token 回退、Dropdown 受约束/滚动布局与 24px 箭头、Dialog 操作与路由返回值、Form 字段范围与错误清除、Swiper 动画继承、TimeCounter 重置、DateTimePicker partial 值补齐、Indexes sticky 状态、Font 字号和行高换算。TMap 循环引用说明仅描述引用链中止，保留后续默认映射的回退语义。

自动非空检查不证明所有自然语言注释的语义永远正确；上述缺失及已发现错误已按实现修复。每个组件均核对清单、构造/成员覆盖和页面输出，未宣称全量视觉对齐、Golden 或设备验收。无组件行为改动，无 Golden 基线变更。

## 复现与最终门禁

```bash
# 各 Flutter 版本分别执行，先重新解析依赖
cd tdesign-component
flutter pub get
flutter analyze --no-pub --fatal-infos
dart run tool/audit_api_docs.dart

# 工具正式 main 包含 #28 后执行
flutter pub upgrade tdesign_flutter_tools
node tool/generate_api.mjs
node tool/generate_api.mjs --check
dart run tool/audit_api_docs.dart

# 站点
cd ../tdesign-site
pnpm site
```

正式工具合并后的 CI、autofix 最新 head 与产物 diff 另行记录。

## 逐组件记录

下表“通过”指公开声明/构造/成员/注释非空检查及官网可见标题检查；声明包含对应枚举、typedef、Theme、控制器及函数。

| 组件 | 公开声明 | 公开成员/枚举值 | 已声明公开构造 | 清单与源码/输出 | 官网 API |
| --- | ---: | ---: | ---: | --- | --- |
| button | 7 | 30 | 2 | 通过 | 通过 |
| divider | 4 | 16 | 2 | 通过 | 通过 |
| fab | 7 | 31 | 4 | 通过 | 通过 |
| icon | 1 | 4 | 2 | 通过 | 通过 |
| link | 4 | 20 | 2 | 通过 | 通过 |
| text | 4 | 24 | 4 | 通过 | 通过 |
| back-top | 4 | 22 | 2 | 通过 | 通过 |
| drawer | 7 | 30 | 3 | 通过 | 通过 |
| indexes | 10 | 60 | 9 | 通过 | 通过 |
| navbar | 4 | 30 | 4 | 通过 | 通过 |
| side-bar | 4 | 20 | 3 | 通过 | 通过 |
| steps | 5 | 18 | 4 | 通过 | 通过 |
| tab-bar | 11 | 55 | 6 | 通过 | 通过 |
| tabs | 7 | 31 | 5 | 通过 | 通过 |
| calendar | 10 | 48 | 4 | 通过 | 通过 |
| cascader | 4 | 21 | 3 | 通过 | 通过 |
| checkbox | 9 | 44 | 4 | 通过 | 通过 |
| picker | 10 | 18 | 7 | 通过 | 通过 |
| date-time-picker | 8 | 36 | 4 | 通过 | 通过 |
| form | 11 | 61 | 4 | 通过 | 通过 |
| input | 4 | 43 | 2 | 通过 | 通过 |
| radio | 8 | 34 | 5 | 通过 | 通过 |
| rate | 3 | 17 | 2 | 通过 | 通过 |
| search | 4 | 35 | 2 | 通过 | 通过 |
| slider | 5 | 37 | 3 | 通过 | 通过 |
| stepper | 4 | 26 | 2 | 通过 | 通过 |
| switch | 4 | 24 | 2 | 通过 | 通过 |
| textarea | 2 | 28 | 1 | 通过 | 通过 |
| tree-select | 3 | 19 | 3 | 通过 | 通过 |
| upload | 9 | 52 | 3 | 通过 | 通过 |
| avatar | 6 | 28 | 3 | 通过 | 通过 |
| badge | 5 | 36 | 5 | 通过 | 通过 |
| cell | 6 | 40 | 3 | 通过 | 通过 |
| time-counter | 7 | 28 | 2 | 通过 | 通过 |
| collapse | 7 | 35 | 3 | 通过 | 通过 |
| empty | 2 | 6 | 2 | 通过 | 通过 |
| footer | 2 | 4 | 2 | 通过 | 通过 |
| image | 3 | 30 | 2 | 通过 | 通过 |
| image-viewer | 3 | 8 | 1 | 通过 | 通过 |
| progress | 4 | 29 | 7 | 通过 | 通过 |
| result | 3 | 11 | 2 | 通过 | 通过 |
| skeleton | 8 | 28 | 10 | 通过 | 通过 |
| swiper | 8 | 60 | 4 | 通过 | 通过 |
| table | 15 | 56 | 6 | 通过 | 通过 |
| tag | 7 | 46 | 3 | 通过 | 通过 |
| action-sheet | 8 | 29 | 6 | 通过 | 通过 |
| dialog | 5 | 43 | 4 | 通过 | 通过 |
| dropdown-menu | 14 | 77 | 8 | 通过 | 通过 |
| loading | 4 | 15 | 2 | 通过 | 通过 |
| message | 5 | 29 | 3 | 通过 | 通过 |
| notice-bar | 4 | 30 | 2 | 通过 | 通过 |
| popover | 7 | 49 | 2 | 通过 | 通过 |
| popup | 16 | 65 | 14 | 通过 | 通过 |
| pull-down-refresh | 4 | 22 | 3 | 通过 | 通过 |
| swipe-cell | 7 | 24 | 4 | 通过 | 通过 |
| toast | 5 | 28 | 2 | 通过 | 通过 |
| theme | 27 | 343 | 8 | 通过 | 通过 |
