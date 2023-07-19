# unescape-js

[![npm](https://img.shields.io/npm/v/unescape-js.svg?maxAge=2592000&style=flat-square)](https://www.npmjs.com/package/unescape-js) [![Travis branch](https://img.shields.io/travis/iamakulov/unescape-js/master.svg?maxAge=2592000&style=flat-square)](https://travis-ci.org/iamakulov/unescape-js) [![Coveralls](https://img.shields.io/coveralls/iamakulov/unescape-js.svg?maxAge=2592000&style=flat-square)](https://coveralls.io/github/iamakulov/unescape-js)

> Unescape special characters encoded with [JavaScript escape sequences](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Grammar_and_types#Using_special_characters_in_strings)

## Install

```
npm install --save unescape-js
```
    
## Usage

`unescape-js` supports:
* all JavaScript escape sequences described [on the according MDN page](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Grammar_and_types#Using_special_characters_in_strings) including ES2015 Unicode code point escapes (`\u{XXXXX}`)
*  Python-style escape sequences (`\UXXXXXXXX`).

```js
var unescapeJs = require('unescape-js');

console.log(unescapeJs('Hello,\\nworld!'));
// Hello,
// world!

console.log(unescapeJs('Copyright \\u00A9'));
// Copyright ©

console.log(unescapeJs('\\u{1F604}'));
// 😄
```

## License

MIT © [Ivan Akulov](http://iamakulov.com)