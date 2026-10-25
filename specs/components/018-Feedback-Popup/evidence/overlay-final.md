# Popup 蒙层配置与使用说明验收

## 候选与范围

基线 develop `264fc58206309039bc63216a88153be30d1ef407`，本轮修订父提交 `af7603e3ca3fc5d2f43965d713495e7bd937dbd9`。本次按 1.0.0 → 1.0.1 整理源码迁移和文档，最终提交以 #1199 的 head 为准；此前版本方向与阶段性文案由 Git 历史追溯，不作为当前发布契约。

TPopupOverlayConfig 为 final，onClick 参数及成员改用 onTap，不保留旧名。旧构造调用、成员访问、库外 extends/implements 与相关 mock 需要适配，属于明确的源码 breaking；发布版本目标不改变这一兼容性结论。直接构造、const、配置默认值、蒙层通知时机和关闭条件保持。Drawer 仅迁移内部调用，公开 onOverlayClick 不变。动态 getter 与配置快照可能不等价，不能以新增 getter 或 noSuchMethod 绕过 final。

## 使用契约与文档

Popup 组件 API 页签的 FAQ 集中说明升级风险、onTap 替换和工厂组合；全局 FAQ 移除重复详情。API 注释与生成文档明确 show() 创建并立即显示新会话，无需随后 open()；open() 沿用原句柄配置重开，已展示时不重复打开。对照 v1.0.0 的 t_popup_handle.dart 确认固定 options 是既有行为。更换配置通过 show() 创建新会话，不自动关闭旧会话。

不新增 update()、dispose()、宿主 API 或 maintainState，不修改 TPopupOptions/copyWith、Controller 绑定规则和 Popup 生命周期。destroyOnClose 修复、关闭后 State 保留及最终释放说明继续由 #1197 独立交付，不以本 PR 的说明替代其验收。

组件页校验仅允许生成入口后追加 FAQ；继续禁止复制 API 表、额外演示章节、原始演示面板和重复生成入口。贡献规范同步记录组件 FAQ 的维护来源。

## 当前验证

- Flutter 3.32.0 / 3.47.7 各 313 项通过：Popup、Drawer、5 项包外消费者及字体/回归登记检查。消费者覆盖库外继承/实现、旧 onClick 参数及成员访问被拒绝，以及 const 构造和工厂组合可用。
- 两版完整 flutter analyze --no-pub --fatal-infos 零诊断，各 57 份生成 API --check 通过。
- 站点主题/文档 35 项通过；57 份组件文档映射 360 份生成示例检查通过。新增 FAQ 正反例验证不放开其他页面约束。
- Popup FAQ 已在本地站点 API 页签预览，截图只保留本地 artifacts/pr1199-faq-preview，不进入仓库。

初次完整分析因 Example 未解析依赖失败；低版隔离快照还缺本地 css2token 包。补齐同候选依赖后重跑完整分析通过，没有修改依赖声明或提交平台生成文件。本轮没有重新测量覆盖率，也未运行全包、Golden、真机或 Web release；历史覆盖率结果仅由 Git 历史追溯，不作为当前新增测量。

当前日志位于本地 artifacts/pr1199-faq-preview/final-{high,low}-{tests,analyze,api}.log、final-site-tests.log；候选输入哈希见 final-inputs.json。低版使用独立快照和独立 SDK 配置，源文件与当前候选核对。

## Review

本轮对组件生产源码仅补充 show/open 注释，未改变执行逻辑；旧 onClick 成员风险有新增正式消费者测试。FAQ、API、Spec 和测试对源码风险、配置复用及关闭行为的表述一致。未混入生命周期修复，也未增加配置更新能力。保留草稿，人工兼容性评审及最终 head CI 状态另见 PR，暂不合并。
