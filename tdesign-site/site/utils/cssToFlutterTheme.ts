/**
 * CSS 变量转 Flutter 主题配置工具
 * 参考: tdesign-component/example/shell/theme/css2JsonTheme.dart
 */

export interface FlutterTheme {
  ref: Record<string, string>;
  color: Record<string, string>;
  radius?: Record<string, number>;
  margin?: Record<string, number>;
  shadow?: Record<string, Array<{
    color: string;
    blurRadius: number;
    spreadRadius: number;
    offset: { x: number; y: number };
  }>>;
}

export interface ThemeOutput {
  light: FlutterTheme;
  dark: FlutterTheme;
}

/**
 * 解析 CSS 内容为键值对
 */
function convertCssToJson(cssContent: string): Record<string, string> {
  const jsonMap: Record<string, string> = {};
  const lines = cssContent.split("\n");

  lines.forEach((line) => {
    const trimmedLine = line.trim();
    if (trimmedLine && !trimmedLine.startsWith("//") && !trimmedLine.startsWith("/*")) {
      // 匹配 CSS 变量: --td-xxx: value;
      const match = trimmedLine.match(/^(--[\w-]+)\s*:\s*(.+?);?\s*$/);
      if (match) {
        jsonMap[match[1]] = match[2];
      }
    }
  });

  return jsonMap;
}

/**
 * 转换为驼峰命名
 * --td-brand-color-1 -> brandColor1
 */
function convertToCamelCase(input: string): string {
  let str = input.replace("--td-", "");
  const parts = str.split("-");
  let result = parts[0];

  for (let i = 1; i < parts.length; i++) {
    if (parts[i]) {
      result += parts[i].charAt(0).toUpperCase() + parts[i].slice(1);
    }
  }

  // 特殊命名处理
  if (result.includes("Secondarycontainer")) {
    result = result.replace("Secondarycontainer", "SecondaryContainer");
  } else if (result.includes("Secondarycomponent")) {
    result = result.replace("Secondarycomponent", "SecondaryComponent");
  } else if (result.includes("Specialcomponent")) {
    result = result.replace("Specialcomponent", "SpecialComponent");
  } else if (result.startsWith("component")) {
    result = result + "Color";
  } else if (result === "textDisabledColor") {
    result = "textColorDisabled";
  } else if (result.startsWith("fontWhite")) {
    result = result.replace("fontWhite", "fontWhColor");
  } else if (result.startsWith("fontGray")) {
    result = result.replace("fontGray", "fontGyColor");
  }

  return result;
}

/**
 * 将 CSS 变量转换为 Flutter 主题配置
 */
export function parseCssToFlutterTheme(cssContent: string): FlutterTheme {
  const jsonMap = convertCssToJson(cssContent);
  const filterMap: Record<string, string> = {};
  const colorKeys = ["brand", "warning", "error", "success", "gray"];

  Object.entries(jsonMap).forEach(([key, value]) => {
    const valueStr = String(value);
    const shouldInclude = colorKeys.some(
      (colorKey) =>
        key.startsWith(`--td-${colorKey}-color`) ||
        key.startsWith("--td-bg-color") ||
        key.startsWith("--td-text-color") ||
        key.startsWith("--td-component") ||
        key.startsWith("--td-font-white") ||
        key.startsWith("--td-font-gray")
    );

    if (shouldInclude) {
      const newKey = convertToCamelCase(key);

      if (valueStr.startsWith("#") || valueStr.startsWith("var")) {
        let colorString = valueStr.replace(";", "");

        if (colorString.length === 4) {
          // 扩展 #eee 为 #eeeeee
          colorString = `#${colorString[1]}${colorString[1]}${colorString[2]}${colorString[2]}${colorString[3]}${colorString[3]}`;
        } else if (colorString.length === 9) {
          // 转换 #rrggbbaa 为 #AARRGGBB
          colorString = `#${colorString.slice(7, 9)}${colorString.slice(1, 7)}`;
        }
        filterMap[newKey] = colorString;
      } else if (valueStr.startsWith("rgba")) {
        // 转换 rgba(r, g, b, a) 为 #AARRGGBB
        try {
          const color = valueStr.replace(/rgba\(|\)|;/g, "");
          const [r, g, b, a] = color.split(",").map((s) => s.trim());
          const alphaInt = Math.round(parseFloat(a) * 255);
          const hexColor =
            "#" +
            alphaInt.toString(16).padStart(2, "0") +
            parseInt(r).toString(16).padStart(2, "0") +
            parseInt(g).toString(16).padStart(2, "0") +
            parseInt(b).toString(16).padStart(2, "0");
          filterMap[newKey] = hexColor.toUpperCase();
        } catch (e) {
          console.error("颜色转换错误:", valueStr, e);
          filterMap[newKey] = "#FFFFFFFF";
        }
      }
    }
  });

  // 处理 var() 引用
  const functionNames = ["Light", "Focus", "Disabled", "Hover", "Active"];
  const defaultNames = ["brandColor", "warningColor", "errorColor", "successColor"];
  const refMap: Record<string, string> = {};
  const removeKeys: string[] = [];

  Object.entries(filterMap).forEach(([key, value]) => {
    const valueStr = String(value);
    if (valueStr.includes("var(")) {
      const field = valueStr.replace(/var\(|\)/g, "");

      // 处理 xxxColorLight -> xxxLightColor
      const funcMatch = functionNames.find((f) => key.endsWith(f));
      if (funcMatch) {
        const reKey = key.replace(`Color${funcMatch}`, `${funcMatch}Color`);
        refMap[reKey] = convertToCamelCase(field);
        removeKeys.push(key);
        return;
      }

      // 处理 brandColor -> brandNormalColor
      if (defaultNames.includes(key)) {
        const reKey = key.replace("Color", "NormalColor");
        refMap[reKey] = convertToCamelCase(field);
        removeKeys.push(key);
        return;
      }

      refMap[key] = convertToCamelCase(field);
      removeKeys.push(key);
    }
  });

  // 移除已处理的 key
  removeKeys.forEach((key) => delete filterMap[key]);

  // 解析圆角
  const radiusMap = parseRadius(jsonMap);

  // 解析间距
  const marginMap = parseMargin(jsonMap);

  // 解析阴影
  const shadowMap = parseShadow(jsonMap);

  return {
    ref: refMap,
    color: filterMap,
    ...(Object.keys(radiusMap).length > 0 && { radius: radiusMap }),
    ...(Object.keys(marginMap).length > 0 && { margin: marginMap }),
    ...(Object.keys(shadowMap).length > 0 && { shadow: shadowMap }),
  };
}

/**
 * 解析圆角变量
 * --td-radius-small: 3px -> radiusSmall: 3
 */
function parseRadius(jsonMap: Record<string, string>): Record<string, number> {
  const radiusMap: Record<string, number> = {};

  Object.entries(jsonMap).forEach(([key, value]) => {
    if (key.startsWith("--td-radius-")) {
      const name = convertToCamelCase(key);
      const numValue = parseFloat(value);
      if (!isNaN(numValue)) {
        radiusMap[name] = numValue;
      }
    }
  });

  return radiusMap;
}

/**
 * 解析间距变量
 * --td-comp-margin-s: 8px -> compMarginS: 8
 */
function parseMargin(jsonMap: Record<string, string>): Record<string, number> {
  const marginMap: Record<string, number> = {};

  Object.entries(jsonMap).forEach(([key, value]) => {
    if (
      key.startsWith("--td-comp-margin") ||
      key.startsWith("--td-comp-padding") ||
      key.startsWith("--td-pop-padding") ||
      key.startsWith("--td-size-")
    ) {
      const name = convertToCamelCase(key);
      // 处理 var() 引用
      let numValue: number;
      if (value.startsWith("var(")) {
        // 尝试从其他变量获取值
        const refKey = value.replace(/var\(|\)/g, "");
        const refValue = jsonMap[refKey];
        numValue = refValue ? parseFloat(refValue) : 0;
      } else {
        numValue = parseFloat(value);
      }
      if (!isNaN(numValue)) {
        marginMap[name] = numValue;
      }
    }
  });

  return marginMap;
}

/**
 * 解析阴影变量
 * --td-shadow-1: 0 1px 10px rgba(0, 0, 0, 5%), ...
 */
function parseShadow(jsonMap: Record<string, string>): Record<string, Array<{
  color: string;
  blurRadius: number;
  spreadRadius: number;
  offset: { x: number; y: number };
}>> {
  const shadowMap: Record<string, Array<{
    color: string;
    blurRadius: number;
    spreadRadius: number;
    offset: { x: number; y: number };
  }>> = {};

  Object.entries(jsonMap).forEach(([key, value]) => {
    // 只处理 --td-shadow-1, --td-shadow-2, --td-shadow-3
    if (key.match(/^--td-shadow-[1-4]$/)) {
      const name = convertToCamelCase(key);
      const shadows = parseShadowValue(value);
      if (shadows.length > 0) {
        shadowMap[name] = shadows;
      }
    }
  });

  return shadowMap;
}

/**
 * 解析单个阴影值
 * "0 1px 10px rgba(0, 0, 0, 5%), 0 4px 5px rgba(0, 0, 0, 8%)"
 */
function parseShadowValue(value: string): Array<{
  color: string;
  blurRadius: number;
  spreadRadius: number;
  offset: { x: number; y: number };
}> {
  const shadows: Array<{
    color: string;
    blurRadius: number;
    spreadRadius: number;
    offset: { x: number; y: number };
  }> = [];

  // 按逗号分割多个阴影（但要注意 rgba 中的逗号）
  const shadowParts = value.split(/,(?![^(]*\))/);

  shadowParts.forEach((part) => {
    const trimmed = part.trim();
    if (!trimmed || trimmed.startsWith("inset")) return;

    // 匹配: offsetX offsetY blurRadius [spreadRadius] color
    // 例如: 0 1px 10px rgba(0, 0, 0, 5%)
    // 或: 0 4px 5px 2px rgba(0, 0, 0, 8%)
    const match = trimmed.match(
      /^(-?[\d.]+(?:px)?)\s+(-?[\d.]+(?:px)?)\s+([\d.]+(?:px)?)\s*(?:([\d.]+(?:px)?)\s+)?(rgba?\([^)]+\)|#[\da-fA-F]+)/
    );

    if (match) {
      const offsetX = parseFloat(match[1]);
      const offsetY = parseFloat(match[2]);
      const blurRadius = parseFloat(match[3]);
      const spreadRadius = match[4] ? parseFloat(match[4]) : 0;
      const colorStr = match[5];

      // 转换颜色为 Flutter 格式
      let color = "#00000000";
      if (colorStr.startsWith("rgba")) {
        const rgbaMatch = colorStr.match(/rgba\((\d+),\s*(\d+),\s*(\d+),\s*([\d.]+%?)\)/);
        if (rgbaMatch) {
          const r = parseInt(rgbaMatch[1]);
          const g = parseInt(rgbaMatch[2]);
          const b = parseInt(rgbaMatch[3]);
          let a = rgbaMatch[4];
          // 处理百分比
          const alpha = a.endsWith("%") ? parseFloat(a) / 100 : parseFloat(a);
          const alphaInt = Math.round(alpha * 255);
          color = (
            "#" +
            alphaInt.toString(16).padStart(2, "0") +
            r.toString(16).padStart(2, "0") +
            g.toString(16).padStart(2, "0") +
            b.toString(16).padStart(2, "0")
          ).toUpperCase();
        }
      } else if (colorStr.startsWith("#")) {
        color = colorStr.toUpperCase();
      }

      shadows.push({
        color,
        blurRadius,
        spreadRadius,
        offset: { x: offsetX, y: offsetY },
      });
    }
  });

  return shadows;
}

/**
 * 生成完整的 Flutter 主题配置
 * @param lightCss Light 模式 CSS (custom-theme + custom-theme-extra)
 * @param darkCss Dark 模式 CSS (custom-theme-dark + custom-theme-extra)
 */
export function generateFlutterTheme(lightCss: string, darkCss: string): ThemeOutput {
  return {
    light: parseCssToFlutterTheme(lightCss),
    dark: parseCssToFlutterTheme(darkCss),
  };
}

/**
 * 从多个 CSS 内容生成主题
 * @param lightThemeCss custom-theme 内容
 * @param darkThemeCss custom-theme-dark 内容
 * @param extraCss custom-theme-extra 内容 (共用)
 */
export function generateFlutterThemeFromParts(
  lightThemeCss: string,
  darkThemeCss: string,
  extraCss: string
): ThemeOutput {
  const lightCss = lightThemeCss + extraCss;
  const darkCss = darkThemeCss + extraCss;
  return generateFlutterTheme(lightCss, darkCss);
}
