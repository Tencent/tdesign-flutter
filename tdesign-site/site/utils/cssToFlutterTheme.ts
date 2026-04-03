/**
 * CSS 变量转 Flutter 主题配置工具
 * 参考: tdesign-component/example/shell/theme/css2JsonTheme.dart
 */

import { logger } from './config';

export interface FlutterTheme {
  ref: Record<string, string>;
  color: Record<string, string>;
  radius?: Record<string, number>;
  margin?: Record<string, number>;  // Flutter parseThemeData 读取的是 "margin" 字段
  shadow?: Record<string, Array<{
    color: string;
    blurRadius: number;
    spreadRadius: number;
    offset: { x: number; y: number };
  }>>;
  font?: Record<string, { size: number; lineHeight: number }>;
}

export interface ThemeOutput {
  light: FlutterTheme;
  dark: FlutterTheme;
}

/**
 * 解析 CSS 内容为键值对
 * 
 * style 标签内容格式通常为:
 * :root { --td-xxx: value; ... }
 * 或直接是 --td-xxx: value; ... 
 */
function convertCssToJson(cssContent: string): Record<string, string> {
  const jsonMap: Record<string, string> = {};
  
  if (!cssContent || typeof cssContent !== 'string') {
    return jsonMap;
  }
  
  // 用正则全局匹配所有 CSS 变量定义，不依赖逐行解析
  // 这样不管 CSS 是否被 :root {} 包裹都能正确解析
  const varRegex = /(--td-[\w-]+)\s*:\s*([^;]+);/g;
  let match;
  
  while ((match = varRegex.exec(cssContent)) !== null) {
    const key = match[1].trim();
    const value = match[2].trim();
    if (key && value) {
      jsonMap[key] = value;
    }
  }
  
  logger.debug(`解析 CSS 变量: 共 ${Object.keys(jsonMap).length} 个`);
  
  return jsonMap;
}

/**
 * 转换为Flutter端期望的token名称格式
 * 根据td_default_theme.dart中的映射关系进行转换
 */
function convertToFlutterTokenName(input: string): string {
  let str = input.replace("--td-", "");
  const parts = str.split("-");
  let result = parts[0];

  for (let i = 1; i < parts.length; i++) {
    if (parts[i]) {
      result += parts[i].charAt(0).toUpperCase() + parts[i].slice(1);
    }
  }

  // 根据Flutter端期望的格式进行特殊映射
  const tokenMappings: Record<string, string> = {
    // 品牌色映射
    'brandColor1': 'brandColor1',
    'brandColor2': 'brandColor2',
    'brandColor3': 'brandColor3',
    'brandColor4': 'brandColor4',
    'brandColor5': 'brandColor5',
    'brandColor6': 'brandColor6',
    'brandColor7': 'brandColor7',
    'brandColor8': 'brandColor8',
    'brandColor9': 'brandColor9',
    'brandColor10': 'brandColor10',
    
    // 警告色映射
    'warningColor1': 'warningColor1',
    'warningColor2': 'warningColor2',
    'warningColor3': 'warningColor3',
    'warningColor4': 'warningColor4',
    'warningColor5': 'warningColor5',
    'warningColor6': 'warningColor6',
    'warningColor7': 'warningColor7',
    'warningColor8': 'warningColor8',
    'warningColor9': 'warningColor9',
    'warningColor10': 'warningColor10',
    
    // 错误色映射
    'errorColor1': 'errorColor1',
    'errorColor2': 'errorColor2',
    'errorColor3': 'errorColor3',
    'errorColor4': 'errorColor4',
    'errorColor5': 'errorColor5',
    'errorColor6': 'errorColor6',
    'errorColor7': 'errorColor7',
    'errorColor8': 'errorColor8',
    'errorColor9': 'errorColor9',
    'errorColor10': 'errorColor10',
    
    // 成功色映射
    'successColor1': 'successColor1',
    'successColor2': 'successColor2',
    'successColor3': 'successColor3',
    'successColor4': 'successColor4',
    'successColor5': 'successColor5',
    'successColor6': 'successColor6',
    'successColor7': 'successColor7',
    'successColor8': 'successColor8',
    'successColor9': 'successColor9',
    'successColor10': 'successColor10',
    
    // 灰色映射
    'grayColor1': 'grayColor1',
    'grayColor2': 'grayColor2',
    'grayColor3': 'grayColor3',
    'grayColor4': 'grayColor4',
    'grayColor5': 'grayColor5',
    'grayColor6': 'grayColor6',
    'grayColor7': 'grayColor7',
    'grayColor8': 'grayColor8',
    'grayColor9': 'grayColor9',
    'grayColor10': 'grayColor10',
    'grayColor11': 'grayColor11',
    'grayColor12': 'grayColor12',
    'grayColor13': 'grayColor13',
    'grayColor14': 'grayColor14',
    
    // 字体颜色映射 (CSS: --td-font-white-* → Flutter: fontWhColor*)
    'fontWhite1': 'fontWhColor1',
    'fontWhite2': 'fontWhColor2',
    'fontWhite3': 'fontWhColor3',
    'fontWhite4': 'fontWhColor4',
    'fontGray1': 'fontGyColor1',
    'fontGray2': 'fontGyColor2',
    'fontGray3': 'fontGyColor3',
    'fontGray4': 'fontGyColor4',
    
    // 背景色映射
    'bgColorPage': 'bgColorPage',
    'bgColorContainer': 'bgColorContainer',
    'bgColorContainerSelect': 'bgColorContainerSelect',
    'bgColorSpecialComponent': 'bgColorSpecialComponent',
    
    // 文本颜色映射
    'textColorPrimary': 'textColorPrimary',
    'textColorSecondary': 'textColorSecondary',
    'textColorPlaceholder': 'textColorPlaceholder',
    'textColorDisabled': 'textColorDisabled',
    'textColorBrand': 'textColorBrand',
    'textColorLink': 'textColorLink',
    'textColorAnti': 'textColorAnti',
    
    // 组件颜色映射 (CSS: --td-component-stroke → Flutter: componentStrokeColor)
    'componentStroke': 'componentStrokeColor',
    'componentBorder': 'componentBorderColor',
  };

  // 如果存在映射关系，使用映射后的名称
  if (tokenMappings[result]) {
    return tokenMappings[result];
  }

  return result;
}

/**
 * 构建Flutter端期望的引用映射关系
 * 根据td_default_theme.dart中的ref映射进行构建
 */
function buildFlutterRefMappings(jsonMap: Record<string, string>): Record<string, string> {
  const refMap: Record<string, string> = {};
  
  // 品牌色引用映射
  refMap['brandLightColor'] = 'brandColor1';
  refMap['brandFocusColor'] = 'brandColor2';
  refMap['brandDisabledColor'] = 'brandColor3';
  refMap['brandHoverColor'] = 'brandColor6';
  refMap['brandNormalColor'] = 'brandColor7';
  refMap['brandActiveColor'] = 'brandColor8';
  refMap['brandColorLightHover'] = 'brandColor2';
  
  // 错误色引用映射
  refMap['errorLightColor'] = 'errorColor1';
  refMap['errorFocusColor'] = 'errorColor2';
  refMap['errorDisabledColor'] = 'errorColor3';
  refMap['errorHoverColor'] = 'errorColor5';
  refMap['errorNormalColor'] = 'errorColor6';
  refMap['errorActiveColor'] = 'errorColor7';
  refMap['errorColorLightHover'] = 'errorColor2';
  
  // 警告色引用映射
  refMap['warningLightColor'] = 'warningColor1';
  refMap['warningFocusColor'] = 'warningColor2';
  refMap['warningDisabledColor'] = 'warningColor3';
  refMap['warningHoverColor'] = 'warningColor4';
  refMap['warningNormalColor'] = 'warningColor5';
  refMap['warningActiveColor'] = 'warningColor6';
  refMap['warningColorLightHover'] = 'warningColor2';
  
  // 成功色引用映射
  refMap['successLightColor'] = 'successColor1';
  refMap['successFocusColor'] = 'successColor2';
  refMap['successDisabledColor'] = 'successColor3';
  refMap['successHoverColor'] = 'successColor4';
  refMap['successNormalColor'] = 'successColor5';
  refMap['successActiveColor'] = 'successColor6';
  refMap['successColorLightHover'] = 'successColor2';
  
  // 背景色引用映射
  refMap['bgColorPage'] = 'grayColor2';
  refMap['bgColorContainerHover'] = 'grayColor1';
  refMap['bgColorContainerActive'] = 'grayColor3';
  refMap['bgColorSecondaryContainer'] = 'grayColor1';
  refMap['bgColorSecondaryContainerHover'] = 'grayColor2';
  refMap['bgColorSecondaryContainerActive'] = 'grayColor4';
  refMap['bgColorComponent'] = 'grayColor3';
  refMap['bgColorComponentHover'] = 'grayColor4';
  refMap['bgColorComponentActive'] = 'grayColor6';
  refMap['bgColorComponentDisabled'] = 'grayColor2';
  refMap['bgColorSecondaryComponent'] = 'grayColor4';
  refMap['bgColorSecondaryComponentHover'] = 'grayColor5';
  refMap['bgColorSecondaryComponentActive'] = 'grayColor6';
  
  // 文本颜色引用映射
  refMap['textColorPrimary'] = 'fontGyColor1';
  refMap['textColorSecondary'] = 'fontGyColor2';
  refMap['textColorPlaceholder'] = 'fontGyColor3';
  refMap['textDisabledColor'] = 'fontGyColor4';
  refMap['textColorBrand'] = 'brandColor7';
  refMap['textColorLink'] = 'brandColor8';
  // 组件颜色引用映射
  refMap['componentStrokeColor'] = 'grayColor3';
  refMap['componentBorderColor'] = 'grayColor4';
  
  return refMap;
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

    // 添加字体大小相关的CSS变量处理（排除颜色变量和字体复合属性）
    const isFontSize = key.startsWith("--td-font-size-") || 
                      key.startsWith("--td-line-height-");

    // 排除已被颜色处理的变量
    if (shouldInclude) {
      // 使用新的Flutter端期望的token名称格式
      const newKey = convertToFlutterTokenName(key);

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
          logger.error("颜色转换错误:", valueStr, e);
          filterMap[newKey] = "#FFFFFFFF";
        }
      } else if (isFontSize) {
        // 处理字体大小值
        const fontSize = parseFloat(valueStr);
        if (!isNaN(fontSize)) {
          filterMap[newKey] = fontSize.toString();
        }
      }
    }
  });

  // 使用新的Flutter端期望的引用映射
  const refMap = buildFlutterRefMappings(jsonMap);

  // 处理 var() 引用
  const functionNames = ["Light", "Focus", "Disabled", "Hover", "Active"];
  const defaultNames = ["brandColor", "warningColor", "errorColor", "successColor"];
  const removeKeys: string[] = [];

  Object.entries(filterMap).forEach(([key, value]) => {
    const valueStr = String(value);
    if (valueStr.includes("var(")) {
      const field = valueStr.replace(/var\(|\)/g, "");

      // 处理 xxxColorLight -> xxxLightColor
      const funcMatch = functionNames.find((f) => key.endsWith(f));
      if (funcMatch) {
        const reKey = key.replace(`Color${funcMatch}`, `${funcMatch}Color`);
        refMap[reKey] = convertToFlutterTokenName(field);
        removeKeys.push(key);
        return;
      }

      // 处理 brandColor -> brandNormalColor
      if (defaultNames.includes(key)) {
        const reKey = key.replace("Color", "NormalColor");
        refMap[reKey] = convertToFlutterTokenName(field);
        removeKeys.push(key);
        return;
      }

      refMap[key] = convertToFlutterTokenName(field);
      removeKeys.push(key);
    }
  });

  // 移除已处理的 key
  removeKeys.forEach((key) => delete filterMap[key]);

  // 解析圆角
  const radiusMap = parseRadius(jsonMap);

  // 解析间距
  const spacerMap = parseMargin(jsonMap);

  // 解析阴影
  const shadowMap = parseShadow(jsonMap);

  // 解析字体大小变量
  const fontMap = parseFont(jsonMap);

  return {
    ref: refMap,
    color: filterMap,
    ...(Object.keys(radiusMap).length > 0 && { radius: radiusMap }),
    ...(Object.keys(spacerMap).length > 0 && { margin: spacerMap }),
    ...(Object.keys(shadowMap).length > 0 && { shadow: shadowMap }),
    ...(Object.keys(fontMap).length > 0 && { font: fontMap }),
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
      const name = convertToFlutterTokenName(key);
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
 * 
 * TDesign CSS 变量是按倍数命名：
 *   --td-spacer: 8px (基础值)
 *   --td-spacer-1: 8px (1倍)
 *   --td-spacer-2: 16px (2倍)
 * 
 * Flutter spacerMap 是按像素值命名：
 *   spacer4: 4, spacer8: 8, spacer16: 16, ...
 * 
 * 所以需要解析实际像素值，然后用像素值作为 key
 * 
 * 注意：Flutter parseThemeData 读取的是 JSON 中的 "margin" 字段
 */
function parseMargin(jsonMap: Record<string, string>): Record<string, number> {
  const spacerMap: Record<string, number> = {};

  Object.entries(jsonMap).forEach(([key, value]) => {
    // 匹配 --td-spacer 系列变量
    if (key.startsWith("--td-spacer")) {
      // 解析实际像素值
      let numValue: number;
      if (value.startsWith("var(")) {
        const refKey = value.replace(/var\(|\)/g, "");
        const refValue = jsonMap[refKey];
        numValue = refValue ? parseFloat(refValue) : 0;
      } else {
        numValue = parseFloat(value);
      }
      
      if (!isNaN(numValue) && numValue > 0) {
        // 用像素值作为 key，匹配 Flutter 的命名：spacer4, spacer8, spacer16...
        const flutterKey = `spacer${Math.round(numValue)}`;
        spacerMap[flutterKey] = numValue;
        logger.debug(`解析间距: ${key} = ${value} → ${flutterKey}: ${numValue}`);
      }
    }
    
    // 同时处理 --td-comp-margin, --td-comp-padding 等
    if (
      key.startsWith("--td-comp-margin") ||
      key.startsWith("--td-comp-padding") ||
      key.startsWith("--td-pop-padding")
    ) {
      const name = convertToFlutterTokenName(key);
      let numValue: number;
      if (value.startsWith("var(")) {
        const refKey = value.replace(/var\(|\)/g, "");
        const refValue = jsonMap[refKey];
        numValue = refValue ? parseFloat(refValue) : 0;
      } else {
        numValue = parseFloat(value);
      }
      if (!isNaN(numValue)) {
        spacerMap[name] = numValue;
      }
    }
  });

  return spacerMap;
}

/**
 * 解析阴影变量
 * --td-shadow-1: 0 1px 10px rgba(0, 0, 0, 5%), ...
 * 
 * 映射关系：
 * --td-shadow-1 → shadowsBase (基础投影)
 * --td-shadow-2 → shadowsMiddle (中层投影)
 * --td-shadow-3 → shadowsTop (上层投影)
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

  // CSS 变量到 Flutter key 的映射
  const shadowMapping: Record<string, string> = {
    '--td-shadow-1': 'shadowsBase',
    '--td-shadow-2': 'shadowsMiddle',
    '--td-shadow-3': 'shadowsTop',
    '--td-shadow-4': 'shadowsTop', // shadow-4 也映射到 shadowsTop
  };

  Object.entries(jsonMap).forEach(([key, value]) => {
    // 检查是否是阴影变量
    if (shadowMapping[key]) {
      const flutterKey = shadowMapping[key];
      const shadows = parseShadowValue(value);
      if (shadows.length > 0) {
        shadowMap[flutterKey] = shadows;
        logger.debug(`解析阴影: ${key} → ${flutterKey}`, shadows);
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
 * 解析字体大小变量
 * --td-font-size-s: 12px -> fontSizeS: { size: 12, lineHeight: 20 }
 * --td-font-size-m: 14px -> fontSizeM: { size: 14, lineHeight: 22 }
 */
function parseFont(jsonMap: Record<string, string>): Record<string, { size: number; lineHeight: number }> {
  const fontMap: Record<string, { size: number; lineHeight: number }> = {};

  Object.entries(jsonMap).forEach(([key, value]) => {
    // 只处理字体大小相关的CSS变量
    if (key.startsWith("--td-font-size-") || 
        key.startsWith("--td-line-height-")) {
      
      const name = convertToFlutterTokenName(key);
      
      // 处理 var() 引用
      let fontSizeValue: string;
      if (value.startsWith("var(")) {
        const refKey = value.replace(/var\(|\)/g, "");
        fontSizeValue = jsonMap[refKey] || value;
      } else {
        fontSizeValue = value;
      }

      // 解析字体大小和行高
      const fontSize = parseFloat(fontSizeValue);
      if (!isNaN(fontSize)) {
        // 安全验证：确保字体大小在合理范围内（最大限制为64px）
        const safeFontSize = Math.min(Math.max(fontSize, 8), 64);
        if (fontSize < 8 || fontSize > 64) {
          logger.warn(`字体大小超出合理范围，已调整为${safeFontSize}px: ${key} = ${fontSize}px`);
        }
        // 根据字体大小计算对应的行高
        const lineHeight = calculateLineHeight(safeFontSize);
        fontMap[name] = { size: safeFontSize, lineHeight: lineHeight };
      }
    }
  });

  // 如果没有找到字体大小变量，添加默认的字体大小配置
  // 移除过大的字体值，避免字体变得过大
  if (Object.keys(fontMap).length === 0) {
    const defaultFontSizes = {
      fontSizeExtraLarge: { size: 18, lineHeight: 26 },
      fontSizeLarge: { size: 16, lineHeight: 24 },
      fontSizeMedium: { size: 14, lineHeight: 22 },
      fontSizeSmall: { size: 12, lineHeight: 20 },
      fontSizeExtraSmall: { size: 10, lineHeight: 16 },
      fontSizeTitleExtraLarge: { size: 20, lineHeight: 28 },
      fontSizeTitleLarge: { size: 18, lineHeight: 26 },
      fontSizeTitleMedium: { size: 16, lineHeight: 24 },
      fontSizeTitleSmall: { size: 14, lineHeight: 22 },
      fontSizeBodyExtraLarge: { size: 18, lineHeight: 26 },
      fontSizeBodyLarge: { size: 16, lineHeight: 24 },
      fontSizeBodyMedium: { size: 14, lineHeight: 22 },
      fontSizeBodySmall: { size: 12, lineHeight: 20 },
      fontSizeBodyExtraSmall: { size: 10, lineHeight: 16 },
      fontSizeMarkLarge: { size: 16, lineHeight: 24 },
      fontSizeMarkMedium: { size: 14, lineHeight: 22 },
      fontSizeMarkSmall: { size: 12, lineHeight: 20 },
      fontSizeMarkExtraSmall: { size: 10, lineHeight: 16 },
      fontSizeLinkLarge: { size: 16, lineHeight: 24 },
      fontSizeLinkMedium: { size: 14, lineHeight: 22 },
      fontSizeLinkSmall: { size: 12, lineHeight: 20 }
    };

    Object.entries(defaultFontSizes).forEach(([key, value]) => {
      fontMap[key] = value;
    });
  }

  return fontMap;
}

/**
 * 根据字体大小计算对应的行高
 * TDesign 字体系统规范：
 * - 10px -> 16px (1.6倍)
 * - 12px -> 20px (1.67倍)
 * - 14px -> 22px (1.57倍)
 * - 16px -> 24px (1.5倍)
 * - 18px -> 26px (1.44倍)
 * - 20px -> 28px (1.4倍)
 * - 24px -> 32px (1.33倍)
 * - 28px -> 36px (1.29倍)
 * - 36px -> 44px (1.22倍)
 * - 48px -> 56px (1.17倍)
 * - 64px -> 72px (1.13倍)
 */
function calculateLineHeight(fontSize: number): number {
  const lineHeightMap: Record<number, number> = {
    10: 16,
    12: 20,
    14: 22,
    16: 24,
    18: 26,
    20: 28,
    24: 32,
    28: 36,
    36: 44,
    48: 56,
    64: 72
  };

  return lineHeightMap[fontSize] || Math.round(fontSize * 1.4);
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
  
  // 生成主题配置
  const themeOutput = generateFlutterTheme(lightCss, darkCss);
  
  logger.debug('CSS → Flutter 主题生成完成', {
    lightColors: Object.keys(themeOutput.light.color).length,
    darkColors: Object.keys(themeOutput.dark.color).length,
    hasRadius: !!themeOutput.light.radius,
    hasShadow: !!themeOutput.light.shadow,
    hasFont: !!themeOutput.light.font,
  });
  
  return themeOutput;
}
