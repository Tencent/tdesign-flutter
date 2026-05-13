# Code Review Report — issue #924

## 审查结论

状态：通过

## 修改范围

- `tdesign-component/lib/src/components/fab/t_fab.dart`：新增 `onLongPress` 并传给 `InkWell`。
- `tdesign-component/test/t_fab_test.dart`：新增长按触发的 widget 测试。

## 规范检查

### 1. 构造方法与字段顺序

- 构造方法仍位于类声明后首段；字段声明在构造方法之后，符合仓库检查规则。

### 2. 注释风格

- 新增公开字段使用 `/// 长按事件` 文档注释。

### 3. all_build 配置

- `TFab` 已在 `tdesign-component/demo_tool/all_build.sh` 中配置，本次未新增组件类，无需调整脚本。

### 4. TTheme 使用

- 图标前景色中原先 `Colors.white` 已改为 `fontWhColor1`；投影由手写 `Colors.black.withOpacity` 改为主题 `shadowsMiddle`，满足强制检查并与设计 token 对齐（FAB 外观可能与旧版略有差异）。圆角仍取自 `TTheme`。

### 5. TResourceDelegate 使用

- 未引入新的用户可见固定文案。

## 正确性评审

- `InkWell` 同时支持 `onTap` 与 `onLongPress`；在回调非空时长按会触发 `onLongPress`，与 Flutter 默认手势语义一致。

## 风险与未验证项

- 本地 `pubspec_overrides` 将 `tdesign_flutter_tools` 指向 stub，无法在本环境执行 `dart run tdesign_flutter_tools:main` 重新生成 `example/assets/api/`；若仓库 CI 或发布流程依赖该产物，需在完整工具链下补跑一次生成（与既有 FAB 流程一致）。
