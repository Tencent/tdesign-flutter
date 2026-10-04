# 实现方案

保留既有公开签名，BackTop 校验异步返回后的 controller 身份、绑定与顶端位置；NoticeBar 用私有非竞争点击观察器保留子组件手势，过滤位移、超时、取消和多指。补全公开字段与方法参数 dartdoc，修正 manifest 与深色模式示例，再从源码生成 API。测试加入已有登记文件，最后全量双 SDK 回归。

额外核对 manifest 中已删除的旧类型名称，移除无效选择项并使用现行 TMessageMarquee；不将内部类暴露为新 API。
