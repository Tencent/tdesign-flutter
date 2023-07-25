/*
 * Copyright (c) 2014, Groupon, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *
 * Neither the name of GROUPON nor the names of its contributors may be
 * used to endorse or promote products derived from this software without
 * specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 * IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

'use strict';

const jsIdentifierRE = /^[a-z_$][a-z0-9_$]*$/i;
const doubleQuotesRE = /''/g;
const SPACES = '          ';

function contains(str1, str2) {
  return str1.indexOf(str2) >= 0;
}

function newlineWrap(str) {
  return str && `\n${str}\n`;
}

function isObject(obj) {
  return typeof obj === 'object' && obj !== null && !Array.isArray(obj);
}

function parseIndent(indent) {
  switch (typeof indent) {
    case 'string':
      return indent.slice(0, 10);
    case 'number':
      const n = Math.max(0, Math.min(10, Math.floor(indent)));
      return SPACES.slice(0, n);
    default:
      return 0;
  }
}

function indentLine(indent, line) {
  return indent + line;
}

function indentLines(indent, str) {
  if (str === '') {
    return str;
  }
  return str.split('\n').map(indentLine.bind(null, indent)).join('\n');
}

function singleQuoteStringify(str) {
  return `'${JSON.stringify(str)
    .slice(1, -1)
    .replace(/\\"/g, '"')
    .replace(/'/g, "\\'")}'`;
}

function quoteType(str) {
  return contains(str, "'") && !contains(str, '"') ? 'double' : 'single';
}

function onelineStringify(str) {
  return (quoteType(str) === 'single' ? singleQuoteStringify : JSON.stringify)(
    str
  );
}

function buildKeyPairs(visitNode, indent, obj) {
  return Object.keys(obj).map(key => {
    const value = obj[key];
    if (!key.match(jsIdentifierRE)) {
      key = onelineStringify(key);
    }
    let serializedValue = visitNode(value, {
      bracesRequired: !indent,
    });
    if (indent) {
      serializedValue =
        isObject(value) && Object.keys(value).length > 0
          ? `\n${indentLines(indent, serializedValue)}`
          : ` ${serializedValue}`;
    }
    return `${key}:${serializedValue}`;
  });
}

function visitArray(visitNode, indent, arr) {
  const items = arr.map(value => {
    return visitNode(value, {
      bracesRequired: true,
    });
  });
  const serializedItems = indent
    ? newlineWrap(indentLines(indent, items.join('\n')))
    : items.join(',');
  return `[${serializedItems}]`;
}

function visitObject(visitNode, indent, obj, arg) {
  const bracesRequired = arg.bracesRequired;
  const keypairs = buildKeyPairs(visitNode, indent, obj);

  if (keypairs.length === 0) return '{}';

  if (indent) {
    const keyPairLines = keypairs.join('\n');
    if (bracesRequired) {
      return `{${newlineWrap(indentLines(indent, keyPairLines))}}`;
    }
    return keyPairLines;
  }

  const serializedKeyPairs = keypairs.join(',');
  if (bracesRequired) {
    return `{${serializedKeyPairs}}`;
  }
  return serializedKeyPairs;
}

function visitString(visitNode, indent, str) {
  if (str.indexOf('\n') === -1 || !indent) {
    return onelineStringify(str);
  }
  const string = str.replace(/\\/g, '\\\\').replace(doubleQuotesRE, "\\''");
  return `'''${newlineWrap(indentLines(indent, string))}'''`;
}

// disabling consistent return so cson parser handles undefined like JSON.stringify does
function stringify(data, visitor, indent) {
  if (typeof data === 'function' || typeof data === 'undefined') {
    // eslint-disable-next-line consistent-return
    return undefined;
  }

  indent = parseIndent(indent);

  const normalized = JSON.parse(JSON.stringify(data, visitor));

  function visitNode(node, options) {
    if (options == null) {
      options = {};
    }

    switch (typeof node) {
      case 'boolean':
        return `${node}`;

      case 'number':
        if (isFinite(node)) {
          return `${node}`;
        }
        return 'null';

      case 'string':
        return visitString(visitNode, indent, node);

      case 'object':
        if (node === null) {
          return 'null';
        } else if (Array.isArray(node)) {
          return visitArray(visitNode, indent, node);
        }
        return visitObject(visitNode, indent, node, options);

      default:
        // eslint-disable-next-line consistent-return
        return undefined;
    }
  }

  // eslint-disable-next-line consistent-return
  return visitNode(normalized);
}

module.exports = stringify;
