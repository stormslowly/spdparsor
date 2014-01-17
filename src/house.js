"use strict";
var http = require("http");
var fs   = require("fs");
var cheer= require("cheerio");
var BufferHelper = require('bufferhelper');
var iconv = require('iconv-lite');

var exec = require('child_process').exec;




var taskFileContent = fs.readFileSync("../test/uniq.house.txt","utf-8");

var tasks = taskFileContent.split("\n");

var task = tasks[0];

function assembleCMD(task){
  var url = task.split(" ")[0];
  var name = task.split(" ")[1];

  var cmd = 'curl  --proxy http://10.144.1.10:8080 ' + url +
            ' -H "Accept-Encoding: gzip" '  + ' |  gunzip > ' + name +'.html';
  return cmd;
}

function handleTask( task ){


  var child = exec( assembleCMD(task),
      function (error, stdout, stderr) {
      if (error !== null) {
        console.log('exec error: ' + error);
      }
      console.log("done",task);
  });

}




// handleTask(task);

tasks.forEach(function(t,i){
  // console.log(i,t);
  handleTask(t);
});

// console.log(tasks);