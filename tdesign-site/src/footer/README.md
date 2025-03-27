---
title: Footer 页脚
description: 可以折叠/展开的内容区域。
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

[td_footer_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_footer_page.dart)

### 1 组件类型

基础页脚
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildFooter(BuildContext context) {
    return SizedBox(
      height: 30,
      child:  TDFooter(
        TDFooterType.text,
        text: 'Copyright © 2019-2023 TDesign.All Rights Reserved.',
      ),
    );

  }</pre>

</td-code-block>
                                  

基础加链接页脚
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSingleLinkFooter(BuildContext context) {
    // 示例链接列表
    final singleLink = <LinkObj>[
      LinkObj(name: '底部链接', uri: Uri.parse('https://example.com')),
    ];

    return TDFooter(
      TDFooterType.link,
      links: singleLink,
      text: 'Copyright © 2019-2023 TDesign.All Rights Reserved.',
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLinksFooter(BuildContext context) {
    final links = <LinkObj>[
      LinkObj(name: '底部链接', uri: Uri.parse('https://example.com')),
      LinkObj(name: '底部链接', uri: Uri.parse('https://example.com')),
    ];
    return Column(
      children: [
        SizedBox(height: 12),
        TDFooter(
          TDFooterType.link,
          links: links,
          text: 'Copyright © 2019-2023 TDesign.All Rights Reserved.',
        )
      ],
    );
  }</pre>

</td-code-block>
                                  

品牌页脚
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBrandFooter(BuildContext context) {
    return TDFooter(
      TDFooterType.brand,
      logo: 'assets/img/td_brand.png',
      width: 204,
      height: 48,
    );
  }</pre>

</td-code-block>
                                  


## API
### TDFooter
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| type | TDFooterType | type | 样式 |
| key |  | - |  |
| logo | String? | - | 品牌图片 |
| text | String | '' | 文字 |
| links | List<LinkObj> | const [] | 链接 |
| isWithUnderline | bool | false | 是否显示下滑线 |
| width | double? | - | 自定义图片宽 |
| height | double? | - | 自定义图片高 |


  