# 验收记录

## 验证基线

- 分支：`rss1102/style/search-miniprogram-alignment`
- 小程序源码：本地 `develop@fc42eb47b`

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test test/components/search/t_search_test.dart` | 通过 | Flutter 3.32.0，7 个用例 |
| `flutter test --coverage ... test/components/search/t_search_test.dart` | 通过 | Search 生产源码 `LH/LF=180/188`，95.74% |
| `flutter analyze` | 通过 | Flutter 3.32.0，组件包零问题 |
| `flutter analyze example` | 通过 | Flutter 3.32.0，Example 零问题 |
| `flutter test test/search_page_test.dart` | 通过 | 375×812，官方场景、40dp 几何和浅色快照共 3 个用例 |
| `flutter test --no-pub test/components/search/t_search_test.dart` | 通过 | Flutter 3.47.0，7 个用例 |
| `flutter analyze --no-pub` | 通过 | Flutter 3.47.0，组件包零问题 |
| `flutter analyze --no-pub example` | 通过 | Flutter 3.47.0，Example 零问题 |
| `dart run tool/generate_example_code.dart --check` | 通过 | Search 示例资产无漂移 |
| `node scripts/check-flutter-component-contracts.mjs` | 通过 | 56 个站点路由契约完整 |
| `flutter build web` | 通过 | Flutter 3.32.0 release Web 构建 |

## 人工复查

- [x] 组件本体为 40dp，Demo 外层为 16dp 水平、8dp 垂直留白
- [x] 搜索/清除图标、文字、提示色、方形/圆形均使用对应 Token 与源码规格
- [x] 默认清除图标只在聚焦且有文字时显示
- [x] 取消操作由 Demo 受控组合，组件不隐式清空或失焦
- [x] 基础、结果预览、字数限制、取消、形状、居中场景与小程序顺序一致
- [x] Web 实际页面完成深色模式复查；浅色手机布局由 375×812 快照锁定

## 未完成

- 尚未本地提交、推送或创建 PR。
