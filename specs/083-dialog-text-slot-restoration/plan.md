# 方案

独立副本 dialog-text-slots-fix，分支 rss1102/fix/dialog-text-slots，从d0de29e8按白名单提取。原混合副本和#1180保持原状。

仅恢复Dialog的四处标题/正文包装；保留原生文字居中与现有样式解析。将修复后的Dialog Popup场景准确登记到Dialog视觉入口并加调度自测，保持ActionSheet过滤边界。

先固定环境形成前后基线矩阵，再在纯分支上重新执行双版本与所属视觉入口，逐项记录而不移用另一分支的通过结论。API仅接受正式生成器产物。
