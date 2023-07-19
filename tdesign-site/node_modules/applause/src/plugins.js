var plugins = [
  require('./plugins/yaml'),
  require('./plugins/cson'),
  require('./plugins/json')
];

// Priority sort
plugins.sort(function (a, b) {
  return (a.priority || 0) - (b.priority || 0);
});

// Expose
module.exports = plugins;
