# 首次运行时放开，替换成自己的flutter路径
flutterPath="~/tools/flutter"
export PATH="$PATH":"$flutterPath/bin/"
export PATH="$PATH":"~/tools/flutter/bin/cache/dart-sdk/bin/"
export PATH="$PATH":"~/.pub-cache/bin"
export PATH="$PATH":"~/.pub-cache/bin/icon_font_generator"

flutter pub global activate icon_font_generator

#----- 以上注释，首次允许时放开 --------

# svg放到icon目录（建议figma全量导出替换），运行此命令，生成ttf
~/.pub-cache/bin/icon_font_generator --from=icons --class-name=TDIcons --out-font=../../assets/tdesign/td_icons.ttf --out-flutter=../../lib/src/components/icon/td_icons.dart