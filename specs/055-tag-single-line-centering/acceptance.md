# 验收记录（2026-10-14）

- 以 PR #1160 原 head `39b92fd2e` 为基线；全部 56 个组件目录的处理边界见 `component-review.md`。不包含 #1159 的日期时间连续滚动修复，此阶段已获授权提交与推送。
- 收敛过度保护：Input / Textarea 撤销任意插槽滚动与极小视口整组滚动；Popup 恢复原固定头部、尺寸及生命周期，移除未发布 API 和尺寸桥接；Calendar 改为至多四次代表性排版，撤销极小视口整面板滚动。Indexes 保留已明确要求的溢出滚动。
- 收敛后 Flutter 3.32.0 / 3.47.7 各 470 项相关功能测试通过（文字/Input/Textarea/Calendar/Popup 280 项，Picker/DateTimePicker 190 项），analyze 均零问题。覆盖显式 TD 配置、自定义内容主题、原生编辑状态、滚轮选择及 Popup 生命周期。
- 收敛后 Linux 3.32：25 项组件 Golden 和 84 项相关公开 Demo 视觉/结构检查通过，共 107 次图像比较；未因此次收敛更新基线。
- 扩展 Popup 消费组件检查：Drawer 通过；ActionSheet、Dialog 两张旧基线仍不匹配，未计入通过且未更新。两者在收敛前后实际 PNG 逐字节一致；Dialog 在原 PR head 上也同样不匹配。上述两张需纳入全组件最终基线审图。
- 真机常规字号：Input、Calendar、Picker、DateTimePicker、Popup 共 21 张截图无布局异常；补验输入/选择与键盘收起后的 State/值保留，以及 Picker、DateTimePicker 滚动后确认更新值并关闭弹层，均通过。
- 提交前最终候选双版本完整组件功能回归各 2,963 项通过，测试登记自测各 14 项通过，67 个改动 Dart 文件格式检查无变化；最终登记视觉/结构套件 716 项通过（686 次图像比较），上述两张扩展检查基线不计入。
- 本记录是本次收敛的验证，不代表全部 56 组件最终逐状态验收完成。默认单行遵循最终 TD 字体 Token；显式尺寸/排版优先，不承诺任意字体的字形光学中心、超长插槽或无法容纳内容的显式视口。详细日志与截图保存在本地 `text-centering-all/rollback-review/` 审图报告，不写入库内。
