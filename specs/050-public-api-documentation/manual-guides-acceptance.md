# 手写指南同步至 1.0

- 快速开始以根 README 为来源，通过统一同步脚本维护站点和包副本。
- 主题与深色模式使用 context.tTheme、TThemeData.defaultData/fromJson、TThemeBuilder.light/dark；资源代理使用 setTResourceBuilder。
- 常见问题说明 Flutter >=3.32.0、Dart >=3.8.0，移除旧文本 padding 用法，源码链接使用实际 develop 路径；版本计划指向 Releases/Issues，不承诺月度发布。
- 本地指南使用 pnpm dev 同时启动站点和 Flutter Web。
- MIT 指向仓库 LICENSE。APK 地址 HEAD 返回 200、Android APK MIME；二维码重新生成且解码为同一 APK 地址。站点副本内嵌二维码，避免依赖部署前缀或线上旧文件。
- 移除 HTML 图片按 URL 是否含 qrcode 的过滤，保留正常图片渲染。
- 深色模式完整示例 Flutter 3.32.0 与本地 latest 3.47.6 analyze 均无问题。
- 站点构建通过；示例文档转换 12 项测试通过；57 个组件页面映射 360 个生成示例。
- 构建页面验收：二维码图像已加载（naturalWidth=280），MIT href 指向 develop/LICENSE；常见问题中的版本节奏、SDK 要求及源码链接已显示，深色模式页面显示新的完整示例。
- 正式上线仍需核对 CDN APK 是否为目标发布版本、站点资源缓存及真实设备下载安装；现有 CDN 文件可访问不等同于已发布 1.0 APK。
