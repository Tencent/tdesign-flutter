# CI像素基线修复（2026-10-17）

551f6dfc的远端双版本分析/功能测试及六项构建已通过，唯一失败为[Linux视觉回归](https://github.com/Tencent/tdesign-flutter/actions/runs/38950396601/job/117140021023)。本批仅同步已确认默认变更的98张Golden与验收文档，未修改组件实现、断言、比较器、容差或跳过任何用例。

## 归因与图像核对

| 已确认变更 | 更新基线数 | 影响范围 |
| --- | ---: | --- |
| Badge square圆角2→3 | 10 | 组件、完整Demo、居中矩阵 |
| SideBar tag内块圆角9→6 | 4 | 初始及选中状态 |
| BackTop图标20→22 | 10 | 组件、滚动后Demo、大字导航矩阵 |
| Dropdown箭头24→20 | 16 | 初始/禁用/单选/多列/排序/滚动展开 |
| Refresh加载图标24→25 | 4 | 基础及自定义文案刷新中 |
| Table水平padding16→12 | 18 | API、整页、排序、横向滚动、固定列 |
| Toast左右22→24、上下14→16 | 36 | 本页及Popover/NavBar/TabBar/Link/NoticeBar/Refresh超时反馈 |

逐项查看了全部98张CI基线、实际图、差异图和变化区域，变更均能归到上述已授权默认规格；共享Toast差异不代表反馈页面本身实现错误。局部裁切、行列、选中、排序及浮层状态未出现额外变化。BackTop组件画布宽290→296、3倍字号导航高690→691来自图标规格变化；其他画布尺寸保持。SideBar完整图通过实际测试引用定位到example/test/sidebar_tag/goldens，同名旧目录基线不误改。

每张有效路径、变化像素/范围、前后SHA、归因及CI来源见[ci-golden-review.json](ci-golden-review.json)。不是把失败图直接当作新期望：先完成对照审阅，再用Linux独立复现，并确认98张复现实际图与CI实际图RGBA像素完全一致，原基线也逐像素匹配CI master。

## 环境与执行

本机通过OrbStack运行linux/amd64容器，Flutter3.32.0（framework be698c48a6，engine1881800949，Dart3.8.0）。使用提交551f6dfc的git archive隔离副本及既有缓存镜像tdesign-flutter-golden-cache:3.32.0，未使用宿主macOS像素结果。

先不带更新参数复现：4个组件文件及14个example测试文件覆盖CI失败的16个套件，稳定重现全部98张差异，未出现像素比较之外的布局或功能失败。首次手工组件命令拼错Table测试文件名，随后使用manifest中的实际路径单独复现；该加载错误不计为组件回归，也未据此更新基线。

按同一文件清单执行一次更新批次（组件、example各一次flutter test --update-goldens），每部分完成后立即以相同参数移除--update-goldens复跑。组件更新/复跑各28项通过；example更新/复跑各183项通过。example命令保留--dart-define=TDESIGN_DEMO_TEST_MODULES=false，各命令使用--no-pub、原manifest参数和--reporter expanded。比较器保持Flutter精确比较，复跑差异为0。

仅把这98张已审阅、重现、复跑的Linux基线复制回工作分支，未复制其他新生成文件。组件/功能源码与551f6dfc一致，复用该head远端双SDK功能/分析/构建证据；本批仅变PNG/文档，不重跑无关本地功能矩阵。最终远端head的完整视觉与其他CI另行核验。
