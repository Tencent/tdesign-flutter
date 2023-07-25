# tree-to-list

[![npm](https://img.shields.io/npm/v/tree-to-list)](https://www.npmjs.com/package/tree-to-list)
[![download](https://img.shields.io/npm/dt/tree-to-list)](https://www.npmjs.com/package/tree-to-list)

> Flatten tree to list


## Install

```
$ npm install tree-to-list
```


## Usage

```js
const treeToList = require('tree-to-list');

// flatten array tree
const arrayTree = [{
    name: 'name1',
    children: [{
        name: 'name3',
        children: [{
            name: 'name5'
        }]
    }, {
        name: 'name4'
    }]
}, {
    name: 'name2'
}];

console.log(treeToList(arrayTree, 'children'));
/*
[
    { name: 'name1' },
    { name: 'name3' },
    { name: 'name5' },
    { name: 'name4' },
    { name: 'name2' }
]
*/

// flatten object tree
const objectTree = {
    node1: {
        name: 'name1',
        tree: {
            node3: {
                name: 'name3',
                tree: {
                    node2: {
                        name: 'name5',
                        key5: 'value5'
                    }
                }
            },
            node4: { name: 'name4' },
        }
    },
    node2: {
        name: 'name2',
        key2: 'value2'
    }
};

console.log(treeToList(objectTree, 'tree'));
/*
{
    node1: { name: 'name1' },
    node3: { name: 'name3' },
    node4: { name: 'name4' },
    node2: {
        name: 'name2',
        key5: 'value5',
        key2: 'value2'
    }
}
*/
```


## API

### treeToList(tree, key)

Returns flattened `Array` or `Object` list.

#### tree

Type: `Array` or `Object`

##### key

Type: `String`\
Default: `'children'`

The key of child nodes.


## License

MIT
