/// <reference types="node" />
import * as stream from 'stream';
import * as ts from 'typescript';
import * as input from './input';
import * as reporter from './reporter';
import * as project from './project';
export declare class Output {
    constructor(_project: project.ProjectInfo, streamFull: stream.Readable, streamJs: stream.Readable, streamDts: stream.Readable);
    project: project.ProjectInfo;
    result: reporter.CompilationResult;
    streamFull: stream.Readable;
    streamJs: stream.Readable;
    streamDts: stream.Readable;
    private pendingIO;
    writeJs(base: string, fileName: string, content: string, sourceMapContent: string, cwd: string, original: input.File): void;
    private writeJsAsync;
    writeDts(base: string, fileName: string, content: string, declarationMapContent: string, cwd: string, original: input.File): void;
    private writeDtsAsync;
    private applySourceMap;
    private pipeRejection;
    finish(result: reporter.CompilationResult): void;
    private mightFinish;
    private getError;
    diagnostic(info: ts.Diagnostic): void;
    error(error: reporter.TypeScriptError): void;
}
