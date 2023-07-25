"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const utils = require("./utils");
class Host {
    constructor(typescript, currentDirectory, input, options) {
        this.getCurrentDirectory = () => {
            return this.currentDirectory;
        };
        this.writeFile = (fileName, data, writeByteOrderMark, onError) => { };
        this.fileExists = (fileName) => {
            let sourceFile = this.input.getFile(fileName);
            if (sourceFile)
                return true;
            return this.fallback.fileExists(fileName);
        };
        this.readFile = (fileName) => {
            let sourceFile = this.input.getFile(fileName);
            if (sourceFile)
                return sourceFile.content;
            return this.fallback.readFile(fileName);
        };
        this.getSourceFile = (fileName, languageVersion, onError) => {
            // TODO: Cache lib.d.ts files between compilations
            let sourceFile = this.input.getFile(fileName);
            if (sourceFile)
                return sourceFile.ts;
            return this.fallback.getSourceFile(fileName, languageVersion, onError);
        };
        this.realpath = (path) => this.fallback.realpath(path);
        this.getDirectories = (path) => this.fallback.getDirectories(path);
        this.directoryExists = (path) => this.fallback.directoryExists(path);
        this.readDirectory = (rootDir, extensions, excludes, includes, depth) => this.fallback.readDirectory(rootDir, extensions, excludes, includes, depth);
        this.typescript = typescript;
        this.fallback = typescript.createCompilerHost(options);
        this.currentDirectory = currentDirectory;
        this.input = input;
    }
    getNewLine() {
        return '\n';
    }
    useCaseSensitiveFileNames() {
        return this.fallback.useCaseSensitiveFileNames();
    }
    getCanonicalFileName(filename) {
        return utils.normalizePath(this.useCaseSensitiveFileNames(), filename);
    }
    getDefaultLibFileName(options) {
        return this.fallback.getDefaultLibFileName(options);
    }
    getDefaultLibLocation() {
        return this.fallback.getDefaultLibLocation();
    }
}
exports.Host = Host;
