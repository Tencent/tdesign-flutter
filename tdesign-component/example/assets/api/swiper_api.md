## API
### TDSwiperPagination
#### 简介
TDesign风格的Swiper指示器样式，与flutter_swiper的Swiper结合使用
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| alignment | Alignment? | - | 当 scrollDirection== Axis.horizontal 时，默认Alignment.bottomCenter |
| key | Key? | - |  |
| margin | EdgeInsetsGeometry | const EdgeInsets.all(10.0) | 指示器和container之间的距离 |
| builder | SwiperPlugin | TDSwiperPagination.dots | 具体样式 |

```
```
 ### TDPageTransformer
#### 简介
TD默认PageTransformer
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| fade | double? | - | 淡化比例 |
| scale | double? | - | 缩放比例 |
| margin | double? | - | 左右间隔 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TDPageTransformer.margin  | 普通margin的卡片式 |
| TDPageTransformer.scaleAndFade  | 缩放或透明的卡片式 |
