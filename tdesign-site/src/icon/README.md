---
title: Icon 图标
description: Icon 作为UI构成中重要的元素，一定程度上影响UI界面整体呈现出的风格。
spline: base
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

`tdesign_flutter` 中已引入 [`tdesign_icons`](https://pub.dev/packages/tdesign_icons) 图标库，无需额外安装，直接使用即可：

```dart
import 'package:tdesign_icons/tdesign_icons.dart';
```

当然，你也可以在不使用 `tdesign_flutter` 组件库的情况下，单独使用 [`tdesign_icons`](https://pub.dev/packages/tdesign_icons) 图标库。

## 代码演示

[td_icon_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_icon_page.dart)

### 1 icon示例

icon数量: 2340+
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _showAllIcons(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.topLeft,
            child: const Wrap(
              children: [
                TText('筛选Icon请前往TDesign官网(长按网址可复制):'),
                SelectableText(
                    'https://tdesign.tencent.com/icons')
              ],
            ),
          ),
          TSearchBar(
            action: '搜索',
            onActionClick: (text) {
              setState(() {
                iconList = [];
                isLoading = true;
              });
              Future.delayed(const Duration(milliseconds: 30), () {
                var list = [];
                TIcons.all.forEach((key, value) {
                  if (value.name.contains(text)) {
                    list.add(value);
                  }
                });
                setState(() {
                  iconList = list;
                  isLoading = false;
                });
              });
            },
            onClearClick: (_) {
              setState(() {
                iconList = TIcons.all.values;
              });
            },
          ),
          TCell(
            title: '显示边框',
            noteWidget: TSwitch(
              isOn: showBorder,
              onChanged: (value) {
                setState(() {
                  showBorder = value;
                });
                return value;
              },
            ),
          ),
          Builder(builder: (context) {
            if (iconList.isEmpty) {
              return Container(
                height: 300,
                alignment: Alignment.center,
                child:
                    isLoading ? const TText('加载中...') : const TText('暂无内容'),
              );
            }

            var width = MediaQuery.of(context).size.width * 0.4;

            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: SingleChildScrollView(
                  child: Wrap(
                      spacing: 16,
                      runSpacing: 18,
                      children: iconList.map((item) {
                        return SizedBox(
                          width: width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: showBorder
                                      ? TTheme.of(context).brandDisabledColor
                                      : Colors.transparent,
                                ),
                                child: Icon(item, size: 32),
                              ),
                              TText(item.name)
                            ],
                          ),
                        );
                      }).toList()),
                ));
          })
        ],
      ),
    );
  }</pre>

</td-code-block>
                                  
