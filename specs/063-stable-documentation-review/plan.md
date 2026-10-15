# 实施方案

- site.config将非菜单路由单列，router注册迁移页和旧深色模式重定向；共享文档链接转换复用当前地址。
- 稳定版用户文案统一修改README、快速开始、迁移开头与FAQ，包内副本继续同步生成。
- 贡献规范保留唯一正文，开头改为面向贡献者的简介和Spec链接。
- 自定义主题使用真实Dart源码的JSON/局部Theme/明暗配置片段；国际化引用完整IntlResourceDelegate及生成的AppLocalizations，通过现有Example环境运行。
- 扩展现有Theme Demo测试验证分组/Widget、浅深色与自定义重建；不把源码同源或测试通过称为像素验收。
- 外部教程尽量改为站内指南；核对保留外链和当前仓库源文件。旧转换脚本不再作为支持全部Token的推荐入口。
