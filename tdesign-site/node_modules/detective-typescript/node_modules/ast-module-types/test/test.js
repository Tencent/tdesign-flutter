var types = require('../');
var assert = require('assert');
var util = require('util');
var Walker = require('node-source-walk');

describe('module-types', function() {
  // Checks whether of not the checker succeeds on
  // a node in the AST of the given source code
  function check(code, checker, harmony) {
    var found = false;
    var walker = new Walker({
      esprimaHarmony: !!harmony
    });

    walker.walk(code, function(node) {
      // Use call to avoid .bind(types) everywhere
      if (checker.call(types, node)) {
        found = true;
        walker.stopWalking();
      }
    });

    return found;
  }

  describe('isDefine', function() {
    it('detects define function calls', function() {
      assert(check('define();', types.isDefine));
    });
  });

  describe('isDefineAMD', function() {
    it('does not detect a generic define function call', function() {
      assert(!check('define();', types.isDefineAMD));
      // Named form
      assert(check('define("foobar", ["a"], function(a){});', types.isDefineAMD));
      // Dependency form
      assert(check('define(["a"], function(a){});', types.isDefineAMD));
      // Factory form
      assert(check('define(function(require){});', types.isDefineAMD));
      // REM form
      assert(check('define(function(require, exports, module){});', types.isDefineAMD));
      // No-dependency form
      assert(check('define({});', types.isDefineAMD));
    });

    it('detects a named form AMD define function call', function() {
      assert(!check('define();', types.isDefineAMD));
    });
  });

  describe('isRequire', function() {
    it('detects require function calls', function() {
      assert(check('require();', types.isRequire));
    });
  });

  describe('isRequire with main-scoped require ', function() {
    it('detects require function calls', function() {
      assert(check('require.main.require();', types.isRequire));
    });
  });

  describe('isTopLevelRequire', function() {
    it('detects top-level (i.e., top of file) require function calls', function() {
      assert(check('require();', types.isTopLevelRequire));
      assert(!check('var foo = 2; \nrequire([], function(){});', types.isTopLevelRequire));
      assert(check('require(["a"], function(a){});', types.isTopLevelRequire));
    });

    it('does not fail on es6', function() {
      assert.doesNotThrow(function() {
        check('import require from "mylib"; \nrequire();', types.isTopLevelRequire, true);
      });
    });
  });

  describe('isExports', function() {
    it('detects module.exports CJS style exports', function() {
      assert(check('module.exports.foo = function() {};', types.isExports));
      assert(check('module.exports = function() {};', types.isExports));
      assert(check('module.exports = {};', types.isExports));
    });

    it('detects plain exports CJS style exports', function() {
      assert(check('exports = function() {};', types.isExports));
      assert(check('exports.foo = function() {};', types.isExports));
      assert(check('exports = {};', types.isExports));
    });
  });

  describe('AMD modules', function() {
    it('detects driver scripts', function() {
      assert(check('require(["a"], function(a){});', types.isAMDDriverScriptRequire));
    });

    it('does not get confused with a commonjs require', function() {
      assert(!check('require("foo");', types.isAMDDriverScriptRequire));
    });

    describe('named form', function() {
      it('detects named form', function() {
        assert(check('define("foobar", ["a"], function(a){});', types.isNamedForm));
      });

      it('needs 3 arguments', function() {
        assert(!check('define("foobar", ["a"]);', types.isNamedForm));
        assert(!check('define("foobar", ["a"], function(a){}, "foo");', types.isNamedForm));
      });

      it('needs the first argument to be a literal', function() {
        assert(!check('define(["foobar"], ["a"], function(a){});', types.isNamedForm));
      });

      it('needs the second argument to be an array', function() {
        assert(!check('define("foobar", 123, function(a){});', types.isNamedForm));
      });

      it('needs the third argument to be a function', function() {
        assert(!check('define("foobar", ["foo"], 123);', types.isNamedForm));
        assert(!check('define("reset", [0, 0], "modifier");', types.isNamedForm));
      });
    });

    describe('dependency form', function() {
      it('detects dependency form modules', function() {
        assert(check('define(["a"], function(a){});', types.isDependencyForm));
      });

      it('needs the first argument to be an array', function() {
        assert(!check('define(123, function(a){});', types.isDependencyForm));
      });

      it('needs the second argument to be a function', function() {
        assert(!check('define(["a"], 123);', types.isDependencyForm));
      });

      it('needs 2 arguments', function() {
        assert(!check('define(["a"], function(a){}, 123);', types.isDependencyForm));
      });
    });

    describe('factory form', function() {
      it('detects factory form modules', function() {
        assert(check('define(function(require){});', types.isFactoryForm));
      });

      it('needs one argument', function() {
        assert(!check('define(function(require){}, 123);', types.isFactoryForm));
      });

      it('needs the first argument to be a function', function() {
        assert(!check('define(123);', types.isFactoryForm));
      });
    });

    it('detects REM form modules', function() {
      assert(check('define(function(require, exports, module){});', types.isREMForm));
    });

    describe('no dependency form', function() {
      it('detects no dependency form modules', function() {
        assert(check('define({});', types.isNoDependencyForm));
      });

      it('needs a aingle argument', function() {
        assert(!check('define({}, 123);', types.isNoDependencyForm));
      });

      it('needs the first argument to be an object', function() {
        assert(!check('define(function(){});', types.isNoDependencyForm));
      });
    });
  });

  describe('ES6', function() {
    it('detects es6 imports', function() {
      assert(check('import {foo, bar} from "mylib";', types.isES6Import, true));
      assert(check('import * as foo from "mod.js";', types.isES6Import, true));
      assert(check('import "mylib2";', types.isES6Import, true));
      assert(check('import foo from "mod.js";', types.isES6Import, true));
      assert(check('import("foo");', types.isES6Import, true));
    });

    it('detects es6 exports', function () {
      assert(check('export default 123;', types.isES6Export, true));
      assert(check('export {foo, bar}; function foo() {} function bar() {}', types.isES6Export, true));
      assert(check('export { D as default }; class D {}', types.isES6Export, true));
      assert(check('export function inc() { counter++; }', types.isES6Export, true));
      assert(check('export * from "mod";', types.isES6Export, true));
    });

    it('detects dynamic imports', function() {
      assert(check('import("./bar");', types.isDynamicImport, true));
      assert(check('function foo() { import("./bar"); }', types.isDynamicImport, true));
    });
  });
});
