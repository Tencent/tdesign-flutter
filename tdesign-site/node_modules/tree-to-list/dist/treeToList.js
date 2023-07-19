/** tree-to-list v2.0.0
 * - https://www.npmjs.com/package/tree-to-list
 * - https://github.com/mcc108/tree-to-list
 */

'use strict';

/** tree-to-list
 * flatten tree to list
 *
 * @param {Array|Object} tree Tree.
 * @param {String} key Node key.
 * @returns {Array|Object} Returns flattened list.
 * @example
 *
 * // 1. flatten array tree
 * tree = [{
 *   name: 'name1',
 *   children: [{
 *     name: 'name3',
 *     children: [{
 *       name: 'name5'
 *     }]
 *   }, {
 *     name: 'name4'
 *   }]
 * }, {
 *   name: 'name2'
 * }]
 *
 * treeToList(tree, 'children')
 * // =>
 * [
 *   { name: 'name1' },
 *   { name: 'name3' },
 *   { name: 'name5' },
 *   { name: 'name4' },
 *   { name: 'name2' }
 * ]
 *
 * // 2. flatten object tree
 * tree = {
 *   node1: {
 *     name: 'name1',
 *     tree: {
 *       node3: {
 *         name: 'name3',
 *         tree: {
 *           node2: {
 *             name: 'name5',
 *             key5: 'value5'
 *           }
 *         }
 *       },
 *       node4: { name: 'name4' },
 *     }
 *   },
 *   node2: {
 *     name: 'name2',
 *     key2: 'value2'
 *   }
 * }
 *
 * treeToList(tree, 'tree')
 * // =>
 * {
 *   node1: { name: 'name1' },
 *   node3: { name: 'name3' },
 *   node4: { name: 'name4' },
 *   node2: {
 *     name: 'name2',
 *     key5: 'value5',
 *     key2: 'value2'
 *   }
 * }
 *
 */
function treeToList(tree) {
  var key = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : 'children';
  var list = [];

  if (Array.isArray(tree)) {
    // array tree
    list = [];
  } else if (Object.prototype.toString.call(tree) === '[object Object]') {
    // object tree
    list = {};
  } else {
    // invalid tree
    return list;
  }

  var stack = _transformStack(tree);

  while (stack.length) {
    var curStack = stack.shift();
    var nodeKey = curStack.key,
        node = curStack.value;
    if (!node) continue; // invalid node

    var item = (nodeKey ? list[nodeKey] : {}) || {};

    for (var prop in node) {
      if (Object.prototype.hasOwnProperty.call(node, prop) && prop !== key) {
        item[prop] = node[prop];
      }
    }

    if (nodeKey) {
      // object
      list[nodeKey] = item;
    } else {
      // array
      list.push(item);
    }

    var subTree = node[key] || [];
    stack = _transformStack(subTree).concat(stack);
  }

  return list;
}
/**
 * transform tree to stack
 *
 * @param {Array|Object} tree Tree.
 */


function _transformStack(tree) {
  var stack = [];

  if (Array.isArray(tree)) {
    // array tree
    for (var index = 0; index < tree.length; index++) {
      var node = tree[index];
      stack.push({
        value: node
      });
    }
  } else if (Object.prototype.toString.call(tree) === '[object Object]') {
    // object tree
    for (var key in tree) {
      if (Object.prototype.hasOwnProperty.call(tree, key)) {
        var _node = tree[key];
        stack.push({
          key: key,
          value: _node
        });
      }
    }
  }

  return stack;
}

module.exports = treeToList;
