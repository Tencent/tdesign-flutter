# 页面 Golden 测试字体

`TDesignGoldenCJK-Regular.otf` 是仅供测试使用的中文字体子集，避免 Linux
Golden 因宿主机缺少 CJK fallback 而把中文渲染成缺字符号。它不会打包进 Example
或组件产物。

`TDesignFeedbackGoldenCJK-Regular.otf` 是 ActionSheet、Dialog、DropdownMenu、
NoticeBar 新增整页 Golden 的独立字体子集，字符清单见
`component_demo_glyphs.txt` 与 `feedback_demo_glyphs.txt`。独立加载可避免扩充共享
字体改变既有组件的像素基线，子集 SHA-256 为
`ba86924f427f2537d08d05d5634c8ab1374dc4da067195352a687e37e53f77cc`。

`RadioGoldenCJK-Regular.otf` 使用同一上游与子集参数，字符清单见
`radio_glyphs.txt`，仅用于 Radio 整页 Golden。子集 SHA-256 为
`cdd6b80b52382a5345597848ba58ef53ddf630aa29bfa1a4165b63264c000c2d`。

- 上游：Noto Sans SC 2.004 `NotoSansSC-Regular.otf`
- 来源：`https://github.com/notofonts/noto-cjk/raw/Sans2.004/Sans/SubsetOTF/SC/NotoSansSC-Regular.otf`
- 上游 SHA-256：`faa6c9df652116dde789d351359f3d7e5d2285a2b2a1f04a2d7244df706d5ea9`
- 子集工具：fonttools 4.59.1
- 共享子集 SHA-256：`2c4215bf330a1f6ba7da5c2be3eb1502e270d466c99852801e11164d946c690d`
- 共享字符清单：`component_demo_glyphs.txt`
- 许可证：SIL Open Font License 1.1，见 `OFL.txt`

字体经过子集化后已将 family/full/PostScript name 改为
`TDesign Golden CJK` / `TDesign Golden CJK Regular` /
`TDesignGoldenCJK-Regular`，不继续使用上游保留字体名。

更新 Demo 页面文案后，先从对应
页面和测试源码重新生成去重字符清单，再在固定 Linux + Flutter 3.32 环境更新权威
Golden；不得使用系统字体生成基线。
