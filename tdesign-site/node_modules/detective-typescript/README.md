### detective-typescript [![CI](https://github.com/pahen/detective-typescript/actions/workflows/ci.yml/badge.svg)](https://github.com/pahen/detective-typescript/actions/workflows/ci.yml) [![npm](http://img.shields.io/npm/v/detective-typescript.svg)](https://npmjs.org/package/detective-typescript) [![npm](http://img.shields.io/npm/dm/detective-typescript.svg)](https://npmjs.org/package/detective-typescript)

> Get the dependencies of TypeScript module

```sh
npm install detective-typescript
```

### Usage

```js
const detective = require('detective-typescript');
const mySourceCode = fs.readFileSync('myfile.ts', 'utf8');

// Pass in a file's content or an AST
const dependencies = detective(mySourceCode);
```

### Options

- `skipTypeImports` (default: `false`) Skips imports that only imports types
- `mixedImports`: (default: `false`) Include CJS imports in dependency list
- `skipAsyncImports`: (default: `false`) Whether or not to omit async imports (import('foo'))
- `jsx`: (default: `false`) Enable parsing of JSX

#### License

MIT
