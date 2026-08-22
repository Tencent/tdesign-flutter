# 验收记录

## 自动验证

- Flutter 3.32.0：`flutter test test/components/text`，20 项通过。
- Flutter latest（3.47.0）：`flutter test test/components/text`，20 项通过。
- Flutter 3.32.0：TText、ActionSheet、Loading、Popover、TabBar、Theme 直接消费者联合测试，185 项通过。
- Flutter 3.32.0：Popup 消费者 Golden 测试通过；ActionSheet/Dialog 基准已按去除错误 Material fallback 字重后的 Token 结果更新。
- Flutter 3.32.0 与 latest：组件包、Example 的 `flutter analyze` 均为 0 error / 0 warning。
- Flutter 3.32.0：Example `flutter build web` 通过。
- 示例代码资产同步检查通过，Text API 资产已重新生成。
- 组件包全量测试完成 2218 项通过、3 项失败。3 项均为仓库基线已存在的 Golden 漂移：
  - `base_components_light`、`base_components_dark` 的基准高度为 510px，当前 HEAD 未修改代码时也输出 502px；
  - `m3_isolation_controls` 在当前 HEAD 未修改代码时同样存在 0.59% 像素差异；
  - 已在独立临时基线副本的 `b791c118` 上复现，未将这些无关快照更新纳入本次改动。

## 跨平台人工验证

- [ ] iOS：中英文、emoji、富文本、缩放和 baseline 无异常
- [ ] Android：中英文、emoji、富文本、缩放和 baseline 无异常
- [ ] Web：字体加载、缩放、富文本和容器布局无异常

Web 已完成编译验证，但以上三端的人工视觉与交互验收仍需在真实运行环境完成。
