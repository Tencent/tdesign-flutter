# plan

Controller 显式记录实际绑定。生成清单以根出口的声明为准，不增加内部类型。增加绑定边界回归；双版本分析与受影响组件测试。

## 再次复查修复方案
SwipeCell 记录实际绑定，以先 attach 新对象再 detach 旧对象保持原子替换；Swiper 使用实际外部绑定判断而不是 oldWidget。Overlay 会话在首次绘制后的单次检查补足未挂载 Entry 缺少卸载通知的路径，已挂载 Entry 使用现有监听；释放幂等，Toast 的卸载释放延迟到 microtask，避免通知栈内 dispose。Popup 及其 Picker/Drawer 消费端统一改为 maintainState，默认 true 保持原路由行为，迁移时取反；不增加关闭后保留的第二状态机制。

Theme extension 文档由 analyzer AST 读取公开成员、dartdoc 与方法签名，按根出口 show/hide 过滤，接入现有 57 份文档生成入口；生成器回归放入已经登记的调度器测试文件。本次仍不声明第三方及传递 export 的整图文档完整性。
