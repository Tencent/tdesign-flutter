/**
Get a random temporary file path.

@param extension - Extension to append to the path.

@example
```
import tempfile = require('tempfile');

tempfile('.png');
//=> '/var/folders/3x/jf5977fn79jbglr7rk0tq4d00000gn/T/4049f192-43e7-43b2-98d9-094e6760861b.png'

tempfile();
//=> '/var/folders/3x/jf5977fn79jbglr7rk0tq4d00000gn/T/6271e235-13b9-4138-8b9b-ee2f26c09ce3'
```
*/
declare function tempfile(extension?: string): string;

export = tempfile;
