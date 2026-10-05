# 当前 57 项 API 复查与修复结论

以 186541d4 为修复基线，当前生产源码指纹 5cc9d77a78edc78b7883a0bdbcf4d8d473082ea227cc5bc651ccda33d48f5551。四项确认问题已修复，三个跟进项在当前审查范围内补齐；其他组件本轮没有新增阻塞。这里表示公开 API 职责和已识别边界的结论，不承诺所有运行组合、Figma 或 M3 视觉全面一致。双版本证据见 acceptance.md。

| 序号 | 组件 | 结论与审查重点 |
|---|---|---|
| 1 | Button | 保留；按下和长按均可独立启用，样式与语义选择器职责明确。 |
| 2 | Divider | 保留；布局、对齐、虚线与内容职责独立。 |
| 3 | Fab | 保留；按钮动作、拖动和吸附分工明确，拖动结束不等于吸附完成。 |
| 4 | Icon | 保留；尺寸、颜色和无障碍标签合理。 |
| 5 | Link | 保留；onPressed 表示动作，图标与下划线表示视觉配置。 |
| 6 | Text | 保留；字体、显式样式与文本布局职责明确。 |
| 7 | BackTop | 保留；激活与成功完成分离，单 ScrollPosition 约束明确。 |
| 8 | Drawer | 保留；条目动作保留 index/item，浮层由句柄管理。 |
| 9 | Indexes | 保留；onSelect 是侧栏选择动作，onChanged 还覆盖滚动派生结果。 |
| 10 | Navbar | 保留；onBack 接管默认返回，安全区与高度语义明确。 |
| 11 | SideBar | 保留；value 使用业务标识，当前项去重合理。 |
| 12 | Steps | 保留；onStepTapped 是点击请求，value 是受控状态。 |
| 13 | TabBar | 保留；主选择、条目动作和菜单分离，重选通知不承诺值变化。 |
| 14 | Tabs | 保留；TabController 管理状态，onTap 可包含重选。 |
| 15 | Calendar | 保留；日期选择、月份导航与定位职责明确。 |
| 16 | Cascader | 保留；受控选择路径与内部浏览状态分离。 |
| 17 | Checkbox | 保留；null 表示聚合半选，用户交互仍为二态，超限表示失败请求。 |
| 18 | Picker | 保留；选择与列滚动结束分工，普通列与联动模型明确。 |
| 19 | DateTimePicker | 保留；公开 onChanged 与 value/mode/范围/步长契约合理。 |
| 20 | Form | 保留；已修复实际绑定记录、单所有者限制和原子替换。 |
| 21 | Input | 保留；controller/initialValue 互斥，enabled/readOnly 正交，长度与字符权重分离。 |
| 22 | Radio | 保留；回调表示包含重选的选择请求，禁用与 Group 交互职责明确。 |
| 23 | Rate | 保留；受控值、交互阶段和半星能力独立。 |
| 24 | Search | 保留；编辑、焦点、清空、提交和操作动作分离。 |
| 25 | Slider | 保留；值、交互阶段、范围、步长与格式化职责明确。 |
| 26 | Stepper | 保留；数值、范围和步长契约合理。 |
| 27 | Switch | 保留；受控开关与 loading 临时禁止交互分离，variant 为视觉配置。 |
| 28 | Textarea | 保留；编辑契约合理，外框样式有独立组件语义。 |
| 29 | TreeSelect | 保留；受控多路径与层级浏览分离，multiple 模型明确。 |
| 30 | Upload | 保留；文件集合变更、文件动作、校验错误与运行错误职责明确。 |
| 31 | Avatar | 保留；图片、回退内容和分组布局独立。 |
| 32 | Badge | 保留；配置对象与渲染 Widget 分工，自定义徽标优先级明确。 |
| 33 | Cell | 保留；点击、长按与分组连续布局职责明确。 |
| 34 | TimeCounter | 保留；时间配置、运行通知和完成分离，Controller 广播契约明确。 |
| 35 | Collapse | 保留；受控 value、模式约束与 Panel 禁用职责明确。 |
| 36 | Empty | 保留；操作区由子 Widget 承担动作。 |
| 37 | Footer | 保留；链接子 Widget 承担动作。 |
| 38 | Image | 保留；加载事件、占位构建器与图片来源分离。 |
| 39 | ImageViewer | 保留；结束 Future、索引与删除意图分离，onDelete 不直接修改集合。 |
| 40 | Progress | 保留；value/status 分离，按钮和微型模式动作合理。 |
| 41 | Result | 保留；状态、展示文本与图标职责明确。 |
| 42 | Skeleton | 保留；预设、自定义布局、动画和延迟配置独立。 |
| 43 | Swiper | 已修复；以实际绑定比较，相同无效配置重试仍拒绝。 |
| 44 | Table | 保留；选择、排序、行/单元格动作作用域明确，rowKey 表示稳定身份。 |
| 45 | Tag | 保留；普通动作、关闭意图和受控选择分离，enabled 禁用范围明确。 |
| 46 | ActionSheet | 保留；onSelected 表示动作，取消与禁用职责明确。 |
| 47 | Dialog | 保留；默认结果动作与自定义回调分工合理，disabled 有必要性。 |
| 48 | DropdownMenu | 保留；单所有者与原子替换已修复，重选提交关闭和多选草稿契约明确。 |
| 49 | Loading | 已补齐；首次绘制前所属 Overlay 卸载也释放会话，双版本回归通过。 |
| 50 | Message | 已修复；未绘制卸载关闭句柄，通知和释放幂等。 |
| 51 | NoticeBar | 保留；目标区点击与子操作独立，短点击过滤合理。 |
| 52 | Popover | 保留；单所有者与原子替换已修复，内容动作与开关生命周期阶段明确。 |
| 53 | Popup | 已修复；改为 maintainState，默认 true，遮挡和重开契约已验证。 |
| 54 | PullDownRefresh | 保留；刷新、加载更多和状态分离，Controller 所有者限制已修复。 |
| 55 | SwipeCell | 已修复；先绑定新对象，失败保留旧对象，卸载实际 owner。 |
| 56 | Toast | 已补齐；所属 Overlay 卸载时取消任务、清理实例；显式 ID 替换和关闭能力保持。 |
| 57 | Theme | 已补齐 12 个公开 Theme extension 文档；不承诺传递 export 整图覆盖。 |

