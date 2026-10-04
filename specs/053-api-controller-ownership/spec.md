# Controller 所有权与公开 API 完整性

## 背景
全 57 项 API 审查发现 DropdownMenu 共享 Controller 无身份解绑会清除存活菜单绑定，Form 单绑定仅 assert，Popover 重复绑定采用覆盖；生成 57 个文件也不能证明公开配置类型全部有文档。

## 最终契约
- DropdownMenu、Form、Popover Controller 只允许一个同时挂载的目标；重复绑定在 debug/release 均抛 StateError。
- 替换先尝试绑定新控制器，再解绑旧控制器；失败保留实际旧绑定。后续更新按实际绑定比较，卸载清理实际 owner。
- Popover.open 未绑定抛 StateError，close 未绑定无副作用；DropdownMenu 未绑定命令和 Form 未绑定空行为保持原契约。
- Radio.onChanged 是选择请求，包括重选；Checkbox null 是外部聚合半选、点击转 true，用户交互不循环产生 null。不减少这些基础能力。
- BackTop ScrollController 必须单 ScrollPosition；Input 下边线与 Textarea 外框不是同一配置，现名保留。
- 生成清单补齐根入口直接公开导出的组件声明，保持 57 项组件数；不扩大内部类型出口。

## 范围与迁移
修复三个 Controller、补注释和公开文档、增加现有已登记文件的边界回归。重复绑定和 Popover 未绑定 open 的异常契约属于 breaking：多个目标分别创建 Controller，并在 Widget 挂载后 open。无需兼容别名。

## 验收
双版本严格分析零诊断，全部 57 项现有功能测试及覆盖率门槛通过；三 Controller 失败替换/卸载回归，282 项根入口直接声明有 API 章节；示例与调度登记同步。视觉令牌和 Golden 基线不修改，远端 Linux Golden 单独验证。
