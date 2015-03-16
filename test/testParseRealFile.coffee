
expect  = require('chai').expect;
fs = require 'fs';
spd = require('../src/spd.js');

describe 'spd parese real spd file',->
  parseFile =(file)->
    fileContent = fs.readFileSync file,'utf-8';
    procedures = spd.parse fileContent;

  it.only 'spd file list',->

    long = 0;
    who = ''
    format = (func)->
      head= "#{func.return} #{func.name} ("

      l = func.name?.length

      if(l>long)
        who = func.name
        long = l;

      paras = func.parameters?.map (p)->
        "#{p.type} #{p.name}"
      .join()

      head+paras+")"


    path = 'test/sdl_form/'
    spdFileList = fs.readdirSync path
    if (spdFileList.length == 0 )
      return ;
    num = 0;
    spdFileList.forEach (file)->
      fullPath =  path + file
      console.log(file);
      funcs = parseFile fullPath
      funcs.forEach (func)->
        num += 1
        console.log format func

    console.log "this is #{num} func #{long} #{who}"
  it 'new test' ,->
    funcs = parseFile 'test/sdl_form/clugengx.spd'
    console.log funcs