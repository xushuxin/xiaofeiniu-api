// 小肥牛扫码点餐项目API子系统
const port = 8090;
const express=require('express');

var app=express();
app.listen(port,()=>{
  console.log(" Server Listening "+port+".....")
})