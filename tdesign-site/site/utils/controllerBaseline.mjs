import { readFileSync } from 'node:fs';
import { createRequire } from 'node:module';
import ts from 'typescript';

const require = createRequire(import.meta.url);

// The package exposes a Web Component, but no API for its default CSS.
// Follow the static mobile/web default-theme selector in the Vite bundle.
// Never execute the browser bundle, depend on minified names, or copy token values.
function loadControllerThemes() {
  const source = readFileSync(require.resolve('@tdesign/theme-generator'), 'utf8');
  const file = ts.createSourceFile('theme-generator.js', source, ts.ScriptTarget.Latest, true, ts.ScriptKind.JS);
  const values = new Map();
  const selectors = [];
  for (const statement of file.statements) {
    if (ts.isVariableStatement(statement)) {
      for (const declaration of statement.declarationList.declarations) {
        if (ts.isIdentifier(declaration.name)) values.set(declaration.name.text, declaration.initializer);
      }
    }
    if (ts.isFunctionDeclaration(statement)) {
      for (const child of statement.body?.statements ?? []) {
        if (ts.isReturnStatement(child) && child.expression && ts.isConditionalExpression(child.expression)) {
          selectors.push(child.expression);
        }
      }
    }
  }

  const resolve = (node) => node && ts.isIdentifier(node) ? values.get(node.text) : node;
  const property = (node, name) => node && ts.isObjectLiteralExpression(node)
    ? node.properties.find((entry) => ts.isPropertyAssignment(entry) && entry.name.getText(file) === name)?.initializer
    : undefined;
  const cssParts = (node) => {
    const css = resolve(property(resolve(node), 'css'));
    const parts = {};
    for (const name of ['light', 'dark', 'extra']) {
      const value = resolve(property(css, name));
      if (!value || !ts.isStringLiteralLike(value) || !value.text.includes('--td-')) return null;
      parts[name] = value.text;
    }
    return parts;
  };
  const predicate = (selector) => ts.isCallExpression(selector.condition)
    && ts.isIdentifier(selector.condition.expression) ? selector.condition.expression.text : null;
  const mobileSelectors = new Set(selectors.filter((selector) => (
    ts.isStringLiteral(selector.whenTrue) && selector.whenTrue.text === 'mobile'
    && ts.isStringLiteral(selector.whenFalse) && selector.whenFalse.text === 'web'
  )).map(predicate).filter(Boolean));
  const themes = selectors.flatMap((selector) => {
    if (!mobileSelectors.has(predicate(selector))) return [];
    const mobile = cssParts(selector.whenTrue);
    const web = cssParts(selector.whenFalse);
    return mobile && web ? [{ mobile, web }] : [];
  });
  if (themes.length !== 1) throw new Error('Unsupported controller CSS bundle: expected one mobile/web default-theme selector');
  return themes[0];
}

const themes = loadControllerThemes();

export function loadControllerBaseline() {
  return { ...themes.mobile };
}

// Mobile panels also read size/line-height declarations defined by web extra.
// Use the installed package's declarations, never a copied default-value table.
export function loadControllerExtraDefaults() {
  return themes.web.extra;
}
