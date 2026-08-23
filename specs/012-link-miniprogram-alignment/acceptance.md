# 验收记录

## 验证基线

- Flutter：`origin/develop@358fbfe4`
- 小程序：`origin/develop@d973e4aab`
- 对照目录：`packages/components/link`

## 自动化验证

| 命令 | 结果 |
| --- | --- |
| Flutter 3.32.0 analyze | 通过 |
| Flutter latest analyze | 通过 |
| `flutter test test/components/link test/components/message/t_message_test.dart` | 通过，共 43 项 |
| `flutter test --coverage test/components/link` | 通过，共 22 项；生产源码 `LH=123 / LF=126 = 97.62%` |
| Link 与基础组件 Golden | 通过 |
| 示例代码生成检查 | 通过 |

## 人工验收

- [x] 浅色和深色 Golden 人工检查
- [x] 按下、悬浮、焦点、禁用状态 Widget 测试
- [ ] Android / iOS / Web 官方 Demo 矩阵截图对照
