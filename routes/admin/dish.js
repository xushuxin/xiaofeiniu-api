/**
 * 菜品相关路由
*/
const express = require('express');
const pool = require('../../pool');
var router = express.Router();
module.exports = router;

/*
*API：GET /admin/dish
*获取菜品（按类别进行分类） 
*返回数据：
*[
  {cid:1,cname:'肉类',dishList:[{},{},...]}
  {cid:2,cname:'蔬菜类',dishList:[{},{},...]}
  ...
]
*/
router.get('/',(req,res)=>{
  //查询所有的菜品类别
  pool.query('SELECT cid,cname FROM xfn_category',(err,result)=>{
    if(err) throw err;
    var categoryList =result;//菜品类别数组
    var count=0;
    for(var c of categoryList){
      //循环查询每个类别下有哪些菜品
      pool.query('SELECT * FROM xfn_dish WHERE categoryId=?',c.cid,(err,result)=> {
        c.dishList=result;
        count++;
        if(count==categoryList.length){
          res.send(categoryList);
        }
      })
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
