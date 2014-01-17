
fs = require 'fs';
cheer = require 'cheerio';
iconv = require('iconv-lite');



taskFileContent = fs.readFileSync("../test/uniq.house.txt","utf-8");

tasks = taskFileContent.split("\n");



parse = (task) ->
  name = task.split(' ')[1];
  url  = task.split(' ')[0];

  #readBuffer = fs.readFileSync(name+".html");

  fileName = name + '.html'

  utfContent = iconv.decode( fs.readFileSync(fileName),'GBK' );


  jQueryDom  = cheer.load utfContent;

  dueDate = jQueryDom('#xfxq_B04_18').text().replace('预计','');
  price   = jQueryDom('.arial20_red').text();
  rePrice = jQueryDom('.biia_0').eq(2).text();
  rePrice = rePrice.replace('物','')
                   .replace('业','')
                   .replace('费','').trim();

  promotion = jQueryDom('#dianshang_box h2').text().trim();


  console.log("%s\t%s\t%s\t%s\t%s\t%s",url,name,dueDate,price,rePrice,promotion)


#parse(tasks[0])

tasks.forEach (t)->
  parse t