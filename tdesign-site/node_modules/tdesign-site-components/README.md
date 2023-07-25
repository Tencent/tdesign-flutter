# TDesign 官网 webcomponents 组件

## 开发

```bash
# 安装
npm install

# 启动
npm dev
```

调试 `index.html` 页面

## 构建

```bash
npm build
```

## 使用

```javascript
// 引入 es 代码和通用样式
import 'tdesign-site-components';
import 'tdesign-site-components/lib/styles/style.css';

// 将 webcomponents 组件拼接成页面
<td-doc-layout>
  <td-header slot="header"></td-header>
  <td-doc-aside slot="doc-aside" title="Vue for Web"></td-doc-aside>

  <td-doc-content slot="doc-content">
    <td-doc-header slot="doc-header">
      <img slot="badge" src="" />
    </td-doc-header>

    <td-doc-tabs></td-doc-tabs>

    <div name="DEMO">文档内容</div>

    <td-doc-demo></td-doc-demo>

    <td-doc-footer slot="doc-footer"></td-doc-footer>
  </td-doc-content>
</td-doc-layout>
```
