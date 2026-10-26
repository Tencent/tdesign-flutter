# Badge / Button / Tag 组件级 Token（2026-10-17）

本批依用户授权补齐组件 Theme 配置，不扩展站点控制器或 CSS 消息链路，不新增全局 Token 依赖。组件级能力与全局控制器覆盖范围分开统计。

## 逐项映射

小程序参考提交：`a9f3ba680481d438b0be37e2e25cf4a62cf0acb3`；375px基准下rpx按1/2换算，px保持不变。源文件位于官方仓库packages/components/{badge,button,tag}下的同名less文件，原始快照仍保留。

| 小程序组件变量 | Flutter新增配置 | Flutter未配置时的行为 | 显式覆盖优先级 |
| --- | --- | --- | --- |
| --td-badge-bubble-border-radius | TBadgeThemeData.bubbleBorderRadius | 左上/右上/右下10，左下1；不依赖全局radius | TBadge.custom完整自定义内容自行控制；组件字段仅作用bubble |
| --td-button-large-icon-size | TButtonThemeData.largeIconSize | 继续size8，默认24 | ButtonStyle.iconSize优先 |
| --td-button-medium-icon-size | TButtonThemeData.mediumIconSize | 继续size7，默认20 | ButtonStyle.iconSize优先 |
| --td-button-small-icon-size | TButtonThemeData.smallIconSize | 独立18 | ButtonStyle.iconSize优先 |
| --td-button-extra-small-icon-size | TButtonThemeData.extraSmallIconSize | 独立18 | ButtonStyle.iconSize优先 |
| --td-tag-small-padding | TTagThemeData.smallPadding | 原始横6/纵2，按实际边框扣减 | 既有统一padding优先 |
| --td-tag-medium-padding | TTagThemeData.mediumPadding | 原始横8/纵2，按实际边框扣减 | 既有统一padding优先 |
| --td-tag-large-padding | TTagThemeData.largePadding | 原始横8/纵3，按实际边框扣减 | 既有统一padding优先 |
| --td-tag-extra-large-padding | TTagThemeData.extraLargePadding | 原始横16/纵9，按实际边框扣减 | 既有统一padding优先 |

Badge使用BorderRadiusGeometry，支持方向圆角；原先常数移到单一内部默认定义。Button四档为有限非负double，普通和渐变分支共用解析，纯图标默认居中间距使用相同尺寸。Tag四档为EdgeInsets，与既有padding一致表示边框以内的净间距；显式配置后不再次扣边框。custom档不使用四档字段，仅继承统一padding或原默认。

小程序Tag默认净padding（纵/横）为1/5、1/7、2/7、8/15，并始终有1dp透明或可见边框。Flutter保持原有盒模型：outline/lightOutline边框1，其他形态边框0；未配置时默认补偿不变，因此不能声称各形态内部padding数值完全等同小程序。新增字段使用同样的净padding语义，不把净值再当作外部规格重复扣边框，也不因原始数值与size刻度相等而新增绑定。

## 默认、更新与插值

九个字段均nullable；构造、copyWith、lerp及渲染消费完整接入。默认到显式、显式到默认采用有效默认端点；Button使用当前size Token回退；Tag使用当前尺寸和实际边框回退，并处理统一padding与分档padding交叉及中断过渡。copyWith保留未指定配置及未覆盖的过渡；ThemeData.mergeExtension仍整体替换同类型扩展，部分修改应先对原扩展copyWith。

Badge.square、其他徽标形态和custom内容不受bubble字段影响；实例ButtonStyle.iconSize和图标内容自身显式尺寸继续优先；Tag既有统一padding仍优先。本批新增可选能力，无默认外观变化，无需迁移。

## 原六处缺口的最新状态

M020、M035、M090..M093原先没有接入拟定的全局映射；本批均已有组件配置入口。M020气泡、M035小/超小图标仍无对应全局刻度，不能通过现有全局控制器调整。Tag四档仍未新增全局引用，但可用组件Theme配置。四档Button一起补齐，因此六个审计消费点对应九个新公开字段，不是九个新全局Token。

本批继承此前对固定默认的全局联动，不改变大中档Button原有size8/size7行为。验收见[component-token-acceptance.md](component-token-acceptance.md)。

## 最小使用示例

```dart
final theme = TThemeBuilder.light(TThemeData.defaultData())
    .mergeExtension(const TBadgeThemeData(
      bubbleBorderRadius: BorderRadius.all(Radius.circular(8)),
    ))
    .mergeExtension(const TButtonThemeData(smallIconSize: 22))
    .mergeExtension(const TTagThemeData(
      smallPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
    ));

MaterialApp(
  theme: theme,
  home: Scaffold(
    body: Column(
      children: [
        const TBadge(variant: TBadgeVariant.bubble, label: 'NEW'),
        TButton(
          size: TButtonSize.small,
          icon: const Icon(Icons.add),
          onPressed: () {},
        ),
        const TTag('Tag', size: TTagSize.small),
      ],
    ),
  ),
);
```

使用方导入`package:tdesign_flutter/tdesign_flutter.dart`即可使用上例中的公开类型。局部子树可通过Theme安装相同扩展；现有同类型配置需先copyWith再mergeExtension，避免替换其他已配置字段。
