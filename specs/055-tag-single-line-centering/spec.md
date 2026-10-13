# Tag 单行文字居中

修复Tag行盒虽居中但额外行高按字体比例分配导致中文字形偏下的问题。仅单行Tag在显式TD配置未指定leadingDistribution时使用even；保留字体、行高、尺寸、颜色、图标、关闭、缩放和显式TD配置。多行Tag、共享TText默认排版及调用方自定义内容不修改。Badge自定义NEW Demo显式采用even，仍展示TBadge.custom；不在Badge中强改自定义内容。本PR不包含DateTimePicker。非breaking，修复默认排版。验收覆盖四档size、状态/变体、缩放、显式配置、多行及Golden。
