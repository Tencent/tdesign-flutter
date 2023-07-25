### detective-less [![npm](http://img.shields.io/npm/v/detective-less.svg)](https://npmjs.org/package/detective-less) [![npm](http://img.shields.io/npm/dm/detective-less.svg)](https://npmjs.org/package/detective-less)

> Find the dependencies of a less file

`npm install --save detective-less`

This is a fork of a package by [mrjoelkemp](https://github.com/mrjoelkemp/) given a lack of a less detective, it is the counterpart to  [detective](https://github.com/substack/node-detective), [detective-amd](https://github.com/mrjoelkemp/node-detective-amd), [detective-sass](https://github.com/mrjoelkemp/node-detective-sass), [detective-scss](https://github.com/mrjoelkemp/node-detective-scss) and [detective-es6](https://github.com/mrjoelkemp/node-detective-es6).

* The AST is generated using the [gonzales-pe](https://github.com/tonyganch/gonzales-pe) parser.

### Usage

```js
var detective = require('detective-less');

var content = fs.readFileSync('styles.less', 'utf8');

// list of imported file names (ex: 'foo.less', 'foo', etc)
var dependencies = detective(content);
```

### License

MIT
