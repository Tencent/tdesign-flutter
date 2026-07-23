// 组件元数据配置 —— 自动化验收脚本引用
//
// 定义全部 57 个组件目录的控制类、resolve/theme 文件存在性、
// config.dart 注册 key、all_build.sh folder-name、文档路径、Golden 优先级。
// 数据来源：lib/src/components/ 目录扫描 + config.dart + all_build.sh + docs/v1.0/components/

/// 控制类枚举（对应 testing.md §3）
enum ControlClass {
  /// A 类：onPressed/onTap，null=禁用（Button/Link/Cell 等）
  a,

  /// B/C 类：value+onChanged，onChanged:null=禁用（Switch/Slider/Rate 等）
  bc,

  /// D 类：controller，enabled:false/readOnly:true（Input/Textarea）
  d,

  /// E 类：仅 show()（Popup/Dialog/Toast）
  e,

  /// F 类：value+onChanged + 项级 disabled（Picker/Calendar）
  f,

  /// 纯展示组件，无交互禁用态（Divider/Icon/Text/Badge 等）
  display,
}

/// 单个组件的元数据
class ComponentMeta {
  /// 组件目录名（lib/src/components/ 下的文件夹名）
  final String dirName;

  /// 主 Widget 类名（如 TButton）
  final String widgetName;

  /// 控制类
  final ControlClass controlClass;

  /// 是否有 resolve 文件（t_{x}_resolve.dart）
  final bool hasResolve;

  /// 是否有 theme_data 文件
  final bool hasThemeData;

  /// config.dart 中的 name（注册 key）
  final String? configKey;

  /// all_build.sh 中的 --folder-name
  final String? apiFolderName;

  /// 组件文档路径（相对于 tdesign-component/）
  final String docPath;

  /// 是否为 P0 Golden 组件
  final bool isP0Golden;

  const ComponentMeta({
    required this.dirName,
    required this.widgetName,
    required this.controlClass,
    this.hasResolve = false,
    this.hasThemeData = true,
    this.configKey,
    this.apiFolderName,
    required this.docPath,
    this.isP0Golden = false,
  });
}

/// 全部 57 个组件元数据
const List<ComponentMeta> componentList = [
  // === 基础（01-base）===
  ComponentMeta(
    dirName: 'button',
    widgetName: 'TButton',
    controlClass: ControlClass.a,
    hasResolve: true,
    configKey: 'button',
    apiFolderName: 'button',
    docPath: 'docs/v1.0/components/01-base/button.md',
    isP0Golden: true,
  ),
  ComponentMeta(
    dirName: 'divider',
    widgetName: 'TDivider',
    controlClass: ControlClass.display,
    configKey: 'divider',
    apiFolderName: 'divider',
    docPath: 'docs/v1.0/components/01-base/divider.md',
  ),
  ComponentMeta(
    dirName: 'fab',
    widgetName: 'TFab',
    controlClass: ControlClass.a,
    hasResolve: true,
    configKey: 'fab',
    apiFolderName: 'fab',
    docPath: 'docs/v1.0/components/01-base/fab.md',
  ),
  ComponentMeta(
    dirName: 'icon',
    widgetName: 'TIcon',
    controlClass: ControlClass.display,
    configKey: 'icon',
    apiFolderName: 'icon',
    docPath: 'docs/v1.0/components/01-base/icon.md',
  ),
  ComponentMeta(
    dirName: 'link',
    widgetName: 'TLink',
    controlClass: ControlClass.a,
    hasResolve: true,
    configKey: 'link',
    apiFolderName: 'link',
    docPath: 'docs/v1.0/components/01-base/link.md',
  ),
  ComponentMeta(
    dirName: 'text',
    widgetName: 'TText',
    controlClass: ControlClass.display,
    hasResolve: true,
    configKey: 'text',
    apiFolderName: 'text',
    docPath: 'docs/v1.0/components/01-base/text.md',
  ),

  // === 导航（02-navigation）===
  ComponentMeta(
    dirName: 'backtop',
    widgetName: 'TBackTop',
    controlClass: ControlClass.a,
    configKey: 'backtop',
    apiFolderName: 'back-top',
    docPath: 'docs/v1.0/components/02-navigation/backtop.md',
  ),
  ComponentMeta(
    dirName: 'drawer',
    widgetName: 'TDrawer',
    controlClass: ControlClass.e,
    configKey: 'drawer',
    apiFolderName: 'drawer',
    docPath: 'docs/v1.0/components/02-navigation/drawer.md',
  ),
  ComponentMeta(
    dirName: 'indexes',
    widgetName: 'TIndexes',
    controlClass: ControlClass.display,
    configKey: 'indexes',
    apiFolderName: 'indexes',
    docPath: 'docs/v1.0/components/02-navigation/indexes.md',
  ),
  ComponentMeta(
    dirName: 'navbar',
    widgetName: 'TNavBar',
    controlClass: ControlClass.a,
    configKey: 'navbar',
    apiFolderName: 'navbar',
    docPath: 'docs/v1.0/components/02-navigation/navbar.md',
  ),
  ComponentMeta(
    dirName: 'sidebar',
    widgetName: 'TSideBar',
    controlClass: ControlClass.f,
    configKey: 'sidebar',
    apiFolderName: 'side-bar',
    docPath: 'docs/v1.0/components/02-navigation/sidebar.md',
  ),
  ComponentMeta(
    dirName: 'steps',
    widgetName: 'TSteps',
    controlClass: ControlClass.display,
    configKey: 'steps',
    apiFolderName: 'steps',
    docPath: 'docs/v1.0/components/02-navigation/steps.md',
  ),
  ComponentMeta(
    dirName: 'tabbar',
    widgetName: 'TBottomTabBar',
    controlClass: ControlClass.a,
    configKey: 'tabBar',
    apiFolderName: 'tab-bar',
    docPath: 'docs/v1.0/components/02-navigation/tab-bar.md',
    isP0Golden: true,
  ),
  ComponentMeta(
    dirName: 'tabs',
    widgetName: 'TTabBar',
    controlClass: ControlClass.display,
    configKey: 'tabs',
    apiFolderName: 'tabs',
    docPath: 'docs/v1.0/components/02-navigation/tabs.md',
  ),

  // === 输入（03-input）===
  ComponentMeta(
    dirName: 'calendar',
    widgetName: 'TCalendar',
    controlClass: ControlClass.f,
    configKey: 'calendar',
    apiFolderName: 'calendar',
    docPath: 'docs/v1.0/components/03-input/calendar.md',
  ),
  ComponentMeta(
    dirName: 'cascader',
    widgetName: 'TMultiCascader',
    controlClass: ControlClass.f,
    configKey: 'cascader',
    apiFolderName: 'cascader',
    docPath: 'docs/v1.0/components/03-input/cascader.md',
  ),
  ComponentMeta(
    dirName: 'checkbox',
    widgetName: 'TCheckbox',
    controlClass: ControlClass.bc,
    configKey: 'checkbox',
    apiFolderName: 'checkbox',
    docPath: 'docs/v1.0/components/03-input/checkbox.md',
  ),
  ComponentMeta(
    dirName: 'date_time_picker',
    widgetName: 'TDateTimePicker',
    controlClass: ControlClass.f,
    configKey: 'dateTimePicker',
    apiFolderName: 'date-time-picker',
    docPath: 'docs/v1.0/components/03-input/date-time-picker.md',
  ),
  ComponentMeta(
    dirName: 'form',
    widgetName: 'TForm',
    controlClass: ControlClass.d,
    configKey: 'form',
    apiFolderName: 'form',
    docPath: 'docs/v1.0/components/03-input/form.md',
  ),
  ComponentMeta(
    dirName: 'input',
    widgetName: 'TInput',
    controlClass: ControlClass.d,
    hasResolve: true,
    configKey: 'input',
    apiFolderName: 'input',
    docPath: 'docs/v1.0/components/03-input/input.md',
  ),
  ComponentMeta(
    dirName: 'picker',
    widgetName: 'TPicker',
    controlClass: ControlClass.f,
    configKey: 'picker',
    apiFolderName: 'picker',
    docPath: 'docs/v1.0/components/03-input/picker.md',
  ),
  ComponentMeta(
    dirName: 'radio',
    widgetName: 'TRadio',
    controlClass: ControlClass.bc,
    configKey: 'radio',
    apiFolderName: 'radio',
    docPath: 'docs/v1.0/components/03-input/radio.md',
  ),
  ComponentMeta(
    dirName: 'rate',
    widgetName: 'TRate',
    controlClass: ControlClass.bc,
    configKey: 'rate',
    apiFolderName: 'rate',
    docPath: 'docs/v1.0/components/03-input/rate.md',
  ),
  ComponentMeta(
    dirName: 'search',
    widgetName: 'TSearchBar',
    controlClass: ControlClass.d,
    configKey: 'search',
    apiFolderName: 'search',
    docPath: 'docs/v1.0/components/03-input/search-bar.md',
  ),
  ComponentMeta(
    dirName: 'slider',
    widgetName: 'TSlider',
    controlClass: ControlClass.bc,
    configKey: 'slider',
    apiFolderName: 'slider',
    docPath: 'docs/v1.0/components/03-input/slider.md',
    isP0Golden: true,
  ),
  ComponentMeta(
    dirName: 'stepper',
    widgetName: 'TStepper',
    controlClass: ControlClass.bc,
    configKey: 'stepper',
    apiFolderName: 'stepper',
    docPath: 'docs/v1.0/components/03-input/stepper.md',
  ),
  ComponentMeta(
    dirName: 'switch',
    widgetName: 'TSwitch',
    controlClass: ControlClass.bc,
    hasResolve: true,
    configKey: 'switch',
    apiFolderName: 'switch',
    docPath: 'docs/v1.0/components/03-input/switch.md',
  ),
  ComponentMeta(
    dirName: 'textarea',
    widgetName: 'TTextarea',
    controlClass: ControlClass.d,
    configKey: 'textarea',
    apiFolderName: 'textarea',
    docPath: 'docs/v1.0/components/03-input/textarea.md',
  ),
  ComponentMeta(
    dirName: 'tree',
    widgetName: 'TTreeSelect',
    controlClass: ControlClass.f,
    configKey: 'treeSelect',
    apiFolderName: 'tree-select',
    docPath: 'docs/v1.0/components/03-input/tree-select.md',
  ),
  ComponentMeta(
    dirName: 'upload',
    widgetName: 'TUpload',
    controlClass: ControlClass.a,
    configKey: 'upload',
    apiFolderName: 'upload',
    docPath: 'docs/v1.0/components/03-input/upload.md',
  ),

  // === 展示（04-display）===
  ComponentMeta(
    dirName: 'avatar',
    widgetName: 'TAvatar',
    controlClass: ControlClass.a,
    configKey: 'avatar',
    apiFolderName: 'avatar',
    docPath: 'docs/v1.0/components/04-display/avatar.md',
  ),
  ComponentMeta(
    dirName: 'badge',
    widgetName: 'TBadge',
    controlClass: ControlClass.display,
    configKey: 'badge',
    apiFolderName: 'badge',
    docPath: 'docs/v1.0/components/04-display/badge.md',
  ),
  ComponentMeta(
    dirName: 'cell',
    widgetName: 'TCell',
    controlClass: ControlClass.a,
    configKey: 'cell',
    apiFolderName: 'cell',
    docPath: 'docs/v1.0/components/04-display/cell.md',
  ),
  ComponentMeta(
    dirName: 'collapse',
    widgetName: 'TCollapse',
    controlClass: ControlClass.display,
    configKey: 'collapse',
    apiFolderName: 'collapse',
    docPath: 'docs/v1.0/components/04-display/collapse.md',
  ),
  ComponentMeta(
    dirName: 'empty',
    widgetName: 'TEmpty',
    controlClass: ControlClass.display,
    configKey: 'empty',
    apiFolderName: 'empty',
    docPath: 'docs/v1.0/components/04-display/empty.md',
  ),
  ComponentMeta(
    dirName: 'footer',
    widgetName: 'TFooter',
    controlClass: ControlClass.display,
    configKey: 'footer',
    apiFolderName: 'footer',
    docPath: 'docs/v1.0/components/04-display/footer.md',
  ),
  ComponentMeta(
    dirName: 'image',
    widgetName: 'TImage',
    controlClass: ControlClass.display,
    configKey: 'image',
    apiFolderName: 'image',
    docPath: 'docs/v1.0/components/04-display/image.md',
  ),
  ComponentMeta(
    dirName: 'image_viewer',
    widgetName: 'TImageViewer',
    controlClass: ControlClass.e,
    configKey: 'imageViewer',
    apiFolderName: 'image-viewer',
    docPath: 'docs/v1.0/components/04-display/image-viewer.md',
  ),
  ComponentMeta(
    dirName: 'progress',
    widgetName: 'TProgress',
    controlClass: ControlClass.display,
    configKey: 'progress',
    apiFolderName: 'progress',
    docPath: 'docs/v1.0/components/04-display/progress.md',
  ),
  ComponentMeta(
    dirName: 'result',
    widgetName: 'TResult',
    controlClass: ControlClass.display,
    configKey: 'result',
    apiFolderName: 'result',
    docPath: 'docs/v1.0/components/04-display/result.md',
  ),
  ComponentMeta(
    dirName: 'skeleton',
    widgetName: 'TSkeleton',
    controlClass: ControlClass.display,
    configKey: 'skeleton',
    apiFolderName: 'skeleton',
    docPath: 'docs/v1.0/components/04-display/skeleton.md',
  ),
  ComponentMeta(
    dirName: 'swiper',
    widgetName: 'TSwiper',
    controlClass: ControlClass.display,
    configKey: 'swiper',
    apiFolderName: 'swiper',
    docPath: 'docs/v1.0/components/04-display/swiper.md',
  ),
  ComponentMeta(
    dirName: 'table',
    widgetName: 'TTable',
    controlClass: ControlClass.display,
    configKey: 'table',
    apiFolderName: 'table',
    docPath: 'docs/v1.0/components/04-display/table.md',
  ),
  ComponentMeta(
    dirName: 'tag',
    widgetName: 'TTag',
    controlClass: ControlClass.a,
    configKey: 'tag',
    apiFolderName: 'tag',
    docPath: 'docs/v1.0/components/04-display/tag.md',
  ),
  ComponentMeta(
    dirName: 'time_counter',
    widgetName: 'TTimeCounter',
    controlClass: ControlClass.display,
    configKey: 'timeCounter',
    apiFolderName: 'time-counter',
    docPath: 'docs/v1.0/components/04-display/time-counter.md',
  ),

  // === 反馈（05-feedback）===
  ComponentMeta(
    dirName: 'action_sheet',
    widgetName: 'TActionSheet',
    controlClass: ControlClass.e,
    configKey: 'actionSheet',
    apiFolderName: 'action-sheet',
    docPath: 'docs/v1.0/components/05-feedback/action-sheet.md',
  ),
  ComponentMeta(
    dirName: 'dialog',
    widgetName: 'TDialog',
    controlClass: ControlClass.e,
    configKey: 'dialog',
    apiFolderName: 'dialog',
    docPath: 'docs/v1.0/components/05-feedback/dialog.md',
  ),
  ComponentMeta(
    dirName: 'dropdown_menu',
    widgetName: 'TDropdownMenu',
    controlClass: ControlClass.e,
    configKey: 'dropdownMenu',
    apiFolderName: 'dropdown-menu',
    docPath: 'docs/v1.0/components/05-feedback/dropdown-menu.md',
  ),
  ComponentMeta(
    dirName: 'loading',
    widgetName: 'TLoading',
    controlClass: ControlClass.display,
    configKey: 'loading',
    apiFolderName: 'loading',
    docPath: 'docs/v1.0/components/05-feedback/loading.md',
  ),
  ComponentMeta(
    dirName: 'message',
    widgetName: 'TMessage',
    controlClass: ControlClass.e,
    configKey: 'message',
    apiFolderName: 'message',
    docPath: 'docs/v1.0/components/05-feedback/message.md',
  ),
  ComponentMeta(
    dirName: 'notice_bar',
    widgetName: 'TNoticeBar',
    controlClass: ControlClass.display,
    configKey: 'noticeBar',
    apiFolderName: 'notice-bar',
    docPath: 'docs/v1.0/components/05-feedback/notice-bar.md',
  ),
  ComponentMeta(
    dirName: 'popover',
    widgetName: 'TPopover',
    controlClass: ControlClass.e,
    configKey: 'popover',
    apiFolderName: 'popover',
    docPath: 'docs/v1.0/components/05-feedback/popover.md',
  ),
  ComponentMeta(
    dirName: 'popup',
    widgetName: 'TPopup',
    controlClass: ControlClass.e,
    configKey: 'popup',
    apiFolderName: 'popup',
    docPath: 'docs/v1.0/components/05-feedback/popup.md',
  ),
  ComponentMeta(
    dirName: 'refresh',
    widgetName: 'TRefreshHeader',
    controlClass: ControlClass.display,
    configKey: 'refresh',
    apiFolderName: 'pull-down-refresh',
    docPath: 'docs/v1.0/components/05-feedback/refresh-header.md',
  ),
  ComponentMeta(
    dirName: 'swipe_cell',
    widgetName: 'TSwipeCell',
    controlClass: ControlClass.display,
    configKey: 'swipeCell',
    apiFolderName: 'swipe-cell',
    docPath: 'docs/v1.0/components/05-feedback/swipe-cell.md',
  ),
  ComponentMeta(
    dirName: 'toast',
    widgetName: 'TToast',
    controlClass: ControlClass.e,
    configKey: 'toast',
    apiFolderName: 'toast',
    docPath: 'docs/v1.0/components/05-feedback/toast.md',
  ),
];
