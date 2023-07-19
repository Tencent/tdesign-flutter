/// <reference types="node" />
import * as stream from 'stream';
import * as ts from 'typescript';
import { Reporter } from './reporter';
import { FileCache } from './input';
import { Output } from './output';
import { ICompiler } from './compiler';
import { FinalTransformers, TsConfig } from './types';
export interface Project {
    (reporter?: Reporter): ICompileStream;
    src(this: Project): NodeJS.ReadWriteStream;
    readonly typescript?: typeof ts;
    readonly projectDirectory: string;
    readonly configFileName: string;
    readonly rawConfig: any;
    readonly config: TsConfig;
    readonly options: ts.CompilerOptions;
    readonly projectReferences: ReadonlyArray<ts.ProjectReference> | undefined;
}
export interface ProjectInfo {
    input: FileCache;
    output: Output;
    compiler: ICompiler;
    singleOutput: boolean;
    options: ts.CompilerOptions;
    projectReferences: ReadonlyArray<ts.ProjectReference>;
    typescript: typeof ts;
    directory: string;
    reporter: Reporter;
}
export declare function setupProject(projectDirectory: string, configFileName: string, rawConfig: any, config: TsConfig, options: ts.CompilerOptions, projectReferences: ReadonlyArray<ts.ProjectReference>, typescript: typeof ts, finalTransformers: FinalTransformers): Project;
export interface ICompileStream extends NodeJS.ReadWriteStream {
    js: stream.Readable;
    dts: stream.Readable;
}
