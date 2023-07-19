const ESCAPE = {
  'n': '\n',
  'f': '\f',
  'r': '\r',
  't': '\t',
  'v': '\v',
};

const CONSTANTS = {
  'null': data => null,
  'true': data => true,
  'false': data => false,
  'undefined': data => undefined,
}

const OPERATORS = {
  '+': (data, a, b) => a(data) + b(data),
  '-': (data, a, b) => a(data) - b(data),
  '*': (data, a, b) => a(data) * b(data),
  '/': (data, a, b) => a(data) / b(data),
  '%': (data, a, b) => a(data) % b(data),
  '===': (data, a, b) => a(data) === b(data),
  '!==': (data, a, b) => a(data) !== b(data),
  '==': (data, a, b) => a(data) == b(data),
  '!=': (data, a, b) => a(data) != b(data),
  '<': (data, a, b) => a(data) < b(data),
  '>': (data, a, b) => a(data) > b(data),
  '<=': (data, a, b) => a(data) <= b(data),
  '>=': (data, a, b) => a(data) >= b(data),
  '&&': (data, a, b) => a(data) && b(data),
  '||': (data, a, b) => a(data) || b(data),
  '!': (data, a) => !a(data),
};

function isNumber(char) {
  return char >= '0' && char <= '9' && typeof char === 'string';
}

function isExpOperator(char) {
  return (char === '-' || char === '+' || isNumber(char));
}

function isIdent(char) {
  return char >= 'a' && char <= 'z' || char >= 'A' && char <= 'Z' || char === '_' || char === '$';
}

class Expression {
  constructor(content) {
    if (!content) throw new Error('invalid expression');

    this.content = content;
  }

  lex() {
    let content = this.content;
    let length = content.length;
    let index = 0;
    let tokens = [];

    while (index < length) {
      let char = content.charAt(index);

      if (char === '"' || char === '\'') {
        // 字符串
        let start = ++index;
        let escape = false;
        let value = '';
        let token;

        while (index < length) {
          let c = content.charAt(index);

          if (escape) {
            if (c === 'u') {
              let hex = content.substring(index + 1, index + 5);
              if (!hex.match(/[\da-f]{4}/i)) {
                throw new Error(`invalid expression: ${content}, invalid unicode escape [\\u${hex}]`);
              }
              index += 4;
              value += String.fromCharCode(parseInt(hex, 16));
            } else {
              let rep = ESCAPE[c];
              value = value + (rep || c);
            }
            escape = false;
          } else if (c === '\\') {
            escape = true;
          } else if (c === char) {
            index++;
            token = {
              index: start,
              constant: true,
              text: char + value + char,
              value,
            };
            break;
          } else {
            value += c;
          }

          index++;
        }

        if (!token) {
          throw new Error(`invalid expression: ${content}`);
        } else {
          tokens.push(token);
        }
      } else if (isNumber(char) || (char === '.' && isNumber(content.charAt(index + 1)))) {
        // 数字
        let start = index;
        let value = '';

        while (index < length) {
          let c = content.charAt(index).toLowerCase();
          if (c === '.' || isNumber(c)) {
            value += c;
          } else {
            let c2 = content.charAt(index + 1);
            if (c === 'e' && isExpOperator(c2)) {
              value += c;
            } else if (isExpOperator(c) && c2 && isNumber(c2) && value.charAt(value.length - 1) === 'e') {
              value += c;
            } else if (isExpOperator(c) && (!c2 || !isNumber(c2)) && value.charAt(value.length - 1) == 'e') {
              throw new Error(`invalid expression: ${content}`);
            } else {
              break;
            }
          }
          index++;
        }

        tokens.push({
          index: start,
          constant: true,
          text: value,
          value: Number(value),
        })
      } else if (isIdent(char)) {
        // 标识符
        let start = index;
        while (index < length) {
          let c = content.charAt(index);
          if (!(isIdent(c) || isNumber(c))) {
            break;
          }
          index++;
        }

        tokens.push({
          index: start,
          text: content.slice(start, index),
          identifier: true
        });
      } else if ('(){}[].,;:?'.indexOf(char) >= 0) {
        // 边界
        tokens.push({
          index,
          text: char
        });

        index++;
      } else if (char === ' ' || char === '\r' || char === '\t' || char === '\n' || char === '\v' || char === '\u00A0') {
        // 空格
        index++;
      } else {
        // 操作符
        let char2 = char + content.charAt(index + 1);
        let char3 = char2 + content.charAt(index + 2);
        let op1 = OPERATORS[char];
        let op2 = OPERATORS[char2];
        let op3 = OPERATORS[char3];
        if (op1 || op2 || op3) {
          let text = op3 ? char3 : op2 ? char2 : char;

          tokens.push({
            index: index,
            text,
            operator: true
          });

          index += text.length;
        } else {
          throw new Error(`invalid expression: ${content}`);
        }
      }
    }

    this.tokens = tokens;
    return tokens;
  }

  parse() {
    let tokens = this.lex();

    let func;
    let token = tokens[0];
    let text = token.text;

    if (tokens.length > 0 && text !== '}' && text !== ')' && text !== ']') {
      func = this.expression();
    }

    return data => func && func(data);
  }

  expect(text) {
    let tokens = this.tokens;
    let token = tokens[0];

    if (!text || text === (token && token.text)) {
      return tokens.shift();
    }
  }

  consume(text) {
    if (!this.tokens.length) throw new Error(`parse expression error: ${this.content}`);

    let token = this.expect(text);
    if (!token) throw new Error(`parse expression error: ${this.content}`);

    return token;
  }

  expression() {
    return this.ternary();
  }

  ternary() {
    let left = this.logicalOR();
    let token;

    if (token = this.expect('?')) {
      let middle = this.expression();

      this.consume(':')
      let right = this.expression();

      return data => left(data) ? middle(data) : right(data);
    }

    return left;
  }

  binary(left, op, right) {
    let fn = OPERATORS[op];

    return data => fn(data, left, right);
  }

  unary() {
    let token;

    if (this.expect('+')) {
      return this.primary();
    } else if (token = this.expect('-')) {
      return this.binary(data => 0, token.text, this.unary());
    } else if (token = this.expect('!')) {
      let fn = OPERATORS[token.text];
      let right = this.unary();

      return data => fn(data, right); 
    } else {
      return this.primary();
    }
  }

  logicalOR() {
    let left = this.logicalAND();
    let token;

    while (token = this.expect('||')) {
      left = this.binary(left, token.text, this.logicalAND());
    }

    return left;
  }

  logicalAND() {
    let left = this.equality();
    let token;

    while (token = this.expect('&&')) {
      left = this.binary(left, token.text, this.equality());
    }

    return left;
  }

  equality() {
    let left = this.relational();
    let token;

    while (token = this.expect('==') || this.expect('!=') || this.expect('===') || this.expect('!==')) {
      left = this.binary(left, token.text, this.relational());
    }

    return left;
  }

  relational() {
    let left = this.additive();
    let token;

    while (token = this.expect('<') || this.expect('>') || this.expect('<=') || this.expect('>=')) {
      left = this.binary(left, token.text, this.additive());
    }

    return left;
  }

  additive() {
    let left = this.multiplicative();
    let token;

    while (token = this.expect('+') || this.expect('-')) {
      left = this.binary(left, token.text, this.multiplicative());
    }

    return left;
  }

  multiplicative() {
    let left = this.unary();
    let token;

    while (token = this.expect('*') || this.expect('/') || this.expect('%')) {
      left = this.binary(left, token.text, this.unary());
    }

    return left;
  }

  primary() {
    let token = this.tokens[0];
    let primary;

    if (this.expect('(')) {
      primary = this.expression();
      this.consume(')');
    } else if (this.expect('[')) {
      primary = this.array();
    } else if (this.expect('{')) {
      primary = this.object();
    } else if (token.identifier && token.text in CONSTANTS) {
      primary = CONSTANTS[this.consume().text];
    } else if (token.identifier) {
      primary = this.identifier();
    } else if (token.constant) {
      primary = this.constant();
    } else {
      throw new Error(`parse expression error: ${this.content}`);
    }

    let next;
    let context;
    while (next = this.expect('(') || this.expect('[') || this.expect('.')) {
      if (next.text === '(') {
        primary = this.functionCall(primary, context);
        context = null;
      } else if (next.text === '[') {
        context = primary;
        primary = this.objectIndex(primary);
      } else {
        context = primary;
        primary = this.fieldAccess(primary);
      }
    }
    return primary;
  }

  fieldAccess(object) {
    let getter = this.identifier();

    return data => {
      let o = object(data);
      return o && getter(o);
    };
  }

  objectIndex(object) {
    let indexFn = this.expression();

    this.consume(']');

    return data => {
      let o = object(data);
      let key = indexFn(data) + '';

      return o && o[key];
    };
  }

  functionCall(func, context) {
    let args = [];

    if (this.tokens[0].text !== ')') {
      do {
        args.push(this.expression());
      } while (this.expect(','));
    }

    this.consume(')');

    return data => {
      let callContext = context && context(data);
      let fn = func(data, callContext);

      return fn && fn.apply(callContext, args.length ? args.map(arg => arg(data)) : null);
    };
  }

  array() {
    let elements = [];
    let token = this.tokens[0];

    if (token.text !== ']') {
      do {
        if (this.tokens[0].text === ']') break;

        elements.push(this.expression());
      } while (this.expect(','));
    }

    this.consume(']');

    return data => elements.map(element => element(data));
  }

  object() {
    let keys = [];
    let values = [];
    let token = this.tokens[0];

    if (token.text !== '}') {
      do {
        token = this.tokens[0];
        if (token.text === '}') break;

        token = this.consume();
        if (token.constant) {
          keys.push(token.value);
        } else if (token.identifier) {
          keys.push(token.text);
        } else {
          throw new Error(`parse expression error: ${this.content}`);
        }

        this.consume(':');
        values.push(this.expression());
      } while (this.expect(','));
    }

    this.consume('}');

    return data => {
      let object = {};
      for (let i = 0, length = values.length; i < length; i++) {
        object[keys[i]] = values[i](data);
      }
      return object;
    };
  }

  identifier() {
    let id = this.consume().text;

    let token = this.tokens[0];
    let token2 = this.tokens[1];
    let token3 = this.tokens[2];

    // 连续读取 . 操作符后的非函数调用标识符
    while (token && token.text === '.' && token2 && token2.identifier && token3 && token3.text !== '(') {
      id += this.consume().text + this.consume().text;

      token = this.tokens[0];
      token2 = this.tokens[1];
      token3 = this.tokens[2];
    }

    return data => {
      let elements = id.split('.');
      let key;

      for (let i = 0; elements.length > 1; i++) {
        key = elements.shift();
        data = data[key];

        if (!data) break;
      }

      key = elements.shift();

      return data && data[key];
    };
  }

  constant() {
    let value = this.consume().value;

    return data => value;
  }
}

module.exports = Expression;
