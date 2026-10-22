# PR #1182 patch render comparisons

Review assets only: no files are added to the PR code branch, Specs, or Golden baselines.

Before: develop e02efbac. After: PR head 1380e680. All captured production/test/manifest input hashes match the frozen PR head.
Environment: same Linux/amd64 Flutter 3.32.0, DPR1, registered Roboto and CJK fonts.

Each board shows before / after / magenta pixel difference. Within each panel: native Text control / default TText / fully explicit TText style control.
48 light/dark pairs, 36 with pixel changes. All fully explicit style-control metrics remain unchanged.
These are targeted rendering fixtures, not replacements for tracked Golden PNG files. No Golden PNG changed in PR #1182.
The unstyled TText inside Popover retains its prior independent typography and can be low-contrast; subtree typography unification is delivered in PR #1184.

| Scene | Light | Dark |
| --- | --- | --- |
| avatar | [light](patch-avatar_light-comparison.png) | [dark](patch-avatar_dark-comparison.png) |
| calendar | [light](patch-calendar_light-comparison.png) | [dark](patch-calendar_dark-comparison.png) |
| collapse_body | [light](patch-collapse_body_light-comparison.png) | [dark](patch-collapse_body_dark-comparison.png) |
| collapse_disabled | [light](patch-collapse_disabled_light-comparison.png) | [dark](patch-collapse_disabled_dark-comparison.png) |
| collapse_header | [light](patch-collapse_header_light-comparison.png) | [dark](patch-collapse_header_dark-comparison.png) |
| collapse_paragraph | [light](patch-collapse_paragraph_light-comparison.png) | [dark](patch-collapse_paragraph_dark-comparison.png) |
| collapse_trailing | [light](patch-collapse_trailing_light-comparison.png) | [dark](patch-collapse_trailing_dark-comparison.png) |
| divider | [light](patch-divider_light-comparison.png) | [dark](patch-divider_dark-comparison.png) |
| drawer | [light](patch-drawer_light-comparison.png) | [dark](patch-drawer_dark-comparison.png) |
| drawer_strut | [light](patch-drawer_strut_light-comparison.png) | [dark](patch-drawer_strut_dark-comparison.png) |
| link | [light](patch-link_light-comparison.png) | [dark](patch-link_dark-comparison.png) |
| link_disabled | [light](patch-link_disabled_light-comparison.png) | [dark](patch-link_disabled_dark-comparison.png) |
| popover | [light](patch-popover_light-comparison.png) | [dark](patch-popover_dark-comparison.png) |
| popover_custom | [light](patch-popover_custom_light-comparison.png) | [dark](patch-popover_custom_dark-comparison.png) |
| popover_inherited_single | [light](patch-popover_inherited_single_light-comparison.png) | [dark](patch-popover_inherited_single_dark-comparison.png) |
| popover_nowrap | [light](patch-popover_nowrap_light-comparison.png) | [dark](patch-popover_nowrap_dark-comparison.png) |
| progress_circular | [light](patch-progress_circular_light-comparison.png) | [dark](patch-progress_circular_dark-comparison.png) |
| progress_plump | [light](patch-progress_plump_light-comparison.png) | [dark](patch-progress_plump_dark-comparison.png) |
| progress_warning | [light](patch-progress_warning_light-comparison.png) | [dark](patch-progress_warning_dark-comparison.png) |
| table_cell | [light](patch-table_cell_light-comparison.png) | [dark](patch-table_cell_dark-comparison.png) |
| table_header | [light](patch-table_header_light-comparison.png) | [dark](patch-table_header_dark-comparison.png) |
| table_outer_theme | [light](patch-table_outer_theme_light-comparison.png) | [dark](patch-table_outer_theme_dark-comparison.png) |
| toolbar | [light](patch-toolbar_light-comparison.png) | [dark](patch-toolbar_dark-comparison.png) |
| toolbar_inherited | [light](patch-toolbar_inherited_light-comparison.png) | [dark](patch-toolbar_inherited_dark-comparison.png) |
