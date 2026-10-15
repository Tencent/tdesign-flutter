# 1.0.0 版本升级

## 目标

在独立 release/1.0.0 分支将组件版本从1.0.0-alpha.1升级至1.0.0，统一 Demo 展示版本。基于 develop 596e013df08e1f7c85032314d2ed611349143395。

## 契约

组件 pubspec.version 与 Demo assets/version 均为1.0.0；Demo pubspec 已为1.0.0+1，保留现有构建号，Android 实际 versionCode 继续由既有 version.gradle 按构建日期生成。构建时间在实际打包时由 write_demo_build_info.dart 重写，本次版本提交不伪造正式构建时间。

仅调整版本元数据与本目录记录；不混入组件、测试、Golden、CI或文档整理。建立PR不等于正式发布。现有发布工作流会在合并 release/ 分支后创建tag；发布缺口关闭之前保持草稿，不合并、不上传。

## 验收

版本来源一致，演示元数据生成结果正确；提交后的真实包 dry-run、公开包入口严格分析及独立迁移消费通过。最终release head还需完整CI及人工放行。
