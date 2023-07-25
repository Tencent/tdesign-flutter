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
function treeToList(tree, key = 'children') {
    let list = [];

    if (Array.isArray(tree)) { // array tree
        list = [];
    } else if (Object.prototype.toString.call(tree) === '[object Object]') { // object tree
        list = {};
    } else { // invalid tree
        return list;
    }

    let stack = _transformStack(tree);

    while (stack.length) {
        const curStack = stack.shift();

        const { key: nodeKey, value: node } = curStack;
        if (!node) continue; // invalid node

        const item = (nodeKey ? list[nodeKey] : {}) || {};
        for (const prop in node) {
            if (Object.prototype.hasOwnProperty.call(node, prop)
                && prop !== key) {
                item[prop] = node[prop];
            }
        }
        if (nodeKey) { // object
            list[nodeKey] = item;
        } else { // array
            list.push(item);
        }

        const subTree = node[key] || [];
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
    const stack = [];

    if (Array.isArray(tree)) { // array tree
        for (let index = 0; index < tree.length; index++) {
            const node = tree[index];
            stack.push({
                value: node,
            });
        }
    } else if (Object.prototype.toString.call(tree) === '[object Object]') { // object tree
        for (const key in tree) {
            if (Object.prototype.hasOwnProperty.call(tree, key)) {
                const node = tree[key];
                stack.push({
                    key,
                    value: node,
                });
            }
        }
    }

    return stack;
}

export default treeToList;
