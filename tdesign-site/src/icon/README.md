---
title: Icon 图标
description: Icon 作为UI构成中重要的元素，一定程度上影响UI界面整体呈现出的风格。
spline: base
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在tdesign_flutter/tdesign_flutter.dart中有所有组件的路径。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

[td_icon_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_icon_page.dart)

### 1 icon示例

icon数量: 2114
            
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
                TDText('筛选Icon请前往TDesign官网(长按网址可复制):'),
                SelectableText(
                    'https://tdesign.tencent.com/icons')
              ],
            ),
          ),
          TDSearchBar(
            action: '搜索',
            onActionClick: (text) {
              setState(() {
                iconList = [];
                isLoading = true;
              });
              Future.delayed(const Duration(milliseconds: 30), () {
                var list = [];
                TDIcons.all.forEach((key, value) {
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
                iconList = TDIcons.all.values;
              });
            },
          ),
          TDCell(
            title: '显示边框',
            noteWidget: TDSwitch(
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
                    isLoading ? const TDText('加载中...') : const TDText('暂无内容'),
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
                                      ? TDTheme.of(context).brandDisabledColor
                                      : Colors.transparent,
                                ),
                                child: Icon(item, size: 32),
                              ),
                              TDText(item.name)
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
                                  


## API
### TDIcons

#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TDIcons._  | 私有构造方法，不支持外部创建，仅提供静态常量给外部使用 |


  