> 2026-10-15 后续实施：依赖调整已实施，双版本及独立消费验证见实施记录，详见 [Spec 058](../058-release-preparation/acceptance.md)。本页原有“未实施”描述为上一轮阶段状态。

# 图片选择依赖检查与处理方案（不实施）

## 检查结果

- 当前 pubspec 固定 image_picker: 1.1.2、image_picker_android: 0.8.12+23。上一轮实际 flutter pub publish --dry-run 返回两条“依赖仅允许单一版本”警告，exit 65。它们是校验警告，不应误述为 pub.dev 绝对禁止上传。
- git 历史 73440511（#976，2026-08-05）在移除 Flutter 适配包、明确 Flutter 3.32 支持时，将 image_picker 从 ^1.1.2 改为精确版本，并加入 Android 实现包精确版本；提交包含“align Flutter 3.32 build pipeline”。这证明锁定有历史背景，但不足以证明具体哪个原生问题必须永久锁定。
- 生产代码只导入 package:image_picker/image_picker.dart，使用 ImagePicker.pickVideo、pickMultiImage、XFile.readAsBytes；未导入 image_picker_android。image_picker 1.1.2 自身已 endorsed Android 实现包，直接依赖不是当前 Dart 调用的必要条件。
- 缓存包元数据：image_picker 1.1.2 要求 Flutter >=3.19/Dart ^3.3；Android 0.8.12+23 要求 Flutter >=3.27/Dart ^3.6，当前 3.32 下可解析。
- [官方变更日志](https://pub.dev/packages/image_picker/changelog)：1.2.1 最低 Flutter 3.29；1.2.2 最低 3.35；1.2.3 最低 3.38；1.2.4 最低 3.41。不能把依赖下限直接改为 ^1.2.4，同时继续承诺 Flutter 3.32。

## 建议方案 A（优先验证，尚未证明兼容）

1. 保持本库 Flutter >=3.32.0 / Dart >=3.8.0 的支持范围。
2. 候选约束：image_picker: ^1.1.2；移除 image_picker_android 直接依赖，让 endorsed 平台包参与 SDK 兼容解析。不在生产 dependency_overrides 中强行覆盖。
3. 不把“solver 能解析”当成运行通过。检查旧 Android/Gradle 场景，明确应用最低 Android API/iOS 版本；上游实现包升级可能改变平台要求。
4. 若某个平台实现确有已复现兼容缺陷，再用最小必要版本范围及关联 issue 约束，说明移除条件。仅因过往锁过版本，不保留无解释的永久 pin。

## 执行与验收矩阵

- Flutter 3.32.0：最低依赖组合、正常可升级组合；记录实际 image_picker 与 Android/iOS/web 实现版本及 SDK/平台下限。
- 当前 stable：正常解析组合、一个独立业务 consumer 同时声明较新 image_picker 的组合，确认不再被本库 exact pin 阻断。
- 依赖下限检查可在隔离宿主执行 downgrade，并记录与业务无关的其他依赖下限失败，避免把全仓一次 downgrade 当作目标依赖证据。
- 双版本 analyze、Upload 组件和 Demo 功能回归；Android/iOS/Web 构建；pub publish --dry-run 无两条单版本警告。
- Android/iOS 真机：单/多图片、视频、取消、拒绝权限、选择期间禁用/退出、重复选择；Web 检查文件选择与结果读取。包含最低承诺平台，而非只测最新系统。
- Android 进程回收后的 lost-data 行为按当前库契约确认；若尚未支持，不在本次依赖调整中顺带扩张公开能力，记录业务自定义 picker 或明确限制。

## 方案 B（仅当 A 暴露明确原生回归）

保留能说明原因的最窄范围，关联最小复现及上游 issue；或者经产品决策提高 SDK/平台最低版本，再调整依赖下限及全部文档。提高 Flutter 最低版本不作为本轮默认选择。

此次没有修改 pubspec、锁文件或 Upload，没有声称候选范围已通过集成测试；执行方案前须以实际候选完成上述矩阵。
