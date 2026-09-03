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

`RadioGoldenCJK-Regular.otf` 使用同一上游与子集参数，字符清单见
`radio_glyphs.txt`，仅用于 Radio 整页 Golden。子集 SHA-256 为
`cdd6b80b52382a5345597848ba58ef53ddf630aa29bfa1a4165b63264c000c2d`。

`CalendarGoldenCJK-Regular.otf` 仅补充 Calendar 整页 Golden 新增且既有子集
未覆盖的字形，字符清单见 `calendar_demo_glyphs.txt`。独立加载可避免扩充共享
字体改变既有组件的像素基线，子集 SHA-256 为
`d9df3abeeda93b75f92a6e35d0bd73b9da67375cab820d6ac203b8fe4c649c0d`，本次下载的
上游源文件 SHA-256 为
`734b20876d6a6777e4c30b627e8391695bbf545c0badf6c066138bebd1f0278a`。

- 上游：Noto Sans SC 2.004 `NotoSansSC-Regular.otf`
- 来源：`https://github.com/notofonts/noto-cjk/raw/Sans2.004/Sans/SubsetOTF/SC/NotoSansSC-Regular.otf`
- 上游 SHA-256：`faa6c9df652116dde789d351359f3d7e5d2285a2b2a1f04a2d7244df706d5ea9`
- 子集工具：fonttools 4.59.1
- 原子集 SHA-256：`2c4215bf330a1f6ba7da5c2be3eb1502e270d466c99852801e11164d946c690d`
- 字符清单：`component_demo_glyphs.txt`
- 补充子集 SHA-256：`2c7a2ea904b3c082910f3929ca81ed543af3fe2897add8ef19a9b4cd518a5b8b`
- 补充字符清单：`alignment_demo_glyphs.txt`
- 许可证：SIL Open Font License 1.1，见 `OFL.txt`

原字体经过子集化后按各测试字体用途设置独立 family/full/PostScript name
（例如 feedback 子集使用 `TDesign Feedback Golden CJK`），不继续使用上游保留字体名。

更新 Button、Divider、Fab、Icon、Link、Text、Form、Input、Rate、Search、Switch、
Textarea、Upload、PullDownRefresh、Toast 或 SwipeCell Demo 页面文案后，更新原字符清单；
更新 Loading、Message、Popover 或 Popup 页面文案时，更新补充字符清单；更新
ActionSheet、Dialog、DropdownMenu 或 NoticeBar 页面文案时，更新 feedback 字符清单。
更新 Calendar 页面文案时，更新 Calendar 字符清单。
随后在固定 Linux + Flutter 3.32 环境更新对应组件的权威 Golden；不得使用系统字体
生成基线。
