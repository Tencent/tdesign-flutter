## API
### TToast

#### 静态方法

##### TToast.dismissAll

关闭所有Toast

返回类型：`void`

##### TToast.dismissLoading

关闭加载Toast（向后兼容）

返回类型：`void`

##### TToast.dismissToast

关闭指定的Toast

返回类型：`void`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| toastId | String | - | - |


##### TToast.showFail

失败提示Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String? | - | - |
| direction | IconTextDirection | IconTextDirection.horizontal | - |
| context | BuildContext | - | - |
| duration | Duration | const Duration(milliseconds: 3000) | - |
| preventTap | bool? | - | - |
| backgroundColor | Color? | - | - |
| maxLines | int? | - | - |
| textStyle | TextStyle? | - | - |
| iconSize | double? | - | - |
| iconColor | Color? | - | - |
| toastId | String? | - | - |


##### TToast.showIconText

带图标的Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String? | - | - |
| icon | IconData? | - | - |
| direction | IconTextDirection | IconTextDirection.horizontal | - |
| context | BuildContext | - | - |
| duration | Duration | const Duration(milliseconds: 3000) | - |
| preventTap | bool? | - | - |
| backgroundColor | Color? | - | - |
| maxLines | int? | - | - |
| textStyle | TextStyle? | - | - |
| iconSize | double? | - | - |
| iconColor | Color? | - | - |
| toastId | String? | - | - |


##### TToast.showLoading

带文案的加载Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | - |
| text | String? | - | - |
| duration | Duration | const Duration(seconds: 99999999) | - |
| preventTap | bool? | - | - |
| customWidget | Widget? | - | - |
| backgroundColor | Color? | - | - |
| textStyle | TextStyle? | - | - |
| iconSize | double? | - | - |
| iconColor | Color? | - | - |
| toastId | String? | - | - |


##### TToast.showLoadingWithoutText

不带文案的加载Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | - |
| duration | Duration | const Duration(seconds: 99999999) | - |
| preventTap | bool? | - | - |
| backgroundColor | Color? | - | - |
| iconSize | double? | - | - |
| iconColor | Color? | - | - |
| toastId | String? | - | - |


##### TToast.showSuccess

成功提示Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String? | - | - |
| direction | IconTextDirection | IconTextDirection.horizontal | - |
| context | BuildContext | - | - |
| duration | Duration | const Duration(milliseconds: 3000) | - |
| preventTap | bool? | - | - |
| backgroundColor | Color? | - | - |
| maxLines | int? | - | - |
| textStyle | TextStyle? | - | - |
| iconSize | double? | - | - |
| iconColor | Color? | - | - |
| toastId | String? | - | - |


##### TToast.showText

普通文本Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String? | - | - |
| context | BuildContext | - | - |
| duration | Duration | const Duration(milliseconds: 3000) | - |
| maxLines | int? | - | - |
| constraints | BoxConstraints? | - | - |
| preventTap | bool? | - | - |
| customWidget | Widget? | - | - |
| backgroundColor | Color? | - | - |
| textStyle | TextStyle? | - | - |
| toastId | String? | - | - |


##### TToast.showWarning

警告Toast

返回类型：`String`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String? | - | - |
| direction | IconTextDirection | IconTextDirection.horizontal | - |
| context | BuildContext | - | - |
| duration | Duration | const Duration(milliseconds: 3000) | - |
| preventTap | bool? | - | - |
| backgroundColor | Color? | - | - |
| maxLines | int? | - | - |
| textStyle | TextStyle? | - | - |
| iconSize | double? | - | - |
| iconColor | Color? | - | - |
| toastId | String? | - | - |


### IconTextDirection
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| horizontal | 横向 |
| vertical | 竖向 |
