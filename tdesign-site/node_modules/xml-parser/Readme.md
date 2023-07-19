
# xml-parser

  Simple non-compiant XML parser because we just need to parse some basic responses and libxml takes forever to compile :D you probably don't want to use this unless you also have similar needs.

## Installation

```
$ npm install xml-parser
```

## Example

 JavaScript:

```js
var fs = require('fs');
var parse = require('xml-parser');
var xml = fs.readFileSync('examples/developerforce.xml', 'utf8');
var inspect = require('util').inspect;

var obj = parse(xml);
console.log(inspect(obj, { colors: true, depth: Infinity }));
```

XML:

```xml
<?xml version="1.0" encoding="utf-8"?>
 <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
   xmlns="urn:enterprise.soap.sforce.com">
   <soapenv:Body>
      <createResponse>
         <result>
            <id>003D000000OY9omIAD</id>
            <success>true</success>
         </result>
         <result>
            <id>001D000000HTK3aIAH</id>
            <success>true</success>
         </result>
      </createResponse>
   </soapenv:Body>
 </soapenv:Envelope>
```

Yields:

```js
{ declaration: { attributes: { version: '1.0', encoding: 'utf-8' } },
  root:
   { name: 'soapenv:Envelope',
     attributes:
      { 'xmlns:soapenv': 'http://schemas.xmlsoap.org/soap/envelope/',
        xmlns: 'urn:enterprise.soap.sforce.com' },
     children:
      [ { name: 'soapenv:Body',
          attributes: {},
          children:
           [ { name: 'createResponse',
               attributes: {},
               children:
                [ { name: 'result',
                    attributes: {},
                    children:
                     [ { name: 'id',
                         attributes: {},
                         children: [],
                         content: '003D000000OY9omIAD' },
                       { name: 'success', attributes: {}, children: [], content: 'true' } ],
                    content: '' },
                  { name: 'result',
                    attributes: {},
                    children:
                     [ { name: 'id',
                         attributes: {},
                         children: [],
                         content: '001D000000HTK3aIAH' },
                       { name: 'success', attributes: {}, children: [], content: 'true' } ],
                    content: '' } ],
               content: '' } ],
          content: '' } ],
     content: '' } }
```

# License

  MIT