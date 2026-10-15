# 验证记录

目标1.0.0，基线596e013df08e1f7c85032314d2ed611349143395。首个版本提交0a99f1f0；后续只补本目录验证记录。

- Flutter3.32.0：在真实Git工作区已提交版本文件后运行 flutter pub publish --dry-run，通过、0 warnings，归档464KB。原有未跟踪coverage目录由.pubignore排除，没有借助无Git副本避开脏工作区检查。
- Flutter3.47.7：隔离副本同版本预检通过、0 warnings，归档464KB。
- 两版归档清单均含LICENSE、README及MIGRATION、TCloudNumber字体和公开入口；排除example、test、tool、coverage、锁文件和构建缓存。没有正式上传或创建tag。
- 两SDK独立迁移宿主均严格分析通过、各21项测试通过，使用组件公开入口；版本切换前的全库严格分析亦各零问题。
- Demo版本由现有write_demo_build_info.dart生成；组件/展示1.0.0，Demo pubspec原有1.0.0+1保持不变；publish_time字节与基线相同。正式打包会重新写入真实构建时间。Android版本码仍为既有日期生成策略，未将其误写成+1。
- 差异只包含组件pubspec、Demo版本资产和本目录Spec。最低Flutter/Dart约束、生产依赖、API和行为均未改变，无新增breaking change。

待办：最终head的完整CI、CodeCC、发布说明确认、Token/设备/设计证据和交付来源核验；见PR1169。此PR保持草稿，不合并、不发布。已有dry-run和path宿主测试不能替代发布后pub.dev真实消费。
