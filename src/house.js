
var http = require("http");

function download(url,cb){
  
  var html = "";
  http.get(url, function dcb(res){
    
    
    res.on("data",function(data){
      html = html + data;
    });

    res.on("end",function(){
       cb(null, html);
    });

  }).on('error',function(err){
    cb(err);
  });

}



download("http://www.baidu.com",function(e,d){
  console.log(e,d);

})