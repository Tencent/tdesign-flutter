const path = require('path')

module.exports = {
    target: 'web',
    entry: path.join(__dirname, './index.js'),
    output: {
        path: __dirname,
        filename: 'build.js',
        library: 'simulate',
        libraryTarget: 'window',
    },
    optimization: {
        minimize: false,
    },
    node: {
        process: false,
        fs: 'empty',
    },
}
