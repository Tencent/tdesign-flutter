# node-detective-postcss [![Build Status](https://travis-ci.org/joscha/node-detective-postcss.svg?branch=master)](https://travis-ci.org/joscha/node-detective-postcss)

> Find the dependencies of a CSS file (postCSS dialects)

Supports `@import` and [`@value ... from`](https://github.com/css-modules/postcss-icss-values).

`npm install --save detective-postcss`

It's the CSS (PostCSS dialect) counterpart to [detective](https://github.com/substack/node-detective), [detective-amd](https://github.com/mrjoelkemp/node-detective-amd), [detective-es6](https://github.com/mrjoelkemp/node-detective-es6), [detective-sass](https://github.com/mrjoelkemp/node-detective-sass), [detective-scss](https://github.com/mrjoelkemp/node-detective-scss).

*   The AST is generated using [postcss](https://github.com/postcss/postcss) and [postcss-values-parser](https://github.com/shellscape/postcss-values-parser).

### Usage

```js
import fs from 'fs';
import detective from 'detective-postcss';

const content = fs.readFileSync('styles.css', 'utf8');

// list of imported file names (ex: 'bla.css', 'foo.css', etc.)
const dependencies = detective(content);

// or to also detect any url() references to images, fonts, etc.
const allDependencies = detective(content, { url: true });
```

### License

Apache 2.0
