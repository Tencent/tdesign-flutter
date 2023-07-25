# gulp-replace-task

[![Build Status](https://img.shields.io/travis/outaTiME/gulp-replace-task.svg)](https://travis-ci.org/outaTiME/gulp-replace-task)
[![Version](https://img.shields.io/npm/v/gulp-replace-task.svg)](https://www.npmjs.com/package/gulp-replace-task)
![Prerequisite](https://img.shields.io/badge/node-%3E%3D10-blue.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](#)
[![Twitter: outa7iME](https://img.shields.io/twitter/follow/outa7iME.svg?style=social)](https://twitter.com/outa7iME)

> Replace text patterns with [applause](https://github.com/outaTiME/applause).

## Install

From NPM:

```shell
npm install gulp-replace-task --save-dev
```

## Usage

Assuming installation via NPM, you can use `gulp-replace-task` in your gulpfile like this:

```javascript
var gulp = require('gulp');
var replace = require('gulp-replace-task');

gulp.task('default', function () {
  gulp
    .src('src/index.html')
    .pipe(
      replace({
        patterns: [
          {
            match: 'foo',
            replacement: 'bar'
          }
        ]
      })
    )
    .pipe(gulp.dest('build'));
});
```

## Options

Supports all the applause [options](https://github.com/outaTiME/applause#options).

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

Gulpfile:

```javascript
var gulp = require('gulp');
var replace = require('gulp-replace-task');

gulp.task('default', function () {
  gulp
    .src('src/manifest.appcache')
    .pipe(
      replace({
        patterns: [
          {
            match: 'timestamp',
            replacement: Date.now()
          }
        ]
      })
    )
    .pipe(gulp.dest('build'));
});
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

Gulpfile:

```javascript
var gulp = require('gulp');
var replace = require('gulp-replace-task');
var pkg = require('./package.json');

gulp.task('default', function () {
  gulp
    .src(['src/manifest.appcache', 'src/humans.txt'])
    .pipe(
      replace({
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
      })
    )
    .pipe(gulp.dest('build'));
});
```

### Cache busting

File `src/index.html`:

```html
<head>
  <link rel="stylesheet" href="/css/style.css?rel=@@timestamp">
  <script src="/js/app.js?rel=@@timestamp"></script>
</head>
```

Gulpfile:

```javascript
var gulp = require('gulp');
var replace = require('gulp-replace-task');

gulp.task('default', function () {
  gulp
    .src('src/index.html')
    .pipe(
      replace({
        patterns: [
          {
            match: 'timestamp',
            replacement: Date.now()
          }
        ]
      })
    )
    .pipe(gulp.dest('build'));
});
```

### Include file

File `src/index.html`:

```html
<body>
  @@include
</body>
```

Gulpfile:

```javascript
var gulp = require('gulp');
var replace = require('gulp-replace-task');
var fs = require('fs');

gulp.task('default', function () {
  gulp
    .src('src/index.html')
    .pipe(
      replace({
        patterns: [
          {
            match: 'include',
            replacement: fs.readFileSync('./includes/content.html', 'utf8')
          }
        ]
      })
    )
    .pipe(gulp.dest('build'));
});
```

### Regular expression

File `src/username.txt`:

```
John Smith
```

Gulpfile:

```javascript
var gulp = require('gulp');
var replace = require('gulp-replace-task');

gulp.task('default', function () {
  gulp
    .src('src/username.txt')
    .pipe(
      replace({
        patterns: [
          {
            match: /(\w+)\s(\w+)/,
            replacement: '$2, $1' // Replaces "John Smith" with "Smith, John"
          }
        ]
      })
    )
    .pipe(gulp.dest('build'));
});
```

### Lookup for `foo` instead of `@@foo`

Gulpfile:

```javascript
var gulp = require('gulp');
var replace = require('gulp-replace-task');

gulp.task('default', function () {
  gulp
    .src('src/foo.txt')
    .pipe(
      replace({
        patterns: [
          {
            match: /foo/g, // Explicitly using a regexp
            replacement: 'bar'
          }
        ]
      })
    )
    .pipe(
      replace({
        patterns: [
          {
            match: 'foo',
            replacement: 'bar'
          }
        ],
        usePrefix: false // Using the option provided
      })
    )
    .pipe(
      replace({
        patterns: [
          {
            match: 'foo',
            replacement: 'bar'
          }
        ],
        prefix: '' // Removing the prefix manually
      })
    )
    .pipe(gulp.dest('build'));
});
```

## Related

- [applause](https://github.com/outaTiME/applause) - Human-friendly replacements

## License

MIT © [outaTiME](https://outa.im)
