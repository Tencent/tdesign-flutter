'use strict';
const path = require('path');
const uuid = require('uuid');
const tempDirectory = require('temp-dir');

module.exports = (extension = '') => path.join(tempDirectory, uuid.v4() + extension);
