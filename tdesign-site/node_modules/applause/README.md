# Applause 👏
[![Build Status](https://img.shields.io/travis/outaTiME/applause.svg)](https://travis-ci.org/outaTiME/applause)
[![Version](https://img.shields.io/npm/v/applause.svg)](https://www.npmjs.com/package/applause)
![Prerequisite](https://img.shields.io/badge/node-%3E%3D10-blue.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](#)
[![Twitter: outa7iME](https://img.shields.io/twitter/follow/outa7iME.svg?style=social)](https://twitter.com/outa7iME)

> Pattern replacer that helps to create human-friendly replacements.

**Try the [playground], where you can test every single option of applause.**

## Install

First make sure you have installed the latest version of [node.js](http://nodejs.org/)
(You may need to restart your computer after this step).

From NPM for programmatic use:

```shell
npm install applause
```

From Git:

```shell
git clone git://github.com/outaTiME/applause
cd applause
npm link .
```

## Usage

Assuming installation via NPM, you can use `applause` in your application like this:

```javascript
var fs = require('fs');
var Applause = require('applause');

var options = {
  patterns: [
    {
      match: 'foo',
      replacement: 'bar'
    }
  ]
};
var applause = Applause.create(options);
var contents = '@@foo';
var result = applause.replace(contents);
console.log(result.content); // bar
```

## Options

### patterns
Type: `Array`

Defines the patterns that will be used to replace the content input.

### patterns.match
Type: `String|RegExp`

Indicates the matching expression.

If the match type is `String`, a simple variable search mechanism `@@string` is used (in any other case the default regexp replacement logic is used):

```javascript
{
  patterns: [
    {
      match: 'foo',
      replacement: 'bar' // Replaces "@@foo" with "bar"
    }
  ]
}
```

### patterns.replacement or patterns.replace
Type: `String|Function|Object`

Indicates the replacement for match. For more information about replacement, see [String.replace].

You can specify a function as a replacement. In this case, the function will be invoked after the match has been made. The result of the function (return value) will be used as the replacement string.

```javascript
{
  patterns: [
    {
      match: /foo/g,
      replacement: function () {
        return 'bar'; // Replaces "foo" with "bar"
      }
    }
  ]
}
```

Objects are also supported as replacement (a string representation of the object is created using [JSON.stringify]):

```javascript
{
  patterns: [
    {
      match: /foo/g,
      replacement: [1, 2, 3] // Replaces "foo" with string representation of the array
    }
  ]
}
```

> The replacement only resolves the [special replacement patterns] when using regexp to match.

### patterns.json
Type: `Object`

If a `json` attribute is found in the pattern definition, the object is flattened using the [delimiter](#delimiter) concatenation and each key-value pair will be used for replacement (simple variable lookup mechanism and no regexp support).

```javascript
{
  patterns: [
    {
      json: {
        key: 'value' // Replaces "@@key" with "value"
      }
    }
  ]
}
```

Nested objects are also supported:

```javascript
{
  patterns: [
    {
      json: {
        key: 'value',  // Replaces "@@key" with "value"
        inner: {       // Replaces "@@inner" with string representation of the "inner" object
          key: 'value' // Replaces "@@inner.key" with "value"
        }
      }
    }
  ]
}
```

You can define functions for deferred invocations:

```javascript
{
  patterns: [
    {
      json: function (done) {
        done({
          key: 'value'
        });
      }
    }
  ]
}
```

### patterns.yaml
Type: `String`

If a `yaml` attribute is found in the pattern definition, it will be converted and then processed as [json](#patternsjson) attribute.

```javascript
{
  patterns: [
    {
      yaml: 'key: "value"' // Replaces "@@key" with "value"
    }
  ]
}
```

You can define functions for deferred invocations:

```javascript
{
  patterns: [
    {
      yaml: function (done) {
        done('key: "value"');
      }
    }
  ]
}
```

### patterns.cson
Type: `String`

If a `cson` attribute is found in the pattern definition, it will be converted and then processed as [json](#patternsjson) attribute.

```javascript
{
  patterns: [
    {
      cson: 'key: "value"'
    }
  ]
}
```

You can define functions for deferred invocations:

```javascript
{
  patterns: [
    {
      cson: function (done) {
        done('key: "value"');
      }
    }
  ]
}
```

### variables
Type: `Object`

This is the old way of defining patterns using a simple plain object (simple variable lookup mechanism and no regexp support). You can still use this, but for more control you should use the new way of `patterns`.

```javascript
{
  variables: {
    'key': 'value' // Replaces "@@key" with "value"
  }
}
```

### prefix
Type: `String`
Default: `@@`

The prefix used for matching (avoid wrong replacements / easy way).

> This only applies for simple variable lookup mechanism.

### usePrefix
Type: `Boolean`
Default: `true`

If set to "false", the pattern is matched without the "prefix" concatenation (this is useful when you want to lookup a simple string).

> This only applies for simple variable lookup mechanism.

### preservePrefix
Type: `Boolean`
Default: `false`

If set to "true", the "prefix" is preserved in the target.

> This only applies for simple variable lookup mechanism and when `patterns.replacement` is a string.

### delimiter
Type: `String`
Default: `.`

The delimiter used to flatten when using an object as a replacement.

### preserveOrder
Type: `Boolean`
Default: `false`

If set to "true", we preserve the order of definition of the patterns; otherwise the order will be ascending to avoid replacement problems such as "head" / "header" (regexp matches will be resolved at last).

[playground]: http://outatime.github.io/applause.io/
[String.replace]: http://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/replace
[JSON.stringify]: http://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/stringify
[special replacement patterns]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/replace#Specifying_a_string_as_a_parameter

## Examples

### Basic

File `src/manifest.appcache`:

```
CACHE MANIFEST
# @@timestamp

CACHE:

favicon.ico
index.html

NETWORK:
*
```

Node:

```javascript
var fs = require('fs');
var Applause = require('applause');

var options = {
  patterns: [
    {
      match: 'timestamp',
      replacement: Date.now()
    }
  ]
};
var applause = Applause.create(options);
var contents = fs.readFileSync('./src/manifest.appcache', 'utf8');
var result = applause.replace(contents);
console.log(result.content); // The replaced output
```

### Multiple matching

File `src/manifest.appcache`:

```
CACHE MANIFEST
# @@timestamp

CACHE:

favicon.ico
index.html

NETWORK:
*
```

File `src/humans.txt`:

```
              __     _
   _    _/__  /./|,//_`
  /_//_// /_|///  //_, outaTiME v.@@version

/* TEAM */
  Web Developer / Graphic Designer: Ariel Oscar Falduto
  Site: https://www.outa.im
  Twitter: @outa7iME
  Contact: afalduto at gmail dot com
  From: Buenos Aires, Argentina

/* SITE */
  Last update: @@timestamp
  Standards: HTML5, CSS3, robotstxt.org, humanstxt.org
  Components: H5BP, Modernizr, jQuery, Bootstrap, LESS, Jade, Grunt
  Software: Sublime Text, Photoshop, LiveReload
```

Node:

```javascript
var fs = require('fs');
var pkg = require('./package.json');
var Applause = require('applause');

var options = {
  patterns: [
    {
      match: 'version',
      replacement: pkg.version
    },
    {
      match: 'timestamp',
      replacement: Date.now()
    }
  ]
};
var applause = Applause.create(options);
var contents = fs.readFileSync('./src/manifest.appcache', 'utf8');
var result = applause.replace(contents);
console.log(result.content); // The replaced output
contents = fs.readFileSync('./src/humans.txt', 'utf8');
result = applause.replace(contents);
console.log(result.content); // The replaced output
```

### Cache busting

File `src/index.html`:

```html
<head>
  <link rel="stylesheet" href="/css/style.css?rel=@@timestamp">
  <script src="/js/app.js?rel=@@timestamp"></script>
</head>
```

Node:

```javascript
var fs = require('fs');
var Applause = require('applause');

var options = {
  patterns: [
    {
      match: 'timestamp',
      replacement: Date.now()
    }
  ]
};
var applause = Applause.create(options);
var contents = fs.readFileSync('./src/index.html', 'utf8');
var result = applause.replace(contents);
console.log(result.content); // The replaced output
```

### Include file

File `src/index.html`:

```html
<body>
  @@include
</body>
```

Node:

```javascript
var fs = require('fs');
var Applause = require('applause');

var options = {
  patterns: [
    {
      match: 'include',
      replacement: fs.readFileSync('./includes/content.html', 'utf8')
    }
  ]
};
var applause = Applause.create(options);
var contents = fs.readFileSync('./src/index.html', 'utf8');
var result = applause.replace(contents);
console.log(result.content); // The replaced output
```

### Regular expression

File `src/username.txt`:

```
John Smith
```

Node:

```javascript
var fs = require('fs');
var Applause = require('applause');

var options = {
  patterns: [
    {
      match: /(\w+)\s(\w+)/,
      replacement: '$2, $1' // Replaces "John Smith" with "Smith, John"
    }
  ]
};
var applause = Applause.create(options);
var contents = fs.readFileSync('./username.txt', 'utf8');
var result = applause.replace(contents);
console.log(result.content); // The replaced output
```

### Lookup for `foo` instead of `@@foo`

Node:

```javascript
var Applause = require('applause');

var options = [
  {
    patterns: [
      {
        match: /foo/g, // Explicitly using a regexp
        replacement: 'bar'
      }
    ]
  },
  {
    patterns: [
      {
        match: 'foo',
        replacement: 'bar'
      }
    ],
    prefix: '' // Removing the prefix manually
  },
  {
    patterns: [
      {
        match: 'foo',
        replacement: 'bar'
      }
    ],
    usePrefix: false // Using the option provided
  }
];
options.forEach(function (option) {
  var applause = Applause.create(option);
  var contents = 'foo';
  var result = applause.replace(contents);
  console.log(result.content); // bar
});
```

## Related

- [js-yaml](https://github.com/nodeca/js-yaml) - YAML 1.2 parser and serialize
- [cson-parser](https://github.com/groupon/cson-parser) - Safe parsing of CSON files

## License

MIT © [outaTiME](https://outa.im)
