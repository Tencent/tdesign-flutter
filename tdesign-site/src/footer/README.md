---
title: Footer 页脚
description: 用于展示App的版权声明、联系信息、重要页面链接和其他相关内容等信息。
spline: data
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在 `tdesign_flutter/tdesign_flutter.dart` 中有所有组件的路径。

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
    return const TFooter(
      TFooterType.text,
      text: 'Copyright © 2019-2023 TDesign.All Rights Reserved.',
    );
  }</pre>

</td-code-block>
                                  

基础加链接页脚
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSingleLinkFooter(BuildContext context) {
    return TFooter(
      TFooterType.link,
      links: [
        TLink(
          label: '底部链接',
          style: TLinkStyle.primary,
          type: TLinkType.withSuffixIcon,
          uri: Uri.parse('https://example.com'),
          linkClick: (link) {
            print('点击了链接 $link');
          },
        ),
      ],
      text: 'Copyright © 2019-2023 TDesign.All Rights Reserved.',
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLinksFooter(BuildContext context) {
    return TFooter(
      TFooterType.link,
      links: [
        TLink(
          label: '底部链接1',
          style: TLinkStyle.primary,
          uri: Uri.parse('https://example.com'),
          linkClick: (link) {
            print('点击了链接1 $link');
          },
        ),
        TLink(
          label: '底部链接2',
          style: TLinkStyle.primary,
          uri: Uri.parse('https://example.com'),
          linkClick: (link) {
            print('点击了链接2 $link');
          },
        ),
      ],
      text: 'Copyright © 2019-2023 TDesign.All Rights Reserved.',
    );
  }</pre>

</td-code-block>
                                  

品牌页脚
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBrandFooter(BuildContext context) {
    return const TFooter(
      TFooterType.brand,
      logo: 'assets/img/t_brand.png',
      width: 204,
    );
  }</pre>

</td-code-block>
                                  


## API
### TFooter
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| type | TFooterType | - | 样式 |
| height | double? | - | 自定义图片高 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| links | List<TLink> | const [] | 链接 |
| logo | String? | - | 品牌图片 |
| text | String | '' | 文字 |
| width | double? | - | 自定义图片宽 |


### TFooterType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| text | 文字样式 |
| link | 链接样式 |
| brand | 品牌样式 |


  