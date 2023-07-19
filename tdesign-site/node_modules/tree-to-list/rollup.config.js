// rollup.config.js
import resolve from '@rollup/plugin-node-resolve';
import commonjs from '@rollup/plugin-commonjs';
import babel from 'rollup-plugin-babel';
import merge from 'lodash/merge';

const { version } = require('./package.json');

const banner = `/** tree-to-list v${version}\n`
    + ' * - https://www.npmjs.com/package/tree-to-list\n'
    + ' * - https://github.com/mcc108/tree-to-list\n'
    + ' */\n';

export default [{
    output: {
        file: 'dist/treeToList.js',
        format: 'cjs',
    }
}, {
    output: {
        file: 'dist/treeToList.esm.js',
        format: 'esm',
    }
}].map(config => merge({
    input: 'src/index.js',
    output: {
        file: 'dist/treeToList.js',
        name: 'treeToList',
        banner,
        exports: 'default',
    },
    plugins: [
        resolve(),
        babel(),
        commonjs()
    ],
}, config));
