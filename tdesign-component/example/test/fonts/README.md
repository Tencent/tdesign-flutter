# 页面 Golden 测试字体

`TDesignGoldenCJK-Regular.otf` 是仅供测试使用的中文字体子集，避免 Linux
Golden 因宿主机缺少 CJK fallback 而把中文渲染成缺字符号。它不会打包进 Example
或组件产物。

`TDesignFeedbackGoldenCJK-Regular.otf` 是 ActionSheet、Dialog、DropdownMenu、
NoticeBar 新增整页 Golden 的独立字体子集，字符清单见
`component_demo_glyphs.txt` 与 `feedback_demo_glyphs.txt`。独立加载可避免扩充共享
字体改变既有组件的像素基线，子集 SHA-256 为
`3ccbd82a3a8abbc2de214373ba6155021263f3401d43087784bf1acbdbb116e1`。
字符清单同时覆盖 DropdownMenu 的“产/火”和 Dialog 页面说明的“断”；保留可见的
缺字占位轮廓，避免空白占位掩盖缺字。

`TDesignAlignmentCJK-Regular.otf` 是 Loading、Message、Popover、Popup 对齐测试
新增文案的补充 fallback。它排在原字体之后，避免扩充原字体改变 Button、Checkbox、
Upload 等既有 Golden 的字形选择与像素基线。

`TreeSelectGoldenCJK-Regular.otf` 仅补充 TreeSelect 整页 Golden 新增且既有子集
未覆盖的字形，字符清单见 `tree_select_demo_glyphs.txt`，不会改变既有组件基线。
它使用 Noto Sans SC 2.004 `NotoSansSC-Regular.otf`，来源与本文下方记录一致；
子集工具为 fonttools 4.59.1，子集 SHA-256 为
`1cbb5418c4cd91a103deb2a28f68dacb1e895a6efcb8f2f5e8198d67d38ac7ca`。

`StepperGoldenCJK-Regular.otf` 仅补充 Stepper 整页 Golden 的“步”字，字符清单见
`stepper_demo_glyphs.txt`，不会改变既有组件的字形选择。子集 SHA-256 为
`6df8e74aa398c55ff2140025fd79c31300653bc02ddf31d35ec94f9c5ae3d0d0`。

`StepsGoldenCJK-Regular.otf` 仅补充 Steps 整页 Golden 所需字形，字符清单见
`steps_demo_glyphs.txt`。子集 SHA-256 为
`1c4a9391deda7834d5f3357e20d8bfcdd97be685e021ed31d2bde4166cdf9524`；源文件为
Android 16 系统的开源 `NotoSansCJK-Regular.ttc` SC 字体面，SHA-256 为
`3e7e5afaac2c6d872592d76abedac03a51c6f0fc42d11e311ff2816a6c368afe`。

`SliderGoldenCJK-Regular.otf` 仅补充 Slider 整页 Golden 新增且既有子集未覆盖的
字形，字符清单见 `slider_demo_glyphs.txt`，不会改变既有组件的字形选择。子集
SHA-256 为 `59c5bebba9bf720005fb977a94b9c150b0b8e8c2698c1dca3a66d9f0d7cd9722`。

`BackTopGoldenCJK-Regular.otf` 仅补充 BackTop 公开说明中的“帮”，字符清单见
`backtop_demo_glyphs.txt`。它作为 BackTop Demo 最后的专用 fallback，不改变其他页面
或既有共享字体的像素基线，子集 SHA-256 为
`44dc59fa4e3b84496d07c21e47af8679cec635b70af2e9561d9dbbfef444b42e`。

`CollapseGoldenCJK-Regular.otf` 仅补充 Collapse 整页 Golden 新增且既有子集未覆盖的
字形，字符清单见 `collapse_demo_glyphs.txt`。独立加载可避免扩充共享字体改变既有
组件的像素基线，子集 SHA-256 为
`e8f9a14d26d2342b00d379f65e969c5b4b03e44ab9d8ae5bff372b885a729ac2`。

`PickerGoldenCJK-Regular.otf` 仅补充 Picker 整页 Golden 新增且既有子集未覆盖的
字形，字符清单见 `picker_demo_glyphs.txt`。独立加载可避免扩充共享字体改变既有组件的
像素基线，子集 SHA-256 为
`83d2e4d3b8ae6282eeab5d8930466e082b29a3a88ac32f19da543ad1b547a107`。

`RadioGoldenCJK-Regular.otf` 使用同一上游与子集参数，字符清单见
`radio_glyphs.txt`，仅用于 Radio 整页 Golden。子集 SHA-256 为
`cdd6b80b52382a5345597848ba58ef53ddf630aa29bfa1a4165b63264c000c2d`。

`CalendarGoldenCJK-Regular.otf` 仅补充 Calendar 整页 Golden 新增且既有子集
未覆盖的字形，字符清单见 `calendar_demo_glyphs.txt`。独立加载可避免扩充共享
字体改变既有组件的像素基线，子集 SHA-256 为
`d9df3abeeda93b75f92a6e35d0bd73b9da67375cab820d6ac203b8fe4c649c0d`，本次下载的
上游源文件 SHA-256 为
`734b20876d6a6777e4c30b627e8391695bbf545c0badf6c066138bebd1f0278a`。

`SkeletonGoldenCJK-Regular.otf` 仅补充 Skeleton 整页 Golden 的组件名称、说明、
类型和动效文案，字符清单见 `skeleton_demo_glyphs.txt`。它作为 Skeleton Demo
最后的专用 fallback，不改变其他页面或既有共享字体的像素基线，子集 SHA-256 为
`0d9bc1e3573e19a40ac0777bf1799418a32eb3ab3f79a52e510e015bd1afbc93`。

`ProgressGoldenCJK-Regular.otf` 仅补充 Progress 整页 Golden 的“百、微、型、始”字，字符清单见
`progress_glyphs.txt`；它作为 Progress Demo 最后的专用 fallback，不改变其他页面
或既有共享像素基线，子集 SHA-256 为
`8f6894a9e05cf085047bbb10b48e18c0f3461d831a8af1c6ef7befb88890acc0`。

`AvatarGoldenCJK-Regular.otf` 仅补充 Avatar 整页 Golden 所需字形，字符清单见
`avatar_demo_glyphs.txt`。它作为 Avatar Demo 最后的专用 fallback，不改变其他页面
或既有共享字体的像素基线，子集 SHA-256 为
`f7a30185d3942c4cb698afb1e74002cc16eaddfcf70ae1ec0774f16e61f9392f`。

`TabBarGoldenCJK-Regular.otf` 仅用于 TabBar 整页明暗 Golden，字符清单见
`tab_bar_demo_glyphs.txt`。它在 Android 真机热重启、逐项操作及 Figma 人工核对
完成后才生成，不改变其他页面的字体回退和既有快照。

- 上游：Android 16 真机 `/system/fonts/NotoSansCJK-Regular.ttc` 的 SC 字体面（index 2）
- 上游 SHA-256：`3e7e5afaac2c6d872592d76abedac03a51c6f0fc42d11e311ff2816a6c368afe`
- 子集工具：fonttools 4.59.1
- 子集 SHA-256：`77e2e93df0b403af5ddd7411b6472ada58a93fcade6b87a34c26fe422f698c70`
- 许可证：SIL Open Font License 1.1，见 `OFL.txt`

`SideBarGoldenCJK-Regular.otf` 仅补充 SideBar 整页 Golden 的公开标题、说明与
入口文案，字符清单见 `sidebar_demo_glyphs.txt`。它作为独立 fallback 加载，避免
扩充共享字体后改变其他组件既有基线；上游与本文其余子集相同，子集工具为
HarfBuzz 11.4.5，子集 SHA-256 为
`490f5cfd79e21292f96c3f07ae6a512650de9bbe0cb78d6eebc0e30ca8f461e0`。
`CascaderGoldenCJK-Regular.otf` 仅补充 Cascader 整页 Golden 新增且既有子集
未覆盖的字形，字符清单见 `cascader_demo_glyphs.txt`。独立加载可避免扩充共享
字体改变既有组件的像素基线，子集 SHA-256 为
`8bdb3ff2e9b33a303bce6b1d6d00ab951f7a27cb34b9626fd60805cff1ca8efa`。

`IndexesGoldenCJK-Regular.otf` 仅补充 Indexes 城市列表和公开 Demo 文案，字符清单见
`indexes_demo_glyphs.txt`。它使用相同上游与子集参数，并设置独立 family，避免改变
其他组件现有 Golden 的字体回退结果。子集 SHA-256 为
`79e8744ec10861ff4a4685ea5915b779c400e3c8c42c8c91c00d815ab9d00d5c`。

`NavBarGoldenCJK-Regular.otf` 仅补充 Navbar 整页 Golden 的全部可见中文，
字符清单见 `navbar_demo_glyphs.txt`。独立加载可避免扩大共享字体并改变其他组件
既有基线；子集 SHA-256 为
`42ac590f847bba78e4854d1db40fe9bc4cfe537a003273e1f43b0ad1d3db557c`，上游字体和
子集参数与本文件下方记录一致。

`ImageGoldenCJK-Regular.otf` 仅补充 Image 整页 Golden 缺少的字形，字符清单见
`image_demo_glyphs.txt`。它使用独立 family，避免扩充共享字体改变其他组件基线；
子集 SHA-256 为
`ba8c31342f34f0d1ca0ceb62e3f50c7de2169e6330f7c2b398993a9a0eff2ba5`。

- 上游：Noto Sans SC 2.004 `NotoSansSC-Regular.otf`
- 来源：`https://github.com/notofonts/noto-cjk/raw/Sans2.004/Sans/SubsetOTF/SC/NotoSansSC-Regular.otf`
- 上游 SHA-256：`faa6c9df652116dde789d351359f3d7e5d2285a2b2a1f04a2d7244df706d5ea9`
- 子集工具：fonttools 4.59.1
- 子集 SHA-256：`77e2e93df0b403af5ddd7411b6472ada58a93fcade6b87a34c26fe422f698c70`
- 许可证：SIL Open Font License 1.1，见 `OFL.txt`

原字体经过子集化后按各测试字体用途设置独立 family/full/PostScript name
（例如 feedback 子集使用 `TDesign Feedback Golden CJK`），不继续使用上游保留字体名。

更新 Button、Divider、Fab、Icon、Link、Text、Form、Input、Rate、Search、Switch、
Textarea、Upload、PullDownRefresh、Toast 或 SwipeCell Demo 页面文案后，更新原字符清单；
更新 Loading、Message、Popover 或 Popup 页面文案时，更新补充字符清单；更新
ActionSheet、Dialog、DropdownMenu 或 NoticeBar 页面文案时，更新 feedback 字符清单。
更新 TreeSelect 页面文案时，更新 TreeSelect 字符清单。
更新 Stepper 页面文案时，更新 Stepper 字符清单。
更新 Slider 页面文案时，更新 Slider 字符清单。
更新 Picker 页面文案时，更新 Picker 字符清单。
更新 Calendar 页面文案时，更新 Calendar 字符清单。
更新 Steps 页面文案时，更新 Steps 字符清单。
更新 SideBar 页面文案时，更新 SideBar 字符清单。
更新 TabBar 页面文案时，更新 TabBar 字符清单。
更新 Cascader 页面文案时，更新 Cascader 字符清单。
更新 Indexes 页面或城市数据时，更新 Indexes 字符清单。
更新 BackTop 页面文案时，更新 BackTop 字符清单。
更新 Drawer 页面文案时，更新 Drawer 字符清单。
更新 Skeleton 页面文案时，更新 Skeleton 字符清单。
更新 Progress 页面文案时，更新 Progress 字符清单。
更新 Avatar 页面文案时，更新 Avatar 字符清单。
更新 Navbar 页面文案时，更新 Navbar 字符清单。
更新 Image 页面文案时，更新 Image 字符清单。
随后在固定 Linux + Flutter 3.32 环境更新对应组件的权威 Golden；不得使用系统字体
生成基线。
