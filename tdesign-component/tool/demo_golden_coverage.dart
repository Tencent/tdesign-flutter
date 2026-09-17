enum DemoGoldenCoverageKind {
  /// Demo 没有会改变组件视觉的公开交互，整页 light/dark 即完整覆盖。
  staticOnly,

  /// 每条有实质视觉差异的路径均已保存独立 Golden。
  exhaustive,

  /// 所有实质视觉状态均已覆盖；等价操作复用同一渲染路径和 Golden。
  ///
  /// `rationale` 必须说明等价关系，功能测试仍需真实触发每条公开操作。
  exhaustiveWithEquivalence,

  /// 稳定视觉状态均已保存；系统、平台或无视觉差异的操作由功能测试覆盖。
  exhaustiveWithFunctionalBoundary,
}

class DemoGoldenCoverage {
  const DemoGoldenCoverage({
    required this.component,
    required this.kind,
    required this.states,
    required this.rationale,
  });

  final String component;
  final DemoGoldenCoverageKind kind;
  final List<String> states;
  final String rationale;
}

/// 公开 Demo 的可审计视觉覆盖矩阵。
///
/// `states` 记录已经进入对应组件 visual suite 的稳定可见状态；没有单独
/// Golden 的操作必须在 `rationale` 说明等价路径或不可确定边界。新增组件时
/// 调度器自测要求同步增加一条记录。
const demoGoldenCoverage = <DemoGoldenCoverage>[
  DemoGoldenCoverage(
    component: 'avatar',
    kind: DemoGoldenCoverageKind.staticOnly,
    states: ['initial'],
    rationale: '公开示例仅展示静态头像、徽标和组合。',
  ),
  DemoGoldenCoverage(
    component: 'action_sheet',
    kind: DemoGoldenCoverageKind.exhaustive,
    states: ['initial', 'all opened list and grid variants'],
    rationale: '每个公开触发器均通过真实点击保存打开态。',
  ),
  DemoGoldenCoverage(
    component: 'badge',
    kind: DemoGoldenCoverageKind.staticOnly,
    states: ['component states'],
    rationale: '公开视觉由输入参数决定，没有状态改变操作。',
  ),
  DemoGoldenCoverage(
    component: 'cell',
    kind: DemoGoldenCoverageKind.exhaustiveWithEquivalence,
    states: ['initial', 'switches changed', 'cell pressed'],
    rationale: '完整页面覆盖全部 Cell 布局，真实点击两个 Switch，并以首个可点击 Cell 代表共同按压路径。',
  ),
  DemoGoldenCoverage(
    component: 'backtop',
    kind: DemoGoldenCoverageKind.exhaustive,
    states: ['initial', 'circle scrolled', 'half-round scrolled'],
    rationale: '两种返回顶部形态均保存滚动后状态。',
  ),
  DemoGoldenCoverage(
    component: 'button',
    kind: DemoGoldenCoverageKind.exhaustiveWithEquivalence,
    states: ['initial', 'primary fill pressed'],
    rationale: '真实 pointer-down 固定按压帧；各 variant 和 colorScheme 的状态解析由组件测试逐项覆盖。',
  ),
  DemoGoldenCoverage(
    component: 'cascader',
    kind: DemoGoldenCoverageKind.exhaustive,
    states: ['initial', 'all popup variants', 'linked selection'],
    rationale: '公开弹层与联动选择均有操作后快照。',
  ),
  DemoGoldenCoverage(
    component: 'picker',
    kind: DemoGoldenCoverageKind.exhaustive,
    states: ['initial', 'all popup variants', 'linked selection'],
    rationale: '公开触发器和联动滚轮状态均已覆盖。',
  ),
  DemoGoldenCoverage(
    component: 'progress',
    kind: DemoGoldenCoverageKind.staticOnly,
    states: ['initial'],
    rationale: 'Demo 展示由参数决定的确定进度，没有公开操作。',
  ),
  DemoGoldenCoverage(
    component: 'date_time_picker',
    kind: DemoGoldenCoverageKind.exhaustive,
    states: ['initial', 'all opened variants'],
    rationale: '日期时间的全部公开触发器均保存打开态。',
  ),
  DemoGoldenCoverage(
    component: 'calendar',
    kind: DemoGoldenCoverageKind.exhaustive,
    states: ['initial', 'all popup variants'],
    rationale: '弹层日历逐场景覆盖；内联日历由初始整页覆盖。',
  ),
  DemoGoldenCoverage(
    component: 'tag',
    kind: DemoGoldenCoverageKind.exhaustiveWithEquivalence,
    states: ['initial', 'outline selectable selected'],
    rationale: '同一选择渲染路径用描边标签代表，其他语义色由初始态和组件测试覆盖。',
  ),
  DemoGoldenCoverage(
    component: 'popover',
    kind: DemoGoldenCoverageKind.exhaustive,
    states: ['initial', 'all opened variants', 'custom option selected'],
    rationale: '公开方位、内容和选择反馈逐场景覆盖。',
  ),
  DemoGoldenCoverage(
    component: 'checkbox',
    kind: DemoGoldenCoverageKind.exhaustiveWithEquivalence,
    states: ['initial', 'basic item toggled'],
    rationale: '受控勾选的共同渲染路径由基础项代表，静态 variant 和卡片状态保留在整页。',
  ),
  DemoGoldenCoverage(
    component: 'collapse',
    kind: DemoGoldenCoverageKind.exhaustiveWithEquivalence,
    states: ['initial', 'accordion selection changed'],
    rationale: '展开布局由整页初始态覆盖，收起和切换路径由手风琴操作后快照覆盖。',
  ),
  DemoGoldenCoverage(
    component: 'divider',
    kind: DemoGoldenCoverageKind.staticOnly,
    states: ['initial'],
    rationale: '分割线无公开交互。',
  ),
  DemoGoldenCoverage(
    component: 'empty',
    kind: DemoGoldenCoverageKind.staticOnly,
    states: ['initial'],
    rationale: '操作按钮无 Demo 状态变化，空状态视觉由整页覆盖。',
  ),
  DemoGoldenCoverage(
    component: 'image_viewer',
    kind: DemoGoldenCoverageKind.exhaustiveWithEquivalence,
    states: ['initial', 'actions viewer opened'],
    rationale: '带操作预览覆盖完整 Overlay；缩放和拖拽用组件功能测试验证。',
  ),
  DemoGoldenCoverage(
    component: 'dialog',
    kind: DemoGoldenCoverageKind.exhaustive,
    states: ['initial', 'all opened variants'],
    rationale: '每个公开对话框触发器均保存打开态。',
  ),
  DemoGoldenCoverage(
    component: 'dropdown_menu',
    kind: DemoGoldenCoverageKind.exhaustive,
    states: ['initial', 'all opened menus', 'overscroll'],
    rationale: '菜单、分栏与边界滚动状态均覆盖。',
  ),
  DemoGoldenCoverage(
    component: 'drawer',
    kind: DemoGoldenCoverageKind.exhaustive,
    states: ['initial', 'all opened variants', 'item pressed'],
    rationale: '打开态和保持 pointer-down 的按压态均已覆盖。',
  ),
  DemoGoldenCoverage(
    component: 'fab',
    kind: DemoGoldenCoverageKind.exhaustiveWithEquivalence,
    states: ['initial', 'auto-collapse while scrolling'],
    rationale: '滚动手势保持期间固定收缩态；任意拖拽位置不作为像素契约。',
  ),
  DemoGoldenCoverage(
    component: 'footer',
    kind: DemoGoldenCoverageKind.staticOnly,
    states: ['initial'],
    rationale: '公开示例没有改变 Footer 视觉的操作。',
  ),
  DemoGoldenCoverage(
    component: 'indexes',
    kind: DemoGoldenCoverageKind.exhaustive,
    states: ['initial', 'all popup variants', 'letter selection'],
    rationale: '触发和选择后的稳定状态均有快照。',
  ),
  DemoGoldenCoverage(
    component: 'image',
    kind: DemoGoldenCoverageKind.staticOnly,
    states: ['initial'],
    rationale: '加载、错误和形状状态由确定输入直接展示。',
  ),
  DemoGoldenCoverage(
    component: 'refresh',
    kind: DemoGoldenCoverageKind.exhaustive,
    states: ['initial', 'refreshing', 'completed', 'timeout'],
    rationale: '拖拽触发后的可见生命周期均固定。',
  ),
  DemoGoldenCoverage(
    component: 'rate',
    kind: DemoGoldenCoverageKind.exhaustiveWithEquivalence,
    states: ['initial', 'basic selected'],
    rationale: '基础评分固定真实点击后的值，其他图标与样式共享选择状态路径。',
  ),
  DemoGoldenCoverage(
    component: 'result',
    kind: DemoGoldenCoverageKind.staticOnly,
    states: ['initial'],
    rationale: '结果页状态均由参数直接展示。',
  ),
  DemoGoldenCoverage(
    component: 'tab_bar',
    kind: DemoGoldenCoverageKind.exhaustive,
    states: ['initial', 'all selections', 'menu opened', 'menu selected'],
    rationale: '公开选择和双层菜单路径均覆盖。',
  ),
  DemoGoldenCoverage(
    component: 'navbar',
    kind: DemoGoldenCoverageKind.exhaustiveWithEquivalence,
    states: ['initial', 'search entered', 'action feedback'],
    rationale: '输入与左右动作反馈均覆盖，共享 Toast 样式不重复截图每个按钮。',
  ),
  DemoGoldenCoverage(
    component: 'tabs',
    kind: DemoGoldenCoverageKind.exhaustiveWithEquivalence,
    states: ['initial', 'content tab selected'],
    rationale: '内容区选择覆盖 tab 切换渲染路径，其他 variant 已在初始整页展示。',
  ),
  DemoGoldenCoverage(
    component: 'swiper',
    kind: DemoGoldenCoverageKind.exhaustiveWithEquivalence,
    states: ['initial', 'first carousel changed'],
    rationale: '真实 fling 固定切换完成态；自动播放的时间推进由功能测试验证。',
  ),
  DemoGoldenCoverage(
    component: 'table',
    kind: DemoGoldenCoverageKind.exhaustive,
    states: [
      'initial',
      'sort ascending and descending',
      'selection changed',
      'fixed columns scrolled',
      'max height scrolled',
    ],
    rationale: '排序、选择和两个滚动容器均由真实操作固定；加载、空态和样式直接展示在初始页。',
  ),
  DemoGoldenCoverage(
    component: 'skeleton',
    kind: DemoGoldenCoverageKind.exhaustiveWithEquivalence,
    states: ['initial animation frame'],
    rationale: '循环骨架动画没有 settled 状态，仅固定测试时钟的初始帧。',
  ),
  DemoGoldenCoverage(
    component: 'time_counter',
    kind: DemoGoldenCoverageKind.exhaustiveWithFunctionalBoundary,
    states: ['initial deterministic values'],
    rationale: '持续计时不逐帧存图，生命周期和时间推进由功能测试覆盖。',
  ),
  DemoGoldenCoverage(
    component: 'icon',
    kind: DemoGoldenCoverageKind.exhaustiveWithEquivalence,
    states: ['initial', 'copy feedback'],
    rationale: '真实点击目录项后固定复制反馈，搜索过滤由功能测试覆盖。',
  ),
  DemoGoldenCoverage(
    component: 'link',
    kind: DemoGoldenCoverageKind.exhaustiveWithEquivalence,
    states: ['initial', 'tap feedback'],
    rationale: '所有可用链接共享回调和反馈渲染路径，禁用路径在初始页展示。',
  ),
  DemoGoldenCoverage(
    component: 'loading',
    kind: DemoGoldenCoverageKind.exhaustiveWithEquivalence,
    states: ['initial', 'speed changed'],
    rationale: '速度操作后状态固定；循环转动不按任意结束帧截图。',
  ),
  DemoGoldenCoverage(
    component: 'message',
    kind: DemoGoldenCoverageKind.exhaustive,
    states: ['initial', 'all opened variants', 'action feedback'],
    rationale: '公开消息和操作反馈逐场景覆盖。',
  ),
  DemoGoldenCoverage(
    component: 'notice_bar',
    kind: DemoGoldenCoverageKind.exhaustive,
    states: ['initial', 'closed', 'entrance action', 'scrolled'],
    rationale: '关闭、入口和滚动后的稳定状态均覆盖。',
  ),
  DemoGoldenCoverage(
    component: 'popup',
    kind: DemoGoldenCoverageKind.exhaustive,
    states: ['initial', 'all opened variants'],
    rationale: '每个公开方位与应用场景均保存打开态。',
  ),
  DemoGoldenCoverage(
    component: 'radio',
    kind: DemoGoldenCoverageKind.exhaustiveWithEquivalence,
    states: ['initial', 'basic selection changed'],
    rationale: '基础组固定选择后状态，variant 和卡片视觉在初始整页覆盖。',
  ),
  DemoGoldenCoverage(
    component: 'text',
    kind: DemoGoldenCoverageKind.staticOnly,
    states: ['initial'],
    rationale: '文字示例没有公开交互。',
  ),
  DemoGoldenCoverage(
    component: 'search',
    kind: DemoGoldenCoverageKind.exhaustiveWithEquivalence,
    states: ['initial', 'filtered result'],
    rationale: '输入和结果过滤后的布局已固定，取消与选择由功能测试覆盖。',
  ),
  DemoGoldenCoverage(
    component: 'steps',
    kind: DemoGoldenCoverageKind.exhaustiveWithEquivalence,
    states: ['initial', 'selectable step changed'],
    rationale: '可选择步骤固定操作后状态，纯展示 variant 在初始页覆盖。',
  ),
  DemoGoldenCoverage(
    component: 'sidebar',
    kind: DemoGoldenCoverageKind.exhaustive,
    states: ['all initial pages', 'selected item for every public page'],
    rationale: '锚点、标签、分页、图标场景均保存选择后状态。',
  ),
  DemoGoldenCoverage(
    component: 'slider',
    kind: DemoGoldenCoverageKind.exhaustiveWithEquivalence,
    states: ['initial', 'single slider changed'],
    rationale: '单游标真实拖拽代表受控更新路径，其他样式和方向在初始页覆盖。',
  ),
  DemoGoldenCoverage(
    component: 'stepper',
    kind: DemoGoldenCoverageKind.exhaustiveWithEquivalence,
    states: ['initial', 'basic incremented'],
    rationale: '加法后的受控值与布局固定，边界和 variant 由初始页及功能测试覆盖。',
  ),
  DemoGoldenCoverage(
    component: 'switch',
    kind: DemoGoldenCoverageKind.exhaustiveWithEquivalence,
    states: ['initial', 'basic toggled'],
    rationale: '固定 300ms 后的开关完成态；持续 loading 动画不使用 pumpAndSettle。',
  ),
  DemoGoldenCoverage(
    component: 'tree_select',
    kind: DemoGoldenCoverageKind.exhaustiveWithEquivalence,
    states: ['initial', 'single leaf changed'],
    rationale: '单选路径固定操作后状态，多选和三列状态由初始页与功能测试覆盖。',
  ),
  DemoGoldenCoverage(
    component: 'upload',
    kind: DemoGoldenCoverageKind.exhaustiveWithFunctionalBoundary,
    states: ['initial static file states'],
    rationale: '文件选择依赖平台插件，拖拽结果由组件功能测试覆盖，不保存平台相关瞬时帧。',
  ),
  DemoGoldenCoverage(
    component: 'form',
    kind: DemoGoldenCoverageKind.exhaustiveWithEquivalence,
    states: ['initial', 'vertical layout', 'disabled'],
    rationale: '布局和禁用视觉固定；Picker 选择及提交结果由功能测试覆盖。',
  ),
  DemoGoldenCoverage(
    component: 'input',
    kind: DemoGoldenCoverageKind.exhaustiveWithFunctionalBoundary,
    states: ['initial', 'text entered'],
    rationale: '真实输入后的稳定布局固定，键盘本体不进入跨平台 Golden。',
  ),
  DemoGoldenCoverage(
    component: 'textarea',
    kind: DemoGoldenCoverageKind.exhaustiveWithFunctionalBoundary,
    states: ['initial', 'all editable fields entered'],
    rationale: '所有可编辑公开实例在同一操作后整页快照中覆盖。',
  ),
  DemoGoldenCoverage(
    component: 'theme',
    kind: DemoGoldenCoverageKind.staticOnly,
    states: ['light and dark token pages', 'Material 2 and 3 isolation'],
    rationale: 'Theme 模块没有自身交互，颜色 Token 页面和 Material 默认值隔离场景固定其公开视觉契约。',
  ),
  DemoGoldenCoverage(
    component: 'toast',
    kind: DemoGoldenCoverageKind.exhaustive,
    states: ['initial', 'all public toast variants opened'],
    rationale: '除关闭操作复用初始态外，每个公开触发器均保存 Overlay；关闭由真实点击断言恢复。',
  ),
  DemoGoldenCoverage(
    component: 'swipe_cell',
    kind: DemoGoldenCoverageKind.exhaustive,
    states: ['initial', 'all public action layouts opened'],
    rationale: '每种起始方向和操作内容均保存滑开后的稳定状态。',
  ),
];
