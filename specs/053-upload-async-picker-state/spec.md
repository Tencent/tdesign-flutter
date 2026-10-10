# Upload 异步选择状态修复

基线：origin/develop e724cd0c4。范围仅 Upload 源码、API 注释/生成产物及既有组件回归。

## 行为契约

- 同一实例只允许一个 picker 在途；重复点击不启动新请求，完成/取消/失败后可以重试。
- 完成时使用最新受控 files、onChanged、maxFiles、maxFileSize；新增批次超限时整批拒绝。
- 禁用只阻止新的交互，不取消已经开始的选择；在途请求完成后仍按最新受控列表与限制校验并交付结果、校验错误或选择器错误。
- 完成时优先使用当前回调；当前回调为空时回退到请求开始时的回调。卸载后不再通知；布局切换时在途状态保留。
- 仅 picker/读取文件异常进入 onError。业务回调异常继续向外传播。
- 保留公开 TUpload 的 StatelessWidget 基类、构造签名和默认值；不增加网络上传能力。

## 风险表

| 风险 | 基线触发/影响 | 修复 | 回归 |
| --- | --- | --- | --- |
| U1 / P1 | 等待期间父级替换文件，完成后旧快照覆盖新文件 | 持久私有状态读取最新受控列表 | latest parent files + immutable list |
| U2 / P1 | 两次选择同时开始，后完成的请求覆盖先前文件 | 同实例拒绝重入，完成后可再选择 | reentry + next request keeps both files |
| U3 / P2 | 等待期间父级更新配置，旧回调/限制继续生效 | 完成时读取最新配置；临时禁用不取消在途请求，缺失回调回退到请求开始时的回调；卸载后不通知 | disabled/re-enabled result + validation/error delivery + updated limits/layout + unmount |

正常使用不要求迁移。依赖同一实例并发调用 picker 的代码现在只启动一次选择，这是修复数据丢失所需的行为边界，已在 dartdoc 说明。
