# 方案

私有 StatefulWidget 持有在途选择状态，始终读取最新配置；try/catch 仅包裹 picker。

测试放入已登记组件文件；不修改 CI、公共清单或 Golden 基线。GitHub CI 将在独立 PR 的最终 head 上验证双 SDK 与 Linux 3.32.0 Golden。
