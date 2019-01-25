SET NAMES UTF8;
DROP DATABASE IF EXISTS xiaofeiniu;
CREATE DATABASE xiaofeiniu CHARSET=UTF8;
USE xiaofeiniu;

--管理员信息表
CREATE TABLE xfn_admin(
  aid INT PRIMARY KEY AUTO_INCREMENT,#管理员编号
  aname VARCHAR(32) UNIQUE,#管理员用户名
  apwd VARCHAR(64)#管理员密码
);

--项目全局设置
CREATE TABLE xfn_setting(
  sid INT PRIMARY KEY AUTO_INCREMENT,#编号
  appName VARCHAR(64),#应用名称
  apiUrl VARCHAR(64),#数据API子系统地址
  adminUrl VARCHAR(64),#管理子系统地址
  appUrl VARCHAR(64),#顾客App子系统地址
  icp VARCHAR(64),# 系统备案信息
  copyright VARCHAR(128)#系统版权信息
);
--桌台信息表
CREATE TABLE xfn_table(
  tid INT PRIMARY KEY AUTO_INCREMENT,#桌台编号
  tname VARCHAR(64) DEFAULT NULL,#别称
  ttype VARCHAR(16),#类型，如3—4人桌
  tstatus INT# 当前状态 0——其它，1——空闲，2——预定，3——占用
);

--桌台预定信息表
CREATE TABLE xfn_reservation(
  rid INT PRIMARY KEY AUTO_INCREMENT,#订单编号
  contactName VARCHAR(64),#联系人姓名
  phone VARCHAR(16),#联系人电话
  contactTime BIGINT, #联系时间
  dinnerTime BIGINT#预约的用餐时间
);

--菜品分类表
CREATE TABLE xfn_category(
  cid INT PRIMARY KEY AUTO_INCREMENT,#类别编号
  cname VARCHAR(32)#类别名称
);

--菜品信息表
CREATE TABLE xfn_dish(
  did INT PRIMARY KEY AUTO_INCREMENT,#菜品编号起始值 100000
  title VARCHAR(32),#菜品名称
  imgUrl VARCHAR(128),#图片地址
  price DECIMAL(6,2),#菜品价格 
  detail VARCHAR(128),#详细描述信息
  categoryId INT ,#所属类别的编号  
  FOREIGN KEY(categoryId) REFERENCES xfn_category(cid)#设置外键
);
--订单表
CREATE TABLE xfn_order(
  oid INT PRIMARY KEY AUTO_INCREMENT,
  startTime BIGINT,#开始用餐时间
  endTime BIGINT,#结束用餐时间
  customerCount INT,#用餐人数
  tableId INT#桌台编号，指明所属桌台
  FOREIGN KEY(tableId) REFERENCES  xfn_table(tid),#设置外键
);
--订单详情
CREATE TABLE xfn_order_detail(
  did INT PRIMARY KEY AUTO_INCREMENT,
  dishId INT,#菜品编号，指明所属菜品
  dishCount INT,#菜品数量
  customerName VARCHAR(64),#点餐用户的称呼
  orderId INT,订单编号，指明所属订单
  FOREIGN KEY(dishId) REFERENCES xfn_dish(did),#设置外键
  FOREIGN KEY(orderId) REFERENCES xfn_order(oid)#设置外键
);

