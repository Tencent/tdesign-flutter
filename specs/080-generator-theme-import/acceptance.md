# 本地验收

基础：develop d0de29e8（已包含 #1174），独立分支 fix/1173-generator-theme-import。下表记录发布前的本地验证，远端结果以独立 PR 当前 head 的 Checks 为准。

| 验证 | Flutter3.32.0 | Flutter3.47.7 |
| --- | --- | --- |
| theme清单及调度器自测（无Golden） | 233通过 | 233通过 |
| 离线接入与旧Web消息链路 | 20通过 | 20通过 |
| css2token完整测试 | 40通过 | 40通过 |
| 组件包/Example/css2token严格分析 | 通过 | 通过 |
| theme生产行覆盖率 | 873/900，97.00% | 870/900，96.67% |

修改的basic.dart覆盖32/32（100%）。测试已加入theme组件清单及sharedExampleTests；css2token既有CI运行整个test目录。CI登记自测通过。本地结果不替代远端CI，发布后核对最终head的Checks。

## 验证方法

- `flutter test <manifest theme.componentTests> test/tool/check_component_coverage_test.dart test/tool/run_component_regression_test.dart test/tool/run_visual_regression_test.dart --no-pub --exclude-tags golden --coverage --reporter expanded`，随后`dart run tool/check_component_coverage.dart theme`。
- 在Example目录：`flutter test --no-pub test/tool/generator_theme_test.dart test/web_theme_message_test.dart --reporter expanded`。
- 包级：`dart test`和`dart analyze --fatal-infos`；组件包和Example分别`flutter analyze --fatal-infos`。
- 使用仓库已捕获的controller-defaults真实浅/深/共享声明拼成完整CSS，实际运行文档中的`dart run tool/convert_theme.dart ... --name ocean`成功生成JSON。端到端测试通过公共fromJson加载，不去除font、不取整。
- 自定义小数CSS通过公共JSON→TThemeBuilder→真实TButton验证明暗配色、字体、行高、尺寸及圆角；TText显式字体与颜色继续优先。另覆盖缺失字号/行高/字重、未配置Token默认继承，以及解析及校验失败不会覆盖源文件或旧输出。
- 字体JSON旧整数、可选字重、非法类型/非有限数/非正字号/负行高/非法字重与fromJson失败返回null已覆盖。公开Font整数构造签名未改，默认主题数据、组件消费及CSS映射未改。
- 双SDK切换前需分别pub get，避免旧package_config指向另一SDK；初次latest因旧配置而编译失败，纠正依赖配置后全套通过。最终low补充测试从Example目录执行。
- 默认渲染不变，本轮未运行或更新Golden；Widget测试验证新增可加载配置的真实样式。生成文档同步检查与diff格式检查通过。

工具仅支持当前生成器的根规则，不是通用CSS解析器；未知Token/值沿用原转换器忽略行为。旧pub.dev 1.0.0解析器不支持本次小数输出，业务需使用含修复的组件版本。

源码及测试指纹与验证摘要见results.json。本地日志及保留模板的PR描述草稿位于工作区review-artifacts/pr1173-local，不作为远端CI证据。

## 本地复审后的结论

复审发现并修复3项问题，最终版本无未处理的阻塞问题：

- 先前新校验将历史合法的lineHeight=0拒绝；现允许整数/小数零行高，保持原构造与JSON行为，字号仍须大于0。
- 有限正字号与行高相除可能溢出为Infinity；公共解析器与离线转换器均拒绝该结果。异常输入不再生成无法加载的JSON；CLI校验失败保留旧输出。
- 模式选择器原先接受不成对引号且不接受属性内合法空白；现严格匹配双引号、单引号和无引号模式，并覆盖空白与损坏选择器回归。

多位小数在完整CSS→命名JSON→公共fromJson往返中保持double精度，不固定小数位、不取整。Font.withSize(int)的既有整数缩放与取整契约保持原样，不将本次JSON修复扩大为公开API变更。

复审后的双SDK结果以上表及results.json当前validation为准，initialValidation为初次实现的历史结果。最新验证包括最终源码完整门禁、真实按钮样式与显式覆盖断言，以及未发布转换工具的实际命令执行。原有未跟踪token_migration/pubspec.lock未改动。实现通过独立PR交付；远端CI状态以当前PR head的Checks为准。
