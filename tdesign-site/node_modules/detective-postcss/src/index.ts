import * as d from 'debug';
import { parse, AtRule } from 'postcss';
import * as postCssValuesParser from 'postcss-values-parser';
import isUrl = require('is-url');

const debug = d('detective-postcss');

function detective(src, options: detective.Options = { url: false }) {
    let references = [];
    let root;
    try {
        root = parse(src);
    } catch (e) {
        throw new detective.MalformedCssError();
    }
    root.walkAtRules(rule => {
        let file = null;
        if (isImportRule(rule)) {
            const firstNode = parseValue(rule.params).first;
            file = getValueOrUrl(firstNode);
            if (file) {
                debug(`found %s of %s`, '@import', file);
            }
        }
        if (isValueRule(rule)) {
            const lastNode = parseValue(rule.params).last;
            if (isFrom(lastNode.prev())) {
                file = getValueOrUrl(lastNode);
                if (file) {
                    debug(`found %s of %s`, '@value with import', file);
                }
            }
            if (options.url && isUrlNode(lastNode)) {
                file = getValueOrUrl(lastNode);
                if (file) {
                    debug(`found %s of %s`, 'url() with import', file);
                }
            }
        }
        file && references.push(file);
    });
    if (options.url) {
        root.walkDecls(decl => {
            const { nodes } = parseValue(decl.value);
            const files = nodes.filter(isUrlNode).map(getValueOrUrl);
            if (files) {
                files.forEach(file =>
                    debug(`found %s of %s`, 'url() with import', file)
                );
                references = references.concat(files);
            }
        });
    }
    return references;
}

function parseValue(value: string) {
    return postCssValuesParser(value).parse().first;
}

function getValueOrUrl(node: postCssValuesParser.Node) {
    let ret;
    if (isUrlNode(node)) {
        // ['(', 'file', ')']
        ret = node.nodes[1].value;
    } else {
        ret = node.value;
    }
    // is-url sometimes gets data: URLs wrong
    return !isUrl(ret) && !ret.startsWith('data:') && ret;
}

function isUrlNode(node: postCssValuesParser.Node) {
    return node.type === 'func' && node.value === 'url';
}

function isValueRule(rule: AtRule) {
    return rule.name === 'value';
}

function isImportRule(rule: AtRule) {
    return rule.name === 'import';
}

function isFrom(node: postCssValuesParser.Node) {
    return node.type == 'word' && node.value === 'from';
}

namespace detective {
    export interface Options {
        url: boolean;
    }

    export class MalformedCssError extends Error {}
}

export = detective;
