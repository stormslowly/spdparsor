
expect  = require('chai').expect;
fs = require 'fs';
spd = require('../src/spd.js');

describe 'spd parese real spd file',->
  parseFile =(file)->
    fileContent = fs.readFileSync file,'utf-8';
    procedures = spd.parse fileContent;

  it.only 'spd file list',->
    path = 'test/sdl_form/'
    spdFileList = fs.readdirSync path
    if (spdFileList.length == 0 )
      return ;
    spdFileList.forEach (file)->
      fullPath =  path + file
      console.log(file);
      parseFile fullPath

  it 'new test' ,->
    console.log ( JSON.stringify(parseFile 'test/sdl_form/clugengx.spd'))
