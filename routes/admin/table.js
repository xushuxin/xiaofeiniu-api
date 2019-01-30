const express =require('express')
const pool =require('../../pool')
var router=express.Router();
module.exports=router;

/* 桌台相关路由器 */
/* GET /admin/table
获取所有桌台信息
返回信息
[
  {tid:xxx,tname:'xxx',status:'xxx'}
  ...
]
*/
router.get('/',(req,res)=>{
  pool.query('SELECT * FROM xfn_table ORDER BY tid',(err,result)=>{
    if(err) throw err;
    res.send(result);
  })
})
/* PUT /admin/settings
获取所有全局设置信息
返回信息
{code:200,msg:"xx"}
*/
router.put('/',(req,res)=>{
  pool.query('UPDATE xfn_settings SET ?',req.body,(err,result)=>{
    if(err) throw err;
    res.send({code:200,msg:'settings updated success'});
  })
})