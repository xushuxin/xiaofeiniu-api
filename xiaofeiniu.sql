SET NAMES UTF8;
DROP DATABASE IF EXISTS xiaofeiniu;
CREATE DATABASE xiaofeiniu CHARSET=UTF8;
USE xiaofeiniu;

-- 管理员信息表
CREATE TABLE xfn_admin(
  aid INT PRIMARY KEY AUTO_INCREMENT,#管理员编号
  aname VARCHAR(32) UNIQUE,#管理员用户名
  apwd VARCHAR(64)#管理员密码
);
INSERT INTO xfn_admin VALUES
(NULL,'admin',PASSWORD('123456')),
(NULL,'boss',PASSWORD('999999'));


-- 项目全局设置
CREATE TABLE xfn_setting(
  sid INT PRIMARY KEY AUTO_INCREMENT,#编号
  appName VARCHAR(64),#应用名称
  apiUrl VARCHAR(64),#数据API子系统地址
  adminUrl VARCHAR(64),#管理子系统地址
  appUrl VARCHAR(64),#顾客App子系统地址
  icp VARCHAR(64),# 系统备案信息
  copyright VARCHAR(128)#系统版权信息
); 
INSERT INTO xfn_setting VALUES
(NULL,'小肥牛','http://127.0.0.1:8090','http://127.0.0.1:8091','http://127.0.0.1:8092','京ICP备12003709号-3','北京达内金桥科技有限公司版权所有');

-- 桌台信息表
CREATE TABLE xfn_table(
  tid INT PRIMARY KEY AUTO_INCREMENT,#桌台编号
  tname VARCHAR(64) DEFAULT NULL,#别称
  type VARCHAR(16),#类型，如3—4人桌
  status INT #当前状态 0——其它，1——空闲，2——预定，3——占用
);

INSERT INTO xfn_table VALUES
(NULL,'福满堂','6-8人桌',1),
(NULL,'金镶玉','4人桌',2),
(NULL,'寿齐天','10人桌',3),
(NULL,'和家福','8人桌',0),
(NULL,'敬业福','8人桌',0),
(NULL,'和谐福','8人桌',0);

-- 桌台预定信息表
CREATE TABLE xfn_reservation(
  rid INT PRIMARY KEY AUTO_INCREMENT,#订单编号
  contactName VARCHAR(64),#联系人姓名
  phone VARCHAR(16),#联系人电话
  contactTime BIGINT, #联系时间
  dinnerTime BIGINT,#预约的用餐时间
  tableId INT,#预定的桌子
  FOREIGN KEY(tableId) REFERENCES xfn_table(tid)#设置外键
);

INSERT INTO xfn_reservation VALUES
(NULL,"张三",13866668888,1548404948807,1549404948807,1),
(NULL,"李四",13866667777,1548404948807,1549404948807,2),
(NULL,"张五",13866666666,1548404948807,1549404948807,3),
(NULL,"黄七",13866665555,1548404948807,1549404948807,4),
(NULL,"孙八",13866664444,1548404948807,1549404948807,5);
-- 菜品分类表
CREATE TABLE xfn_category(
  cid INT PRIMARY KEY AUTO_INCREMENT,#类别编号
  cname VARCHAR(32)#类别名称
);

INSERT INTO xfn_category VALUES
(NULL,"肉类"),
(NULL,"丸滑类"),
(NULL,"海鲜河鲜"),
(NULL,"蔬菜豆制品"),
(NULL,"菌菇类");

-- 菜品信息表
CREATE TABLE xfn_dish(
  did INT PRIMARY KEY AUTO_INCREMENT,#菜品编号起始值 100000
  title VARCHAR(32),#菜品名称
  imgUrl VARCHAR(128),#图片地址
  price DECIMAL(6,2),#菜品价格 
  detail VARCHAR(128),#详细描述信息
  categoryId INT ,#所属类别的编号  
  FOREIGN KEY(categoryId) REFERENCES xfn_category(cid)#设置外键
);
INSERT INTO xfn_dish VALUES
(100000,'草鱼片','CE7I9470.jpg',35,'选鲜活草鱼，切出鱼片冷鲜保存。锅开后再煮1分钟左右即可食用。',1),
(NULL,'脆皮肠','CE7I9017.jpg',25,'锅开后再煮3分钟左右即可食用。',1),
(NULL,'旭伟蟹肉墨鱼滑','1-CE7I8970.jpg',66,'将冰鲜墨鱼筒，经破碎、搅拌等工艺，再配以秘制调料，嵌入鲜毛蟹中。锅开后再煮4分钟左右即可食用。配上丸滑蘸碟，风味更突出。',2),
(NULL,'兆湛撒尿牛肉丸','EU0A0225.jpg',70,'选用牛后腿部位牛霖，经过排酸、绞碎、搅打成的牛肉滑，捏成丸子后，里面裹入用老鸡、火腿等精心熬制的汤冻。锅开后浮起来再煮3分钟左右即可食用。配上丸滑蘸碟，风味更突出。撒尿牛丸中心汤汁温度较高，吃时小心被汤汁烫到。',2),
(NULL,'冻虾','CE7I7004_dx.jpg',70,'将活虾冷冻而成。肉质脆嫩，锅开后再煮4分钟左右即可食用',3),
(NULL,'鱼豆腐','CE7I9538_ydf1.jpg',50,'选用优质鱼肉，配以佐料，搅打、蒸制而成。细嫩鲜滑，鱼香味浓。锅开后再煮2分钟左右即可食用。',3),
(NULL,'包心菜','baocai.jpg',15,'经过挑选、清洗、装盘而成。口感清香，锅开后再煮1分钟左右即可食用',4),
(NULL,'蒿子秆（皇帝菜）','CE7I9268_hzg1.jpg',70,'经过挑选、清洗、切配、装盘而成，锅开后再煮1分钟左右即可食用',4),
(NULL,'青笋','HGS_5023qs1.jpg',15,'经过去泥、挑选、去皮、清洗、切配、装盘而成。口感清脆，锅开后再煮4分钟左右即可食用',5),
(NULL,'有机香菇','CE7I9428_xg3.jpg',45,'经过挑选、清洗、装盘而成。锅开后再煮2分钟左右即可食用',5);
-- 订单表
CREATE TABLE xfn_order(
  oid INT PRIMARY KEY AUTO_INCREMENT,
  startTime BIGINT,#开始用餐时间
  endTime BIGINT,#结束用餐时间
  customerCount INT,#用餐人数
  tableId INT,#桌台编号，指明所属桌台
  FOREIGN KEY(tableId) REFERENCES xfn_table(tid)#设置外键
);
INSERT INTO xfn_order VALUES
(NULL,1548404948807,1548406948807,3,1);
-- 订单详情
CREATE TABLE xfn_order_detail(
  did INT PRIMARY KEY AUTO_INCREMENT,
  dishId INT,#菜品编号，指明所属菜品
  dishCount INT,#当前菜品数量
  customerName VARCHAR(64),#点餐用户的称呼
  orderId INT,#订单编号，指明所属订单
  FOREIGN KEY(dishId) REFERENCES xfn_dish(did),#设置外键
  FOREIGN KEY(orderId) REFERENCES xfn_order(oid)#设置外键
);
INSERT INTO xfn_order_detail VALUES
(NULL,100000,1,'张三',1);

