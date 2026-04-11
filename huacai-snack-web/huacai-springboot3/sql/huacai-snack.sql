/*
 Navicat Premium Data Transfer

 Source Server         : test
 Source Server Type    : MySQL
 Source Server Version : 80031
 Source Host           : localhost:3306
 Source Schema         : huacai-snack

 Target Server Type    : MySQL
 Target Server Version : 80031
 File Encoding         : 65001

 Date: 18/10/2025 00:09:45
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for address
-- ----------------------------
DROP TABLE IF EXISTS `address`;
CREATE TABLE `address`  (
  `address_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '收货地址ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '收货人',
  `phone` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '手机号码',
  `detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '详细地址',
  `is_default` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否默认地址',
  `user_id` int NOT NULL COMMENT '用户ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`address_id`) USING BTREE,
  UNIQUE INDEX `address_id`(`address_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '收货地址' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of address
-- ----------------------------
INSERT INTO `address` VALUES ('38c1782c50c94d9a829c8178618088f1', '李四', '13688889988', '成都市温江区333号', 0, 104, '2025-10-15 18:20:56');
INSERT INTO `address` VALUES ('dc154f809d1b41678f0e2504def41574', '张三', '13699993332', '成都市青羊区999号', 1, 104, '2025-10-15 22:27:45');

-- ----------------------------
-- Table structure for banner
-- ----------------------------
DROP TABLE IF EXISTS `banner`;
CREATE TABLE `banner`  (
  `banner_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '轮播图ID',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '图片',
  `sort` int NOT NULL COMMENT '排序',
  PRIMARY KEY (`banner_id`) USING BTREE,
  UNIQUE INDEX `banner_id`(`banner_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '轮播图' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of banner
-- ----------------------------
INSERT INTO `banner` VALUES ('1301b55ad5b2496db13ddc1e9b0eac65', 'https://imgs.design006.com/202108/Design006_BZxdtZWzW8.jpg?x-oss-process=style/prev_w_750_h_auto', 3);
INSERT INTO `banner` VALUES ('47da803a60fe45bcbf6b356445352d48', 'https://img.shetu66.com/2023/10/12/1697079406976853.png', 1);
INSERT INTO `banner` VALUES ('87960d4bd46041adba3e52c099447c4c', 'https://img.shetu66.com/2023/10/12/1697079552724812.png', 2);

-- ----------------------------
-- Table structure for cart
-- ----------------------------
DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart`  (
  `cart_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '购物车ID',
  `product_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '商品ID',
  `quantity` int NOT NULL COMMENT '数量',
  `user_id` int NOT NULL COMMENT '用户ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`cart_id`) USING BTREE,
  UNIQUE INDEX `cart_id`(`cart_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '购物车' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cart
-- ----------------------------
INSERT INTO `cart` VALUES ('2a7cd5bb8c2e454c966e8e507a05c708', '701', 4, 1, '2025-10-14 20:28:00');
INSERT INTO `cart` VALUES ('9616471f5c5345c5af659a7a3de21a22', '105', 1, 104, '2025-10-18 00:02:43');
INSERT INTO `cart` VALUES ('a2ae86d7dfef478187375a7361e48a31', '702', 1, 1, '2025-10-14 22:36:01');
INSERT INTO `cart` VALUES ('e0d8147fe2be4aa78aaedbe2c079d895', '310', 1, 104, '2025-10-18 00:02:41');

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `category_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '零食分类ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '分类名称',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '分类图片',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '描述',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`category_id`) USING BTREE,
  UNIQUE INDEX `category_id`(`category_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '零食分类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES ('3a9bb338e6fc4a8e9a767fe1ac4c1e13', '蜜饯果干', 'https://ts4.tc.mm.bing.net/th/id/OIP-C._hKTeehmQoB2fQT49sGoVgHaHa?rs=1&pid=ImgDetMain&o=7&rm=3', '果味浓郁，甜而不腻', '2025-10-04 22:01:00');
INSERT INTO `category` VALUES ('3cc695ea81d54b4baf30dc72bd454fbd', '膨化食品', 'https://pic.52112.com/180425/180425_319/NTcQMOPgTR_small.jpg', '酥脆可口，多种口味', '2025-10-04 22:01:00');
INSERT INTO `category` VALUES ('465d56330d104a2c8df9bd805fbb6c55', '肉干肉脯', 'https://ts4.tc.mm.bing.net/th/id/OIP-C.mV2xF7h-ECeAGCXm-sOCZwHaFk?rs=1&pid=ImgDetMain&o=7&rm=3', '肉质鲜美，回味无穷', '2025-10-04 22:01:00');
INSERT INTO `category` VALUES ('49c9ea1fe7d24ce2856e62c1279569c5', '海味零食', 'https://img.alicdn.com/imgextra/i3/2952274021/O1CN016z8Cps1fZfP7oTQpB_!!2952274021.jpg', '海洋美味，鲜香可口', '2025-10-04 22:01:00');
INSERT INTO `category` VALUES ('6d2fabd1a6fa437d847538934eef17d3', '饼干糕点', 'https://ts1.tc.mm.bing.net/th/id/OIP-C.kb-B9AjP2kvBc4w6u68NCAHaEl?rs=1&pid=ImgDetMain&o=7&rm=3', '酥脆香甜，多种口味', '2025-10-04 22:01:00');
INSERT INTO `category` VALUES ('89461019d01d45188665249aaae36f80', '饮品', 'https://pic.616pic.com/ys_bnew_img/00/18/15/h7C6pvtKUW.jpg', '清爽解渴，多种选择', '2025-10-04 22:01:00');
INSERT INTO `category` VALUES ('abac8f246dbf40139ade6140a712987b', '糖果巧克力', 'https://img95.699pic.com/photo/32040/9988.jpg_wh300.jpg!/fh/300/quality/90', '甜蜜滋味，快乐分享', '2025-10-04 22:01:00');
INSERT INTO `category` VALUES ('b33832e1bbe24a5fb3f7d10d803bfcf1', '坚果炒货', 'https://cbu01.alicdn.com/img/ibank/2018/856/428/8981824658_307831109.jpg', '香脆可口，营养丰富', '2025-10-04 22:01:00');
INSERT INTO `category` VALUES ('bd3ea913b6c7454789a014795069e500', '进口零食', 'https://pic.616pic.com/ys_bnew_img/00/56/99/Rp6NYNtBmo.jpg', '全球精选，异国风味', '2025-10-04 22:01:00');
INSERT INTO `category` VALUES ('cf140e65905b4148905e6febcbe97a10', '方便食品', 'https://m.360buyimg.com/babel/jfs/t1/88841/37/13870/263778/5e5e6485E18a8231a/390897038f3127db.jpg', '方便快捷，美味即享', '2025-10-04 22:01:00');

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '代码生成业务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES (14, 'order', '订单', 'order_products', 'order_id', 'Order', 'sub', 'element-plus', 'com.huacai.snack', 'snack', 'order', '订单', 'huacai', '0', '/', '{}', 'admin', '2025-10-16 16:01:27', '', '2025-10-16 16:03:46', NULL);
INSERT INTO `gen_table` VALUES (15, 'order_products', '订单商品明细', NULL, NULL, 'OrderProducts', 'crud', 'element-plus', 'com.huacai.snack', 'snack', 'products', '订单商品明细', 'huacai', '0', '/', '{}', 'admin', '2025-10-16 16:01:27', '', '2025-10-16 16:02:26', NULL);

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '字典类型',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 103 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '代码生成业务表字段' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column` VALUES (88, 14, 'order_id', '订单号', 'varchar(255)', 'String', 'orderId', '1', '0', '0', '1', NULL, NULL, '1', 'EQ', 'input', '', 1, 'admin', '2025-10-16 16:01:27', '', '2025-10-16 16:03:46');
INSERT INTO `gen_table_column` VALUES (89, 14, 'name', '收货人', 'varchar(255)', 'String', 'name', '0', '0', '1', '1', '1', '1', '0', 'LIKE', 'input', '', 2, 'admin', '2025-10-16 16:01:27', '', '2025-10-16 16:03:46');
INSERT INTO `gen_table_column` VALUES (90, 14, 'phone', '手机号码', 'varchar(255)', 'String', 'phone', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'input', '', 3, 'admin', '2025-10-16 16:01:27', '', '2025-10-16 16:03:46');
INSERT INTO `gen_table_column` VALUES (91, 14, 'address', '收货地址', 'varchar(255)', 'String', 'address', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'input', '', 4, 'admin', '2025-10-16 16:01:27', '', '2025-10-16 16:03:46');
INSERT INTO `gen_table_column` VALUES (92, 14, 'total_amount', '合计价格', 'decimal(10,0)', 'Long', 'totalAmount', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'input', '', 5, 'admin', '2025-10-16 16:01:27', '', '2025-10-16 16:03:46');
INSERT INTO `gen_table_column` VALUES (93, 14, 'product_count', '商品件数', 'int', 'Long', 'productCount', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'input', '', 6, 'admin', '2025-10-16 16:01:27', '', '2025-10-16 16:03:46');
INSERT INTO `gen_table_column` VALUES (94, 14, 'status', '订单状态', 'varchar(200)', 'String', 'status', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', 'order_status', 7, 'admin', '2025-10-16 16:01:27', '', '2025-10-16 16:03:46');
INSERT INTO `gen_table_column` VALUES (95, 14, 'remark', '备注', 'text', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'textarea', '', 8, 'admin', '2025-10-16 16:01:27', '', '2025-10-16 16:03:46');
INSERT INTO `gen_table_column` VALUES (96, 14, 'user_id', '用户ID', 'int', 'Long', 'userId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2025-10-16 16:01:27', '', '2025-10-16 16:03:46');
INSERT INTO `gen_table_column` VALUES (97, 14, 'create_time', '下单时间', 'datetime', 'Date', 'createTime', '0', '0', '1', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 10, 'admin', '2025-10-16 16:01:27', '', '2025-10-16 16:03:46');
INSERT INTO `gen_table_column` VALUES (98, 15, 'op_id', '订单商品明细ID', 'int', 'Long', 'opId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-10-16 16:01:27', '', '2025-10-16 16:02:26');
INSERT INTO `gen_table_column` VALUES (99, 15, 'order_id', '订单号', 'varchar(255)', 'String', 'orderId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-10-16 16:01:27', '', '2025-10-16 16:02:26');
INSERT INTO `gen_table_column` VALUES (100, 15, 'image', '图片', 'varchar(255)', 'String', 'image', '0', '0', '0', '1', '1', '1', '0', 'EQ', 'imageUpload', '', 3, 'admin', '2025-10-16 16:01:27', '', '2025-10-16 16:02:26');
INSERT INTO `gen_table_column` VALUES (101, 15, 'name', '商品名称', 'varchar(255)', 'String', 'name', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2025-10-16 16:01:27', '', '2025-10-16 16:02:26');
INSERT INTO `gen_table_column` VALUES (102, 15, 'price', '价格', 'decimal(10,0)', 'BigDecimal', 'price', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'input', '', 5, 'admin', '2025-10-16 16:01:27', '', '2025-10-16 16:02:26');
INSERT INTO `gen_table_column` VALUES (103, 15, 'quantity', '数量', 'int', 'Long', 'quantity', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'input', '', 6, 'admin', '2025-10-16 16:01:27', '', '2025-10-16 16:02:26');

-- ----------------------------
-- Table structure for order
-- ----------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order`  (
  `order_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '订单号',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '收货人',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '手机号码',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '收货地址',
  `total_amount` decimal(10, 2) NOT NULL COMMENT '合计价格',
  `product_count` int NOT NULL COMMENT '商品件数',
  `status` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '待收货' COMMENT '订单状态',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '备注',
  `user_id` int NOT NULL COMMENT '用户ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间',
  PRIMARY KEY (`order_id`) USING BTREE,
  UNIQUE INDEX `order_id`(`order_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '订单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order
-- ----------------------------
INSERT INTO `order` VALUES ('OR20251016235855104', '张三', '13699993332', '成都市青羊区999号', 16.70, 3, '已取消', '快发货', 104, '2025-10-16 23:58:56');
INSERT INTO `order` VALUES ('OR20251017000046104', '张三', '13699993332', '成都市青羊区999号', 36.60, 4, '已完成', '', 104, '2025-10-17 00:00:47');
INSERT INTO `order` VALUES ('OR20251018000152104', '张三', '13699993332', '成都市青羊区999号', 79.50, 5, '待收货', '', 104, '2025-10-18 00:01:53');

-- ----------------------------
-- Table structure for order_products
-- ----------------------------
DROP TABLE IF EXISTS `order_products`;
CREATE TABLE `order_products`  (
  `op_id` int NOT NULL AUTO_INCREMENT COMMENT '订单商品明细ID',
  `order_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '订单号',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '图片',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '商品名称',
  `price` decimal(10, 0) NOT NULL COMMENT '价格',
  `quantity` int NOT NULL COMMENT '数量',
  PRIMARY KEY (`op_id`) USING BTREE,
  UNIQUE INDEX `op_id`(`op_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '订单商品明细' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_products
-- ----------------------------
INSERT INTO `order_products` VALUES (15, 'OR20251016235855104', 'https://imgservice.suning.cn/uimg1/b2c/image/dmxOHawNX4Ilj59bipUcRA.jpg', '碳酸饮料', 5, 2);
INSERT INTO `order_products` VALUES (16, 'OR20251016235855104', 'https://cbu01.alicdn.com/img/ibank/O1CN01GAZwHU1D9jx5mOG8c_!!1822720174-0-cib.310x310.jpg', '果汁饮料', 7, 1);
INSERT INTO `order_products` VALUES (17, 'OR20251017000046104', 'https://img.sialchina.cn/image/95b8a202203111945312914.jpg', '爆米花', 13, 1);
INSERT INTO `order_products` VALUES (18, 'OR20251017000046104', 'https://cbu01.alicdn.com/img/ibank/O1CN01tR6Diq1L3nU09INPq_!!2211385611244-0-cib.310x310.jpg', '玉米片', 9, 1);
INSERT INTO `order_products` VALUES (19, 'OR20251017000046104', 'https://cbu01.alicdn.com/img/ibank/O1CN01fYBODs1owPkP3vb58_!!2201485865289-0-cib.310x310.jpg', '虾条', 7, 1);
INSERT INTO `order_products` VALUES (20, 'OR20251017000046104', 'https://ts4.tc.mm.bing.net/th/id/OIP-C.osy3Am4C5515aNWD8_HI5QHaHa?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3', '薯片', 8, 1);
INSERT INTO `order_products` VALUES (21, 'OR20251018000152104', 'https://img.alicdn.com/i1/2174558845/O1CN01BC4KQF2FD40ozg7uR_!!2174558845.jpg', '夹心饼干', 13, 1);
INSERT INTO `order_products` VALUES (22, 'OR20251018000152104', 'https://cbu01.alicdn.com/img/ibank/O1CN01Q2ucw71TtZ9ellRKA_!!2207282512440-0-cib.jpg', '芒果干', 19, 1);
INSERT INTO `order_products` VALUES (23, 'OR20251018000152104', 'https://img.alicdn.com/i3/6000000004502/O1CN01bYnd681j7xxLOQrjV_!!6000000004502-0-at.jpg', '芝士球', 12, 1);
INSERT INTO `order_products` VALUES (24, 'OR20251018000152104', 'https://img.alicdn.com/bao/uploaded/i2/2206463863539/O1CN01SqzQcC1c0uWDLyTRu_!!0-item_pic.jpg', '猕猴桃干', 20, 1);
INSERT INTO `order_products` VALUES (25, 'OR20251018000152104', 'https://cbu01.alicdn.com/img/ibank/O1CN019s77Js1bB9noyEFfU_!!2216574323426-0-cib.310x310.jpg', '蔬菜脆', 16, 1);

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product`  (
  `product_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '商品ID',
  `category_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '分类ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '商品名称',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '描述',
  `price` decimal(10, 2) NOT NULL COMMENT '价格',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '图片',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`product_id`) USING BTREE,
  UNIQUE INDEX `product_id`(`product_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '商品' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product
-- ----------------------------
INSERT INTO `product` VALUES ('1001', 'bd3ea913b6c7454789a014795069e500', '进口饼干', '欧洲进口，独特风味', 22.90, 'https://img.alicdn.com/i2/6000000005819/O1CN01hJwB0u1sr9VHD0JLd_!!6000000005819-2-at.png', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('1002', 'bd3ea913b6c7454789a014795069e500', '进口巧克力', '比利时进口，丝滑口感', 45.90, 'https://ts1.tc.mm.bing.net/th/id/OIP-C.LDj0Vw39_U72KjEjUvFOVwHaFH?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('1003', 'bd3ea913b6c7454789a014795069e500', '进口糖果', '德国进口，精致包装', 28.90, 'https://img.alicdn.com/i4/1708386627/O1CN01NxWiu01ypDWLFOdYI_!!1708386627.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('1004', 'bd3ea913b6c7454789a014795069e500', '进口薯片', '美国进口，厚切口感', 18.90, 'https://cbu01.alicdn.com/img/ibank/2020/932/977/20173779239_1139239984.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('1005', 'bd3ea913b6c7454789a014795069e500', '进口饮料', '韩国进口，独特口味', 12.90, 'https://img.alicdn.com/i2/4063133301/O1CN01HswqYo1aFu6QAr78C_!!4063133301.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('1006', 'bd3ea913b6c7454789a014795069e500', '进口果干', '泰国进口，天然风味', 25.90, 'https://img.alicdn.com/i1/6000000005867/O1CN01pASYC81tD8VizmOzI_!!6000000005867-0-at.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('1007', 'bd3ea913b6c7454789a014795069e500', '进口坚果', '澳大利亚进口，品质保证', 55.90, 'https://ts1.tc.mm.bing.net/th/id/OIP-C.MBJFQteIZhmLugXyv1bZDgHaHa?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('1008', 'bd3ea913b6c7454789a014795069e500', '进口咖啡', '意大利进口，香浓醇厚', 38.90, 'https://img.alicdn.com/bao/uploaded/i2/2785649190/O1CN01NBxcGX2Hl4h6xBxWY_!!0-item_pic.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('1009', 'bd3ea913b6c7454789a014795069e500', '进口茶包', '英国进口，英式风味', 32.90, 'https://img.alicdn.com/i3/776991400/TB2BskxwSVmpuFjSZFFXXcZApXa_!!776991400.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('101', 'b33832e1bbe24a5fb3f7d10d803bfcf1', '香酥腰果', '精选大颗粒腰果，香脆可口', 38.90, 'https://cbu01.alicdn.com/img/ibank/2019/900/443/11503344009_1643926659.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('1010', 'bd3ea913b6c7454789a014795069e500', '进口果汁', '法国进口，纯正果汁', 15.90, 'https://img.alicdn.com/i1/2024473350/O1CN01RpsjIf1acLXmtuqT3_!!2024473350.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('102', 'b33832e1bbe24a5fb3f7d10d803bfcf1', '炭烧腰果', '炭烧工艺，香味浓郁', 42.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01fT925Y1f7jOJ6WUE1_!!2218078793960-0-cib.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('103', 'b33832e1bbe24a5fb3f7d10d803bfcf1', '原味瓜子', '颗粒饱满，原味香醇', 15.90, 'https://img.alicdn.com/bao/uploaded/i4/2024927958/O1CN01BEFd4L28eohyHIBwk_!!2024927958.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('104', 'b33832e1bbe24a5fb3f7d10d803bfcf1', '五香瓜子', '五香口味，回味无穷', 16.90, 'https://img.alicdn.com/bao/uploaded/i1/2274885538/O1CN01KeljGs1qmSCQ2ixqN_!!2274885538.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('105', 'b33832e1bbe24a5fb3f7d10d803bfcf1', '开心果', '自然开口，果仁饱满', 45.90, 'https://img.alicdn.com/bao/uploaded/i4/2208513164704/O1CN0154oUFD1kcTsgrnDg5_!!0-item_pic.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('106', 'b33832e1bbe24a5fb3f7d10d803bfcf1', '巴旦木', '营养丰富，口感香脆', 35.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01hcicWS1z2UvKLqOYc_!!2212632016656-0-cib.310x310.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('107', 'b33832e1bbe24a5fb3f7d10d803bfcf1', '碧根果', '奶香味，酥脆可口', 48.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01Q7NV3G2GMVsMSntRu_!!2212876669001-0-cib.310x310.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('108', 'b33832e1bbe24a5fb3f7d10d803bfcf1', '夏威夷果', '奶油口味，果仁饱满', 52.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01TSzbxb1N7a7FrI9Mj_!!2452191523-0-cib.310x310.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('109', 'b33832e1bbe24a5fb3f7d10d803bfcf1', '核桃仁', '原味核桃，营养丰富', 32.90, 'https://img.alicdn.com/bao/uploaded/i3/2212455048082/O1CN01HOYjHc29ZbiMIK5FQ_!!2212455048082.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('110', 'b33832e1bbe24a5fb3f7d10d803bfcf1', '松子', '东北红松，香味浓郁', 68.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01fgpDjx1adGbPtfiLp_!!2218558263352-0-cib.310x310.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('111', 'b33832e1bbe24a5fb3f7d10d803bfcf1', '榛子', '野生榛子，原生态', 38.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01rFaRPe1JOkXtWqguZ_!!2217594621019-0-cib.310x310.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('112', 'b33832e1bbe24a5fb3f7d10d803bfcf1', '杏仁', '美国大杏仁，香脆', 42.90, 'https://img.mall.ccb.com/photo/2021/03/06/52f55ae13be99dfc63b2ed9ac139a941.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('201', 'abac8f246dbf40139ade6140a712987b', '牛奶巧克力', '丝滑口感，奶香浓郁', 28.90, 'https://img.alicdn.com/bao/uploaded/i4/894675413/O1CN01yVNoVk1prCcDHQ3id_!!894675413.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('202', 'abac8f246dbf40139ade6140a712987b', '黑巧克力', '纯正可可，苦中带甜', 32.90, 'https://img14.360buyimg.com/pop/jfs/t1/231380/24/11399/57039/659d023fFcbdccbc8/b6b6cc9edc2dccab.png', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('203', 'abac8f246dbf40139ade6140a712987b', '水果硬糖', '多种水果口味', 12.90, 'https://img.alicdn.com/bao/uploaded/i4/2212731201946/O1CN01GUrLen1QFJWYfbpK5_!!0-item_pic.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('204', 'abac8f246dbf40139ade6140a712987b', '夹心巧克力', '多种夹心口味', 35.90, 'https://img.alicdn.com/i1/2205289627600/O1CN01jUYEP9260qfrRM7Py_!!2205289627600.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('205', 'abac8f246dbf40139ade6140a712987b', '棒棒糖', '卡通造型，儿童喜爱', 8.90, 'https://img.alicdn.com/bao/uploaded/i1/3586740366/O1CN01IvWyAG1EZfmckkg9A_!!2-item_pic.png', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('206', 'abac8f246dbf40139ade6140a712987b', '软糖', 'Q弹口感，多种水果味', 15.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01BHN00M1q6m7g4bTdY_!!2210248225447-0-cib.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('207', 'abac8f246dbf40139ade6140a712987b', '白巧克力', '香甜可口，奶味浓郁', 29.90, 'https://img14.360buyimg.com/pop/jfs/t1/163376/9/31871/46536/64391a9cFedd4693a/648a8776b300b186.png', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('208', 'abac8f246dbf40139ade6140a712987b', '薄荷糖', '清新口气，提神醒脑', 9.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01PcCoFY1R0UIdDp3w5_!!3482322049-0-cib.jpg?__r__=1654223804958', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('209', 'abac8f246dbf40139ade6140a712987b', '牛轧糖', '花生口味，香甜不腻', 24.90, 'https://img.alicdn.com/bao/uploaded/i3/2212172971682/O1CN01jaRWnz1OIOzzB0RQX_!!2212172971682-0-tblite.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('210', 'abac8f246dbf40139ade6140a712987b', '巧克力豆', '彩色糖衣，趣味十足', 18.90, 'https://img.alicdn.com/i1/725677994/O1CN01s6b0Z528vIpRgbepb_!!725677994-0-sm.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('211', 'abac8f246dbf40139ade6140a712987b', '水果糖', '天然果汁制作', 11.90, 'https://cbu01.alicdn.com/img/ibank/2020/515/413/18173314515_65327265.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('212', 'abac8f246dbf40139ade6140a712987b', '巧克力棒', '威化夹心，酥脆可口', 22.90, 'https://img.alicdn.com/i4/1743227250/TB2mH3_aJHO8KJjSZFLXXaTqVXa_!!1743227250.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('301', '465d56330d104a2c8df9bd805fbb6c55', '牛肉干', '内蒙古风味，肉质紧实', 45.90, 'https://img.alicdn.com/bao/uploaded/i3/571877243/O1CN01GahVN523NLXzitcGj_!!571877243.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('302', '465d56330d104a2c8df9bd805fbb6c55', '猪肉脯', '蜜汁口味，香甜可口', 32.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01i9xgr61w5Ic45YlvO_!!2211206836256-0-cib.310x310.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('303', '465d56330d104a2c8df9bd805fbb6c55', '手撕牛肉', '原味牛肉，纤维分明', 52.90, 'https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=335589240,1230730688&fm=199&app=68&f=JPEG?w=750&h=750&s=1B144C83AE9B7FEF6A1639A60300E028', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('304', '465d56330d104a2c8df9bd805fbb6c55', '麻辣牛肉', '川味麻辣，过瘾十足', 48.90, 'https://img.alicdn.com/i4/2452287770/O1CN01BO9jNj27GiFpatuMo_!!2452287770.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('305', '465d56330d104a2c8df9bd805fbb6c55', '五香肉干', '传统五香，回味悠长', 38.90, 'https://img.alicdn.com/bao/uploaded/i1/2258976511/O1CN01Rm1JlP1xy5WljWrO9_!!0-item_pic.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('306', '465d56330d104a2c8df9bd805fbb6c55', '鸡肉脯', '低脂健康，口感细腻', 28.90, 'https://img.alicdn.com/i3/4058755602/O1CN01mcqrXT1rFlVELWXtv_!!4058755602.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('307', '465d56330d104a2c8df9bd805fbb6c55', '鸭肉干', '特色风味，肉质紧实', 35.90, 'https://img.alicdn.com/i4/3603231910/O1CN016S6ezU1PypEUfa2Hz_!!3603231910.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('308', '465d56330d104a2c8df9bd805fbb6c55', '香辣肉丝', '香辣可口，下酒佳品', 42.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01e2ZpHX2AsDfwbkbGf_!!2217891108258-0-cib.310x310.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('309', '465d56330d104a2c8df9bd805fbb6c55', '原味肉松', '蓬松细腻，营养丰富', 25.90, 'https://img.alicdn.com/bao/uploaded/i3/1035548554/O1CN01FyT6LQ2D3mlioIqbz_!!1035548554.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('310', '465d56330d104a2c8df9bd805fbb6c55', '炭烤肉干', '炭火烤制，香味独特', 39.90, 'https://img.alicdn.com/i3/577929348/O1CN01nRlsuD2IvR73Fs8vM_!!577929348.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('401', '6d2fabd1a6fa437d847538934eef17d3', '苏打饼干', '酥脆可口，低脂健康', 8.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01qWZuqt1QUt1sQnld2_!!2300881980-0-cib.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('402', '6d2fabd1a6fa437d847538934eef17d3', '夹心饼干', '多种夹心，香甜可口', 12.90, 'https://img.alicdn.com/i1/2174558845/O1CN01BC4KQF2FD40ozg7uR_!!2174558845.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('403', '6d2fabd1a6fa437d847538934eef17d3', '威化饼干', '层层酥脆，奶香浓郁', 15.90, 'https://img.alicdn.com/bao/uploaded/i2/2215417279334/O1CN016jHQmH2Ip1giEUGAY_!!2215417279334.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('404', '6d2fabd1a6fa437d847538934eef17d3', '曲奇饼干', '黄油曲奇，酥松香甜', 18.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01UnlELE1fUAe9BRam8_!!3372074009-0-cib.310x310.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('405', '6d2fabd1a6fa437d847538934eef17d3', '蛋卷', '鸡蛋制作，香脆可口', 14.90, 'https://img.alicdn.com/imgextra/i2/1733866140/O1CN01wImcaE1vEAkGoY80j_!!1733866140.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('406', '6d2fabd1a6fa437d847538934eef17d3', '华夫饼', '松软香甜，早餐佳品', 22.90, 'https://cbu01.alicdn.com/img/ibank/2020/218/132/13610231812_1020955689.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('407', '6d2fabd1a6fa437d847538934eef17d3', '消化饼干', '全麦制作，健康营养', 11.90, 'https://ts1.tc.mm.bing.net/th/id/OIP-C.-KHVBK9S87e9OAX9QeAHiAHaHa?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('408', '6d2fabd1a6fa437d847538934eef17d3', '葱油饼干', '香葱口味，咸香酥脆', 9.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01H1YKaw1G56iwMQXN4_!!2210049410570-0-cib.310x310.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('409', '6d2fabd1a6fa437d847538934eef17d3', '巧克力饼干', '巧克力涂层，香甜可口', 16.90, 'https://ts2.tc.mm.bing.net/th/id/OIP-C.lV412QaPEPfb9NWiXceFpQHaKU?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('410', '6d2fabd1a6fa437d847538934eef17d3', '薄脆饼干', '薄如蝉翼，香脆可口', 10.90, 'https://img.alicdn.com/i4/2200765383356/O1CN018S8gHX1af5qyHY910_!!2200765383356.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('411', '6d2fabd1a6fa437d847538934eef17d3', '燕麦饼干', '燕麦制作，健康粗粮', 13.90, 'https://img.alicdn.com/i3/2207554494978/O1CN01u53Eay1mdyPWQ0rTl_!!2207554494978.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('412', '6d2fabd1a6fa437d847538934eef17d3', '奶油饼干', '奶香浓郁，口感酥松', 14.90, 'https://ts1.tc.mm.bing.net/th/id/OIP-C.mzgltYz_a_c-TANcqHbGogHaHa?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('501', '49c9ea1fe7d24ce2856e62c1279569c5', '烤鱼片', '深海鱼制作，鲜香美味', 25.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01LZHulz2DZqR4QMSMO_!!2206506758624-0-cib.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('502', '49c9ea1fe7d24ce2856e62c1279569c5', '鱿鱼丝', '原味鱿鱼，嚼劲十足', 28.90, 'https://img.alicdn.com/i3/398972802/TB2EcHrxOlnpuFjSZFgXXbi7FXa_!!398972802.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('503', '49c9ea1fe7d24ce2856e62c1279569c5', '香辣小鱼', '香辣口味，开胃小食', 18.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01o9rvdb1Jpljy6Tq7k_!!2014931078-0-cib.310x310.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('504', '49c9ea1fe7d24ce2856e62c1279569c5', '海苔', '烤海苔，营养丰富', 12.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01vFRP9Y1KxO8dFsJeI_!!2216085621230-0-cib.310x310.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('505', '49c9ea1fe7d24ce2856e62c1279569c5', '虾干', '原只虾干，鲜香可口', 35.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01WmD81R1TBbMEQDYYi_!!2216926202344-0-cib.310x310.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('506', '49c9ea1fe7d24ce2856e62c1279569c5', '鱼豆腐', 'Q弹口感，鲜香美味', 15.90, 'https://t00img.yangkeduo.com/goods/images/2020-10-11/7d58214c991a0d6f88518e02a96cdecf.jpeg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('507', '49c9ea1fe7d24ce2856e62c1279569c5', '海带丝', '麻辣海带，爽口开胃', 9.90, 'https://cbu01.alicdn.com/img/ibank/2014/052/193/1453391250_1384967362.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('508', '49c9ea1fe7d24ce2856e62c1279569c5', '扇贝肉', '原味扇贝，肉质鲜美', 42.90, 'https://img.alicdn.com/i4/2208340768075/O1CN01zZBhX029WOsrPpHbo_!!2208340768075.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('509', '49c9ea1fe7d24ce2856e62c1279569c5', '海蜇丝', '凉拌海蜇，爽脆可口', 22.90, 'https://img.alicdn.com/bao/uploaded/i4/587093069/O1CN01Zd03iv1YXeHsjdSxm_!!587093069.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('510', '49c9ea1fe7d24ce2856e62c1279569c5', '鱼丸', '弹牙鱼丸，鲜香美味', 19.90, 'https://cbu01.alicdn.com/img/ibank/2020/554/000/21102000455_1020955689.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('601', '89461019d01d45188665249aaae36f80', '果汁饮料', '新鲜水果榨取，营养丰富', 6.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01GAZwHU1D9jx5mOG8c_!!1822720174-0-cib.310x310.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('602', '89461019d01d45188665249aaae36f80', '碳酸饮料', '气泡十足，清爽解渴', 4.90, 'https://imgservice.suning.cn/uimg1/b2c/image/dmxOHawNX4Ilj59bipUcRA.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('603', '89461019d01d45188665249aaae36f80', '茶饮料', '原叶冲泡，茶香浓郁', 5.90, 'https://ts1.tc.mm.bing.net/th/id/OIP-C.WEn-ch-HGUzOMehnXRnSiQHaFj?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('604', '89461019d01d45188665249aaae36f80', '功能饮料', '补充能量，提神醒脑', 7.90, 'https://ts3.tc.mm.bing.net/th/id/OIP-C.g3ZTOOwhYyqgG69LNs2jmAHaHa?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('605', '89461019d01d45188665249aaae36f80', '酸奶', '活性乳酸菌，促进消化', 8.90, 'https://ts2.tc.mm.bing.net/th/id/OIP-C.dH-PlAMwVrbJLcjszXtoCAHaE8?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('606', '89461019d01d45188665249aaae36f80', '矿泉水', '天然矿泉水，纯净健康', 2.90, 'https://ts2.tc.mm.bing.net/th/id/OIP-C.y87YTfH_acKs8c3_vb6HQwHaHa?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('607', '89461019d01d45188665249aaae36f80', '咖啡饮料', '现磨咖啡，香浓醇厚', 12.90, 'https://img.alicdn.com/i2/6000000007581/O1CN01JEFIbe25s9TXtMnS4_!!6000000007581-0-at.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('608', '89461019d01d45188665249aaae36f80', '植物蛋白饮料', '豆奶杏仁露，营养丰富', 6.90, 'https://cf.dtcj.com/richeditor/d915956d-e91c-46cb-b085-9a4ffd9c3a34.png', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('609', '89461019d01d45188665249aaae36f80', '运动饮料', '补充电解质，运动必备', 8.90, 'https://imgservice.suning.cn/uimg1/b2c/image/8vR_Ojjbo6J8i-Io-PE5wg.png', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('610', '89461019d01d45188665249aaae36f80', '果味饮料', '多种水果口味，清爽', 5.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01W4MOtU1iEXtyzyZeM_!!2213056124381-0-cib.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('611', '89461019d01d45188665249aaae36f80', '乳酸菌饮料', '促进消化，酸甜可口', 7.90, 'https://imgservice.suning.cn/uimg1/b2c/image/yYtJa24TUU22uWToTUrWlw==.jpg_800w_800h_4e', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('612', '89461019d01d45188665249aaae36f80', '气泡水', '无糖气泡，清爽解腻', 4.90, 'https://pica.zhimg.com/v2-646d2592bdd32cd5ec7b9a6b1748e1d7_720w.jpg?source=172ae18b', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('701', '3a9bb338e6fc4a8e9a767fe1ac4c1e13', '芒果干', '果肉厚实，酸甜适中', 18.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01Q2ucw71TtZ9ellRKA_!!2207282512440-0-cib.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('702', '3a9bb338e6fc4a8e9a767fe1ac4c1e13', '葡萄干', '新疆特产，甜而不腻', 12.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01qkv97S2EYIn0GnmDh_!!2210180898756-0-cib.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('703', '3a9bb338e6fc4a8e9a767fe1ac4c1e13', '草莓干', '整颗草莓，酸甜可口', 22.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01dNnZr61Tnc5A2Tzfx_!!2212413752427-0-cib.jpg?__r__=1681145122665', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('704', '3a9bb338e6fc4a8e9a767fe1ac4c1e13', '菠萝干', '热带风味，香甜浓郁', 16.90, 'https://img.alicdn.com/i1/1742837449/O1CN01QzeM0424th9SRRbaQ_!!1742837449.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('705', '3a9bb338e6fc4a8e9a767fe1ac4c1e13', '猕猴桃干', '维生素丰富，酸甜开胃', 19.90, 'https://img.alicdn.com/bao/uploaded/i2/2206463863539/O1CN01SqzQcC1c0uWDLyTRu_!!0-item_pic.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('706', '3a9bb338e6fc4a8e9a767fe1ac4c1e13', '山楂片', '开胃消食，酸甜可口', 8.90, 'https://m.360buyimg.com/mobilecms/s750x750_jfs/t1/130751/10/39905/578167/64f32467Ff14f56b0/476cdb75b4b41e9f.png', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('707', '3a9bb338e6fc4a8e9a767fe1ac4c1e13', '话梅', '生津止渴，酸甜开胃', 14.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01RrxPSj2FrMvRdZiqR_!!2201459848933-0-cib.310x310.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('708', '3a9bb338e6fc4a8e9a767fe1ac4c1e13', '杏干', '自然风干，原汁原味', 15.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01bk9Jx21DTt8A3u6z4_!!2212938430218-0-cib.310x310.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('709', '3a9bb338e6fc4a8e9a767fe1ac4c1e13', '香蕉片', '香脆可口，甜而不腻', 11.90, 'https://img.alicdn.com/bao/uploaded/i1/2212733782636/O1CN01flacZR1VLKoGegdEl_!!0-item_pic.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('710', '3a9bb338e6fc4a8e9a767fe1ac4c1e13', '苹果干', '脆甜口感，营养丰富', 13.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01vVUhTI1b4Hwp0LPnk_!!2214031593411-0-cib.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('801', 'cf140e65905b4148905e6febcbe97a10', '方便面', '多种口味，快捷美味', 4.90, 'https://img.alicdn.com/imgextra/i3/2269542950/TB2mBSOX0uO.eBjSZFCXXXULFXa_!!2269542950.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('802', 'cf140e65905b4148905e6febcbe97a10', '自热火锅', '麻辣鲜香，方便快捷', 35.90, 'https://asset.ibanquan.com/image/61f8ef03cf857600248544c5/s.jpeg?v=1643704086', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('803', 'cf140e65905b4148905e6febcbe97a10', '速食米饭', '即食即热，方便快捷', 12.90, 'https://img.alicdn.com/bao/uploaded/i4/2214688110823/O1CN011WlM4K1Hwyo6yzQrd_!!0-item_pic.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('804', 'cf140e65905b4148905e6febcbe97a10', '速食粥', '多种口味，营养早餐', 8.90, 'https://img.alicdn.com/i2/2214973385994/O1CN01bsbBof1u9IoOkaXgJ_!!2214973385994.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('805', 'cf140e65905b4148905e6febcbe97a10', '罐头食品', '长久保存，即开即食', 15.90, 'https://img.alicdn.com/bao/uploaded/i4/3943789748/O1CN01ClYBSd2LsdbzJNdRc_!!3943789748.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('806', 'cf140e65905b4148905e6febcbe97a10', '速食汤', '冲泡即饮，方便快捷', 6.90, 'https://img.alicdn.com/i4/3015107655/O1CN01U1Rb6B26Q2edYbOGV_!!3015107655.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('807', 'cf140e65905b4148905e6febcbe97a10', '速冻水饺', '多种馅料，方便美味', 18.90, 'https://ts3.tc.mm.bing.net/th/id/OIP-C.t4feCzCeclF6hp8xKcQ7ngHaHa?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('808', 'cf140e65905b4148905e6febcbe97a10', '方便粉丝', '爽滑口感，多种口味', 5.90, 'https://img.alicdn.com/i3/3416832369/O1CN01zokWJK1TN32YkHBTx_!!3416832369.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('809', 'cf140e65905b4148905e6febcbe97a10', '即食麦片', '营养早餐，冲泡即食', 22.90, 'https://img14.360buyimg.com/pop/jfs/t1/201935/22/16392/156442/619cb932E7dbba102/f0afcf48b077db65.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('810', 'cf140e65905b4148905e6febcbe97a10', '自热米饭', '多种菜式，方便快捷', 16.90, 'https://img.alicdn.com/i1/1599933637/O1CN01cZW2tT1cjn2uk7krw_!!1599933637.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('901', '3cc695ea81d54b4baf30dc72bd454fbd', '薯片', '薄脆口感，多种风味', 7.90, 'https://ts4.tc.mm.bing.net/th/id/OIP-C.osy3Am4C5515aNWD8_HI5QHaHa?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('902', '3cc695ea81d54b4baf30dc72bd454fbd', '虾条', '鲜虾口味，酥脆可口', 6.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01fYBODs1owPkP3vb58_!!2201485865289-0-cib.310x310.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('903', '3cc695ea81d54b4baf30dc72bd454fbd', '玉米片', '玉米制作，健康酥脆', 8.90, 'https://cbu01.alicdn.com/img/ibank/O1CN01tR6Diq1L3nU09INPq_!!2211385611244-0-cib.310x310.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('904', '3cc695ea81d54b4baf30dc72bd454fbd', '爆米花', '电影院风味，香甜可口', 12.90, 'https://img.sialchina.cn/image/95b8a202203111945312914.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('905', '3cc695ea81d54b4baf30dc72bd454fbd', '薯条', '香脆薯条，休闲零食', 9.90, 'https://img.alicdn.com/i1/4036258315/O1CN01zBao8X2BIK18zATzM_!!4036258315.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('906', '3cc695ea81d54b4baf30dc72bd454fbd', '蔬菜脆', '多种蔬菜，健康零食', 15.90, 'https://cbu01.alicdn.com/img/ibank/O1CN019s77Js1bB9noyEFfU_!!2216574323426-0-cib.310x310.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('907', '3cc695ea81d54b4baf30dc72bd454fbd', '米饼', '大米制作，清淡可口', 5.90, 'https://cbu01.alicdn.com/img/ibank/2020/505/240/13377042505_279948420.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('908', '3cc695ea81d54b4baf30dc72bd454fbd', '洋葱圈', '洋葱口味，酥脆香甜', 8.90, 'https://img13.360buyimg.com/n1/jfs/t1/3202/22/3584/272055/5b99db4cE2c38ec70/168f508069161e20.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('909', '3cc695ea81d54b4baf30dc72bd454fbd', '芝士球', '芝士口味，浓郁香脆', 11.90, 'https://img.alicdn.com/i3/6000000004502/O1CN01bYnd681j7xxLOQrjV_!!6000000004502-0-at.jpg', '2025-10-12 17:19:06');
INSERT INTO `product` VALUES ('910', '3cc695ea81d54b4baf30dc72bd454fbd', '脆脆角', '三角形状，香脆可口', 7.90, 'https://img.alicdn.com/bao/uploaded/i3/1970543660/O1CN01iKBWox1cuKQM1chWA_!!1970543660.jpg', '2025-10-12 17:19:06');

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '参数配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2025-08-30 08:59:54', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (2, '验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2025-08-30 08:59:54', 'admin', '2025-09-11 13:30:28', '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (3, '是否开启用户注册功能', 'sys.account.registerUser', 'true', 'Y', 'admin', '2025-08-30 08:59:54', 'admin', '2025-09-11 13:31:46', '是否开启注册用户功能（true开启，false关闭）');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 202 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '花菜编程', 0, 'huacai', '15888888888', 'huacai@qq.com', '0', '0', 'admin', '2025-08-30 08:59:53', 'admin', '2025-08-30 10:36:00');

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 103 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2025-08-30 08:59:54', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2025-08-30 08:59:54', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2025-08-30 08:59:54', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2025-08-30 08:59:54', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2025-08-30 08:59:54', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2025-08-30 08:59:54', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2025-08-30 08:59:54', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2025-08-30 08:59:54', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (9, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2025-08-30 08:59:54', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (100, 1, '待收货', '待收货', 'order_status', NULL, 'warning', 'N', '0', 'admin', '2025-10-16 16:00:37', 'admin', '2025-10-16 16:00:44', NULL);
INSERT INTO `sys_dict_data` VALUES (101, 2, '已完成', '已完成', 'order_status', NULL, 'success', 'N', '0', 'admin', '2025-10-16 16:00:54', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (102, 3, '已取消', '已取消', 'order_status', NULL, 'danger', 'N', '0', 'admin', '2025-10-16 16:01:01', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '字典类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2025-08-30 08:59:54', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2025-08-30 08:59:54', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2025-08-30 08:59:54', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '系统是否', 'sys_yes_no', '0', 'admin', '2025-08-30 08:59:54', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (100, '订单状态', 'order_status', '0', 'admin', '2025-10-16 16:00:03', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int NULL DEFAULT 1 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2044 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '菜单权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 99, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', '系统管理', 'admin', '2025-08-30 08:59:54', 'admin', '2025-10-11 22:43:40', '系统管理目录');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 1, 'C', '0', '0', 'system:user:list', '用户管理', 'admin', '2025-08-30 08:59:54', 'admin', '2025-09-01 11:20:55', '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 1, 'C', '0', '0', 'system:role:list', '角色管理', 'admin', '2025-08-30 08:59:54', 'admin', '2025-09-01 11:26:22', '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 1, 'C', '0', '0', 'system:menu:list', '菜单管理', 'admin', '2025-08-30 08:59:54', 'admin', '2025-09-01 11:26:28', '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 1, 'C', '0', '0', 'system:dept:list', '部门管理', 'admin', '2025-08-30 08:59:54', 'admin', '2025-09-01 11:26:33', '部门管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 1, 'C', '0', '0', 'system:dict:list', '字典管理', 'admin', '2025-08-30 08:59:54', 'admin', '2025-09-01 11:26:38', '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 1, 'C', '0', '0', 'system:config:list', '参数设置', 'admin', '2025-08-30 08:59:54', 'admin', '2025-09-01 11:26:44', '参数设置菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 1, 8, 'gen', 'tool/gen/index', '', '', 1, 1, 'C', '0', '0', 'tool:gen:list', '代码生成', 'admin', '2025-08-30 08:59:54', 'admin', '2025-09-01 11:26:49', '代码生成菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2025-08-30 08:59:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2006, '轮播图管理', 2012, 1, 'banner', 'snack/banner/index', NULL, '', 1, 1, 'C', '0', '0', 'snack:banner:list', '轮播图管理', 'admin', '2025-10-11 22:42:02', 'admin', '2025-10-11 22:49:08', '轮播图菜单');
INSERT INTO `sys_menu` VALUES (2007, '轮播图查询', 2006, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:banner:query', '#', 'admin', '2025-10-11 22:42:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2008, '轮播图新增', 2006, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:banner:add', '#', 'admin', '2025-10-11 22:42:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2009, '轮播图修改', 2006, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:banner:edit', '#', 'admin', '2025-10-11 22:42:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2010, '轮播图删除', 2006, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:banner:remove', '#', 'admin', '2025-10-11 22:42:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2011, '轮播图导出', 2006, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:banner:export', '#', 'admin', '2025-10-11 22:42:02', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2012, '基本信息管理', 0, 1, 'info', NULL, NULL, '', 1, 1, 'M', '0', '0', '', '基本信息管理', 'admin', '2025-10-11 22:43:29', 'admin', '2025-10-11 22:49:01', '');
INSERT INTO `sys_menu` VALUES (2013, '零食分类管理', 2012, 2, 'category', 'snack/category/index', NULL, '', 1, 1, 'C', '0', '0', 'snack:category:list', '零食分类管理', 'admin', '2025-10-12 14:58:48', 'admin', '2025-10-12 15:01:57', '零食分类菜单');
INSERT INTO `sys_menu` VALUES (2014, '零食分类查询', 2013, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:category:query', '#', 'admin', '2025-10-12 14:58:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2015, '零食分类新增', 2013, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:category:add', '#', 'admin', '2025-10-12 14:58:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2016, '零食分类修改', 2013, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:category:edit', '#', 'admin', '2025-10-12 14:58:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2017, '零食分类删除', 2013, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:category:remove', '#', 'admin', '2025-10-12 14:58:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2018, '零食分类导出', 2013, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:category:export', '#', 'admin', '2025-10-12 14:58:48', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2019, '商品管理', 2025, 1, 'product', 'snack/product/index', NULL, '', 1, 1, 'C', '0', '0', 'snack:product:list', '商品管理', 'admin', '2025-10-12 16:45:19', 'admin', '2025-10-12 16:49:27', '商品菜单');
INSERT INTO `sys_menu` VALUES (2020, '商品查询', 2019, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:product:query', '#', 'admin', '2025-10-12 16:45:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2021, '商品新增', 2019, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:product:add', '#', 'admin', '2025-10-12 16:45:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2022, '商品修改', 2019, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:product:edit', '#', 'admin', '2025-10-12 16:45:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2023, '商品删除', 2019, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:product:remove', '#', 'admin', '2025-10-12 16:45:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2024, '商品导出', 2019, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:product:export', '#', 'admin', '2025-10-12 16:45:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2025, '经营服务管理', 0, 2, 'service', NULL, NULL, '', 1, 1, 'M', '0', '0', '', '经营服务管理', 'admin', '2025-10-12 16:47:25', 'admin', '2025-10-12 16:49:16', '');
INSERT INTO `sys_menu` VALUES (2026, '购物车管理', 2025, 2, 'cart', 'snack/cart/index', NULL, '', 1, 1, 'C', '0', '0', 'snack:cart:list', '购物车管理', 'admin', '2025-10-13 22:27:30', 'admin', '2025-10-13 22:31:30', '购物车菜单');
INSERT INTO `sys_menu` VALUES (2027, '购物车查询', 2026, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:cart:query', '#', 'admin', '2025-10-13 22:27:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2028, '购物车新增', 2026, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:cart:add', '#', 'admin', '2025-10-13 22:27:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2029, '购物车修改', 2026, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:cart:edit', '#', 'admin', '2025-10-13 22:27:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2030, '购物车删除', 2026, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:cart:remove', '#', 'admin', '2025-10-13 22:27:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2031, '购物车导出', 2026, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:cart:export', '#', 'admin', '2025-10-13 22:27:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2032, '收货地址管理', 2025, 3, 'address', 'snack/address/index', NULL, '', 1, 1, 'C', '0', '0', 'snack:address:list', '收货地址管理', 'admin', '2025-10-14 22:17:19', 'admin', '2025-10-14 22:20:17', '收货地址菜单');
INSERT INTO `sys_menu` VALUES (2033, '收货地址查询', 2032, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:address:query', '#', 'admin', '2025-10-14 22:17:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2034, '收货地址新增', 2032, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:address:add', '#', 'admin', '2025-10-14 22:17:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2035, '收货地址修改', 2032, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:address:edit', '#', 'admin', '2025-10-14 22:17:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2036, '收货地址删除', 2032, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:address:remove', '#', 'admin', '2025-10-14 22:17:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2037, '收货地址导出', 2032, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:address:export', '#', 'admin', '2025-10-14 22:17:19', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2038, '订单管理', 2025, 4, 'order', 'snack/order/index', NULL, '', 1, 1, 'C', '0', '0', 'snack:order:list', '订单管理', 'admin', '2025-10-16 16:04:32', 'admin', '2025-10-16 16:12:56', '订单菜单');
INSERT INTO `sys_menu` VALUES (2039, '订单查询', 2038, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:order:query', '#', 'admin', '2025-10-16 16:04:32', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2040, '订单新增', 2038, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:order:add', '#', 'admin', '2025-10-16 16:04:32', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2041, '订单修改', 2038, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:order:edit', '#', 'admin', '2025-10-16 16:04:32', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2042, '订单删除', 2038, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:order:remove', '#', 'admin', '2025-10-16 16:04:32', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2043, '订单导出', 2038, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'snack:order:export', '#', 'admin', '2025-10-16 16:04:32', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '角色信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2025-08-30 08:59:54', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '2', 'admin', '2025-08-30 08:59:54', 'admin', '2025-08-30 10:34:10', '普通角色');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '角色和部门关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '角色和菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 105 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 100, 'admin', '花菜', '00', 'huacai@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-10-17 14:32:54', 'admin', '2025-08-30 08:59:53', '', '2025-10-17 14:32:54', '管理员');
INSERT INTO `sys_user` VALUES (104, NULL, '张三', '张三', '00', '', '', '0', '', '$2a$10$0quTpedWw5D1ItWqarkvb.3Wrke2WYaf6yBvcqi.hz0dkLBr4C.ye', '0', '0', '127.0.0.1', '2025-10-15 18:37:35', '', '2025-10-14 15:35:59', '', '2025-10-15 18:37:34', NULL);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '用户和角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);

SET FOREIGN_KEY_CHECKS = 1;
