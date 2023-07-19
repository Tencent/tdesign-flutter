const uslug = require('uslug')
function uslugify (x) {
  return uslug(x)
}
const umd = require('markdown-it')({
  html: false,
  xhtmlOut: true,
  typographer: true
}).use(require('markdown-it-anchor'), { permalink: true, permalinkBefore: true, permalinkSymbol: '§', slugify: uslugify })
  .use(require('markdown-it-toc-done-right'), { slugify: uslugify })

console.log(umd.render('${toc}\n\n# こんにちは RunKit'))
