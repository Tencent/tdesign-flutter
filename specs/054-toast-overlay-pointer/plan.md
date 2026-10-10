# 方案

保持遮罩绘制和布局，仅在全屏遮罩外增加 IgnorePointer。

测试放入已登记组件文件；不修改 CI、公共清单或 Golden 基线。GitHub CI 将在独立 PR 的最终 head 上验证双 SDK 与 Linux 3.32.0 Golden。
