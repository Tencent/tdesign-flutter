# Code Review Report — issue #924

## 审查结论

状态：通过（自检）

## 修改范围

- `tdesign-component/lib/src/components/fab/t_fab.dart`：新增 `onLongPress`，`InkWell` 透传；图标反色与阴影改走主题。
- `tdesign-component/test/t_fab_test.dart`：新增用例。
- `tdesign-component/example/lib/page/t_fab_page.dart`：新增交互示例模块；`ExamplePage.test` 增加同构项便于站点「单元测试」区块生成。
- `tdesign-component/example/assets/api/fab_api.md`：API 表增加 `onLongPress` 行。

## 规范检查

### 1. 构造方法与字段顺序

- `TFab` 保持「构造方法在前、字段在后」；新增参数置于 `onClick` 之后，与 `InkWell` 参数语义相邻。

### 2. 注释风格

- 新增公开字段使用 `/// 长按回调`。

### 3. all_build 配置

- `TFab` 已在 `tdesign-component/demo_tool/all_build.sh` 中配置，本次未新增组件类名。

### 4. TTheme 使用

- 主色 / 危险态上图标与文字反色使用 `textColorAnti`；投影使用 `shadowsMiddle` 与 `shadowsBase` 回退。

### 5. TResourceDelegate 使用

- 本次无新增用户可见组件内固定文案；示例页 `SnackBar` 文案为演示用途，沿用示例页既有写法。

## 正确性评审

- `onLongPress` 为可选，默认 `null` 时行为与升级前一致（无长按回调）。
- 单击与长按手势由 `InkWell` 区分，与 Flutter 默认语义一致；已由 TC-01、TC-02 锁定。

## 风险与未验证项

- 投影由自定义三层阴影改为主题 `shadowsMiddle` / `shadowsBase`，FAB 外观光感可能与旧版略有差异，但更符合设计 token；若设计侧有专门 FAB 投影 token，可后续单独收敛。
- 本地 `dart run tdesign_flutter_tools` 生成命令不可用（stub 包），`fab_api.md` 已手工同步；若 CI 会跑全量 `all_build.sh`，应以 CI 产物为准再核对一行差异。
