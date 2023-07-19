## 2023-04-10 v2.9.1
- 更新 API 定义到 2.30.4
- 修复页面 `onShareAppMessage` 异步形式的定义错误

## 2023-01-12 v3.9.0
- 更新 API 定义到 2.29.1
- 将 xr-frame 的命名空间由 `WechatXrFrame` 改为 `XrFrame`。这是一个 **破坏性改动**

## 2022-09-09 v3.6.0
- 更新 API 定义到 2.26.0
- 更改了部分监听方法及其参数的命名

## 2022-06-24 v3.5.0
- 更新 API 定义到 2.24.6

## 2022-04-01 v3.4.6
- 更新 API 定义到 2.23.2

## 2022-01-20 v3.4.5
- 更新 API 定义到 2.21.3

## 2021-08-24 v3.4.4
- 更新 API 定义到 2.20.1

## 2021-08-24 v3.4.3
- 更新 API 定义到 2.19.2
- 补充自定义组件获取更新性能接口定义

## 2021-08-02 v3.4.2
- 更新 API 定义到 2.19.0
- 重新整理了注释，包括：
  - 加入插件支持情况、版本和说明
  - 将支持和废弃情况挪到前面，使其更不容易因为接口说明太长而被忽略
  - 移除文首、文末和多余（连续超过两个）的空行
  - 修复几个链接

## 2021-07-07 v3.4.1
- 移除一个意外加入的非预期字符

## 2021-07-07 v3.4.0
- 更新 API 定义到 2.18.0
- 更新来自文档代码示例的测试用例
- 更新 npm 依赖以解决安全问题
- 修复 [#202](https://github.com/wechat-miniprogram/api-typings/issues/202), [#204](https://github.com/wechat-miniprogram/api-typings/issues/204)

## 2021-04-21 v3.3.2
- 更新 API 定义到 2.16.1

## 2021-04-09 v3.3.1
- 更新 API 定义到 2.16.0

## 2021-03-02 v3.3.0
- 更新部分新接口定义
- 支持泛型（[#177](https://github.com/wechat-miniprogram/api-typings/issues/177)）
- 支持索引签名，以支持 `wx.requestSubscribeMessage`（[#175](https://github.com/wechat-miniprogram/api-typings/issues/175)）

## 2021-02-22 v3.2.3
- 更新 API 定义到 2.15.0
- 修复 `Component.triggerEvent` 的 `detail` 类型
- 修复几个接口的定义（[#193](https://github.com/wechat-miniprogram/api-typings/issues/193), [#185](https://github.com/wechat-miniprogram/api-typings/issues/185), [#180](https://github.com/wechat-miniprogram/api-typings/issues/180)）
- 修改 `MethodOption` 以解决 [#161](https://github.com/wechat-miniprogram/api-typings/issues/161)（鸣谢：[@Lienviws](https://github.com/Lienviws)）

## 2021-01-14 v3.2.2
- 修复几个接口未 Promise 化的问题

## 2021-01-06 v3.2.1
- 更新 API 定义到 2.14.1
- 补齐 `virtualHost` ([#174](https://github.com/wechat-miniprogram/api-typings/issues/174))

## 2020-11-13 v3.2.0
- 更新 API 定义到 2.14.0
- 补齐 NFC 接口的错误码

## 2020-11-04 v3.1.6
- 补齐 `requirePlugin` 和 `requireMiniProgram`

## 2020-10-29 v3.1.5
- 更新 API 定义
- 修复代码格式问题（`no-unnecessary-qualifier`）

## 2020-10-28 v3.1.4
- 更新 API 定义到 2.13.2
- 为被废弃的接口增加了 `@deprecated` 标识

## 2020-10-14 v3.1.3
- 修复 `ICustomTimelineContent` 的 `query` 的类型

## 2020-09-30 v3.1.2
- 更新 API 定义到 2.13.1

## 2020-09-24 v3.1.1
- 更新 API 定义到 2.13.0
- 改变了嵌套命名空间的写法
- 支持 `Component` 的第五个泛型参数，用于将自定义组件作为页面根组件使用的情况

## 2020-09-22 v3.1.0
- 将代码风格检查从 tslint 迁移到 eslint

## 2020-08-19 v3.0.2
- 更新 API 定义
- 合并 PR [#151](https://github.com/wechat-miniprogram/api-typings/pull/151), [#152](https://github.com/wechat-miniprogram/api-typings/pull/152)，补齐事件类型，补齐 `onShareTimeline`

## 2020-08-19 v3.0.2
- 更新 API 定义
- 合并 PR [#124](https://github.com/wechat-miniprogram/api-typings/pull/124), [#145](https://github.com/wechat-miniprogram/api-typings/pull/145)，修复两个动画接口的问题

## 2020-08-03 v3.0.1
- 更新 API 定义
- 修复某些取消监听的接口（`off`）的参数不为可选值的问题

## 2020-07-30 v3.0.0
- 由于基础库接口基本向前兼容，不再与基础库保持版本同步
- 更新 API 定义到 2.12.0

## 2020-06-15 v2.11.0-1
- 该版本继续合并了一部分完全相同的 interface / callback，是一个 **破坏性改动**，原本字面上引用了这些 interface / callback 的代码可能会报错。
- 为 `Component` 构造器增加第四个泛型，以允许在自定义组件上挂载自定义的字段 ([#133](https://github.com/wechat-miniprogram/api-typings/issues/133))
- 修复一些接口错误 ([#134](https://github.com/wechat-miniprogram/api-typings/issues/134))
- 补齐 `App` 的 `onThemeChange` ([#135](https://github.com/wechat-miniprogram/api-typings/issues/135))
- 补齐 `Page` 的 `onAddToFavorites` ([#136](https://github.com/wechat-miniprogram/api-typings/issues/136))

## 2020-05-20 v2.11.0
- 同步 API 定义到基础库 2.11.0
- 该版本继续合并了一部分完全相同的 interface / callback，是一个 **破坏性改动**，原本字面上引用了这些 interface / callback 的代码可能会报错。
- 修复接口错误 ([#126](https://github.com/wechat-miniprogram/api-typings/issues/126))

## 2020-04-20 v2.10.4
- 同步 API 定义到基础库 2.10.4
- 在之前的版本中，分属于不同接口的两个 interface / callback 即使完全相同，也会拥有不同的名字。在这次更新中，他们将合并为同一个（如 `FileSystemManagerGetFileInfoCompleteCallback` 和 `WxGetFileInfoCompleteCallback` 都变成了 `GetFileInfoCompleteCallback`）。这是一个 **破坏性改动**，原本字面上引用了这些 interface / callback 的代码可能会报错。
- 修复了一些取消监听接口（off callback）的参数错误 ([#120](https://github.com/wechat-miniprogram/api-typings/issues/120))

## 2020-04-03 v2.10.3-1
- 补齐 `Component` 的 `getOpenerEventChannel` ([#112](https://github.com/wechat-miniprogram/api-typings/issues/113) by [@baranwang](https://github.com/baranwang))
- 加入了部分事件的定义 ([#115](https://github.com/wechat-miniprogram/api-typings/issues/115) by [@zenml](https://github.com/zenml))
- 更新了小程序·云开发的 API 定义 ([#92](https://github.com/wechat-miniprogram/api-typings/issues/92))

## 2020-03-26 v2.10.3
- 同步 API 定义到基础库 2.10.3

## 2020-03-18 v2.10.2-1
- 支持 API Promise 化调用 ([#105](https://github.com/wechat-miniprogram/api-typings/issues/105)) 

## 2020-03-06 v2.10.2
- 同步 API 定义到基础库 2.10.2

## 2020-02-10 v2.10.1-1
- 允许重写部分全局变量 (由 `const` 改为 `let`)  ([#102](https://github.com/wechat-miniprogram/api-typings/issues/102)) 
- 补齐 `Page` 上的 `options` 字段 ([#101](https://github.com/wechat-miniprogram/api-typings/issues/101) by [@baranwang](https://github.com/baranwang)) 

## 2020-01-19 v2.10.1
- 同步 API 定义到基础库 2.10.1
- 补齐 `Component` `selectOwnerComponent`, `animate`, `clearAnimation` ([#96](https://github.com/wechat-miniprogram/api-typings/issues/96)) 
- 补齐 `App` `onUnhandledRejection` ([#99](https://github.com/wechat-miniprogram/api-typings/issues/99)) 

## 2020-01-07 v2.10.0-1
- 修复接口错误 ([#95](https://github.com/wechat-miniprogram/api-typings/issues/95)) 

## 2020-01-07 v2.10.0
- 同步 API 定义到基础库 2.10.0

## 2019-12-20 v2.9.4
- 同步 API 定义到基础库 2.9.4
- 修正一些接口错误 ([#88](https://github.com/wechat-miniprogram/api-typings/issues/88)，[#89](https://github.com/wechat-miniprogram/api-typings/issues/89)，[#91](https://github.com/wechat-miniprogram/api-typings/issues/91)) 

## 2019-12-06 v2.9.3
- 同步 API 定义到基础库 2.9.3
- 补齐 `Component` 纯数据字段 (`pureDataPattern`) 
- 支持 `Component` 的属性监听器使用 `string` 类型

## 2019-11-14 v2.9.2
- 同步 API 定义到基础库 2.9.2
- 补齐 `Behaviors` 中缺少的一些选项

## 2019-11-06 v2.9.1
- 同步 API 定义到基础库 2.9.1

## 2019-10-23 v2.9.0
- 同步 API 定义到基础库 2.9.0

## 2019-10-10 v2.8.3-1
- 修复注释文档中不可用的链接
- 组件实例类型支持 `Partial` 的自定义方法 ([用例](https://github.com/wechat-miniprogram/api-typings/blob/master/test/issue.test.ts#L170-L185)) 

## 2019-09-19 v2.8.3
- 同步 API 定义到基础库 2.8.3
- `getApp` 支持范型 ([#77](https://github.com/wechat-miniprogram/api-typings/issues/77)) 
- 修正一些接口错误 ([#73](https://github.com/wechat-miniprogram/api-typings/issues/73), [#75](https://github.com/wechat-miniprogram/api-typings/issues/75), [#79](https://github.com/wechat-miniprogram/api-typings/issues/79)) 
- 补齐 `require`, `exports`, `module.exports` 定义，以支持在没有 `@types/node` 下编译

## 2019-09-10 v2.8.2
- 同步 API 定义到基础库 2.8.2
- 加强了参数为可选值的方法参数类型定义和注释 (如 `FileSystemManager.appendFileSync` 的 `encoding`) 

## 2019-08-30 v2.8.1
- 同步 API 定义到基础库 2.8.1
- 修复了部分最低基础库显示为 `[object Object]` 的问题

## 2019-08-20 v2.8.0-2

- 将 `object` 改为 `Record<string, any>`，以允许任意属性和方法
- 自定义组件属性构造器为 `ObjectConstructor` 时，类型推导为 `Record<string, any>` 而不是 `object`
- 修正 `component` 参数的类型为页面或自定义组件实例
- 补齐 `console: WechatMiniprogram.Console` 全局变量
- 修正一些其他的接口类型错误

## 2019-08-14 v2.8.0-1

- 补齐 `styleIsolation` 到 `ComponentOption`

## 2019-08-14 v2.8.0

- 同步 API 定义到基础库 2.8.0
- 不再向全局暴露 `IAnyObject`，收回到命名空间 `WechatMiniprogram` 内
- 对齐代码规范，使用 4 空格缩进，不再使用分号等
- 小幅改动 behavior, component 和 page 的定义，使其对 data 和 properties 等的类型推断更准确
- 修复了一些其他问题 ([#60](https://github.com/wechat-miniprogram/api-typings/issues/60), [#59](https://github.com/wechat-miniprogram/api-typings/issues/59), [#48](https://github.com/wechat-miniprogram/api-typings/issues/48), [#47](https://github.com/wechat-miniprogram/api-typings/issues/47), [#45](https://github.com/wechat-miniprogram/api-typings/issues/45), [#33](https://github.com/wechat-miniprogram/api-typings/issues/33), [#13](https://github.com/wechat-miniprogram/api-typings/issues/13)) 

## 2019-08-08 v2.7.7-2

- 补齐了部分接口 fail 回调的错误码 ([#51](https://github.com/wechat-miniprogram/api-typings/issues/51)) 

## 2019-08-06 v2.7.7-1

- 重写了 page, component 和 behavior 的定义，替换原来不完整的定义，使其更全面，更准确 ([#46](https://github.com/wechat-miniprogram/api-typings/issues/46), [#40](https://github.com/wechat-miniprogram/api-typings/issues/40), [#30](https://github.com/wechat-miniprogram/api-typings/issues/30), [#28](https://github.com/wechat-miniprogram/api-typings/issues/28), [#27](https://github.com/wechat-miniprogram/api-typings/issues/27)) 

## 2019-07-31 v2.7.7

- 同步 API 定义到基础库 2.7.7
- 将命名空间从 `Wx` 更改为更正式的 `WechatMiniprogram`，这是一个 **破坏性改动**，原本字面上引用了 `Wx` 命名空间的代码可能失效
- 修复了云开发的定义无法使用的问题 ([#25](https://github.com/wechat-miniprogram/api-typings/issues/25), [#32](https://github.com/wechat-miniprogram/api-typings/issues/32), [#42](https://github.com/wechat-miniprogram/api-typings/issues/42)) 
- 修复了一些其它问题 ([#11](https://github.com/wechat-miniprogram/api-typings/issues/11), [#35](https://github.com/wechat-miniprogram/api-typings/issues/35), [#43](https://github.com/wechat-miniprogram/api-typings/issues/43))