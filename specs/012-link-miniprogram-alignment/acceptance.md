# 验收记录

## 验证基线

- Flutter：`origin/develop`
- 小程序：`origin/develop@d973e4aab`
- 对照目录：`packages/components/link`

## 自动化验证

| 命令 | 结果 |
| --- | --- |
| Flutter 3.32.0 analyze | 通过 |
| Flutter latest analyze | 通过 |
| Link 聚焦测试与 Golden | 通过 |
| 示例代码生成检查 | 通过 |

## 人工验收

- [x] 浅色和深色 Golden 人工检查
- [x] 按下、悬浮、焦点、禁用状态 Widget 测试
- [ ] Android / iOS / Web 官方 Demo 矩阵截图对照
