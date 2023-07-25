var through2 = require('through2');
var PluginError = require('plugin-error');
var Applause = require('applause');

var PLUGIN_NAME = 'gulp-replace-task';

module.exports = function (opts) {
  return through2.obj(function (file, enc, cb) {
    if (file.isNull()) {
      this.push(file);
      return cb();
    }

    if (file.isStream()) {
      this.emit('error', new PluginError(PLUGIN_NAME, 'Streaming not supported'));
      return cb();
    }

    var options = opts || {};
    var contents = file.contents.toString();
    var applause = Applause.create(options);
    var result = applause.replace(contents).content;
    file.contents = Buffer.from(result === false ? contents : result);

    this.push(file);
    cb();
  });
};
