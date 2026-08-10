---
name: tdesign-flutter-pr-workflow
description: Create or update Tencent/tdesign-flutter pull requests while preserving the repository PR template, recording evidence accurately, and using complete cross-repository links. Use this skill whenever a Flutter PR is opened, edited, pushed, or its GitHub description or review status is updated.
---

# TDesign Flutter PR Workflow

Keep every tdesign-flutter PR description aligned with the repository template and current CI evidence. This applies to
new PRs, Draft PRs, PR description edits, follow-up commits, and status updates.

## Required workflow

1. Read `.github/PULL_REQUEST_TEMPLATE.md` from the current checkout before drafting or editing a PR description.
2. Preserve the template's heading order, checkbox wording, guidance text, and checklist. Do not add a second top-level
   validation section outside the template. Put validation under `### 💡 需求背景和解决方案`, as the repository's existing
   CI PRs do.
3. Select only the applicable PR category. For CI-only changes, select `CI/CD 改进`; select the no-Changelog checkbox
   when the change is not user-facing.
4. State the related issue accurately. If there is no issue, say so explicitly; do not invent an issue link.
5. Put local and remote validation in the solution section. Separate passed, pending, skipped, and environment-blocked
   results. Never describe a running or unavailable check as passed.
6. Use complete Markdown URLs for every cross-repository reference, including PRs, commits, workflow runs, artifacts,
   previews, and dependency preview packages. A bare `PR #123` is insufficient when the target is another repository.
7. Before creating or editing the PR, run `git diff --check` and the repository-appropriate YAML/Flutter checks. Use
   `gh pr create` or `gh pr edit` only after the description has been checked against the template.
8. After pushing, inspect the actual PR state and check runs. Report the PR URL, branch, commit, and which checks are
   passed, pending, skipped, or failed.

## Description rules

- The PR description is the source of truth for the current review state, not a place to paste unverified logs.
- Keep the repository's Chinese template language and headings unless the user explicitly requests another language.
- For a template-conforming update, edit the existing description in place instead of appending an unrelated comment.
- If a GitHub comment is requested rather than the PR description, first identify the exact comment ID and preserve the
  existing comment's intended format.
- If the PR is cross-repository, write links such as
  `https://github.com/Tencent/tdesign-flutter/pull/983`, never only `PR #983`.

## Safe handoff

Do not merge a PR or mark it ready without explicit user authorization. A Draft PR is appropriate for testing CI or
preview artifacts. If GitHub authentication, a check run, or a preview deployment is unavailable, record that blocker
in the template-compatible validation text and keep the claim scoped to the evidence observed.
