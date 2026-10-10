# 方案

统一正时长计时，零与负值不创建 Timer；移除无限哨兵。加载方法默认 2000ms。
将 Toast 的 preventTap 更名为 preventScrollThrough，沿用独立于遮罩绘制的全屏命中层。用实际背景按钮、ScrollController 和 PointerScrollEvent 验证拦截与恢复，不添加重复状态源。
使用 SingleChildLayoutDelegate 以 Overlay 高度和 Toast 实际尺寸计算中心坐标，避免 FractionalOffset 按剩余空间定位带来的偏差。
同步调用方、源码 dartdoc、生成 API/示例、Spec 与 PR breaking 迁移说明。仅 Linux 3.32.0 更新有意变化的 Toast Golden。
