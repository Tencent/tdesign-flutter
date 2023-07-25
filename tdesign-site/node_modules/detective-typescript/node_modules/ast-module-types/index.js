// Deprecated
// Whether or not the node represents a generic define() call 
// Note: this should not be used as it will have false positives.
// It is mostly used to guide sniffs for other methods and will be made private eventually.
module.exports.isDefine = function (node) {
  if (!node) return false;

  var c = node.callee;

  return c &&
    node.type === 'CallExpression' &&
    c.type    === 'Identifier' &&
    c.name    === 'define';
};

// Whether or not the node represents any of the AMD define() forms
module.exports.isDefineAMD = function (node) {
  if (!node) return false;

  var e = module.exports;

  return e.isNamedForm(node) || e.isDependencyForm(node) || 
  e.isFactoryForm(node) || e.isNoDependencyForm(node) || 
  e.isREMForm(node);
};

// Whether or not the node represents a require function call
module.exports.isRequire = function (node) {
    return this.isPlainRequire(node) || this.isMainScopedRequire(node);
};

// Whether or not the node represents a plain require function call [require(...)]
module.exports.isPlainRequire = function (node) {
    if (!node) return false;

    var c = node.callee;

    return c &&
          node.type  === 'CallExpression' &&
          c.type     === 'Identifier' &&
          c.name     === 'require';
}

// Whether or not the node represents main-scoped require function call [require.main.require(...)]
module.exports.isMainScopedRequire = function (node) {
    if (!node) return false;

    var c = node.callee;

    return c &&
          node.type  === 'CallExpression' &&
              c.type     === 'MemberExpression' &&
              c.object.type === 'MemberExpression' &&
              c.object.object.type === 'Identifier' &&
              c.object.object.name === 'require' &&
              c.object.property.type === 'Identifier' &&
              c.object.property.name === 'main' &&
              c.property.type === 'Identifier' &&
              c.property.name === 'require';
}

// Whether or not the node represents a require at the top of the module
// Instead of trying to find the require then backtrack to the top,
// just take the root and check its immediate child
module.exports.isTopLevelRequire = function (node) {
  if (node.type !== 'Program' || !node.body ||
      !node.body.length || !node.body[0].expression) {
    return false;
  }

  return this.isRequire(node.body[0].expression);
};

// Whether or not the node represents an AMD-style driver script's require
// Example: require(deps, function)
module.exports.isAMDDriverScriptRequire = function (node) {
  return  this.isRequire(node) &&
          node.arguments &&
          node.arguments[0] && node.arguments[0].type &&
          node.arguments[0].type === 'ArrayExpression';
};

// Whether or not the node represents the use of
// assigning (and possibly attaching) something to module.exports or exports
module.exports.isExports = function (node) {
  if (node.type !== 'AssignmentExpression') return;

  // Only the left side matters
  node = node.left;

  function isExportsIdentifier(obj) {
    return obj.type && obj.type === 'Identifier' && obj.name === 'exports';
  }

  function isModuleIdentifier(obj) {
    return obj.type && obj.type === 'Identifier' && obj.name === 'module';
  }

  // module.exports.foo
  function isModuleExportsAttach() {
    if (!node.object || !node.object.object || !node.object.property) return false;

    var objObj = node.object.object,
        objProp = node.object.property;

    return node.type === 'MemberExpression' &&
          isModuleIdentifier(objObj) &&
          isExportsIdentifier(objProp);
  }

  // module.exports
  function isModuleExportsAssign() {
    if (!node.object || !node.property) return false;

    return node.type === 'MemberExpression' &&
          isModuleIdentifier(node.object) &&
          isExportsIdentifier(node.property);
  }

  // exports
  function isExportsAssign() {
    return isExportsIdentifier(node);
  }

  // exports.foo
  function isExportsAttach() {
    return node.type === 'MemberExpression' &&
          isExportsIdentifier(node.object);
  }

  return isModuleExportsAttach() || isModuleExportsAssign() ||
          isExportsAttach() || isExportsAssign();
};

// define('name', [deps], func)
module.exports.isNamedForm = function (node) {
  if (!this.isDefine(node)) return false;

  var args = node['arguments'];

  return args && args.length == 3 && 
  (args[0].type === 'Literal' || args[0].type === 'StringLiteral') &&
  (args[1].type == 'ArrayExpression') && 
  (args[2].type == 'FunctionExpression');
};

// define([deps], func)
module.exports.isDependencyForm = function (node) {
  if (!this.isDefine(node)) return false;

  var args = node['arguments'];

  return args && args.length == 2 && 
  args[0].type === 'ArrayExpression' && 
  args[1].type == 'FunctionExpression';
};

// define(func(require))
module.exports.isFactoryForm = function (node) {
  if (!this.isDefine(node)) return false;

  var args = node['arguments'],
      firstParamNode = args.length && args[0].params ? args[0].params[0] : null;

  // Node should have a function whose first param is 'require'
  return args && args.length == 1 && 
  args[0].type === 'FunctionExpression' &&
  firstParamNode && firstParamNode.type === 'Identifier' && 
  firstParamNode.name === 'require';
};

// define({})
module.exports.isNoDependencyForm = function (node) {
  if (!this.isDefine(node)) return false;

  var args = node['arguments'];

  return args && args.length == 1 && 
  args[0].type === 'ObjectExpression';
};

// define(function(require, exports, module)
module.exports.isREMForm = function(node) {
  if (!this.isDefine(node)) return false;

  var args = node['arguments'],
      params = args.length ? args[0].params : null,
      first, second, third;

  if (!args || args.length == 0 || args[0].type !== 'FunctionExpression' || params.length !== 3) {
    return false;
  }

  first = params[0];
  second = params[1];
  third = params[2];

  return first.type === 'Identifier' && first.name === 'require' &&
        second.type === 'Identifier' && second.name === 'exports' &&
        third.type === 'Identifier' && third.name === 'module';
};

module.exports.isES6Import = function(node) {
  switch(node.type) {
    case 'Import':
    case 'ImportDeclaration':
    case 'ImportDefaultSpecifier':
    case 'ImportNamespaceSpecifier':
      return true;
  };

  return false;
};

module.exports.isES6Export = function (node) {
  switch(node.type) {
    case 'ExportDeclaration':
    case 'ExportNamedDeclaration':
    case 'ExportSpecifier':
    case 'ExportDefaultDeclaration':
    case 'ExportAllDeclaration':
      return true;
  };

  return false;
};

module.exports.isDynamicImport = function(node) {
 return node.callee && node.callee.type === 'Import' && node.arguments.length;
};
