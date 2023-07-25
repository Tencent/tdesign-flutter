"use strict";
var __rest = (this && this.__rest) || function (s, e) {
    var t = {};
    for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p) && e.indexOf(p) < 0)
        t[p] = s[p];
    if (s != null && typeof Object.getOwnPropertySymbols === "function")
        for (var i = 0, p = Object.getOwnPropertySymbols(s); i < p.length; i++) {
            if (e.indexOf(p[i]) < 0 && Object.prototype.propertyIsEnumerable.call(s, p[i]))
                t[p[i]] = s[p[i]];
        }
    return t;
};
Object.defineProperty(exports, "__esModule", { value: true });
const stream = require("stream");
const vfs = require("vinyl-fs");
const path = require("path");
const PluginError = require("plugin-error");
const utils = require("./utils");
const reporter_1 = require("./reporter");
const input_1 = require("./input");
const output_1 = require("./output");
const compiler_1 = require("./compiler");
function setupProject(projectDirectory, configFileName, rawConfig, config, options, projectReferences, typescript, finalTransformers) {
    const caseSensitive = typescript.createCompilerHost(options).useCaseSensitiveFileNames();
    const input = new input_1.FileCache(typescript, options, caseSensitive);
    const compiler = options.isolatedModules ? new compiler_1.FileCompiler() : new compiler_1.ProjectCompiler();
    let running = false;
    if (options.isolatedModules) {
        options.newLine = typescript.NewLineKind.LineFeed;
        options.sourceMap = false;
        options.declaration = false;
        options.inlineSourceMap = true;
    }
    const project = (reporter) => {
        if (running) {
            throw new Error('gulp-typescript: A project cannot be used in two compilations at the same time. Create multiple projects with createProject instead.');
        }
        running = true;
        input.reset();
        compiler.prepare(projectInfo, finalTransformers);
        const stream = new CompileStream(projectInfo);
        projectInfo.output = new output_1.Output(projectInfo, stream, stream.js, stream.dts);
        projectInfo.reporter = reporter || reporter_1.defaultReporter();
        stream.on('finish', () => {
            running = false;
        });
        return stream;
    };
    const singleOutput = options.out !== undefined || options.outFile !== undefined;
    project.src = src;
    project.typescript = typescript;
    project.projectDirectory = projectDirectory;
    project.configFileName = configFileName;
    project.rawConfig = rawConfig;
    project.config = config;
    project.options = options;
    project.projectReferences = projectReferences;
    const projectInfo = {
        input,
        singleOutput,
        compiler,
        options,
        projectReferences,
        typescript,
        directory: projectDirectory,
        // Set when `project` is called
        output: undefined,
        reporter: undefined
    };
    return project;
}
exports.setupProject = setupProject;
function src() {
    if (arguments.length >= 1) {
        utils.message("tsProject.src() takes no arguments", "Use gulp.src(..) if you need to specify a glob");
    }
    let base;
    if (this.options["rootDir"]) {
        base = path.resolve(this.projectDirectory, this.options["rootDir"]);
    }
    const _a = this.rawConfig, { extends: _extends } = _a, config = __rest(_a, ["extends"]);
    const { fileNames, errors } = this.typescript.parseJsonConfigFileContent(config, this.typescript.sys, path.resolve(this.projectDirectory), undefined, this.configFileName);
    for (const error of errors) {
        console.log(error.messageText);
    }
    if (base === undefined)
        base = utils.getCommonBasePathOfArray(fileNames.filter(file => file.substr(-5) !== ".d.ts")
            .map(file => path.dirname(file)));
    const vinylOptions = { base, allowEmpty: true };
    return vfs.src(fileNames, vinylOptions);
}
class CompileStream extends stream.Duplex {
    constructor(project) {
        super({ objectMode: true });
        this.js = new CompileOutputStream();
        this.dts = new CompileOutputStream();
        this.project = project;
    }
    _write(file, encoding, cb = (err) => { }) {
        if (!file)
            return cb();
        if (file.isNull()) {
            cb();
            return;
        }
        if (file.isStream()) {
            return cb(new PluginError('gulp-typescript', 'Streaming not supported'));
        }
        const inputFile = this.project.input.addGulp(file);
        this.project.compiler.inputFile(inputFile);
        cb();
    }
    _read() {
    }
    end(chunk, encoding, callback) {
        if (typeof chunk === 'function') {
            this._write(null, null, chunk);
        }
        else if (typeof encoding === 'function') {
            this._write(chunk, null, encoding);
        }
        else {
            this._write(chunk, encoding, callback);
        }
        this.project.compiler.inputDone();
    }
}
class CompileOutputStream extends stream.Readable {
    constructor() {
        super({ objectMode: true });
    }
    _read() {
    }
}
