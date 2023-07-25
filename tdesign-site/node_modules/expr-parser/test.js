const Expression = require('./index');

test('parse normal', () => {
  let expr = new Expression('"\\u2605haha"').parse();
  expect(expr({})).toBe('★haha');

  expr = new Expression('"\\n\\r\\f\\t\\v\\s"').parse();
  expect(expr({})).toBe('\n\r\f\t\v\s');

  expr = new Expression('2e3').parse();
  expect(expr({})).toBe(2000);

  expr = new Expression('2e-3').parse();
  expect(expr({})).toBe(0.002);

  expr = new Expression('+"123"').parse();
  expect(expr({})).toBe('123');

  expr = new Expression('-123').parse();
  expect(expr({})).toBe(-123);

  expr = new Expression('a.b.c.d').parse();
  expect(expr({ a: { b: null } })).toBe(null);

  expr = new Expression('{ a: {}, b: [] }').parse();
  expect(expr({})).toEqual({ a: {}, b: [] });

  expr = new Expression(']123').parse();
  expect(expr({})).toBe(undefined);
});

test('parse constants', () => {
  let expr = new Expression('a === null').parse();
  expect(expr({ a: null })).toBe(true);
  expect(expr({ a: 1 })).toBe(false);

  expr = new Expression('a === undefined').parse();
  expect(expr({ a: undefined })).toBe(true);
  expect(expr({ a: 1 })).toBe(false);

  expr = new Expression('a === true').parse();
  expect(expr({ a: true })).toBe(true);
  expect(expr({ a: 1 })).toBe(false);

  expr = new Expression('a === false').parse();
  expect(expr({ a: false })).toBe(true);
  expect(expr({ a: 1 })).toBe(false);
});

test('parse operators', () => {
  let expr = new Expression('a.value + 12 - (2 * 14 / 4)').parse();
  expect(expr({ a: { value: 1 } })).toBe(6);
  expect(expr({ a: { value: 3 } })).toBe(8);

  expr = new Expression('a && b || c && ( d || e )').parse();
  expect(expr({ a: true, b: false, c: true, d: false, e: true })).toBe(true);
  expect(expr({ a: false, b: true, c: false, d: true, e: false })).toBe(false);

  expr = new Expression('a.value + 12 - (2 * 14 / 4)').parse();
  expect(expr({ a: { value: 1 } })).toBe(6);
  expect(expr({ a: { value: 3 } })).toBe(8);

  expr = new Expression('a === b && a !== c').parse();
  expect(expr({ a: 1, b: 1, c: '1' })).toBe(true);
  expect(expr({ a: 1, b: 1, c: 1 })).toBe(false);

  expr = new Expression('a > 3 && b < 10').parse();
  expect(expr({ a: 4, b: 5 })).toBe(true);
  expect(expr({ a: 3, b: 5 })).toBe(false);
  expect(expr({ a: 4, b: 11 })).toBe(false);

  expr = new Expression('a.list[i + 1]').parse();
  expect(expr({ a: { list: [0, 5, 10] }, i: 1 })).toBe(10);
  expect(expr({ a: { list: [0, 5, 10] }, i: 0 })).toBe(5);

  expr = new Expression('a > b ? b : a').parse();
  expect(expr({ a: 2, b: 1 })).toBe(1);
  expect(expr({ a: 2, b: 3 })).toBe(2);

  expr = new Expression('a % b == 1 && c % d == 2 && e % f != 1').parse();
  expect(expr({ a: 21, b: 2, c: 8, d: 3, e: 3, f: 3 })).toBe(true);

  expr = new Expression('a == b').parse();
  expect(expr({ a: 10, b: 10 })).toBe(true);
  expect(expr({ a: 10, b: '10' })).toBe(true);
  expect(expr({ a: 10, b: '110' })).toBe(false);

  expr = new Expression('a != b').parse();
  expect(expr({ a: 10, b: 10 })).toBe(false);
  expect(expr({ a: 10, b: '10' })).toBe(false);
  expect(expr({ a: 10, b: '110' })).toBe(true);

  expr = new Expression('a >= b && c <= d').parse();
  expect(expr({ a: 2, b: 2, c: 3, d: 3 })).toBe(true);
  expect(expr({ a: 3, b: 2, c: 3, d: 4 })).toBe(true);
  expect(expr({ a: 2, b: 2, c: 3, d: 2 })).toBe(false);
  expect(expr({ a: 1, b: 2, c: 3, d: 3 })).toBe(false);

  expr = new Expression('!a').parse();
  expect(expr({ a: 1 })).toBe(false);
  expect(expr({ a: 0 })).toBe(true);
});

test('parse object/array/function', () => {
  let expr = new Expression('a["b"].c + a.d["e"]').parse();
  expect(expr({ a: { b: { c: 1 }, d: { e: 2 } } })).toBe(3);

  expr = new Expression('{ a: { b: { "c": null }, d: { e: 2 }, } }').parse();
  expect(expr({})).toEqual({ a: { b: { c: null }, d: { e: 2 } } });

  expr = new Expression('a(1, 2)').parse();
  expect(expr({ a: (num1, num2) => num1 + num2 })).toBe(3);

  expr = new Expression('a.b()').parse();
  expect(expr({ a: { b: function () { return this.c + this.d; }, c: 2, d: 3 } })).toBe(5);

  expr = new Expression('[1, 2, 3, ][2]').parse();
  expect(expr({})).toBe(3);
});

test('error', () => {
  function getErr(str) {
    let catchErr = null;
    try {
      new Expression(str).parse();
    } catch (err) {
      catchErr = err;
    }

    return catchErr && catchErr.message || '';
  }

  expect(getErr()).toBe('invalid expression');
  expect(getErr('{ ;a: 123 }')).toBe('parse expression error: { ;a: 123 }');
  expect(getErr(';')).toBe('parse expression error: ;');
  expect(getErr('\\')).toBe('invalid expression: \\');
  expect(getErr('"" || "\\uzzzz"')).toBe('invalid expression: "" || "\\uzzzz", invalid unicode escape [\\uzzzz]');
  expect(getErr('"')).toBe('invalid expression: "');
  expect(getErr('2e-a')).toBe('invalid expression: 2e-a');
  expect(getErr('1 === 1 ? true')).toBe('parse expression error: 1 === 1 ? true');
  expect(getErr('1 === 1 ? true ;')).toBe('parse expression error: 1 === 1 ? true ;');
})
