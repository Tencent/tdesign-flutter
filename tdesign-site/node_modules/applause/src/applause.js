var _ = require('lodash');
var plugins = require('./plugins');

// Took from MDN
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions

var escapeRegExp = function (string) {
  return string.replace(/([.*+?^${}()|[\]/\\])/g, '\\$1');
};

var getPatterns = function (applause) {
  var opts = applause.options;
  // Shallow patterns
  var patterns = _.chain(opts.patterns)
    .clone()
    .compact()
    .filter(function (pattern) {
      return !_.isEmpty(pattern);
    })
    .value();
  // Backward compatibility
  var variables = opts.variables;
  if (!_.isEmpty(variables)) {
    patterns.push({
      json: variables
    });
  }

  // Process
  for (var i = patterns.length - 1; i >= 0; i -= 1) {
    var pattern = patterns[i];
    // Plugins
    plugins.forEach(function (plugin) {
      if (plugin.match(pattern, opts) === true) {
        plugin.transform(pattern, opts, function (items) {
          if (items instanceof Error) {
            throw items;
          } else {
            // Store transformed pattern in context
            pattern = items;
          }
        });
      } else {
        // Plugin doesn't apply
      }
    });
    // Convert to array
    if (!_.isArray(pattern)) {
      pattern = [pattern];
    }

    // Link with pattern with original source
    pattern.forEach(function (pattern) {
      pattern.source = patterns[i];
    });
    // Attach index
    Array.prototype.splice.apply(patterns, [i, 1].concat(pattern));
  }

  if (opts.preserveOrder !== true) {
    // Only sort non regex patterns (prevents replace issues like head, header)
    patterns.sort(function (a, b) {
      var x = a.match;
      var y = b.match;
      if (_.isString(x) && _.isString(y)) {
        return y.length - x.length;
      }

      if (_.isString(x)) {
        return -1;
      }

      return 1;
    });
  }

  return patterns;
};

// Applause

var Applause = function (opts) {
  this.options = _.defaults(opts, {
    patterns: [],
    prefix: opts.usePrefix === false ? '' : '@@',
    usePrefix: true,
    preservePrefix: false,
    delimiter: '.',
    preserveOrder: false
  });
};

Applause.prototype.replace = function (content, process) {
  var opts = this.options;
  // Prevent null
  content = content || '';
  // Prepare patterns
  var patterns = getPatterns(this);
  var detail = [];
  var totalCount = 0;
  // Iterate over each pattern and make replacement
  patterns.forEach(function (pattern) {
    // Filter empty patterns
    var match = pattern.match;
    // Support replace flag too
    var replacement = pattern.replacement;
    if (replacement === undefined || replacement === null) {
      replacement = pattern.replace;
    }

    // Var source = pattern.source;
    var expression = false;
    // Match check
    if (match !== undefined && match !== null) {
      if (_.isRegExp(match)) {
        expression = true;
      } else if (_.isString(match)) {
        if (match.length > 0) {
          match = new RegExp(opts.prefix + escapeRegExp(match), 'g');
        } else {
          // Empty match
          return;
        }
      } else {
        throw new Error('Unsupported match type (RegExp or String expected).');
      }
    } else {
      throw new Error('Match attribute expected in pattern definition.');
    }

    // Replacement check
    if (replacement !== undefined && replacement !== null) {
      if (_.isFunction(replacement)) {
        // Replace using function return value
        replacement = function () {
          var args = Array.prototype.slice.call(arguments);
          return pattern.replacement.apply(this, args.concat(process || []));
        };
      } else {
        if (!_.isString(replacement)) {
          // Transform object to string
          replacement = JSON.stringify(replacement);
        }

        if (expression === false) {
          // Escape dollar sequences in easy mode
          replacement = replacement.replace(/\$/g, '$$$');
          // Preserve prefix
          if (opts.preservePrefix === true) {
            replacement = opts.prefix + replacement;
          }
        }
      }
    } else {
      throw new Error('Replacement attribute expected in pattern definition.');
    }

    // Replace logic
    var count = ((typeof content === 'string' && content.match(match)) || []).length;
    if (count > 0) {
      // Update content
      content = content.replace(match, replacement);
      // Save detail data
      detail.push({
        match: match,
        replacement: replacement,
        source: pattern.source,
        count: count
      });
      totalCount += count;
    }
  });
  if (detail.length === 0) {
    content = false;
  }

  return {
    content: content,
    detail: detail,
    count: totalCount
  };
};

// Static
Applause.create = function (opts) {
  return new Applause(opts);
};

Applause.version = require('../package.json').version;

// Expose
module.exports = Applause;
