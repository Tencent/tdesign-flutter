"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const path = require("path");
const colors = require("ansi-colors");
function forwardSlashes(fileName) {
    return fileName.replace(/\\/g, '/');
}
exports.forwardSlashes = forwardSlashes;
function normalizePath(caseSensitive, pathString) {
    const normalized = path.normalize(pathString);
    if (!caseSensitive)
        return normalized.toLowerCase();
    return normalized;
}
exports.normalizePath = normalizePath;
/**
 * Splits a filename into an extensionless filename and an extension.
 * 'bar/foo.js' is turned into ['bar/foo', 'js']
 * 'foo.d.ts' is parsed as ['foo', 'd.ts'] if you add 'd.ts' to knownExtensions.
 * @param knownExtensions An array with known extensions, that contain multiple parts, like 'd.ts'. 'a.b.c' should be listed before 'b.c'.
 */
function splitExtension(fileName, knownExtensions) {
    if (knownExtensions) {
        for (const ext of knownExtensions) {
            const index = fileName.length - ext.length - 1;
            if (fileName.substr(index) === '.' + ext) {
                return [fileName.substr(0, index), ext];
            }
        }
    }
    const ext = path.extname(fileName).toLowerCase().substr(1);
    const index = fileName.length - ext.length;
    return [fileName.substr(0, index - 1), ext];
}
exports.splitExtension = splitExtension;
/**
 * Finds the common base path of two directories
 */
function getCommonBasePath(a, b) {
    const aSplit = a.split(/\\|\//); // Split on '/' or '\'.
    const bSplit = b.split(/\\|\//);
    let commonLength = 0;
    for (let i = 0; i < aSplit.length && i < bSplit.length; i++) {
        if (aSplit[i] !== bSplit[i])
            break;
        commonLength += aSplit[i].length + 1;
    }
    return a.substr(0, commonLength);
}
exports.getCommonBasePath = getCommonBasePath;
function getCommonBasePathOfArray(paths) {
    if (paths.length === 0)
        return '';
    return paths.reduce(getCommonBasePath);
}
exports.getCommonBasePathOfArray = getCommonBasePathOfArray;
function getError(info, typescript, file) {
    const err = new Error();
    err.name = 'TypeScript error';
    err.diagnostic = info;
    const codeAndMessageText = typescript.DiagnosticCategory[info.category].toLowerCase() +
        ' TS' +
        info.code +
        ': ' +
        typescript.flattenDiagnosticMessageText(info.messageText, '\n');
    if (!info.file) {
        err.message = codeAndMessageText;
        return err;
    }
    let fileName = info.file.fileName;
    if (file) {
        err.tsFile = file.ts;
        err.fullFilename = file.fileNameOriginal;
        if (file.gulp) {
            fileName = path.relative(file.gulp.cwd, file.fileNameOriginal);
            err.relativeFilename = fileName;
            err.file = file.gulp;
        }
        else {
            fileName = file.fileNameOriginal;
        }
    }
    else {
        err.fullFilename = info.file.fileName;
    }
    const startPos = typescript.getLineAndCharacterOfPosition(info.file, info.start);
    const endPos = typescript.getLineAndCharacterOfPosition(info.file, info.start + info.length);
    err.startPosition = {
        position: info.start,
        line: startPos.line,
        character: startPos.character
    };
    err.endPosition = {
        position: info.start + info.length - 1,
        line: endPos.line,
        character: endPos.character
    };
    err.message = colors.red(fileName + '(' + (startPos.line + 1) + ',' + (startPos.character + 1) + '): ').toString()
        + codeAndMessageText;
    return err;
}
exports.getError = getError;
function deprecate(title, alternative, description) {
    message(title, alternative, description);
    console.log('  ' + colors.gray('More information: ' + colors.underline('http://dev.ivogabe.com/gulp-typescript-3/')));
}
exports.deprecate = deprecate;
function message(title, alternative, description) {
    console.log(colors.red('gulp-typescript').toString() +
        colors.gray(': ') +
        title +
        colors.gray(' - ') +
        alternative);
    if (description)
        console.log('  ' + colors.gray(description.replace(/\n/g, '\n  ')));
}
exports.message = message;
