var _ = require('lodash');
// Var CSON = require('cson-parser');
const optionalRequire = require('optional-require')(require);

// Expose
module.exports = {
  name: 'cson',
  priority: 10,
  match: function (pattern) {
    var cson = pattern.cson;
    var match = typeof cson !== 'undefined';
    return match;
  },
  transform: function (pattern, opts, done) {
    var cson = pattern.cson;
    // Function support
    if (_.isFunction(cson)) {
      cson.call(this, function (result) {
        // Override cson function with value
        cson = result;
      });
    }

    try {
      const CSON = optionalRequire('cson-parser');
      if (!CSON) {
        throw new Error('Missing ' + this.name + ' dependency for transform (cson-parser).');
      }

      done({
        json: CSON.parse(cson)
      });
    } catch (e) {
      done(e);
    }
  }
};
