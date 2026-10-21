# 本分支基线矩阵

同一Linux Flutter3.32.0、原基线、依赖和字体。通过仅限列出的既有场景，非全部TText用法像素覆盖。

| 组件 | 修复前 | 修复后 | PNG更新 |
| --- | --- | --- | --- |
| dialog | Popup差4.00%/9996px，Demo通过 | 既有入口通过 | 不需要 |

## 审阅截图

以下是既有同环境诊断的实际渲染截图，非新增或更新Golden基线。修复后截图SHA与原基线一致；纯分支另经Linux精确比较通过。

| 修复前实际图 | 修复后实际图 |
| --- | --- |
| ![修复前](evidence/dialog-before.png) | ![修复后](evidence/dialog-after.png) |

## 共享Theme消费者补充

| 场景 | PR原提交 | 显式局部主题补齐后 | PNG更新 |
| --- | --- | --- | --- |
| m3_custom_content（M2/M3） | CI差1.96%/6253px | Linux原基线精确通过 | 无 |
| 完整Theme Component / Theme Demo | 此前未纳入Dialog局部验收 | 27/22项测试通过 | 无 |

仅补齐自定义内容自身主题意图，Dialog直接TText槽仍使用Dialog默认。详见acceptance.md补充记录。
