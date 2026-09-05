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

`TabBarGoldenCJK-Regular.otf` 仅用于 TabBar 整页明暗 Golden，字符清单见
`tab_bar_demo_glyphs.txt`。它在 Android 真机热重启、逐项操作及 Figma 人工核对
完成后才生成，不改变其他页面的字体回退和既有快照。

- 上游：Android 16 真机 `/system/fonts/NotoSansCJK-Regular.ttc` 的 SC 字体面（index 2）
- 上游 SHA-256：`3e7e5afaac2c6d872592d76abedac03a51c6f0fc42d11e311ff2816a6c368afe`
- 子集工具：fonttools 4.59.1
- 子集 SHA-256：`77e2e93df0b403af5ddd7411b6472ada58a93fcade6b87a34c26fe422f698c70`
- 许可证：SIL Open Font License 1.1，见 `OFL.txt`

原字体经过子集化后按各测试字体用途设置独立 family/full/PostScript name
（例如 feedback 子集使用 `TDesign Feedback Golden CJK`），不继续使用上游保留字体名。

更新 Button、Divider、Fab、Icon、Link、Text、Form、Input、Rate、Search、Switch、
Textarea、Upload、PullDownRefresh、Toast 或 SwipeCell Demo 页面文案后，更新原字符清单；
更新 Loading、Message、Popover 或 Popup 页面文案时，更新补充字符清单；更新
ActionSheet、Dialog、DropdownMenu 或 NoticeBar 页面文案时，更新 feedback 字符清单。
更新 Picker 页面文案时，更新 Picker 字符清单。
更新 Calendar 页面文案时，更新 Calendar 字符清单。
更新 TabBar 页面文案时，更新 TabBar 字符清单。
随后在固定 Linux + Flutter 3.32 环境更新对应组件的权威 Golden；不得使用系统字体
生成基线。
