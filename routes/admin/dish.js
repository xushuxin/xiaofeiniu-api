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
router.get('/', (req, res) => {
  //查询所有的菜品类别
  pool.query('SELECT cid,cname FROM xfn_category ORDER BY cid', (err, result) => {
    if (err) throw err;
    result.forEach((el, i, arr) => {//也可以使用let创建for循环，每次创建的都是局部变量（只要循环体内有异步操作就需要，如：绑定事件、查询数据库）
      pool.query('SELECT * FROM xfn_dish WHERE categoryId=? ORDER BY did DESC', el.cid, (err, result) => {
        if (err) throw err;
        el.dishList = result;
        if (i == arr.length - 1) {
          res.send(arr);
        }
      })
    });
  })
})

/*
*API：POST /admin/dish/image //非幂等，每次上传都会重新提交
*请求参数
*接收客户端上传的菜品图片，保存在服务器上，返回该图片在服务器上的随机文件名
*响应数据形如：
*{code:200,msg:"upload success",fileName:'1234546789-1537'}
*/
//引入multer中间件
const multer = require('multer');//第三方模块需要下载
const fs = require('fs');//核心模块，不用下载
var upload = multer({
  dest: 'tmp/'//指定客户端上传的文件临时存储路径
})
//定义路由，使用文件上传中间件
router.post('/image', upload.single('dishImg'), (req, res) => {
  // console.log(req.file);//客户端上传的图片
  // console.log(req.body);//客户端随图片提交的字符数据
  //把客户端上传的文件从临时的目录转移到永久的图片路径下
  var imgName = req.file.originalname;//原始文件名
  var tmpFile = req.file.path;//临时文件名(包括路径)
  var suffix = imgName.substring(imgName.lastIndexOf('.'));//原始文件名中的后缀名部分
  var newFile = randomFileName(suffix);//目标文件名
  fs.rename(tmpFile, 'img/dish/' + newFile, () => {//把临时路径转换成新路径
    res.send({ code: 200, msg: 'upload success', fileName: newFile })
  })
})

//生成一个随机文件名
//suffix表示图片后缀
//参数形如156454456-xxxx.jpg
function randomFileName(suffix) {
  var time = new Date().getTime();//当前系统时间
  var num = Math.floor(Math.random() * (10000 - 1000) + 1000);//4位随机数
  return time + '-' + num + suffix;
}
/*
*API：POST /admin/dish //非幂等，每次上传都会重新提交
*请求参数：{title:'xx',imgUrl:'..jpg',price:xx,detail:'xx',categoryId:xx}
*添加一个新菜品
*输出消息
*{code:200,msg:'dish added success',dishId:46}
*/
router.post('/', (req, res) => {
  pool.query('INSERT INTO xfn_dish SET ?', req.body, (err, result) => {
    if (err) throw err;
    res.send({code:200,msg:'dish added success',dishId:result.insertId})//将INSERT语句产生的自增编号输出给客户端
  })
})
/**
 * DELETE /admin/dish/:did
 * 根据指定的菜品编号删除该菜品
 * 输出数据：
 * {code:200,msg:'dish deleted success'}
 * {code:400,msg:'dish not exists'}
*/

/*
*API：PUT /admin/dish //幂等
*请求参数：{did:xx,title:'xx',imgUrl:'..jpg',price:xx,detail:'xx',categoryId:xx}
*根据指定的菜品编号修改菜品
*输出消息
*{code:200,msg:'dish updated success'}
*{code:400,msg:'dish not exists'}
*/
