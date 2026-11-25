# 048-Theme-configuration-contracts 未完成事项

<a id="source-048"></a>
<a id="source-051"></a>
<a id="source-055"></a>
<a id="source-078"></a>
<a id="source-053"></a>
<a id="source-054"></a>
<a id="source-047"></a>
<a id="source-059"></a>
<a id="source-060"></a>
<a id="source-077"></a>
<a id="source-079"></a>

## 原记录明确未关闭

- [ ] 后续实现或发布候选变更时，按 spec.md 重新核对受影响契约与验证结果。
- [ ] 审查尚未裁定的异名同义入口和实际消费链，逐项确定唯一所有者、迁移路径及 breaking 风险。
- [ ] 复核所有组件的 Token 动态回退和公开覆盖路径，不能将已处理组件外推为全仓完成。
- [ ] 完成适用的设计、跨端像素、全部状态和真机字体/交互验收；历史 Golden 通过不替代这些项目。

## 当前候选复核

- [ ] 后续实际交付前，将验收标准绑定最终候选 SHA、SDK 与相关环境，核对受影响结果；文字槽范围及已有候选结果见 acceptance.md，其他 Token 运行、设计与设备范围仍须单独复核。

已完成的开发步骤和旧 PR 创建过程已清理。原记录的远端 CI/Review 或设备连接状态不作为当前事实；相关事项需以实际证据核对，不能随文档整理关闭。

## Token 逐项缺口

以下编号和数量属于冻结证据范围，尚未针对当前候选重判。原始观察不等于当前缺陷；差异后续处置见 [处置报告](./evidence/differences/solutions.md)。

### 047-miniprogram-token-alignment

- [ ] DOING 核对组件变量的真实消费链，按需要开放 Theme 字段，不机械暴露全部变量；BackTop、Indexes、TabBar 的圆角来源已核实并修正，TabBar 胶囊阴影改用小程序的 `shadow-3`；Tag 四种语义色的深浅色回退链已补运行时测试。
- [ ] TODO 固定设计与 Flutter 的实际字体后，直接核对 Tag 文字排版宽度；确认组件是否应显式解析全局字体族，再判定 38px 设计实例的剩余宽差。不通过增大 Padding 或固定宽度凑单个文案。
- [ ] TODO 继续逐组件核实 Flutter 的最终消费值与必要的 Theme 覆盖；804 项默认值提取与静态映射不是逐项运行验证。历史静态候选包含 2 个回退冲突、1 个未解析暗色值、3 个无回退变量；须按当前源码重判，不能直接列为当前已复现缺陷。
- [ ] TODO 对需设计稿裁定的歧义进行后续比对。

### 059-component-token-runtime-evidence

- [ ] 复核原 31 项运行差异和 1 项平台几何的后续处置：8 项已有契约、2 项修复、21 项待实施、1 项待平台取证；补齐适用视觉验证，不将原始差异数当作当前缺陷数。
- [ ] 按 [补证顺序](#token-evidence-order) 继续补524项运行证据，190项已有静态测试候选但不能据此关闭。
- [ ] 完成适用的公开覆盖路径、完整状态、Linux Golden/设计和真机审查，之后才能关闭最终消费任务。

### 060-token-difference-resolution

- [ ] 取得适用设计/平台裁定并实施21项候选方案，执行Linux视觉验证；其余524项继续逐批补核。

### 077-all-component-web-theme-consumption

- [ ] 取得未读取的 7 页 Figma 及缺失绑定，裁定剩余规范冲突。
- [ ] 对最终候选执行 Flutter 3.32.0 Linux Golden，审阅既有失败、受影响场景与新 head 远端 CI；本次 macOS 文档整理不执行、不更新基线。

<a id="token-evidence-order"></a>

## Token 补证顺序

先完成已审组件的剩余槽位，再扩大到常用组件，按同一原则分批：

1. Button剩19项：fill边框与填充的等效绘制证据、纯图标圆角，以及6项dashed变量。当前TButtonVariant没有dashed，须有能力/迁移范围裁定，不能拿outline替代验证。
2. Input剩12项：对齐、分隔线左右偏移、Label、Tips和后置文本。先追到TFormItem+TInput真实组合并明确内容所有者；不为名称对应新增便捷API。
3. Switch剩3项与Avatar剩1项：滑块两类水平边距、阴影和头像margin，补实际Painter/布局证据；不能从外框尺寸推算最终消费已完成。
4. Cell/CellGroup、Checkbox/Radio、Slider、Search：分别覆盖交互/禁用状态、浅暗色以及既有Theme与实例路径；复用台账所列的现有测试候选，经实际断言核对后才晋级。
5. StepItem/Steps、Tabs、Cascader及其余组件按[运行报告](./evidence/runtime/runtime-review.md)逐组件分布推进；弹层/滚动/日期场景使用真实操作触发可见状态。相关最终像素仅在Linux3.32执行Golden；IME、系统权限和GPU路径按真机验收表处理。

524项中190项已有同组件测试中的getter引用候选，[逐项台账](./evidence/runtime/runtime-review.json)逐条列出文件行号。候选匹配没有证明状态/绘制断言正确，不自动减去这190项。其余项已有冻结CSS选择器/属性、目标值及当前Flutter定位或缺失说明，可据此补场景。

## 每批关闭条件

记录目标来源→实际消费→默认状态→适用的Token/Theme/实例覆盖→双SDK结果→源码/资源/依赖摘要；处理真实差异或取得有依据的契约裁定。默认运行与最终视觉分别记账。没有对应Flutter能力的项必须明确作范围裁定，不能静默延期；最终证据仍不完整时保持未完成，不以移除专项工具关闭任务。

## 文字槽交付

- [x] #1182 / #1184 按已确认的 patch 策略分别交付；#1182 已进入 develop，#1184 `6a3075946` 合并 develop 后验收完成，最终 CI 30项成功、1项条件跳过。范围和风险见 spec，结果见 acceptance。
- [x] Popover 自定义菜单明暗两张基线经审阅授权更新，已无更新复验；其余已有基线保留。

## 文字槽 Review 收口

- [x] 新增 TabBar 自定义菜单长文案、混合等高及滚动前后明暗 Golden，并确认登记入口实际执行。
- [x] 提取 Picker/Steps/TabBar 重复 helper，保留原有场景和断言并做双版本回归。
- [x] 收敛过期交付限制和重复验收流水，保留范围、关键取舍、最终候选和真实未完成事项。
- [x] 完成双版本功能/严格分析与 Linux 3.32 Golden 验证，核对所有已有 PNG 哈希不变。
- [ ] 核对 Review 收口交付后最终 head 的远端 CI，不外推此前提交的通过结果。


## Drawer / TabBar 旧 implements 兼容

- [x] 内部解析私有化，恢复原类接口，保留 Token/插值/copyWith 行为。
- [x] 登记历史接口包外编译、组件渲染、双向/中断动画和内部导出边界回归。
- [x] 双 SDK 门禁、源码/文档一致性、独立本地提交及最终 Review；本地验收阶段未推送或创建 PR。
