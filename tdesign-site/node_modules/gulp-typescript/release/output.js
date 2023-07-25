"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const path = require("path");
const sourceMap = require("source-map");
const VinylFile = require("vinyl");
const utils = require("./utils");
const reporter = require("./reporter");
class Output {
    constructor(_project, streamFull, streamJs, streamDts) {
        // Number of pending IO operatrions
        this.pendingIO = 0;
        this.project = _project;
        this.streamFull = streamFull;
        this.streamJs = streamJs;
        this.streamDts = streamDts;
    }
    writeJs(base, fileName, content, sourceMapContent, cwd, original) {
        this.pipeRejection(this.writeJsAsync(base, fileName, content, sourceMapContent, cwd, original), this.streamJs);
    }
    writeJsAsync(base, fileName, content, sourceMapContent, cwd, original) {
        return __awaiter(this, void 0, void 0, function* () {
            const file = new VinylFile({
                path: fileName,
                contents: Buffer.from(content),
                cwd,
                base
            });
            this.pendingIO++;
            yield this.applySourceMap(sourceMapContent, original, file).then(appliedSourceMap => {
                if (appliedSourceMap)
                    file.sourceMap = JSON.parse(appliedSourceMap);
                this.streamFull.push(file);
                this.streamJs.push(file);
                this.pendingIO--;
                this.mightFinish();
            });
        });
    }
    writeDts(base, fileName, content, declarationMapContent, cwd, original) {
        this.pipeRejection(this.writeDtsAsync(base, fileName, content, declarationMapContent, cwd, original), this.streamDts);
    }
    writeDtsAsync(base, fileName, content, declarationMapContent, cwd, original) {
        return __awaiter(this, void 0, void 0, function* () {
            const file = new VinylFile({
                path: fileName,
                contents: Buffer.from(content),
                cwd,
                base
            });
            this.pendingIO++;
            yield this.applySourceMap(declarationMapContent, original, file).then(appliedSourceMap => {
                if (appliedSourceMap)
                    file.sourceMap = JSON.parse(appliedSourceMap);
                this.streamFull.push(file);
                this.streamDts.push(file);
                this.pendingIO--;
                this.mightFinish();
            });
        });
    }
    applySourceMap(sourceMapContent, original, output) {
        return __awaiter(this, void 0, void 0, function* () {
            if (sourceMapContent === undefined)
                return undefined;
            const map = JSON.parse(sourceMapContent);
            const directory = path.dirname(output.path);
            // gulp-sourcemaps docs:
            // paths in the generated source map (`file` and `sources`) are relative to `file.base` (e.g. use `file.relative`).
            map.file = utils.forwardSlashes(output.relative);
            map.sources = map.sources.map(relativeToOutput);
            delete map.sourceRoot;
            const consumer = yield new sourceMap.SourceMapConsumer(map);
            const generator = sourceMap.SourceMapGenerator.fromSourceMap(consumer);
            const sourceMapOrigins = this.project.singleOutput
                ? this.project.input.getFileNames(true).map(fName => this.project.input.getFile(fName))
                : [original];
            for (const sourceFile of sourceMapOrigins) {
                if (!sourceFile || !sourceFile.gulp || !sourceFile.gulp.sourceMap)
                    continue;
                const inputOriginalMap = sourceFile.gulp.sourceMap;
                const inputMap = typeof inputOriginalMap === 'object' ? inputOriginalMap : JSON.parse(inputOriginalMap);
                // We should only apply the input mappings if the input mapping isn't empty,
                // since `generator.applySourceMap` has a really bad performance on big inputs.
                if (inputMap.mappings !== '') {
                    const inputConsumer = yield new sourceMap.SourceMapConsumer(inputMap);
                    generator.applySourceMap(inputConsumer);
                    inputConsumer.destroy();
                }
                if (!inputMap.sources || !inputMap.sourcesContent)
                    continue;
                for (let i = 0; i < inputMap.sources.length; i++) {
                    const absolute = path.resolve(sourceFile.gulp.base, inputMap.sources[i]);
                    const relative = path.relative(output.base, absolute);
                    generator.setSourceContent(utils.forwardSlashes(relative), inputMap.sourcesContent[i]);
                }
            }
            consumer.destroy();
            return generator.toString();
            function relativeToOutput(fileName) {
                const absolute = path.resolve(directory, fileName);
                return utils.forwardSlashes(path.relative(output.base, absolute));
            }
        });
    }
    // Avoids UnhandledPromiseRejectionWarning in NodeJS
    pipeRejection(promise, alternateStream) {
        promise.catch(err => {
            this.streamFull.emit("error", err);
            alternateStream.emit("error", err);
        });
    }
    finish(result) {
        this.result = result;
        this.mightFinish();
    }
    mightFinish() {
        if (this.result === undefined || this.pendingIO !== 0)
            return;
        if (this.project.reporter.finish)
            this.project.reporter.finish(this.result);
        if (reporter.countErrors(this.result) !== 0) {
            this.streamFull.emit('error', new Error("TypeScript: Compilation failed"));
        }
        this.streamFull.emit('finish');
        this.streamFull.push(null);
        this.streamJs.push(null);
        this.streamDts.push(null);
    }
    getError(info) {
        let fileName = info.file && info.file.fileName;
        const file = fileName && this.project.input.getFile(fileName);
        return utils.getError(info, this.project.typescript, file);
    }
    diagnostic(info) {
        this.error(this.getError(info));
    }
    error(error) {
        if (!error)
            return;
        // call reporter callback
        if (this.project.reporter.error)
            this.project.reporter.error(error, this.project.typescript);
        // & emit the error on the stream.
    }
}
exports.Output = Output;
