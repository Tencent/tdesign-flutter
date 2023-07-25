'use strict';

const Walker = require('node-source-walk');
const gonzales = require('gonzales-pe');
const debug = require('debug')('detective-less');

/**
 * Extract the @import statements from a given less file's content
 *
 * @param  {String} fileContent
 * @return {String[]}
 */
module.exports = function detective(fileContent) {
  if (typeof fileContent === 'undefined') { throw new Error('content not given'); }
  if (typeof fileContent !== 'string') { throw new Error('content is not a string'); }

  let dependencies = [];
  let ast;

  try {
    debug('content: ' + fileContent);
    ast = gonzales.parse(fileContent, { syntax: 'less' });
  } catch (e) {
    debug('parse error: ', e.message);
    ast = {};
  }

  detective.ast = ast;

  const walker = new Walker();

  walker.walk(ast, function(node) {
    if (!isImportStatement(node)) { return; }

    dependencies = dependencies.concat(extractDependencies(node));
  });

  return dependencies;
};

function isImportStatement(node) {
  if (!node || node.type !== 'atrule') { return false; }
  if (!node.content.length || node.content[0].type !== 'atkeyword') { return false; }

  const atKeyword = node.content[0];

  if (!atKeyword.content.length) { return false; }

  const importKeyword = atKeyword.content[0];

  if (importKeyword.type !== 'ident' || importKeyword.content !== 'import') { return false; }

  return true;
}

function extractDependencies(importStatementNode) {
  return importStatementNode.content
  .filter(function(innerNode) {
    return innerNode.type === 'string' || innerNode.type === 'ident';
  })
  .map(function(identifierNode) {
    return identifierNode.content.replace(/["']/g, '');
  });
}
