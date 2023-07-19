const cloneDeep = require('lodash/cloneDeep')
const treeToList = require('../dist/treeToList')

test('flatten array tree', () => {
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
    const arrayTreeClone = cloneDeep(arrayTree);

    expect(
        treeToList(arrayTree)
    ).toEqual([
        { name: 'name1' },
        { name: 'name3' },
        { name: 'name5' },
        { name: 'name4' },
        { name: 'name2' }
    ]);
    expect(arrayTree).toEqual(arrayTreeClone);
});

test('flatten object tree', () => {
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
    const objectTreeClone = cloneDeep(objectTree);

    expect(
        treeToList(objectTree, 'tree')
    ).toEqual({
        node1: { name: 'name1' },
        node3: { name: 'name3' },
        node4: { name: 'name4' },
        node2: {
            name: 'name2',
            key5: 'value5',
            key2: 'value2'
        }
    });
    expect(objectTree).toEqual(objectTreeClone);
});

test('flatten null node', () => {
    const tree = [{
        name: 'name1',
        children: [{
            name: 'name3',
            children: null
        }, null]
    }, {
        name: 'name2'
    }];
    const treeClone = cloneDeep(tree);

    expect(
        treeToList(tree)
    ).toEqual([
        { name: 'name1' },
        { name: "name3" },
        { name: 'name2' },
    ]);
    expect(tree).toEqual(treeClone);
});

test('flatten invalid tree', () => {
    const invalidTree = 'tree';

    expect(
        treeToList(invalidTree)
    ).toEqual([]);
});

test('maximum call stack size', () => {
    const createData = (deep, breadth) => {
        const data = {};
        let temp = data;
        for (let i = 0; i < deep; i++) {
            temp = temp['children'] = {};
            for (let j = 0; j < breadth; j++) {
                temp[j] = j;
            }
        }
        return data;
    };

    const data = createData(10000);

    expect(() => {
        treeToList(data);
    }).not.toThrow('Maximum call stack size exceeded');
});
