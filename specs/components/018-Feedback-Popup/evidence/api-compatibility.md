# 1.0.1 API 兼容迁移验收

- 基线：develop `3704434fd2adfb6988110bc760aaaa52a814581c`；本轮修改基于 #1196 远端提交 `311f04de4cdd0fab1d5d444904451e408ff9ed3e`。
- 分支：`rss1102/feat/api-compat-migration-1.0.1`。
- 本地候选：`copywith-unified/candidate-source.patch` SHA-256 `fc618ff9a020da8094ae6c723eb1982ca722da87606f5d17cc63e2f1eda4ac4b`，包含基线以来组件源码、测试、生成产物及本轮 FAQ；不含本验收记录。
- 原始日志、依赖锁文件、覆盖率和 PR 说明草稿位于工作区 `artifacts/pr1148-api-compat/copywith-unified/`。
- 本轮仅本地验证及 Review；按用户要求不推送、不更新远端 PR、不合并。远端 CI 不作为本地新候选的通过证据。

## API 取舍

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

普通旧调用、旧 const 构造、旧 getter 覆盖、回调时机、默认行为和 Controller 绑定规则保留。新参数非空时优先，未传或 null 时兼容旧入口。旧入口继续标明替代名称及 2.0.0 删除计划。弃用提示可能影响将 info 视为失败的检查。

**继承源码的破坏性变化：** `TPopupOptions.copyWith` 新增可选参数 `bool? maintainState`，覆盖或实现该方法的业务类必须在原签名中增加此参数并正确处理或转发。普通旧调用以及没有重写 copyWith 的继承无需修改；不能把这次变化描述为全部旧覆盖无须适配。FAQ 明确绑定 1.0.0 → 1.0.1，更新日志草稿使用 breaking 条目。

`copyWith` 的规则为：maintainState 非空时优先（包含 false）；否则取非空 destroyOnClose 的反值；两者均为空时保留当前有效状态，包含旧 destroyOnClose getter 覆盖。支持一次复制同时修改状态和其他字段，原对象不变。旧参数计划在 2.0.0 删除。

此前独立方法方案保留旧覆盖签名，但增加重复入口及未来迁移成本；本轮按用户确定的方案移除未发布的 copyWithMaintainState。旧方案和文档修正过程由 Git 历史及 `fix-copywith/`、`docs-steps-drawer/`、`docs-deprecation-wording/` 追溯，不作为当前签名兼容结论。

## 正式回归

跨组件兼容回归登记在 popup 清单，`t_api_compatibility_test.dart` 共 83 项。保留旧 getter、const 构造、类型别名、旧构造器显式函数类型、实际回调次数与参数、受控状态、禁用与重复选择等原边界。

本轮增加 24 项：18 项当前状态真假 × 新旧 nullable 参数矩阵，以及 6 项复制配置后的真实路由场景。原有独立复制测试改为原 copyWith 新参数；适配后的子类验证 8 次虚调用的新旧参数转发及原有复制定制。其他字段、原对象不变、normalized 和旧 getter 覆盖继续保护。

Popup、Drawer、Picker 原有 18 个路由场景保留，连同新增 6 个 copyWith 场景，共 24 项验证路由 maintainState、被不透明路由遮挡时释放、恢复及最终关闭释放。

生成文档测试校验新参数 bool?、可选性、默认 null 的语义、优先级、取反迁移及独立方法移除。FAQ 与生成 API、Spec 和 PR 说明草稿的风险表述一致。

## 双版本验证

| 检查 | Flutter 3.32.0 / Dart 3.8.0 | Flutter 3.47.7 / Dart 3.13.5 |
| --- | --- | --- |
| 八组件正式功能回归（含 83 项兼容用例） | 932 通过 | 932 通过 |
| 公开示例、API 文档与代码面板 | 129 通过 | 129 通过 |
| 工具测试（含 API、清单与字体覆盖） | 172 通过 | 172 通过 |
| flutter analyze --fatal-infos | 无诊断 | 无诊断 |
| API 生成 --check | 57 份通过 | 57 份通过 |
| 示例片段 --check | 通过 | 通过 |
| 包外旧覆盖消费者 | 预期 invalid_override | 预期 invalid_override |

两套独立目录使用相同源码补丁指纹及各自依赖、缓存；未混用 SDK 构建产物。包外消费者用于确认已说明的迁移风险，预期诊断不表示项目分析或回归失败。适配后的覆盖由正式组件测试编译、运行。

### 生产源码覆盖率

| 组件 | Flutter 3.32.0 LH/LF | Flutter 3.47.7 LH/LF |
| --- | --- | --- |
| checkbox | 364/374 (97.33%) | 363/374 (97.06%) |
| drawer | 286/292 (97.95%) | 286/292 (97.95%) |
| notice_bar | 341/352 (96.88%) | 341/352 (96.88%) |
| picker | 402/412 (97.57%) | 402/412 (97.57%) |
| popover | 649/660 (98.33%) | 649/660 (98.33%) |
| popup | 537/551 (97.46%) | 535/551 (97.10%) |
| steps | 277/279 (99.28%) | 277/279 (99.28%) |
| tab_bar | 659/679 (97.05%) | 659/679 (97.05%) |

沿用现有生产范围与 95% 门槛，未调整阈值。原始输出见 high/low-components.log，LCOV 见 high/low-coverage/。

### FAQ 与站点

独立临时站点目录使用当前 FAQ、生成 API 和已安装依赖，26 项文档单测、57 个组件文档 / 360 个示例映射检查及生产构建均通过。最初临时目录缺少 scripts/documentation.mjs 的一次设置失败保留在 site-tests.log；补齐仓库原有脚本后，最终结果为 site-tests-final.log / site-build.log，未修改项目规避。

### 日志

high/low-analyze.log、high/low-components.log、high/low-examples.log、high/low-tools.log、high/low-api-check.log、high/low-snippets.log 为本轮最终结果。high/low-legacy-override-risk.log 为预期旧消费者诊断。站点为 site-tests-final.log、site-docs.log、site-build.log。PR_BODY_DRAFT.md / PR_TITLE_DRAFT.txt 仅本地草稿。

## 本地 Review 与范围

按最终源码重新核对，统一参数优先级、null 回退、旧普通调用及 getter 覆盖、复制其他字段、生命周期和适配后子类转发符合当前 Spec。独立方法已从生产代码和生成 API 移除，旧方法覆盖不兼容已在 API、FAQ、Spec 及 breaking 日志草稿明确，没有用 FAQ 声称消除风险。未发现新的阻塞问题。

本轮为 macOS Widget/工具验证及站点构建，不外推 Android/iOS 真机或 Web release。未改主题、布局、字体、Golden 基线或 Controller 绑定。未执行 Linux Golden 或新候选远端 CI，未推送、更新远端 PR 或合并。
