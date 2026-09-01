# TreeSelect 公开 Demo 对齐

## 目标

对齐小程序公开 Demo 的基础、多选与三列场景，并建立独立行为与视觉回归。

## API Review

- `TTreeSelectOption` 以不可变递归节点表达任意深度，不增加小程序 keys 映射层。
- `value` 使用根到叶的完整路径列表；单选和多选共享同一稳定值类型，`multiple` 只改变选择数量。
- `value + onChanged` 为严格受控模式，空 callback 表达禁用，不引入 `defaultValue`。
- 三列是数据深度产生的布局结果，不增加列数参数；生产组件源码不变且无 breaking change。

## 行为契约

- Demo 顺序与公开页面一致。
- 基础与多选使用二级树；三列场景使用三级树并展示完整路径。
- 所有实例均由页面持有状态。
