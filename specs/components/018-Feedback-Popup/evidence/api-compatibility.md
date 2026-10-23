# 1.0.1 API 兼容迁移验收

- 基线：develop `3704434fd2adfb6988110bc760aaaa52a814581c`（前四组修复已合并）。
- 分支：`rss1102/feat/api-compat-migration-1.0.1`。
- 候选源码：`candidate-source.patch` SHA-256 `bf1e61e464f6195e26971a07359e53305669ef832515bab38ed68460ea95ec7a`，覆盖组件源码、测试、清单、示例与生成产物；不含本验收记录。
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

统一新增推荐入口，不删除旧入口。新旧参数同时提供时新参数优先，未传或传 null 时兼容旧参数；没有新参数时经旧公开 getter 分派，保留子类覆盖。旧参数、getter、类型标明替代名称及 2.0.0 删除计划。旧 const 构造、可调用函数类型、回调时机、默认值、Controller 绑定规则保留。BackTop 不在此次迁移内，其 onPressed 不标记 Deprecated。

`TSteps.selectable` 和 `TTabBarPopUpBtnConfig` 支持二选一回调，因此旧必填参数放宽为可选，旧构造器 tear-off 的显式函数类型继续可赋值。前者使用断言要求提供新旧参数之一；后者保留非空公开回调类型，缺少两者时抛 ArgumentError。这些属于旧代码原本不能合法构造的情况。

本次保持有效旧调用的源码和运行兼容；新增 Deprecated 提示可能使把 info 作为失败的使用方检查报错，应使用说明中的推荐入口。2.0 的删除才需要移除旧调用，本次没有删除或改变回调语义。

## 回归边界

跨组件兼容测试 `test/components/popup/t_api_compatibility_test.dart` 共 55 项，覆盖：旧 getter 继承覆盖、显式新参数优先、旧 const 构造和类型别名、旧必填回调构造器 tear-off、取反参数全组合及工厂/copyWith/normalized、实际回调次数与参数、Steps 纵横布局及受控重选、Checkbox 达限/超限/取消、TabBar 禁用/显式 false/重复选择、Popup 遮罩关闭。

Popup、Drawer、Picker 分别覆盖旧参数真假 × 新参数 null/false/true 的 18 个路由场景：验证实际 maintainState、被不透明路由遮挡时的内容释放、恢复及最终关闭释放。原有组件测试保留旧调用，避免迁移示例后失去旧 API 运行验证。

## 双版本结果

| 检查 | Flutter 3.32.0 / Dart 3.8.0 | Flutter 3.47.7 / Dart 3.13.5 |
| --- | --- | --- |
| 八组件正式功能回归（含 55 项兼容用例） | 904 通过 | 904 通过 |
| 公开示例、API 文档与代码面板 | 129 通过 | 129 通过 |
| 工具自测（含 API、清单与字体覆盖） | 171 通过 | 171 通过 |
| flutter analyze --fatal-infos | 无诊断 | 无诊断 |
| API 生成 --check | 57 份通过 | 57 份通过 |
| 示例片段 --check | 通过 | 通过 |

独立还原目录在相同源码指纹上完成低版本严格分析、57 份 API 同步以及 77 项文档/清单/字体复核，全部通过。两套 SDK 的最终依赖分别冻结，不混用构建缓存。

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

八组件均通过现有 95% 门槛；未调整覆盖率范围或阈值。覆盖率不是手势及生命周期契约的替代证据。

### 验证环境与日志

- 高版本组件：`high-components-final.log`；示例最终有效结果：`high-examples-clean.log`；分析：`high-analyze-final.log`；工具：`high-tooling-final.log`。
- 低版本组件：`low-components-final.log`；示例：`low-examples-final.log`；工具：`low-tooling.log`；独立目录最终复核：`low-final-analyze.log`、`low-final-api-check.log`、`low-final-docs-font.log`。
- 同目录切换 SDK 后的一次高版本示例复验发生 `ink_sparkle.frag` 缓存格式不匹配（2 项失败，见 `high-examples-final.log`）。仅清理该工作树 `example/build` 和 `example/.dart_tool/flutter_build` 后，同一源码与断言 129 项全部通过；该失败不作为通过证据，也不修改组件规避。

### Review 结论

通过本次兼容迁移复核，未发现阻塞问题。逐项确认旧公开 getter/typedef、const 构造、显式函数类型及继承覆盖保留；新参数优先、单次通知和取反映射与 Spec 一致。未混入 BackTop 行为调整、Controller 绑定收紧、旧按钮启用规则修改或主题/布局变更。公开示例使用推荐入口，旧测试继续保护旧入口。


## 范围

本地 macOS Widget/工具测试，不外推 Android/iOS 真机或 Web release。公开布局、主题、资源未变化；内部调试提示更新推荐回调名。不生成或更新 Golden；本地验证结果不代表远端 CI 或合并结论。
