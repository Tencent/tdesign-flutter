./bin/demo_tool generate --file ../lib/src/components/avatar/td_avatar.dart --name TDAvatar --folder-name avatar --output ../example/assets/api/ --only-api
./bin/demo_tool generate --file ../lib/src/components/badge/td_badge.dart --name TDBadge --folder-name badge --output ../example/assets/api/ --only-api
./bin/demo_tool generate --file ../lib/src/components/bottom_nav_bar/td_bottom_nav_bar.dart --name TDBottomNavBar,IconTextTypeConfig,IconTypeConfig,BadgeConfig,TDBottomNavBarTabConfig,TDBottomNavBarPopUpBtnConfig,TDBottomNavBarPopUpShapeConfig,PopUpMenuItem --folder-name bottom_nav_bar --output ../example/assets/api/ --only-api
./bin/demo_tool generate --folder ../lib/src/components/button --name TDButton,TDButtonStyle --folder-name button --output ../example/assets/api/ --only-api
./bin/demo_tool generate --folder ../lib/src/components/checkbox --name TDCheckbox,TDCheckboxGroup --folder-name checkbox --output ../example/assets/api/ --only-api
# Dialog 需要多个文件生成一个api
./bin/demo_tool generate --folder ../lib/src/components/dialog --name TDAlertDialog,TDConfirmDialog,TDDialogButtonOptions,TDDialogButtonStyle,TDDialogScaffold,TDDialogTitle,TDDialogContent,TDDialogInfoWidget,HorizontalNormalButtons,HorizontalTextButtons,TDDialogButton,TDDialogImagePosition,TDImageDialog,TDInputDialog --folder-name dialog --output ../example/assets/api/ --only-api

./bin/demo_tool generate --file ../lib/src/components/divider/td_divider.dart --name TDDivider --folder-name divider --output ../example/assets/api/ --only-api
./bin/demo_tool generate --file ../lib/src/components/empty/td_empty.dart --name TDEmpty --folder-name empty --output ../example/assets/api/ --only-api
./bin/demo_tool generate --file ../lib/src/components/image/td_image.dart --name TDImage --folder-name image --output ../example/assets/api/ --only-api
./bin/demo_tool generate --file ../lib/src/components/input/td_input.dart --name TDInput --folder-name input --output ../example/assets/api/ --only-api
./bin/demo_tool generate --file ../lib/src/components/loading/td_loading.dart --name TDLoading --folder-name loading --output ../example/assets/api/ --only-api
./bin/demo_tool generate --file ../lib/src/components/navbar/td_nav_bar.dart --name TDNavBar,TDNavBarItem, --folder-name navbar --output ../example/assets/api/ --only-api
# picker需多个文件生成一个api
./bin/demo_tool generate --folder ../lib/src/components/picker --name TDPicker,TDDatePicker --folder-name date_picker --output ../example/assets/api/ --only-api
./bin/demo_tool generate --folder ../lib/src/components/picker --name TDPicker,TDMultiPicker,TDMultiLinkedPicker,MultiLinkedPickerModel --folder-name picker --output ../example/assets/api/ --only-api

./bin/demo_tool generate --folder ../lib/src/components/popup --name TDSlidePopupRoute,TDPopupBottomDisplayPanel,TDPopupBottomConfirmPanel,TDPopupCenterPanel --folder-name popup --output ../example/assets/api/ --only-api --get-comments
# 需多个文件生成一个api,透彻父类参数需处理
./bin/demo_tool generate --file ../lib/src/components/radio/td_radio.dart --name TDRadioStyle,TDRadio,TDRadioGroup --folder-name radio --output ../example/assets/api/ --only-api --get-comments
# 有三方组件
./bin/demo_tool generate --file ../lib/src/components/refresh/td_refresh_header.dart --name TDRefreshHeader --folder-name refresh --output ../example/assets/api/ --only-api --get-comments
./bin/demo_tool generate --file ../lib/src/components/search/td_search_bar.dart --name TDSearchBar --folder-name search --output ../example/assets/api/ --only-api
# 有三方组件
./bin/demo_tool generate --folder ../lib/src/components/swiper --name TDSwiperPagination,TDPageTransformer --folder-name swiper --output ../example/assets/api/ --only-api --get-comments
./bin/demo_tool generate --file ../lib/src/components/switch/td_switch.dart --name TDSwitch --folder-name switch --output ../example/assets/api/ --only-api
# 多个类生成一个api, 注释未生效
./bin/demo_tool generate --folder ../lib/src/components/tabbar --name TDTabBar,TDTab,TDTabBarView --folder-name tabbar --output ../example/assets/api/ --only-api
./bin/demo_tool generate --folder ../lib/src/components/tag --name TDTag,TDSelectTag,TDTagStyle --folder-name tag --output ../example/assets/api/ --only-api
./bin/demo_tool generate --file ../lib/src/components/text/td_text.dart --name TDText,TDTextSpan,TDTextConfiguration --folder-name text --output ../example/assets/api/ --only-api
# 只有方法，没有变量
./bin/demo_tool generate --file ../lib/src/components/toast/td_toast.dart --name TDToast --folder-name toast --output ../example/assets/api/ --only-api

./bin/demo_tool generate --file ../lib/src/theme/td_theme.dart --name TDTheme,TDThemeData --folder-name theme --output ../example/assets/api/ --only-api