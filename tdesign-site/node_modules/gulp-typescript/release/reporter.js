"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const colors = require("ansi-colors");
function emptyCompilationResult(noEmit) {
    return {
        transpileErrors: 0,
        optionsErrors: 0,
        syntaxErrors: 0,
        globalErrors: 0,
        semanticErrors: 0,
        declarationErrors: 0,
        emitErrors: 0,
        noEmit,
        emitSkipped: false
    };
}
exports.emptyCompilationResult = emptyCompilationResult;
function countErrors(results) {
    return results.transpileErrors
        + results.optionsErrors
        + results.syntaxErrors
        + results.globalErrors
        + results.semanticErrors
        + results.declarationErrors
        + results.emitErrors;
}
exports.countErrors = countErrors;
function defaultFinishHandler(results) {
    let hasError = false;
    const showErrorCount = (count, type) => {
        if (count === 0)
            return;
        console.log('TypeScript:', colors.magenta(count.toString()), (type !== '' ? type + ' ' : '') + (count === 1 ? 'error' : 'errors'));
        hasError = true;
    };
    showErrorCount(results.transpileErrors, '');
    showErrorCount(results.optionsErrors, 'options');
    showErrorCount(results.syntaxErrors, 'syntax');
    showErrorCount(results.globalErrors, 'global');
    showErrorCount(results.semanticErrors, 'semantic');
    showErrorCount(results.declarationErrors, 'declaration');
    showErrorCount(results.emitErrors, 'emit');
    if (!results.noEmit) {
        if (results.emitSkipped) {
            console.log('TypeScript: emit', colors.red('failed'));
        }
        else if (hasError) {
            console.log('TypeScript: emit', colors.cyan('succeeded'), '(with errors)');
        }
    }
}
function nullReporter() {
    return {};
}
exports.nullReporter = nullReporter;
function defaultReporter() {
    return {
        error: (error) => {
            console.log(error.message);
        },
        finish: defaultFinishHandler
    };
}
exports.defaultReporter = defaultReporter;
function longReporter() {
    return {
        error: (error, typescript) => {
            if (error.tsFile) {
                console.log('[' + colors.gray('gulp-typescript') + '] ' + colors.red(error.fullFilename
                    + '(' + error.startPosition.line + ',' + error.startPosition.character + '): ')
                    + 'error TS' + error.diagnostic.code + ' ' + typescript.flattenDiagnosticMessageText(error.diagnostic.messageText, '\n'));
            }
            else {
                console.log(error.message);
            }
        },
        finish: defaultFinishHandler
    };
}
exports.longReporter = longReporter;
function fullReporter(fullFilename = false) {
    return {
        error: (error, typescript) => {
            console.log('[' + colors.gray('gulp-typescript') + '] '
                + colors.bgRed(error.diagnostic.code + '')
                + ' ' + colors.red(typescript.flattenDiagnosticMessageText(error.diagnostic.messageText, '\n')));
            if (error.tsFile) {
                console.log('> ' + colors.gray('file: ') + (fullFilename ? error.fullFilename : error.relativeFilename) + colors.gray(':'));
                const lines = error.tsFile.text.split(/(?:\r\n|\r|\n)/);
                const logLine = (lineIndex, errorStart, errorEnd) => {
                    const line = lines[lineIndex];
                    if (errorEnd === undefined)
                        errorEnd = line.length;
                    console.log('> ' + colors.gray('[' + (lineIndex + 1) + '] ')
                        + line.substring(0, errorStart)
                        + colors.red(line.substring(errorStart, errorEnd))
                        + line.substring(errorEnd));
                };
                for (let i = error.startPosition.line; i <= error.endPosition.line; i++) {
                    logLine(i, i === error.startPosition.line ? error.startPosition.character : 0, i === error.endPosition.line ? error.endPosition.character : undefined);
                }
            }
        },
        finish: defaultFinishHandler
    };
}
exports.fullReporter = fullReporter;
