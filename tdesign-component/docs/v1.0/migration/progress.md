# v1.0 迁移进展

> 本文件记录分批迁移到 `tdesign-flutter` 主仓的阶段状态。状态仅表示当前 v1 仓库内准备程度，不等同于主仓 PR 已合入。

## 状态说明

| 状态 | 含义 |
| --- | --- |
| Not Started | 尚未进入迁移准备 |
| In Progress | 已开始实现或验收，但仍有待修复项 |
| Ready for PR | v1 仓库内已具备提交主仓 PR 的基本条件 |
| In PR | 已提交主仓 PR，等待 review |
| Merged | 已合入主仓 |
| Blocked | 被外部依赖或未解决争议阻塞 |

## 阶段进展

| 阶段 | 范围 | 当前状态 | 最近验证 / 备注 |
| --- | --- | --- | --- |
| PR 0 | 重构基础设施、验收约束、迁移说明 | Ready for PR | 本目录已新增迁移方案；仍需按主仓 CI 情况确认最终脚本入口 |
| PR 1 | Foundation / Theme / Token | Ready for PR | `TThemeBuilder.light/dark` 已接入 M3 `ThemeData`、Material 子主题、全局组件 `ThemeExtension`；已通过专用 ThemeData barrel 隔离包总出口依赖；定向测试和 analyze 已通过 |
| PR 2 | `text` / `divider` / `icon` | Ready for PR | 已纳入 01-base 定向测试和 analyze；仍建议在提交前复跑单组件 docs validate |
| PR 3 | `button` / `link` | Ready for PR | 已纳入 01-base 定向测试和 analyze；`button` 单文件覆盖率仍低于 95%，但 01-base 总覆盖率已达标 |
| PR 4 | `fab` | Ready for PR | FAB 定向测试 68 个通过；FAB analyze 0 issues；tools FAB validate `ERROR=0, WARN=0` |
| PR 5 | Overlay / Popup 基础设施 | Ready for PR | Popup 路由、Options、Handle、布局和安全区测试已覆盖；必须先于依赖 Popup 的 Drawer 迁移 |
| PR 6 | 03-input / Form 基础能力 | Ready for PR | 当前组件域测试通过；全量套件中的源码覆盖率 98.63%，DateTimePicker 根组件、快照和 Radio Theme 已补契约测试 |
| PR 7 | Feedback 业务组件 | Ready for PR | 05-feedback 定向 302 项测试通过、隔离覆盖率 95.28%；全量套件覆盖率 97.75%，Popover Theme 与强类型回调已闭环 |
| PR 8 | Display / Navigation 中低风险组件 | Ready for PR | 02-navigation 最近定向测试 326 个通过、analyze 0 issues、覆盖率 97.96%；04-display 最近定向测试 350 个通过、analyze 0 issues、覆盖率 99.05%；Drawer 必须在 PR 5 后迁移 |
| PR 9+ | picker/date-picker/dropdown/table/upload 等复杂组件 | Ready for component PR | 复杂组件链路最近定向测试 171 个通过、analyze 0 issues、覆盖率 95.50%；已补 `TDropdownItem.operateHeight` API 注释；迁移主仓时仍按单组件或依赖链拆分 |
| Final PR | export、索引、CI、全量验收收口 | Not Started | 等主要组件迁移完成后执行 |

## 当前类别验收快照

最近一次 v1 仓库验证结果：

| 验收项 | 结果 |
| --- | --- |
| FAB 定向测试 | 通过，68 个测试 |
| FAB 定向 analyze | 0 issues |
| Foundation / Theme 定向测试 | 通过 |
| Foundation / Theme 定向 analyze | 0 issues |
| Foundation PR 边界 | `TThemeBuilder` 不反向依赖 `tdesign_flutter.dart` 总出口；当前组件 ThemeData 默认定义均已注入 |
| 01-base 定向测试 + coverage | 通过 |
| 01-base 源码总覆盖率 | 98.21% (932/949) |
| 01-base 定向 analyze | 0 issues |
| FAB tools validate | `ERROR=0, WARN=0` |
| 02-navigation 定向测试 | 326 个测试通过 |
| 02-navigation 定向 analyze | 0 issues |
| 02-navigation 源码总覆盖率 | 97.96% (2741/2798) |
| 03-input 源码总覆盖率 | 98.63% (3447/3495) |
| 04-display 定向测试 | 350 个测试通过 |
| 04-display 定向 analyze | 0 issues |
| 04-display 源码总覆盖率 | 99.05% (2089/2109) |
| 05-feedback 隔离覆盖率 | 95.28% (2970/3117) |
| 05-feedback 全量套件覆盖率 | 97.75% (3047/3117) |
| 05-feedback 定向测试 | 302 个测试通过 |
| 复杂组件链路定向测试 | 171 个测试通过 |
| 复杂组件链路定向 analyze | 0 issues |
| 复杂组件链路源码总覆盖率 | 95.50% (2757/2887) |
| 复杂组件链路 API 文档 | `dropdown-menu_api.md` 的 `operateHeight` 说明已补齐；本轮 API 说明列检查无 `-` |
| 全量 Flutter 测试 | 1856 个通过，6 个按环境条件跳过 |
| 全组件源码覆盖率 | 98.32% (12259/12468) |
| 全包 analyze | 0 issues |

## 当前剩余风险

| 风险 | 影响 | 建议处理 |
| --- | --- | --- |
| 部分内部文件低于 95%，但各组件域总覆盖率均已达标 | 若主仓要求每文件 95%，仍会增加迁移成本 | 主仓 PR 明确采用组件域总行覆盖率；对关键入口单独设置行为测试门禁 |
| 全量组件 ThemeExtension 已由 `TThemeBuilder` 默认注入 | 全局 Theme 可控，但主仓拆分时组件 ThemeData 定义与消费可能落在不同 PR | Foundation PR 只迁纯 ThemeData 定义；消费实现与组件 PR 同步验收 |
| 主仓 CI 与 v1 本地命令可能不完全一致 | 本地 Ready for PR 不一定等同主仓 CI 通过 | PR 0 明确主仓 CI 适配清单 |

## 下一步建议

1. 先开 PR 0，提交迁移约束、验收口径和文档索引。
2. PR 1 合入 Foundation / Theme / Token，再按 PR 2-4 迁移 01-base。
3. 03-input、Overlay/Feedback、Navigation/Display 按依赖和组件边界拆分，不能直接复用 v1 仓库中的大提交。
4. 主仓 CI 明确使用“组件域总行覆盖率 >= 95%”；关键入口另以行为测试和 API 文档检查兜底。
