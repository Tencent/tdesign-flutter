# Develop 全组件、示例与 API 审查记录

日期：2026-10-09。基线：`origin/develop e724cd0c4`；审查工作分支：`rss1102/fix/develop-component-audit`；文档交付分支：`rss1102/docs/develop-doc-cleanup`（PR #1155）。

## 结论与边界

已修复本轮确认的文档错误和无调用的历史实现。基线中确认 Upload 存在两种文件丢失场景（P1）、异步完成后调用已撤销回调（P2），Toast 存在遮罩拦截与配置不符（P2）。2026-10-10 已通过独立 PR #1153/#1154 提交这四项修复，尚未合并。本 PR 仅交付文档清理和风险登记，本分支/当前 develop 的这些运行缺陷仍存在。组件修复和双版本正确行为回归见对应 PR，不将独立分支修复误报为 develop 已解决。

范围来自 `tool/components.json`：56 个组件及 Theme，共 57 个 API 页、369 个公开声明；60 个 Demo 入口，370 个独立示例。全部执行公开导出/注释结构审计、示例映射、独立编译及现有非视觉回归；源码审查重点见逐项表。静态审计不保证注释语义完全正确，已有用例也不保证组件没有其他 bug。Web 页面只做抽样检查，尚未逐一人工操作 370 个代码面板。审查阶段未在本地执行 Linux Flutter 3.32.0 Golden；远端 CI 的最终提交与 Linux Golden 结果见本 PR 描述。自动回归不等于逐项人工视觉对齐验收。

## 已复现风险

P1 指合法操作导致数据丢失；P2 指契约或交互错误。下列问题均存在于本次 develop 基线，不是本轮文档清理引入。

| 编号 | 组件/等级 | 基线触发及错误结果 | 基线根因位置 | 修复及验收 | 当前状态 |
| --- | --- | --- | --- | --- | --- |
| U1 | Upload / P1 | picker 等待期间，父组件将文件从 old 更新为 new；picker 返回 picked 后收到 old + picked，new 丢失 | `lib/src/components/upload/t_upload.dart:656–682`；await 后读取旧 StatelessWidget 的 files | 私有 State 在完成时读取最新受控 files；替换列表及不可变结果回归通过 | 独立 [#1153](https://github.com/Tencent/tdesign-flutter/pull/1153) 已修复；CI 结果见对应 PR，待合并 |
| U2 | Upload / P1 | 自定义异步 picker 可以连续启动两次；first 完成后 second 仍以空列表为基底，最终仅保留 second | 同上；没有并发请求保护，两个闭包使用同一旧快照 | 同一实例仅允许一次选择在途；重复点击不启动第二请求，完成后可再次选择并合并已有文件 | 独立 [#1153](https://github.com/Tencent/tdesign-flutter/pull/1153) 已修复；CI 结果见对应 PR，待合并 |
| U3 | Upload / P2 | 等待期间父组件令 onChanged=null，picker 完成后旧 onChanged 仍被调用一次 | 同上；context.mounted 只证明 Element 存活，不能证明 Widget 配置仍有效 | 完成时读取最新 onChanged 和数量/大小限制；禁用/卸载丢弃结果，布局切换仍调用当前回调 | 独立 [#1153](https://github.com/Tencent/tdesign-flutter/pull/1153) 已修复；CI 结果见对应 PR，待合并 |
| T1 | Toast / P2 | showOverlay=true、preventTap=false；背景 TextButton 点击无响应，dismissAll 后恢复 | `lib/src/components/toast/t_toast.dart:578–585`；全屏有颜色的 Container 命中点击 | 遮罩单独包裹 IgnorePointer，按 preventTap 决定命中；四种配置及关闭恢复均验证 | 独立 [#1154](https://github.com/Tencent/tdesign-flutter/pull/1154) 已修复；CI 结果见对应 PR，待合并 |

最小复现保存在 [risk-reproduction.dart.txt](risk-reproduction.dart.txt)。这四个测试断言的是**基线错误行为**，通过表示缺陷已复现，不表示组件正常；因此不作为永久 CI 回归测试。复现方式：临时复制为 `tdesign-component/test/develop_audit_tmp_test.dart`，在组件目录运行 `flutter test test/develop_audit_tmp_test.dart`，运行后移除临时文件。该文本仅用于检出基线 e724cd0c4 的旧行为，不能在修复后的代码上当作通过门禁。永久回归已加入现有已登记的 [Upload PR #1153 测试](https://github.com/Tencent/tdesign-flutter/pull/1153/files) 和 [Toast PR #1154 测试](https://github.com/Tencent/tdesign-flutter/pull/1154/files)，断言正确行为。

修复源码分别属于 [Upload PR #1153](https://github.com/Tencent/tdesign-flutter/pull/1153)（私有状态）和 [Toast PR #1154](https://github.com/Tencent/tdesign-flutter/pull/1154)（IgnorePointer），不包含在本分支。

## 逐组件记录

下表各行的“结构通过”共同包含：API 导出与 dartdoc 结构、站点映射、独立示例编译。风险栏“未新增复现”只表示本轮审查及现有非视觉测试没有确认额外严重缺陷，不表示无风险。每项都受上述人工交互/视觉证据边界限制。

| 组件 | 源码审查重点 | 示例/API | 本轮确认风险或修复 |
| --- | --- | --- | --- |
| button | 禁用/loading、点击及长按、Theme 优先级 | 结构通过 | 未新增复现 |
| divider | 方向、边距及文字分隔布局 | 结构通过 | 未新增复现 |
| fab | 拖动边界、受控位置及浮动布局 | 结构通过 | 未新增复现 |
| icon | 图标查找、字体及主题尺寸 | 结构通过 | 未新增复现 |
| link | 禁用回调、颜色和链接展示 | 结构通过 | 未新增复现 |
| text | 字体加载、样式继承及布局 | 结构通过 | 未新增复现 |
| back-top | 滚动监听、控制器归属及销毁 | 结构通过 | 未新增复现 |
| drawer | Popup 路由、关闭结果及安全区 | 结构通过 | 未新增复现 |
| indexes | 索引滚动、sticky header 与监听 | 结构通过 | 未新增复现 |
| navbar | 安全区、左右内容及高度 | 结构通过 | 未新增复现 |
| side-bar | 滚动同步、选择回调及主题 | 结构通过 | 未新增复现 |
| steps | 越界索引、竖向布局和状态 | 结构通过 | 未新增复现 |
| tab-bar | 选择回调、受控索引及主题 | 结构通过 | 未新增复现 |
| tabs | TabController 同步、滚动及生命周期 | 结构通过 | 未新增复现 |
| calendar | 日期范围、初始化回调及运行期更新 | 结构通过 | 未新增复现 |
| cascader | 层级数据、选择路径和取消 | 结构通过 | 未新增复现 |
| checkbox | 受控组值、禁用及全选 | 结构通过 | 未新增复现 |
| picker | WheelController、列表更新和结果 | 结构通过 | 未新增复现 |
| date-time-picker | 日期约束、初始事件与轮列同步 | 结构通过 | 未新增复现 |
| form | 字段注册、校验和重置 | 结构通过 | 未新增复现 |
| input | 编辑控制器、受控值及焦点 | 结构通过 | 未新增复现 |
| radio | 组选择、禁用和主题 | 结构通过 | 未新增复现 |
| rate | 手势、浮层及边界取值 | 结构通过 | 未新增复现 |
| search | 输入控制器、清空及提交 | 结构通过 | 未新增复现 |
| slider | 范围夹取、手势及步长 | 结构通过 | 未新增复现 |
| stepper | 输入校验、上下界及受控回调 | 结构通过 | 未新增复现 |
| switch | 受控切换、禁用及平台样式 | 结构通过 | 未新增复现 |
| textarea | 控制器生命周期、长度及编辑 | 结构通过 | 未新增复现 |
| tree-select | 双列数据、选中值及滚动 | 结构通过 | 未新增复现 |
| upload | 异步 picker、受控文件及回调边界 | 结构通过 | U1/U2/U3 修复由 #1153 交付，待合并 |
| avatar | 网络失败、占位及组合头像 | 结构通过 | 未新增复现 |
| badge | 数量/小红点、溢出及布局 | 结构通过 | 未新增复现 |
| cell | 点击、禁用及字段布局 | 结构通过 | 未新增复现 |
| time-counter | 计时更新、停止/销毁及主题形状 | 结构通过 | 修正 Theme shape 迁移注释；未新增复现 |
| collapse | 受控展开、多面板及动画 | 结构通过 | 未新增复现 |
| empty | 空态资源、主题及自定义内容 | 结构通过 | 未新增复现 |
| footer | 链接回调、分隔及内容布局 | 结构通过 | 未新增复现 |
| image | 加载/错误/占位及尺寸 | 结构通过 | 未新增复现 |
| image-viewer | 预览路由、初始索引及关闭 | 结构通过 | 未新增复现 |
| progress | 数值边界、环形/线性和主题 | 结构通过 | 未新增复现 |
| result | 状态资源及自定义内容 | 结构通过 | 未新增复现 |
| skeleton | 动画生命周期及占位布局 | 结构通过 | 未新增复现 |
| swiper | 自动播放、数据更新及索引 | 结构通过 | 未新增复现 |
| table | 表头/固定列、数据及布局 | 结构通过 | 未新增复现 |
| tag | 选择、禁用、关闭及状态 | 结构通过 | 未新增复现 |
| action-sheet | 路由结果、禁用项及网格/列表 | 结构通过 | 未新增复现 |
| dialog | typed result、关闭和按钮状态 | 结构通过 | 未新增复现 |
| dropdown-menu | 展开/收起、选择和控制器 | 结构通过 | 未新增复现 |
| loading | 动画、Indicator 及主题配置 | 结构通过 | 清理失效设计裁决引用；未新增复现 |
| message | 计时、关闭及 Overlay 生命周期 | 结构通过 | 未新增复现 |
| notice-bar | 滚动/轮播、点击及销毁 | 结构通过 | 未新增复现 |
| popover | 定位、Overlay 及关闭 | 结构通过 | 未新增复现 |
| popup | 路由结果、屏障及布局/主题 | 结构通过 | 未新增复现 |
| pull-down-refresh | 刷新 Future、状态与控制器 | 结构通过 | 未新增复现 |
| swipe-cell | 滑动、自动尺寸及群组关闭 | 结构通过 | 未新增复现 |
| toast | 实例替换、定时销毁及遮罩穿透 | 结构通过 | T1 修复由 #1154 交付，待合并 |
| theme | Token 引用、lerp/copyWith、扩展及资源代理 | 结构通过 | 清理 Token 重复注释；未新增复现 |

## 全局配置、历史残留与文档修复

| 对象 | 检查/修复 | 结果及保留项 |
| --- | --- | --- |
| 全局 Theme/资源 | Token 引用循环、显式值优先级、extraThemeData 的 lerp、Material 桥接与 ResourceDelegate | 现有回归覆盖；没有重新引入已在 develop 修复的 Theme lerp/Upload catch 问题 |
| 字体/圆角/阴影 | 额外 3 个公开入口及 10 示例，CJK 字符覆盖、字体加载 | 结构和编译通过；保留有效字体 TODO #993 |
| Upload API | onError 注释误称捕获业务回调异常 | 由 #1153 修正并重新生成，未包含在本 PR |
| TimeCounter API | Theme shape 注释带有旧实现迁移口吻 | 改为当前行为；重新生成 time-counter_api.md |
| 示例生成指南 | README 仍展示已失效的方法注解、TButtonStyle/content/onTap | 改为独立 Widget + ExampleCodeManifest 及当前 TButton API |
| FAQ | 过时 SDK/布局说明、全局 context 建议、正则过滤器误导 | 改为当前 SDK、当前 Overlay context；说明 anchored RegExp 应用 withFunction 全值校验 |
| DartVersionUtil | 无引用、无公开导出的 Dart 3.2 兼容分支及注释代码 | 删除；当前最低 SDK 已超出该分支覆盖范围 |
| 站点 tdoc transform | 无调用的 WXML/JS/WXSS/JSON 示例转换、导入及 md-to-vue 旧覆盖率注释 | 删除，保留当前 flutter-example / flutter-api；站点构建通过 |
| 示例生命周期说明 | 已有 mounted/dispose 防护，却仍带旧 setState-after-dispose 栈 TODO | 更新为调用方移除观察者的当前契约 |
| 私有注释/依赖备注 | Loading 失效引用、Theme 断句、空 swipe-cell 备注 | 本 PR 清理不改变运行时行为；Toast 备注随 #1154 清理 |
| 应保留的历史材料 | Changelog、完成的 Spec、现行兼容入口 all_build.sh、正式弃用契约、Badge Token TODO、ResourceDelegate TODO #994 | 有实际用途，保留；#994 的默认中文本地化回退属于现存能力限制，未归为已复现严重 bug |

## 验证记录

详见 [acceptance.md](acceptance.md)，57 页当前资产摘要与 SHA-256 记录于 [api-evidence.json](api-evidence.json)。双版本配置分别重新解析，避免将指向另一 SDK 的 package_config 当作有效验证。切换 SDK 后只清理生成的 unit_test_assets/test_cache，没有更新 Golden，也没有清理原有 coverage、失败截图、APK 或 migration-audit。
