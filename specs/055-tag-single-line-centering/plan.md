复用内部 TTextStyled 与 TTextResolve，在全部显式样式解析后为内置单行文字提供 even 默认值。组件已声明 maxLines=1 时复用共享策略；固定数字等内置文字明确选择相同默认值。公开 TText、可换行内容和 Widget 插槽不改变默认策略。先完成组件分类与功能回归，再在 Linux Flutter 3.32 无更新比较 Golden；逐图确认文字位置、尺寸和非文字像素，确认预期差异后更新并无更新复跑。双版本严格静态检查、功能回归、覆盖率和生成产物检查。

默认尺寸增长使用内置原生 TextPainter 的同一字体、支柱、缩放和高度行为；仅作用于所属组件内置内容。逐项验证 Picker 尺寸切换受控值、Switch 固定 size、Steps 标记与图标、TimeCounter 固定 size、Progress 显式 strokeWidth、Calendar 明确高度及 Indexes 溢出滚动和选择。
