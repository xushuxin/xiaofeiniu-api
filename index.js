// 小肥牛扫码点餐项目API子系统
const port = 8090; 
const express=require('express');
const cors=require('cors');
const bodyParser=require('body-parser');
const categoryRouter=require('./routes/admin/category');
const adminRouter=require('./routes/admin/admin');
const dishRouter=require('./routes/admin/dish');
const settingsRouter=require('./routes/admin/settings')
const tableRouter=require('./routes/admin/table')



 
//创建应用HTTP服务器
var app=express();
app.listen(port,()=>{
  console.log("Server Listening on:"+port)
})

//使用中间件
app.use(cors());
app.use(bodyParser.urlencoded({extended:false}));//把x-www-form-urlencoded格式的请求主体数据解析出来放入req.body属性
app.use(bodyParser.json());//把JSON格式的请求主体数据解析出来放入req.body属性
//挂载管理后台必需路由
app.use('/admin/category',categoryRouter)
app.use('/admin',adminRouter)
app.use('/admin/dish',dishRouter)
app.use('/admin/settings',settingsRouter)
app.use('/admin/table',tableRouter)

//挂载顾客App必需的路由
app.use('/dish',dishRouter)
