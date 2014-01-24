
expect  = require('chai').expect;
fs = require 'fs';
spd = require('../src/spd.js');

describe 'spd parese real spd file',->
  parseFile =(file)->
    fileContent = fs.readFileSync file,'utf-8';
    procedures = spd.parse fileContent;

  it 'spd file list',->
    path = 'test/sdl_form/'
    spdFileList = fs.readdirSync path

    expect(spdFileList).to.have.length.above(5)
    spdFileList.forEach (file)->
      fullPath =  path + file
      parseFile fullPath
