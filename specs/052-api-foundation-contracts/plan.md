# 技术方案

Button 使用两个 nullable callback 的 OR 作为唯一启用源。Steps 直接改名并迁移源代码、测试和示例。Loading 以私有会话对象持有 Overlay 与 Entry；监听 Entry 卸载时校验 Overlay 生命周期和会话身份，清理期间先移除监听，避免通知中同步 dispose；show/dismiss 补充首次未绘制时的回收。
