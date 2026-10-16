# 固定默认一致Token批次验收（2026-10-16）

BackTop默认图标20→22、Dropdown24→20、Refresh24→25；22/25没有对应全局刻度，保持独立默认，Dropdown20读取size7。28个固定默认点中22个源码位置使用一致尺寸刻度，6点暂未接入（2个缺少匹配全局刻度、4个Tag涉及边框补偿）。详见[fixed-default-mapping.md](fixed-default-mapping.md)。这是用户授权的新Flutter依赖，不冒称小程序原有全局引用或Figma绑定。

源码位置不等于独立可见属性：Search图标主题默认及布局回退有3点，前缀自身显式20和清除命中盒32未改。实际清除图标size8变化有独立断言，未用布局预留字段变化冒充额外图标控制。

## 本地功能与静态检查

| 检查 | Flutter3.32.0 | Flutter3.47.7 |
| --- | --- | --- |
| 13组组件、主题与调度器测试 | 1030通过 | 1030通过 |
| 57页双模式及清单核对 | 115通过 | 115通过 |
| 严格分析--fatal-infos | 无问题 | 无问题 |
| 14组生产行覆盖率门禁 | 全部≥95% | 全部≥95% |

每SDK运行57页×light/dark共114组，五类独立及组合切换；fixture中404个适用类别正向契约，不能将契约数当作独立属性数量。报告见fixed-results-<SDK>.json。Badge观察器原先只看TBadgeLabel，现纳入Material Badge实际dot分支并排除anchor child，防止内嵌按钮造成尺寸误报。

Button尺寸断言在新旧SDK均等待300ms使图标主题过渡完成，不把动画首帧当作最终值。

聚焦实际Widget断言覆盖Avatar中/大图标、Badge圆点、Button中/大图标、Drawer图标、Search高度/清除图标、Loading纵向gap、Dropdown高/箭头、Swiper分数框、Tabs tag高、CountDown三档背景块。验证默认、相关/无关Token、原位Element保持及已有显式入口。Toast四条实际渲染路径分别在明暗模式持有打开浮层更新；BackTop验证22、无关刻度隔离、显式优先及默认插值；Refresh真实刷新中验证Loading和绘制指示器均25。

可空组件Theme的Token默认由内部延迟插值解析器处理，包含Avatar已有解析、Badge/Drawer/Toast/Dropdown/Search的相关字段；额外断言验证实际当前Token默认、copyWith/merge与中断过渡。未新增公开配置字段。公共API签名不变，三个默认视觉及自定义尺寸的新增联动属于有意行为变化，后续发布需说明。

## 覆盖率（生产源码LH/LF）

| 模块 | Flutter3.32.0 | Flutter3.47.7 |
| --- | --- | --- |
| avatar | 288/292，98.63% | 288/292，98.63% |
| badge | 293/300，97.67% | 291/300，97.00% |
| button | 473/478，98.95% | 473/478，98.95% |
| backtop | 202/202，100.00% | 202/202，100.00% |
| dropdown_menu | 1008/1016，99.21% | 1008/1016，99.21% |
| drawer | 246/247，99.60% | 245/247，99.19% |
| refresh | 206/215，95.81% | 206/215，95.81% |
| loading | 267/267，100.00% | 267/267，100.00% |
| search | 239/244，97.95% | 239/244，97.95% |
| swiper | 533/550，96.91% | 533/550，96.91% |
| tabs | 771/789，97.72% | 771/789，97.72% |
| time_counter | 309/313，98.72% | 309/313，98.72% |
| toast | 265/269，98.51% | 265/269，98.51% |
| theme | 838/859，97.56% | 835/859，97.21% |

原始门禁输出见fixed-coverage-<SDK>.txt。共享生产插值文件已加入theme覆盖率范围，测试沿用已登记文件，三项回归调度器自测实际通过。API文档对13组件用生成器生成，并再次输出到临时目录逐字节比对通过。

## 复现入口与范围

组件命令由固定范围枚举：test/components/{avatar,badge,button,backtop,dropdown_menu,drawer,refresh,loading,search,swiper,tabs,time_counter,toast}中非golden测试；加共享ownership、theme/acceptance及test/components/theme非golden测试、3个调度器自测。flutter test参数--exclude-tags golden --coverage --reporter expanded。每模块由tool/check_component_coverage.dart过滤并检查既有95%阈值。

页面命令：在example目录运行flutter test --dart-define=TDESIGN_DEMO_TEST_MODULES=false test/theme/all_component_web_theme_test.dart --exclude-tags golden --reporter expanded，不设置组件筛选。静态检查flutter analyze --fatal-infos。完整当前源码diff和未跟踪源码按排序字节纳入fixed-source-fingerprint.json，不覆盖历史检查点。

本批范围核对：修改22个已有生产文件，另增加1个内部插值文件；其他已有生产文件与本批前哈希一致。git diff --check通过。SDK验证后恢复仓库固定3.32.0依赖配置，不部署、不提交。

## 像素验收限制及一次误跑记录

初次回归清单误纳入了theme目录中未标记的Golden文件，在macOS产生像素差异；未使用更新参数，未修改基线，差异产物归档到临时目录。随后按文件名及tag排除像素测试，以上最终结果仅为功能/交互与静态检查，不把误跑结果作为视觉验收。

[组件对齐技能第284行](../../.agents/skills/tdesign-component-align-review/SKILL.md#L284)要求“自动 Golden 与其他像素比较测试仅在 Flutter 3.32.0 Linux 执行和更新基线”。本机macOS且无可用Docker daemon，最终像素验收仍待该Linux环境，不更新基线。
