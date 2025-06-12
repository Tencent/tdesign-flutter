---
title: Footer 页脚
description: 用于展示App的版权声明、联系信息、重要页面链接和其他相关内容等信息。
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
    return const TDFooter(
      TDFooterType.text,
      text: 'Copyright © 2019-2023 TDesign.All Rights Reserved.',
    );
  }</pre>

</td-code-block>
                                  

基础加链接页脚
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSingleLinkFooter(BuildContext context) {
    // 示例链接列表
    final singleLink = <TDLink>[
      TDLink(
        label: '底部链接',
        style: TDLinkStyle.primary,
        // type: TDLinkType.withSuffixIcon,
        uri: Uri.parse('https://example.com'),
        linkClick: (link) {
          print('点击了链接 $link');
        },
      ),
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
    final links = <TDLink>[
      TDLink(
        label: '底部链接1',
        style: TDLinkStyle.primary,
        uri: Uri.parse('https://example.com'),
        linkClick: (link) {
          print('点击了链接1 $link');
        },
      ),
      TDLink(
        label: '底部链接2',
        style: TDLinkStyle.primary,
        uri: Uri.parse('https://example.com'),
        linkClick: (link) {
          print('点击了链接2 $link');
        },
      ),
    ];
    return Column(
      children: [
        const SizedBox(height: 12),
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
| links | List<TDLink> | const [] | 链接 |
| width | double? | - | 自定义图片宽 |
| height | double? | - | 自定义图片高 |


  