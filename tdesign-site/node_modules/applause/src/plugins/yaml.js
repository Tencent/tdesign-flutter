var _ = require('lodash');
// Var YAML = require('js-yaml');
const optionalRequire = require('optional-require')(require);

// Expose

module.exports = {
  name: 'yaml',
  priority: 10,
  match: function (pattern) {
    var yaml = pattern.yaml;
    var match = typeof yaml !== 'undefined';
    return match;
  },
  transform: function (pattern, opts, done) {
    var yaml = pattern.yaml;
    // Function support
    if (_.isFunction(yaml)) {
      yaml.call(this, function (result) {
        // Override yaml function with value
        yaml = result;
      });
    }

    try {
      const YAML = optionalRequire('js-yaml');
      if (!YAML) {
        throw new Error('Missing ' + this.name + ' dependency for transform (js-yaml).');
      }

      done({
        json: YAML.load(yaml)
      });
    } catch (e) {
      done(e);
    }
  }
};
