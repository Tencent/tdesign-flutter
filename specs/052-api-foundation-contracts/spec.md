# 保留基础能力的 API 收敛

基线 fcaa77ccbdbdf3eff752494ac4b35fd20149ce1a；不要求保留旧 API 兼容别名。

## 基础能力与行为契约

- Button 点击与长按独立；任一回调非空即启用，二者均为空禁用。长按不同时触发点击。普通和渐变路径一致；动态切换同步 disabled/pressed 状态及无障碍语义。禁用时调用方同时清空两个回调，不增加冗余 disabled 参数。
- Steps.onChange 直接迁移为 onStepTapped，保留索引参数和重选当前步骤通知；value 由调用方持有，点击不自动改变。progress 可为空（只读），selectable 必填，display 不提供交互参数；横纵形态不改变。
- Loading 保留全局唯一、最近 Overlay、重复 show 不替换、主动 dismiss、主题捕获和自定义内容。所属 Overlay 卸载后释放静态会话与 Entry，使新 Overlay 可再次 show。普通页面离开但根 Overlay 尚存时不会自动关闭。Entry 尚未首次绘制即卸载的情形在下一次 show/dismiss 时清理。旧 Entry 迟到的卸载通知不能清除新实例；隐藏于不透明覆盖层后不视为 Overlay 销毁。
- Radio/Dropdown 的重选、Checkbox 聚合半选保留；Sidebar 已过滤重选。不为字面一致性减去真实业务能力。

## 兼容性

Steps 公共参数改名、Button 长按独立启用属于 breaking。旧 Steps.onChange 改为 onStepTapped；旧 onPressed=null 禁用 Button 的调用方也须将 onLongPress 置空。Loading 保留签名，修复失效 Overlay 阻塞后续 show。

## 验收

双 SDK 功能测试覆盖单独点击/长按/双动作/禁用、动态状态、Steps 重选受控边界，Loading 卸载恢复、主动关闭、页面离开、覆盖层遮挡与早期关闭。严格 analyze、登记回归、覆盖率与生成产物通过。没有绘制/尺寸/资源改动；新增长按启用状态按交互和语义验证，不更新已有 Golden。
