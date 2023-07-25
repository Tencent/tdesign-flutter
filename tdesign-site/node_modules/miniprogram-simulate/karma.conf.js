// Karma configuration
// Generated on Fri Jan 11 2019 20:11:14 GMT+0800 (CST)

const path = require('path')

module.exports = function(config) {
  config.set({

    // base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: path.resolve(__dirname, 'test'),


    // frameworks to use
    // available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ['mocha'],


    // list of files / patterns to load in the browser
    files: [
        '../build.js',
        'spec/*.spec.js',
        'comp1/*',
        'comp2/*',
        'comp3/*',
        'comp4/*',
        'comp5/*',
        'comp5/comp/*',
        'comp7/*',
        'comp8/*',
        'comp8/comp/*',
    ],


    // list of files / patterns to exclude
    exclude: [
    ],


    // preprocess matching files before serving them to the browser
    // available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {
        'comp1/*': ['filemap'],
        'comp2/*': ['filemap'],
        'comp3/*': ['filemap'],
        'comp4/*': ['filemap'],
        'comp5/*': ['filemap'],
        'comp5/comp/*': ['filemap'],
        'comp7/*': ['filemap'],
        'comp8/*': ['filemap'],
        'comp8/comp/*': ['filemap'],
        'spec/*.spec.js': ['webpack', 'dirname'],
    },


    // test results reporter to use
    // possible values: 'dots', 'progress'
    // available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ['progress'],


    // web server port
    port: 9876,


    // enable / disable colors in the output (reporters and logs)
    colors: true,


    // level of logging
    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_INFO,


    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: true,


    // start these browsers
    // available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    browsers: ['ChromeHeadless'],


    // Continuous Integration mode
    // if true, Karma captures browsers, runs the tests and exits
    singleRun: true,

    // Concurrency level
    // how many browser should be started simultaneous
    concurrency: Infinity,

    webpack: {
        optimization: {
            minimize: false,
        },
        node: {
            __dirname: false,
        },
    },

    fileMapPreprocessor: {
        // compilerOptions
        maxBuffer: 5 * 1024 * 1024,
    },
  })
}
