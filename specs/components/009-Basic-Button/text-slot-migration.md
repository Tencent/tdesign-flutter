# Button / NavBar 文字默认值迁移

## 一条规则

普通位置用正文默认值，组件文字槽用组件默认值，自己明确设置的样式优先。

| 位置或配置 | 当前含义 |
| --- | --- |
| 普通位置的 `TText('说明')` | 最近 TD 文字主题默认值；未配置字段回退 TD 正文 Token。 |
| `TButton(child: TText('提交'), onPressed: ...)` | 按钮尺寸、配色和当前状态的文字默认值。 |
| `TNavBar(title: TText('首页'))` | 导航标题字体、标题色以及单行省略默认。 |
| 实例 `TText.style` / `font` | 显式字段覆盖默认；style 同名字段优先于 font。 |
| 外层 `TTextThemeData` | 通用子树默认值，不强制覆盖组件场景默认；重复字段由组件文字槽覆盖。 |
| 内容内部更近的 `TTextThemeData` | 在该文字槽内重新提供局部默认；实例显式字段仍优先。 |

未设置style、空TextStyle和只设置部分字段遵循同一解析规则。全局字体族及各类文字规格使用TD Token；正文规格不等于按钮文案或导航标题规格。TText仍不从外部DefaultTextStyle.style或Material TextTheme自动获取字体和颜色；方向、MediaQuery缩放及已有段落环境行为保持。

## 哪些用法需要检查

这是默认行为 breaking change，没有 API 签名变化或新配置。无样式/空样式 TText、部分显式样式、依赖外层通用文字主题的内容以及复合文字子树可能改变字号、行高、字重、颜色、自然宽度和省略位置。原生Text应保持现有外观；不据此承诺所有业务页面无变化。

默认Token下，大/中按钮TText从正文14/22常规字重改为按钮16/24、600；小/超小按钮字号行高仍14/22，但字重和配色接受按钮默认。NavBar默认标题从正文14/22改为18/26、600，颜色使用标题配置。主题自定义后数值以实际Token/组件样式为准。

## 直接使用组件默认值

以下为放入现有TD应用的核心片段；包已导入 `package:tdesign_flutter/tdesign_flutter.dart`，`onPressed` 使用业务回调：

```dart
TButton(
  colorPreset: TButtonColorPreset.primary,
  onPressed: () {},
  child: const TText('提交'),
)

const TNavBar(title: TText('首页'))
```

仅覆盖颜色：`TText('提交', style: TextStyle(color: Colors.red))`；红色保留，字号、行高、字重等未设置字段接受组件默认。显式颜色也会覆盖禁用前景色，需由调用方确认可读性。

## 保留旧正文外观

若过去故意使用正文外观，不再依赖组件外层通用文字主题。用当前上下文读取原正文默认，然后在文字实例显式设置：

```dart
Widget legacyBodyLabel(BuildContext context, String label) {
  final font = context.tTheme.fontBodyMedium;
  return TText(
    label,
    style: TextStyle(
      fontSize: font?.size ?? 14,
      height: font?.height ?? 22 / 14,
      fontWeight: font?.fontWeight ?? FontWeight.w400,
      color: context.tTheme.textColorPrimary,
    ),
  );
}
```

此示例保留默认正文的四项排版/配色；若旧外观还依赖外层文字主题的字距、字体族等字段，应同时显式带入那些值，不能将此片段当作恢复任意历史主题的通用函数。也可在内容内部用局部TTextThemeData区分主副标题，合并已有扩展而不是替换其他主题扩展。

复合NavBar标题中的每个TText都接受标题默认；副标题需要更小或不同颜色时，给副标题明确style。TText.rich基础样式同理，span的显式样式仍优先。TextStyle(inherit:false)沿用Flutter整体替换语义，不代表继续合并未指定字段。

## 消费组件和未改范围

Dialog action.child 经Button也接受按钮文字默认；DropdownMenu/Upload内置原生Text预期不变；Fab默认字符串已显式读取按钮样式，TFab.child替代整个按钮、不在本scope范围。Button.icon、背景/前景装饰回调、NavBar leading/actions、belowTitleWidget/flexibleSpace未新增文字默认。

全局 TText/Resolve/Scope 可执行代码、Material隔离、工具链和CI入口不变。不引入兼容开关、自动类型判断或按style有无切换契约。
