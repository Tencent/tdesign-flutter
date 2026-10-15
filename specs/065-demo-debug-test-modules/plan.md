# 实施方案

保留共享默认 true 与 kDebugMode，移除47个页面的 false 覆盖。增加默认 true 的进程开关，公开功能与 Demo Golden 统一传 false；默认 Debug 开关契约另开进程验证。48张既有基线仅从已核对的 Linux CI 原始产物复制。与日期 fixture 和 artifact 收集修复分开交付。
