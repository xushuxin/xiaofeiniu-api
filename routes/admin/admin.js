/**
 * 管理员相关路由
*/
const express = require('express');
const pool = require('../../pool');
var router = express.Router();
module.exports = router;

/*
*API：GET /admin/login
*请求数据：{aname:'xxx',apwd:'xxx'} 
*用户登录验证(有的项目选择post请求)
*返回数据：
*{code:200,msg:'login succ'}
*{code:400,msg:'aname or apwd err'}
*/
router.get('/login/:aname/:apwd', (req, res) => {
  var aname = req.params.aname;
  var apwd = req.params.apwd;
  pool.query('SELECT aid FROM xfn_admin WHERE aname=? AND apwd=PASSWORD(?)', [aname, apwd], (err, result) => {
    if (err) throw err;
    if (result.length > 0) {
      res.send({ code: 200, msg: 'login success' })
    } else {
      res.send({ code: 400, msg: 'aname or apwd err' })
    }
  })
})
/*
*API：PATCH /admin/login //修改部分数据用PATCH
*请求数据：{aname:'xxx',oldPwd:'xxx',newPwd:'xxx'} 
*根据管理员名和密码修改管理员密码
*返回数据：
*{code:200,msg:'modified succ'}//修改成功
*{code:400,msg:'aname or oldPwd err'}//用户名或者旧密码错误
*{code:401,msg:' apwd not modified'}//新旧密码相同
*/
router.patch('/', (req, res) => {
  var data = req.body;
  console.log(data);
  //首先根据aname/oldPwd查询该用户是否存在
  pool.query('SELECT aid FROM xfn_admin WHERE aname=? AND apwd=PASSWORD(?)',[data.aname,data.oldPwd],(err,result)=>{
    if (err) throw err;
    if(result.length>0){//如果查询到了用户，在修改其密码
      pool.query('UPDATE xfn_admin SET apwd=PASSWORD(?) WHERE aid=?',[data.newPwd,result[0].aid],(err,result)=>{
        if (err) throw err;
        if(result.changedRows>0){
          res.send({code:200,msg:'modified success'});
        }else{
          res.send({code:401,msg:'pwd not modified'});
        }
        
      })
    }else{
      res.send({code:400,msg:'aname or oldPwd err'})
    }
  })
})