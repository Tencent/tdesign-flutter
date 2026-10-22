# Popover page theme, palette and repair stages

The page's light/dark mode and the Popover's default dark palette are independent. A dark bubble on a light page does not mean dark mode.

The three columns are actual unmodified renderings: original develop e02efbac, PR #1182 (measurement only), PR #1184 (content subtree typography). The third column is not a pixel diff. Each column contains native Text / default TText / explicit pink TText.

The light-page black-on-dark result is retained as evidence of the old typography contract, not a recommended Demo appearance. PR #1184 supplies the bubble's white defaults; explicit styles remain in control.

These images clarify targeted review fixtures, not changes to production Demo, Specs or Golden baselines.

- [Light page / default dark bubble](popover_nowrap_light_stages.png)
- [Dark page / default dark bubble](popover_nowrap_dark_stages.png)
- [Original 48 patch comparisons](https://github.com/Tencent/tdesign-flutter/blob/17eaa957866a87d2cfccab17334702b2f163f5ce/README.md)
