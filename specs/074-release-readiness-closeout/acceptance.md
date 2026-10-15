# 验证记录

检查基线：596e013df08e1f7c85032314d2ed611349143395。日期：2026-10-15。

- Flutter3.32.0 / 3.47.7：严格静态分析均零问题；仓库外独立迁移消费各21项通过，包含公开包入口分析。两SDK使用隔离编译缓存，未调整生产依赖。
- 站点示例/API/页面契约测试26项通过；README/迁移片段同步检查6份文档、0项过时。新增文档及修改的入口链接检查通过。
- develop run38733652355：双SDK分析、APK/iOS/Web共6项构建、Linux3.32视觉回归通过；两项功能job仍在工具自测阶段运行，未将其记为全部通过。
- CodeCC旧check116408636711：failure，严重漏洞计数null，0条annotation；重试API返回404，无法在本环境取得有效扫描报告。此项保持待处理。
- 不重新生成macOS Golden；不改历史Token报告、自动CHANGELOG、CI或生产代码。

本轮只能证明上述检查；没有真实设备、设计复核、剩余524项消费证据或最终版本候选发布归档的通过声明。发布门槛见readiness.md；独立版本PR另行记录归档预检。

独立版本升级已创建PR1170，基于develop，不包含本PR文档整理；两SDK真实包归档预检通过、0 warnings，结果留在Spec075。原零差异PR1163已关闭。本PR仍不声明最终候选可发布。

后续状态核对：develop run38733652355完整成功；版本PR1170 head7d3cb3e2的CodeCC check116424269590成功，严重漏洞数为0；PR1169 head3ec9793b扫描亦成功。旧null失败不再阻塞上述已扫描head。最终候选仍须读取对应head的实际结果；未放宽扫描或视觉门禁。

补核CI工具阶段：Flutter3.32.0在本地重跑工作流实际调用的6份工具测试文件（coverage/component runner/visual runner/API audit/typedef/presentation），147项全部通过。未改测试或超时设置。
