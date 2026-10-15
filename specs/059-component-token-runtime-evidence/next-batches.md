> 历史快照：本文对应Ghost修复前的Spec059指纹与比较目标。最新32项处置、修复后验证及未实施方案见 [Spec060](../060-token-difference-resolution/acceptance.md)。原始观察和机器数据保留，不用旧日志验证新源码。

# 后续处置顺序与边界

## 先处理31项已复现差异

这些是变量级比较差异，不自动等同于31个独立缺陷。保留现有已批准例外；相同默认值但动态回退不同的情况，须先对照当前公开契约和单一所有者规则裁定。

| 批次 | 变量数 | 当前事实 | 操作与完成条件 |
|---|---:|---|---|
| Switch颜色/几何 | 11 | 关闭标签颜色为textColorDisabled；大/小轨道宽、滑块和图标实际经过统一FittedBox缩放，与冻结尺寸存在差异 | 核对thumbContentOffColor的已公开默认契约；若按冻结目标更改须同步dartdoc。几何不能只改外层SizedBox，需让Painter轨道、滑块和内容共同使用最终规格；保留真实拖动/禁用/加载行为，双SDK及Linux受影响Golden复验。 |
| Button状态/回退 | 11 | 默认/浅色填充按压背景、危险禁用前景、幽灵按压前景及部分Token别名路径与冻结目标不同 | 先分析Material状态层叠加后的实际像素，保留已批准的primary深色禁用文字。对直接背景/前景及errorColor3与errorColorDisabled的独立覆盖逐项裁定，再调整唯一解析入口，保留实例ButtonStyle状态覆盖。 |
| Avatar默认/字号 | 5 | 组描边使用bgColorContainer，冻结源码为白色；四项字号在自定义全局字体指标后仍保持尺寸预设常量 | 查证AvatarGroup深色设计依据；核对已批准的“按size内置字号”契约，决定是否应跟随全局字体指标。不能为追同名变量恢复已删除textStyle入口或新增平行Theme字段。 |
| Input边框/间距 | 2 | 启用边框用componentBorder，冻结目标为componentStroke；独立输入padding固定16，未跟随spacer2 | 核对TInputThemeData的已公开固定padding/状态边框契约及FormItem组合；若改变默认或回退，记录行为迁移并保留组件Theme覆盖。 |
| Empty间距 | 2 | 图标模式描述间距22，冻结目标16；操作间距固定32，未跟随spacer4 | 核对图标/图片两分支的设计及动态间距承诺；分别验证真实描述/操作间距、长文案和字号缩放，避免用整页外边距补偿。 |

根因文件分别位于tdesign-component/lib/src/components/switch、button、avatar、input、empty；实际值、比较目标、场景和源码入口见runtime-review.json及runtime-observations.json。当前只新增诊断/契约测试，没有偷偷把上述行为改成未经裁定的新值。

## 单独处理平台几何

buttonBorderWidth的冻结Less为4rpx，Flutter outline/ghost为1dp。必须取得WeChat原生button伪元素的有效几何或设计证据，不能由4rpx直接断言Flutter应改为2dp，也不能只因既有1dp测试通过就关闭此项。

## 继续补524项运行证据

先完成已审组件的剩余槽位，再扩大到常用组件，按同一原则分批：

1. Button剩19项：fill边框与填充的等效绘制证据、纯图标圆角，以及6项dashed变量。当前TButtonVariant没有dashed，须有能力/迁移范围裁定，不能拿outline替代验证。
2. Input剩12项：对齐、分隔线左右偏移、Label、Tips和后置文本。先追到TFormItem+TInput真实组合并明确内容所有者；不为名称对应新增便捷API。
3. Switch剩3项与Avatar剩1项：滑块两类水平边距、阴影和头像margin，补实际Painter/布局证据；不能从外框尺寸推算最终消费已完成。
4. Cell/CellGroup、Checkbox/Radio、Slider、Search：分别覆盖交互/禁用状态、浅暗色以及既有Theme与实例路径；复用台账所列的现有测试候选，经实际断言核对后才晋级。
5. StepItem/Steps、Tabs、Cascader及其余组件按runtime-review.md逐组件分布推进；弹层/滚动/日期场景使用真实操作触发可见状态。相关最终像素仅在Linux3.32执行Golden；IME、系统权限和GPU路径按真机验收表处理。

524项中190项已有同组件测试中的getter引用候选，runtime-review.json逐条列出文件行号。候选匹配没有证明状态/绘制断言正确，不自动减去这190项。其余项已有冻结CSS选择器/属性、目标值及当前Flutter定位或缺失说明，可据此补场景。

## 每批关闭条件

记录目标来源→实际消费→默认状态→适用的Token/Theme/实例覆盖→双SDK结果→源码/资源/依赖摘要；处理真实差异或取得有依据的契约裁定。默认运行与最终视觉分别记账。没有对应Flutter能力的项必须明确作范围裁定，不能静默延期；最终验收仍不满足时，--require-complete保持失败。
