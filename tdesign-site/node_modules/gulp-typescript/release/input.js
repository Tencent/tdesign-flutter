"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const path = require("path");
const utils = require("./utils");
var FileChangeState;
(function (FileChangeState) {
    FileChangeState[FileChangeState["New"] = 0] = "New";
    FileChangeState[FileChangeState["Equal"] = 1] = "Equal";
    FileChangeState[FileChangeState["Modified"] = 2] = "Modified";
    FileChangeState[FileChangeState["Deleted"] = 3] = "Deleted";
    FileChangeState[FileChangeState["NotFound"] = 4] = "NotFound";
})(FileChangeState = exports.FileChangeState || (exports.FileChangeState = {}));
var FileKind;
(function (FileKind) {
    FileKind[FileKind["Source"] = 0] = "Source";
    FileKind[FileKind["Config"] = 1] = "Config";
})(FileKind = exports.FileKind || (exports.FileKind = {}));
var File;
(function (File) {
    function fromContent(caseSensitive, fileName, content) {
        let kind = FileKind.Source;
        if (path.extname(fileName).toLowerCase() === 'json')
            kind = FileKind.Config;
        return {
            fileNameNormalized: utils.normalizePath(caseSensitive, fileName),
            fileNameOriginal: fileName,
            content,
            kind
        };
    }
    File.fromContent = fromContent;
    function fromGulp(caseSensitive, file) {
        let str = file.contents.toString('utf8');
        let data = fromContent(caseSensitive, file.path, str);
        data.gulp = file;
        return data;
    }
    File.fromGulp = fromGulp;
    function equal(a, b) {
        if (a === undefined || b === undefined)
            return a === b; // They could be both undefined.
        return (a.fileNameOriginal === b.fileNameOriginal)
            && (a.content === b.content);
    }
    File.equal = equal;
    function getChangeState(previous, current) {
        if (previous === undefined) {
            return current === undefined ? FileChangeState.NotFound : FileChangeState.New;
        }
        if (current === undefined) {
            return FileChangeState.Deleted;
        }
        if (equal(previous, current)) {
            return FileChangeState.Equal;
        }
        return FileChangeState.Modified;
    }
    File.getChangeState = getChangeState;
})(File = exports.File || (exports.File = {}));
class FileDictionary {
    constructor(caseSensitive, typescript) {
        this.files = {};
        this.firstSourceFile = undefined;
        this.caseSensitive = caseSensitive;
        this.typescript = typescript;
    }
    addGulp(gFile) {
        return this.addFile(File.fromGulp(this.caseSensitive, gFile));
    }
    addContent(fileName, content) {
        return this.addFile(File.fromContent(this.caseSensitive, fileName, content));
    }
    addFile(file) {
        if (file.kind === FileKind.Source) {
            this.initTypeScriptSourceFile(file);
            if (!this.firstSourceFile)
                this.firstSourceFile = file;
        }
        this.files[file.fileNameNormalized] = file;
        return file;
    }
    getFile(name) {
        return this.files[utils.normalizePath(this.caseSensitive, name)];
    }
    getFileNames(onlyGulp = false) {
        const fileNames = [];
        for (const fileName in this.files) {
            if (!this.files.hasOwnProperty(fileName))
                continue;
            let file = this.files[fileName];
            if (onlyGulp && !file.gulp)
                continue;
            fileNames.push(file.fileNameOriginal);
        }
        return fileNames;
    }
    getSourceFileNames(onlyGulp) {
        const fileNames = this.getFileNames(onlyGulp);
        const sourceFileNames = fileNames
            .filter(fileName => fileName.substr(fileName.length - 5).toLowerCase() !== '.d.ts');
        if (sourceFileNames.length === 0) {
            // Only definition files, so we will calculate the common base path based on the
            // paths of the definition files.
            return fileNames;
        }
        return sourceFileNames;
    }
    get commonBasePath() {
        const fileNames = this.getSourceFileNames(true);
        return utils.getCommonBasePathOfArray(fileNames.map(fileName => {
            const file = this.files[utils.normalizePath(this.caseSensitive, fileName)];
            return path.resolve(process.cwd(), file.gulp.base);
        }));
    }
    // This empty setter will prevent that TS emits 'readonly' modifier.
    // 'readonly' is not supported in current stable release.
    set commonBasePath(value) { }
    get commonSourceDirectory() {
        const fileNames = this.getSourceFileNames();
        return utils.getCommonBasePathOfArray(fileNames.map(fileName => {
            const file = this.files[utils.normalizePath(this.caseSensitive, fileName)];
            return path.dirname(file.fileNameNormalized);
        }));
    }
    // This empty setter will prevent that TS emits 'readonly' modifier.
    // 'readonly' is not supported in current stable release.
    set commonSourceDirectory(value) { }
}
exports.FileDictionary = FileDictionary;
class FileCache {
    constructor(typescript, options, caseSensitive) {
        this.previous = undefined;
        this.noParse = false; // true when using a file based compiler.
        this.version = 0;
        this.typescript = typescript;
        this.options = options;
        this.caseSensitive = caseSensitive;
        this.createDictionary();
    }
    addGulp(gFile) {
        return this.current.addGulp(gFile);
    }
    addContent(fileName, content) {
        return this.current.addContent(fileName, content);
    }
    reset() {
        this.version++;
        this.previous = this.current;
        this.createDictionary();
    }
    createDictionary() {
        this.current = new FileDictionary(this.caseSensitive, this.typescript);
        this.current.initTypeScriptSourceFile = (file) => this.initTypeScriptSourceFile(file);
    }
    initTypeScriptSourceFile(file) {
        if (this.noParse)
            return;
        if (this.previous) {
            let previous = this.previous.getFile(file.fileNameOriginal);
            if (File.equal(previous, file)) {
                file.ts = previous.ts; // Re-use previous source file.
                return;
            }
        }
        file.ts = this.typescript.createSourceFile(file.fileNameOriginal, file.content, this.options.target);
    }
    getFile(name) {
        return this.current.getFile(name);
    }
    getFileChange(name) {
        let previous;
        if (this.previous) {
            previous = this.previous.getFile(name);
        }
        let current = this.current.getFile(name);
        return {
            previous,
            current,
            state: File.getChangeState(previous, current)
        };
    }
    getFileNames(onlyGulp = false) {
        return this.current.getFileNames(onlyGulp);
    }
    get firstSourceFile() {
        return this.current.firstSourceFile;
    }
    // This empty setter will prevent that TS emits 'readonly' modifier.
    // 'readonly' is not supported in current stable release.
    set firstSourceFile(value) { }
    get commonBasePath() {
        return this.current.commonBasePath;
    }
    set commonBasePath(value) { }
    get commonSourceDirectory() {
        return this.current.commonSourceDirectory;
    }
    set commonSourceDirectory(value) { }
    isChanged(onlyGulp = false) {
        if (!this.previous)
            return true;
        const files = this.getFileNames(onlyGulp);
        const oldFiles = this.previous.getFileNames(onlyGulp);
        if (files.length !== oldFiles.length)
            return true;
        for (const fileName of files) {
            if (oldFiles.indexOf(fileName) === -1)
                return true;
        }
        for (const fileName of files) {
            const change = this.getFileChange(fileName);
            if (change.state !== FileChangeState.Equal)
                return true;
        }
        return false;
    }
}
exports.FileCache = FileCache;
