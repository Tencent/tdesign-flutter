# 实施计划

1. 在独立 worktree 合入 Calendar #1059、Picker #1062、DateTimePicker #1061 的现有提交，避免遗漏已有修复。
2. 以 Figma 完整页面和弹出状态确定视觉差异；小程序源码仅用于解释 API/default，不机械复制容器 API。
3. 保持平铺组件本体；修改最小内部样式和 Demo 组合，补充必要月日模式与 dartdoc。
4. 回归真实点击/滚动/取消/确认、日期边界与主题；双版本严格 analyze 和功能测试。
5. Flutter 3.32 Linux 检查实际图、更新基线并无更新复跑；登记组件/Demo/状态矩阵入口、检查覆盖率与生成片段。
6. 交付改动和验收记录；按用户授权推送集成分支，并在 CNB 使用组件 Review skill 进行审查。
