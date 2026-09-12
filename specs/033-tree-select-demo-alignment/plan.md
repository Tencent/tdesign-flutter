# Plan

1. 固定 Figma 设计节点、小程序版本和 Flutter 实现基线。
2. 合并最新 `develop`，把 TreeSelect 登记迁移到集中测试 manifest。
3. 按设计稿修正 Demo 数据、初始状态、默认列宽和三列溢出。
4. 补齐单选、多选、三列、Theme 插值、查看代码、覆盖率和明暗 Golden 证据。
5. 在 Flutter 3.32.0 与 latest 运行严格 analyze 和非视觉回归，Golden 只在
   Flutter 3.32.0 Linux 更新和复验。
