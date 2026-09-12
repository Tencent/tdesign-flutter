/// Steps 内部使用模式。
///
/// 该类型不从包入口导出，只用于在根组件与渲染层之间传递
/// 已由命名构造确定的单一模式。
enum TStepsMode { progress, selectable, display }
