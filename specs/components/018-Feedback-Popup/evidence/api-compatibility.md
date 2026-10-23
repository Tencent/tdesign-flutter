# 1.0.1 API 兼容迁移验收

- 基线：develop `3704434fd2adfb6988110bc760aaaa52a814581c`（前四组修复已合并）。
- 分支：`rss1102/feat/api-compat-migration-1.0.1`。
- 候选源码：`candidate-source.patch` SHA-256 `8ade53449ab1cb58ceda9124979582edd9724d7b56a1f6417522d678d2b9822c`，覆盖组件源码、测试、清单、示例与生成产物；不含本验收记录。
- 原始日志及可还原补丁保存在工作区 `artifacts/pr1148-api-compat/`。正式回归入口为 `tool/component_test_manifest.dart`；跨组件兼容回归登记在 popup 组件。

## 取舍与兼容契约

| 入口 | 推荐 API | 修改依据 |
| --- | --- | --- |
| NoticeBar.onPressed | onTargetTap | 明确通知的是公告区域目标，保留原目标值及手势分流 |
| CheckboxGroup.onMaxSelected | onSelectionLimitExceeded | 表达新增选择被上限阻止，避免误解为刚达到上限 |
| Drawer.onItemClick / TDrawerItemClickCallback | onItemTap / TDrawerItemTapCallback | 统一触摸回调及类型命名 |
| Popover.onLongTap | onLongPress | 与 Flutter 长按手势名称一致；覆盖 Anchor、Widget 与展示函数 |
| PopupOverlayConfig.onClick | onTap | 与 Flutter 点击手势名称一致，关闭策略不变 |
| Steps.onChange | onStepTapped | 表达点击索引而非状态已改变，与 Flutter Stepper 的名称一致 |
| TabBar 菜单 onChanged | onSelected | 表达菜单选择动作，保留重复选择通知 |
| TabBarItemConfig.allowMultipleTaps | notifyOnReselect | 表达重复点击当前项是否通知，不改变整栏 onChanged |
| Popup / Drawer / Picker.destroyOnClose | maintainState | 采用路由的实际语义：遮挡时是否保留状态，与关闭后释放无关；两者取反 |

统一新增推荐入口，不删除旧入口。构造参数及回调的新旧参数同时提供时新参数优先，未传或传 null 时兼容旧参数；没有新参数时经旧公开 getter 分派，保留子类覆盖。旧参数、getter、类型标明替代名称及 2.0.0 删除计划。旧 const 构造、可调用函数类型、回调时机、默认值、Controller 绑定规则保留。BackTop 不在此次迁移内，其 onPressed 不标记 Deprecated。

`TSteps.selectable` 和 `TTabBarPopUpBtnConfig` 支持二选一回调，因此旧必填参数放宽为可选，旧构造器 tear-off 的显式函数类型继续可赋值。前者使用断言要求提供新旧参数之一；后者保留非空公开回调类型，缺少两者时抛 ArgumentError。这些属于旧代码原本不能合法构造的情况。

本次保持有效旧调用的源码和运行兼容；新增 Deprecated 提示可能使把 info 作为失败的使用方检查报错，应使用说明中的推荐入口。2.0 的删除才需要移除旧调用，本次没有删除或改变回调语义。

## 回归边界

跨组件兼容测试 `test/components/popup/t_api_compatibility_test.dart` 共 59 项，覆盖：旧 getter 继承覆盖、显式新参数优先、旧 const 构造和类型别名、旧必填回调构造器 tear-off、取反参数全组合及工厂/copyWith/normalized、实际回调次数与参数、Steps 纵横布局及受控重选、Checkbox 达限/超限/取消、TabBar 禁用/显式 false/重复选择、Popup 遮罩关闭。

Popup、Drawer、Picker 分别覆盖旧参数真假 × 新参数 null/false/true 的 18 个路由场景：验证实际 maintainState、被不透明路由遮挡时的内容释放、恢复及最终关闭释放。原有组件测试保留旧调用，避免迁移示例后失去旧 API 运行验证。

## 双版本结果

| 检查 | Flutter 3.32.0 / Dart 3.8.0 | Flutter 3.47.7 / Dart 3.13.5 |
| --- | --- | --- |
| 八组件正式功能回归（含 59 项兼容用例） | 908 通过 | 908 通过 |
| 公开示例、API 文档与代码面板 | 129 通过 | 129 通过 |
| 工具自测（含 API、清单与字体覆盖） | 172 通过 | 172 通过 |
| flutter analyze --fatal-infos | 无诊断 | 无诊断 |
| API 生成 --check | 57 份通过 | 57 份通过 |
| 示例片段 --check | 通过 | 通过 |

本轮在两个独立工作树使用相同源码指纹完成表中全部检查，依赖分别冻结，不混用构建缓存。

### 生产源码覆盖率

| 组件 | Flutter 3.32.0 LH/LF | Flutter 3.47.7 LH/LF |
| --- | --- | --- |
| checkbox | 364/374 (97.33%) | 363/374 (97.06%) |
| drawer | 286/292 (97.95%) | 286/292 (97.95%) |
| notice_bar | 341/352 (96.88%) | 341/352 (96.88%) |
| picker | 402/412 (97.57%) | 402/412 (97.57%) |
| popover | 649/660 (98.33%) | 649/660 (98.33%) |
| popup | 539/553 (97.47%) | 537/553 (97.11%) |
| steps | 277/279 (99.28%) | 277/279 (99.28%) |
| tab_bar | 659/679 (97.05%) | 659/679 (97.05%) |

八组件均通过现有 95% 门槛；未调整覆盖率范围或阈值。覆盖率不是手势及生命周期契约的替代证据。

### 验证环境与日志

本轮日志位于工作区 `artifacts/pr1148-api-compat/fix-copywith/`：

- 高版本：`high-components.log`、`high-examples.log`、`high-tools.log`、`high-analyze.log`、`high-api-check.log`、`high-snippets.log`。
- 低版本：`low-components.log`、`low-examples.log`、`low-tools.log`、`low-analyze.log`、`low-api-check.log`、`low-snippets.log`。
- 两套环境均为组件 908 项、示例 129 项、工具 172 项通过，严格分析无诊断，57 份 API 及示例片段同步检查退出码为 0。
- `high/low-coverage/` 与锁文件保留覆盖率和依赖证据。先前候选日志仅供历史追溯，不作为本轮通过依据。

### copyWith 复核修复

旧候选向可覆盖的 `copyWith` 增加 `maintainState` 参数，导致完整旧签名的子类出现 invalid_override；已恢复旧签名。独立入口 `copyWithMaintainState(bool)` 通过原 `copyWith(destroyOnClose: !maintainState)` 虚分派，保留旧子类复制定制，不改变原对象或 Controller 绑定。

正式兼容测试增加 4 项（共 59 项）：完整旧签名覆盖可编译运行、独立入口只调用旧覆盖一次并取反传参、其他配置与原对象保留、真假状态及 normalized。原有旧参数 null/真假和构造新旧优先级矩阵继续保留。工具测试增加生成文档迁移说明、方法分离及必填 bool 检查。

中文迁移：非空 `oldValue` 的 `options.copyWith(destroyOnClose: oldValue)` 可改为 `options.copyWithMaintainState(!oldValue)`；原来不传或传 null 的调用继续使用 `copyWith()`，保留当前有效值。旧参数计划在 2.0.0 删除。构造配置仍使用 `maintainState`，不向旧 copyWith 增加同名参数。

站点预览确认旧参数行显示取反关系、独立替代入口和 2.0.0 计划，新方法单列必填 bool 与子类覆盖说明。截图见本轮日志目录的 `popup-copywith-migration.png`、`popup-independent-copy.png`。仅验证 API 文档展示，不作为 Flutter 示例运行证据。

### Review 结论

本轮修复后重新复核，前述方法覆盖与迁移文档问题均闭环，未发现新的阻塞问题。逐项确认旧公开 getter/typedef、const 构造、显式函数类型及继承覆盖保留；新参数优先、单次通知和取反映射与 Spec 一致。未混入 BackTop 行为调整、Controller 绑定收紧、旧按钮启用规则修改或主题/布局变更。公开示例使用推荐入口，旧测试继续保护旧入口。


## 范围

本地 macOS Widget/工具测试，不外推 Android/iOS 真机或 Web release。公开布局、主题、资源未变化；内部调试提示更新推荐回调名。不生成或更新 Golden；本地验证结果不代表远端 CI 或合并结论。

## Steps / Drawer 中文注释复核

本轮以 `87182fcac4d5a31bcc539e517ca05a9df6fd6e90` 为基线，仅调整 Steps / Drawer 的 dartdoc 及对应生成 API。四个文件的文档补丁 SHA-256：`0adee157fecb71c225057af2338dc4d8d75ba724824e7880b4dc9e6d8e7e48d4`；补丁和日志位于工作区 `artifacts/pr1148-api-compat/docs-steps-drawer/`。上文组件实现验证及源码指纹属于前一实现候选，不将本轮文档检查写成重新执行组件交互或 Golden。

- progress 明确新回调非空时优先，否则沿用旧 onChange；两者均为空才只读。保留点击当前步骤、值由调用方更新和回调不改变指示器视觉的说明。
- selectable 参数说明只保留本构造器的点击索引、当前步骤通知、受控更新、至少提供一个回调及优先级；原有点状指示器和节点视觉说明保留。
- Drawer 补齐点击回调说明的句号。两处生产文件的 Dart 可执行 token 与基线逐项一致，API 签名、默认行为和 Controller 绑定规则未变。

Flutter 3.32.0 / 3.47.7 的 172 项工具测试（含字体覆盖）和 70 项 API 文档渲染测试均通过。随后将已弃用 onChange 的 dartdoc 链接改为代码标记，生成 Markdown 保持一致；在最终源码上再次完成 57 份 API 同步、字体覆盖和严格分析，两套 SDK 均通过且无诊断。低版本首次分析对文档链接报出的 2 条弃用提示保留在 `low-analyze-before-link-fix.log`，不作为最终通过证据。

最终复核确认生成参数表保留全部关键契约，selectable 不再混入其他构造器说明；未发现新的文档或实现问题。本轮未修改测试、字体、视觉、运行逻辑或 Controller。

## 旧入口废弃说明统一

以 `ce957a12c3e7832edca87b917b2b3de8bea4b835` 为基线，18 处旧 API 源注释统一为“已废弃，此为兼容入口。请使用对应替代 API；将在 2.0.0 删除。”取反迁移及 copyWith 的非空旧值、null 保留语义继续说明；8 份生成 API 同步。13 个生产 Dart 文件的可执行 token 与基线逐项一致，未改签名、默认行为或 Controller 绑定。

现有共享测试字体缺少“废”，本轮仅补齐该字及清单，沿用已有 Noto Sans SC 2.004 来源、HarfBuzz 11.4.5 和 fonttools 4.59.1。原有 1181 个 cmap 字符的轮廓及 hint 程序、横纵度量、全局度量均一致；10220 行不含新增字的既有源码文本在 HarfBuzz 下的字形程序、位置和 advance 均一致。不更新 Golden 基线，字体不进入产品产物；Linux Golden 仍以本次提交的远端 CI 结果为准。

两套独立 SDK（Flutter 3.32.0 / 3.47.7）各通过 172 项工具测试（含字体覆盖）、70 项 API 文档渲染、57 份 API 同步检查和严格分析。文档及字体补丁 SHA-256：`01f963f0ad5fdeeec5afb7c4e8f892e909b8337b21ab857b1b66049a718f333b`。补丁、字体对比与原始日志位于工作区 `artifacts/pr1148-api-compat/docs-deprecation-wording/`。原有实现功能回归按前述实现候选追溯，不写成本轮重跑结果。

复核确认废弃状态、替代入口与 2.0.0 删除计划明确，特殊迁移说明保留，运行实现未改；本地文档 Review 通过，未合并。
