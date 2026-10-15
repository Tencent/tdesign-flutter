# 实施方案

恢复共享默认值为 true，保留 kDebugMode 门禁；删除页面 false 覆盖。更新受影响功能测试并运行，检查共享控件静态分析。不得更新 Golden 基线，不改 CI、版本和 CHANGELOG。仅本地修改。
