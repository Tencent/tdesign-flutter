// incomplete declarations for the postcss-values-parser
declare module 'postcss-values-parser' {
    namespace parser {
        interface Node {
            first?: parser.Node;
            last?: parser.Node;
            prev?(): parser.Node;
            type:
                | 'atword'
                | 'colon'
                | 'comma'
                | 'comment'
                | 'func'
                | 'number'
                | 'operator'
                | 'paren'
                | 'string'
                | 'unicoderange'
                | 'word';
            value: string;
            nodes?: Node[];
        }
    }
    function parser(str: string): { parse(): parser.Node };
    export = parser;
}
