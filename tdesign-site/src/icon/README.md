---
title: Icon 图标
description: 
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

icon数量: 244
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _showAllIcons(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Wrap(
        children: [
          Container(
            child: TDButton(text: showBorder? '隐藏边框':'显示边框',
              shape: TDButtonShape.filled,
              onTap: (){
                setState(() {
                  showBorder = !showBorder;
                });
              },),
            margin: const EdgeInsets.only(bottom: 16),
          ),
          for (var iconData in TDIcons.all.values) SizedBox(
            height: 100,
            width: 175,

            child: Column(
              children: [
                Container(
                  color: showBorder ? TDTheme.of(context).brandDisabledColor : Colors.transparent,
                  child: Icon(iconData),
                ),
                TDText(iconData.name)
              ],
            ),
          )
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


  