# markdown-it-toc-done-right

A table of contents (TOC) plugin for [Markdown-it](https://github.com/markdown-it/markdown-it) with focus on semantic and security. Made to work gracefully with [markdown-it-anchor](https://github.com/valeriangalliat/markdown-it-anchor).

[![Build Status](https://img.shields.io/travis/nagaozen/markdown-it-toc-done-right/master.svg?style=flat)](https://travis-ci.org/nagaozen/markdown-it-toc-done-right)
[![Coverage Status](https://coveralls.io/repos/github/nagaozen/markdown-it-toc-done-right/badge.svg?branch=master)](https://coveralls.io/github/nagaozen/markdown-it-toc-done-right?branch=master)
[![NPM version](https://img.shields.io/npm/v/markdown-it-toc-done-right.svg?style=flat)](vhttps://www.npmjs.org/package/markdown-it-toc-done-right)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com) 
[![Try markdown-it-toc-done-right on RunKit](https://badge.runkitcdn.com/markdown-it-toc-done-right.svg)](https://npm.runkit.com/markdown-it-toc-done-right)

## tl;dr

If you are drowning in table of contents plugins options, just pick this one. It delivers an **accessible**, **semantic**, **SEO friendly** and **safe** TOC. Place one of: `${toc}`, `[[toc]]`, `[toc]`, `[[_toc_]]` in your markdown and, BOOM, the `<nav class="table-of-contents">` will be there. [Click here for additional information](#really-another-markdown-it-table-of-contents-plugin).

## Installation

```sh
$ npm i -S markdown-it-toc-done-right markdown-it-anchor
```

## Usage

```js
// node.js
var md = require("markdown-it")({
	html: false,
	xhtmlOut: true,
	typographer: true
}).use( require("markdown-it-anchor"), { permalink: true, permalinkBefore: true, permalinkSymbol: '§' } )
  .use( require("markdown-it-toc-done-right") );

var result = md.render("# markdown-it rulezz!\n\n${toc}\n## with markdown-it-toc-done-right rulezz even more!");

// browser without AMD, added to "window" on script load
// Note, there is no dash in "markdownit".
var md = window.markdownit({
	html: false,
	xhtmlOut: true,
	typographer: true
}).use( window.markdownitAnchor, { permalink: true, permalinkBefore: true, permalinkSymbol: '§' } )
  .use( window.markdownitTocDoneRight );

var result = md.render("# markdown-it rulezz!\n\n${toc}\n## with markdown-it-toc-done-right rulezz even more!");
```

## Options

You may specify options when using the plugin:

```js
md.use(require("markdown-it-toc-done-right"), options);
```

These options are available:

Name                   | Description                                                      | Default
-----------------------|------------------------------------------------------------------|-------------------------------------
`placeholder`          | The pattern serving as the TOC placeholder in your markdown      | "(\\$\\{toc\\}|\\[\\[?_?toc_?\\]?\\])"
`slugify`              | A custom slugification function                                  | See [`index.js`](index.js)
`uniqueSlugStartIndex` | Index to start with when making duplicate slugs unique.          | 1
`containerClass`       | The class for the container DIV                                  | "table-of-contents"
`containerId`          | The ID for the container DIV                                     | `undefined`
`listClass`            | The class for the `listType` HTMLElement                         | `undefined`
`itemClass`            | The class for the LI                                             | `undefined`
`linkClass`            | The class for the A                                              | `undefined`
`level`                | Minimum level to apply anchors on or array of selected levels    | 1
`listType`             | Type of list (`ul` for unordered, `ol` for ordered)              | `ol`
`format`               | A function for formatting headings (see below)                   | `undefined`
`callback`             | A function (html, ast) {} called after rendering.                | `undefined`

`format` is an optional function for changing how the headings are displayed in the TOC _e.g._ Wrapping content in `<span>`:

```js
function format(x, htmlencode) {
	return `<span>${htmlencode(x)}</span>`;
}
```

## User-Friendly URLs

Starting from `v2.0.0`, `markdown-it-toc-done-right` dropped package `string`
keeping it's core value of being an unopinionated and secure library. Yet,
users looking for backward compatibility may want the old slugify:

```sh
$ npm i -S string
```

```js
var string = require("string");

function legacySlugify(s) {
	return string(s).slugify().toString();
}

var md = require("markdown-it")({
	html: false,
	xhtmlOut: true,
	typographer: true
}).use( require("markdown-it-anchor"), { permalink: true, permalinkBefore: true, permalinkSymbol: '§', slugify: legacySlugify } )
  .use( require("markdown-it-toc-done-right"), { slugify: legacySlugify } );
```

## Unicode support

Unicode is supported by default. Yet, if you are looking for a "prettier"
--opinionated-- link, _i.e_ without %xx, you may want to take a look at `uslug`:

```sh
$ npm i -S uslug
```

```js
var uslug = require("uslug");

function uslugify(s) {
	return uslug(s);
}

var md = require("markdown-it")({
	html: false,
	xhtmlOut: true,
	typographer: true
}).use( require("markdown-it-anchor"), { permalink: true, permalinkBefore: true, permalinkSymbol: '§', slugify: uslugify } )
  .use( require("markdown-it-toc-done-right"), { slugify: uslugify } );
```

## Really? Another markdown-it table of contents plugin?

Unfortunately, I'm a little rigorous developer and most of the existing plugins (_exempli gratia_ `markdown-it-toc-and-anchor`, `markdown-it-table-of-contents`, `markdown-it-toc`, `markdown-it-toc-x3` _et cetera_) fail under, at least, one of these criteria: **correctness**, **semantic**, **security**.

Let me first define those:

- **correctness** `(C1)`, means the that the algorithm is correct with respect to a specification.
- **semantic** `(C2)`, means the that the algorithm delivers meaningful output (_id est_ more than presentation driven HTML).
- **security** `(C3)`, means the that the algorithm protects you, by default, against malicious users.

Whenever I need to work with markdown syntax, I leverage Markdown-it. It's GREAT, the developers care about [security](https://github.com/markdown-it/markdown-it/blob/master/docs/security.md), it's [built for flexibility](https://css-tricks.com/choosing-right-markdown-parser/#comment-1599728), have a [huge community extending it](https://www.npmjs.com/search?q=markdown-it-plugin) and outputs a semantic perfect (X)HTML. Somehow, not all plugin developers keep the same high standards for their extensions. Take for example the three most popular, at the time of writing this README, solutions for this problem: `markdown-it-toc-and-anchor`, `markdown-it-table-of-contents`, `markdown-it-toc`. They all implement their TOC as `inline` and, most obscure of all, after the `emphasis` rule. Does it make any sense? Could someone explain why it's like that? Two errors get derived from this single choice:

1. `(C1)` Invalidates your HTML at [Nu Html Checker](https://validator.w3.org/nu/). Using those plugins you will inject the "ERROR: No `p` element in scope but a `p` end tag seen." to your page.
1. `(C2)` Throw HTML5 semantics away. One of the reasons for the tag `<nav>` to exists is [exactly to be used as a container for table of contents](https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/Using_HTML_sections_and_outlines#Problems_solved_by_HTML5). Semantic is great for SEO and Accessibility. If you, like me, care about SEO and Accessibility you can't use those plugins.

Of course that neither of the above arguments degrades your presentation, but as a coach that trains people to be A-grade web developers to work with very sensitive data (_i.e._ money and credit card) it doesn't make sense for me to keep any one of these plugins. Another very common `(C1)` mistake that can be found in the wild is using an optional regular expression to match the placeholder in the source, but using a hard-coded `charCodeAt` value to reject a token. Finally, `(C3)` is also a concern since the prevalence of unescaped HTML is currently very high; opening your page to XSS and other HTML injection security vulnerabilities.

The only other plugin that addresses `(C2)` and `(C3)` found is `markdown-it-toc-x3`. It's made because the author also noted `(C2)` and addresses `(C3)` by always using `markdown-it token.attrSet(k,v)`, but I've technical `(D1)` and philosophical `(D2)` disagreements with the code:

1. `(D1)`, the approach is very obscure: `(i)` cloning the argument `md` into `md2`, using it to render `heading_open next token` into something that needs to be slugified, stripped and will generate more tokens to be concatenated with token.children; `(ii)` hard-coding `<svg>` into it?; `(iii)` building a string representation of the TOC to `md2` parse and get the tokens back? Really? I feel it's a bit hard to maintain code like that. 
1. `(D2)` composability, do one thing and do it well. If a plugin could be broken in two plugins, it should be broken. `+1` for maintenance.

And those are the "why"s of `markdown-it-toc-done-right`. It protects you by HTML enconding critical points `(C3)` ✓, outputs a nice semantic tag `nav` which works the same as WAI-ARIA landmark `role="navigation"` saving you from [this kind of issue](https://github.com/w3c/aria/issues/534) `(C2)` ✓ and get the job done with an über simple approach `(C1)` ✓.

## How it works?

The idea behind the plugin is incredibly simple:

1. Filter the heading tokens
1. Use 'em to build an AST
1. Apply the HTML semantics in the AST.

Very straightforward, it's one of the smallest plugins you will find around. `+1` for maintenance.

## Cherry on top

Really? You reached here? You deserve a dessert! Try applying this CSS to your `markdown-it-toc-done-right` page.

```css
body { scroll-behavior: smooth; }

ol { counter-reset: list-item; }
li { display: block; counter-increment: list-item; }
li:before { content: counters(list-item,'.') ' '; }
```

Want to know more about scroll-behavior? Visit <https://developer.mozilla.org/en-US/docs/Web/CSS/scroll-behavior>.  
Want to know more about nested counters? Visit <https://www.w3.org/TR/css-lists-3/>.

## Contributing

* ⇄ Pull requests and ★ Stars are always welcome.
* For bugs and feature requests, please create an issue.
* Pull requests must be accompanied by passing automated tests (`$ npm test`).

**Working on your first Pull Request?** You can learn how from this *free* series [How to Contribute to an Open Source Project on GitHub](https://egghead.io/series/how-to-contribute-to-an-open-source-project-on-github).
