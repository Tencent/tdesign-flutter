# 1.0文档复核验收

日期：2026-10-15。此轮按用户指定的“1.0已发布”口径整理用户文档，没有执行包发布、修改版本号或更改CI。

## 七项处理

1. README、快速开始、FAQ、迁移开头及包内副本统一为 `tdesign_flutter: ^1.0.0`；去掉源码固定提交和预发布安装说明。
2. 左侧菜单不再显示迁移项；快速开始保留迁移链接。迁移页作为非菜单路由继续提供 `/flutter/migration-1-0`，不丢失原地址。
3. 根贡献指南开头改为正式贡献流程简介和设计/验收规范链接，去掉内部工具和“唯一事实来源”声明；站点继续直接读取根正文。
4. FAQ按1.0重新组织，优先链接站内快速开始、迁移、主题和具体组件；移除旧test_app/main源码跳转、旧转换脚本入口、缓存全局context和正则按单字符匹配等旧说明。保留仓库源码链接的目标在本地核实；Flutter国际化文档打开后更新为其当前重定向目标。
5. Theme标题从“主题--基础”改为“Theme 主题”，描述明确为色板示例和API。左侧按唯一Example代码manifest读取功能色、文字与图标颜色、中性色板三个例子；右侧TThemeColorsPage恰好挂载同三个Widget。现有代码片段生成器--check通过；运行测试覆盖浅深色三组示例与自定义中性色Token重建，Web主题接收/生命周期也回归通过。此结论是源码与功能对齐，不宣称像素验收。
6. 自定义主题和国际化片段改为从真实Dart源码提取。主题覆盖JSON命名、空值回退、局部扩展保留和明暗切换；国际化使用当前完整IntlResourceDelegate及生成的AppLocalizations，按当前context构建代理、开启needAlwaysBuild，验证中文切英文。文档明确仅实现cancel/confirm不完整，其余必填字段和默认中文字段也需业务翻译。旧CSS转换脚本不再作为全Token通用导入推荐；说明官网实际css2token转换及适配边界。
7. 深色模式并入custom-theme的“明暗模式”章节，删除重复文档及侧栏项；旧 `/flutter/dark-mode` 重定向新章节，路由支持锚点定位。README、快速开始及FAQ入口均更新。

## 实际验证

| 检查 | 结果 |
|---|---|
| Example严格分析，Flutter3.32.0/3.47.7 | 均0问题 |
| Theme/主题通信/生命周期功能回归 | 两SDK各25项通过，最终命令排除golden |
| 核心示例及测试源码 | 9个文件在主工程与高SDK隔离工程指纹一致 |
| 站点文档/示例/API回归 | 22项通过 |
| 站点主题桥接 | 6项通过 |
| 文档映射与组件契约 | 57页、360个生成示例通过 |
| Example代码片段生成检查 | --check退出0 |
| 文档片段与包内副本同步 | --check通过 |
| 站点生产构建 | 通过 |
| 本地预览 | 19000端口的配置、主题页、国际化页模块HTTP200，19001示例服务保持运行 |
| 当前Markdown相对/仓库源码链接 | 存在性检查通过 |

命令：在Example工程运行 `flutter analyze --no-pub --fatal-infos` 和 `flutter test --no-pub --exclude-tags golden test/theme/theme_demo_test.dart test/web_theme_message_test.dart test/web_theme_listener_lifecycle_test.dart`；在组件工程运行 `dart --packages=.dart_tool/package_config.json tool/generate_example_code.dart --check`；根目录运行 `npm run site --prefix tdesign-site` 和 `node scripts/sync-readme.mjs --check`。

源码与日志指纹见[validation.json](validation.json)。日志仍在临时目录，不把后续日志不存在当作可重新核验；重新验证按上述命令执行。

## 失败记录与边界

首次Example分析发现IntlResourceDelegate闭包可用构造tear-off，已修复并双版本复核0问题。另一次误从仓库根目录执行分析，没有正确包级上下文，产生大量依赖解析诊断；不计为Example分析结果，最终均在Example包执行。

首次测试误包含两个Golden在macOS比较，浅/深各失败约7.03%/6.98%；未更新基准或把它们认定为生产视觉缺陷。反馈图片移到临时目录保留，没有提交。最终功能命令明确排除Golden。规定的Linux3.32视觉验收仍未完成，不能把功能测试或源码同源当作像素一致证据。

站点构建保留既有上游PURE注解、历史二维码资源、输出目录与大chunk警告；未部署站点，未进行新浏览器像素或窄屏人工验收。生产Dart、测试调度清单、CI/工作流、CHANGELOG和版本号均未改；此前677项队列未因这次文档复核而关闭。
