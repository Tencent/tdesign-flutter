var _ = require('lodash');

var flatten = function (json, delimiter) {
  var result = [];
  var recurse = function (cur, prop) {
    for (var key in cur) {
      // eslint-disable-next-line no-prototype-builtins
      if (cur.hasOwnProperty(key)) {
        var item = cur[key];
        var match = prop ? prop + delimiter + key : key;
        result.push({
          match: match,
          replacement: item,
          expression: false
        });
        // Deep scan
        if (typeof item === 'object') {
          recurse(item, prop ? prop + delimiter + key : key);
        }
      }
    }
  };

  recurse(json);
  return result;
};

// Expose

module.exports = {
  name: 'json',
  priority: 20,
  match: function (pattern) {
    var json = pattern.json;
    var match = typeof json !== 'undefined';
    return match;
  },
  transform: function (pattern, opts, done) {
    var delimiter = opts.delimiter;
    var json = pattern.json;
    // Function support
    if (_.isFunction(json)) {
      json.call(this, function (result) {
        // Override json function with value
        json = result;
      });
    }

    if (_.isPlainObject(json)) {
      // Replace json with flatten data
      done(flatten(json, delimiter));
    } else {
      done(new Error('Unsupported type for json (plain object expected).'));
    }
  }
};
