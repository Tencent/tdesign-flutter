# PR #1184 Golden review assets

Comparison images are hosted separately for the PR description. They are not added to the code branch, Specs or Golden baselines.

Left: the unchanged baseline (matches the current PR's tracked PNG byte-for-byte).
Middle: candidate rendering, whose Popover implementation and Golden test match the current PR.
Right: magenta marks all nonzero RGB pixel differences.

Full-page comparisons and 3x nearest-neighbor detail crops use the same coordinates. No source image is retouched.

Environment: Linux/amd64 Flutter 3.32.0, DPR1, registered Golden fonts and CI Demo flags.
Light: 1,848 different pixels. Dark: 1,853 different pixels.
The test differences remain pending; publishing these images does not approve or update baselines.
