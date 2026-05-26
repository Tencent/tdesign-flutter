## API
### TSwiperPagination
#### 简介
TDesign风格的Swiper指示器样式，与flutter_swiper的Swiper结合使用
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| alignment | Alignment? | - | 当 scrollDirection== Axis.horizontal 时，默认Alignment.bottomCenter 当 scrollDirection== Axis.vertical 时，默认Alignment.centerRight |
| builder | SwiperPlugin | TSwiperPagination.dots | 具体样式 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| margin | EdgeInsetsGeometry | const EdgeInsets.all(10.0) | 指示器和container之间的距离 |

#### 静态成员

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| controls | SwiperPlugin | - | 箭头样式 |
| dots | SwiperPlugin | - | 圆点样式 |
| dotsBar | SwiperPlugin | - | 圆角矩形 + 圆点样式 默认宽度20，高度6 |
| fraction | SwiperPlugin | - | 数字样式 |


### TPageTransformer
#### 简介
TD默认PageTransformer
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| fade | double? | - | 淡化比例 |
| margin | double? | - | 左右间隔 |
| scale | double? | - | 缩放比例 |


#### 工厂构造方法

##### TPageTransformer.margin

普通margin的卡片式

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| margin | double? | 6.0 | 左右间隔 |


##### TPageTransformer.scaleAndFade

缩放或透明的卡片式

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| fade | double? | 1 | 淡化比例 |
| scale | double? | 0.8 | 缩放比例 |
