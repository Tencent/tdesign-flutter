# 页面 Golden 测试字体

`TDesignGoldenCJK-Regular.otf` 是仅供测试使用的中文字体子集，避免 Linux
Golden 因宿主机缺少 CJK fallback 而把中文渲染成缺字符号。它不会打包进 Example
或组件产物。

- 上游：Noto Sans SC 2.004 `NotoSansSC-Regular.otf`
- 来源：`https://github.com/notofonts/noto-cjk/raw/Sans2.004/Sans/SubsetOTF/SC/NotoSansSC-Regular.otf`
- 上游 SHA-256：`faa6c9df652116dde789d351359f3d7e5d2285a2b2a1f04a2d7244df706d5ea9`
- 子集工具：fonttools 4.59.1
- 子集 SHA-256：`2c4215bf330a1f6ba7da5c2be3eb1502e270d466c99852801e11164d946c690d`
- 字符清单：`component_demo_glyphs.txt`
- 许可证：SIL Open Font License 1.1，见 `OFL.txt`

字体经过子集化后已将 family/full/PostScript name 改为
`TDesign Golden CJK` / `TDesign Golden CJK Regular` /
`TDesignGoldenCJK-Regular`，不继续使用上游保留字体名。

更新 Button、Divider、Fab、Icon、Link、Text、Form、Input、Rate、Search、Switch、
Textarea、Upload、PullDownRefresh、Toast 或 SwipeCell Demo 页面文案后，先从对应
页面和测试源码重新生成去重字符清单，再在固定 Linux + Flutter 3.32 环境更新权威
Golden；不得使用系统字体生成基线。
