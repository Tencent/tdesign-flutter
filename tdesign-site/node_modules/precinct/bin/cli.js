#!/usr/bin/env node

'use strict';

const fs = require('fs');
const program = require('commander');
const precinct = require('../index.js');
const { version } = require('../package.json');

program
  .version(version)
  .usage('[options] <filename>')
  .option('--es6-mixedImports')
  .option('-t, --type <type>', 'The type of content being passed in. Useful if you want to use a non-js detective')
  .parse(process.argv);

const content = fs.readFileSync(program.args[0], 'utf8');

const options = {
  es6: {}
};

if (program.es6MixedImports) {
  options.es6.mixedImports = true;
}

if (program.type) {
  options.type = program.type;
}

console.log(precinct(content, options).join('\n'));
