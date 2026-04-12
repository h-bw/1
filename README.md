# 零食商城项目说明

这是一个前后端分离的零食商城项目，包含：

- 用户端小程序/移动端：`huacai-snack-app`
- 管理后台：`huacai-snack-web/huacai-admin-vue3`
- 后端服务：`huacai-snack-web/huacai-springboot3`

适合用于快速了解一个完整的中小型商城项目结构，也适合作为毕业设计、课程设计或二次开发的基础项目。

## 1. 项目概览

项目采用前后端分离架构，面向两个主要角色：

- 普通用户：浏览商品、加入购物车、提交订单、查看订单
- 管理员：维护商品、分类、轮播图、订单等后台数据

整体业务链路比较清晰：

1. 用户在首页或分类页浏览商品
2. 进入商品详情页后加入购物车
3. 在购物车中统一结算
4. 选择收货地址并提交订单
5. 后台查看并管理订单、商品和展示内容

## 2. 技术栈

### 用户端

- UniApp
- Vue 3
- Vite

### 管理后台

- Vue 3
- Vite
- Element Plus
- Pinia
- Axios

### 后端

- Spring Boot 3
- Spring Security
- MyBatis
- MySQL

## 3. 项目结构

```text
lingshi/
├─ huacai-snack-app/                 # 用户端小程序/移动端
├─ huacai-snack-web/
│  ├─ huacai-admin-vue3/             # 管理后台
│  └─ huacai-springboot3/            # Spring Boot 后端
├─ scripts/                          # 论文、图表、辅助脚本
└─ thesis_images/                    # 论文配图
```

### 用户端目录重点

```text
huacai-snack-app/
├─ pages/
│  ├─ index.vue                      # 首页
│  ├─ login.vue                      # 登录
│  ├─ register.vue                   # 注册
│  ├─ category/                      # 分类
│  ├─ product/                       # 商品详情
│  ├─ cart/                          # 购物车
│  ├─ order/                         # 订单确认、订单列表
│  ├─ mine/                          # 个人中心
│  └─ common/                        # 公共页面
├─ api/                              # 接口封装
├─ utils/                            # 请求与工具方法
└─ config.js                         # 用户端接口地址配置
```

### 管理后台目录重点

```text
huacai-snack-web/huacai-admin-vue3/
├─ src/views/snack/
│  ├─ category/                      # 分类管理
│  ├─ product/                       # 商品管理
│  ├─ banner/                        # 轮播图管理
│  ├─ order/                         # 订单管理
│  ├─ cart/                          # 购物车管理
│  └─ address/                       # 地址管理
└─ vite.config.js                    # 开发代理配置
```

### 后端目录重点

```text
huacai-snack-web/huacai-springboot3/
├─ src/main/java/com/huacai/snack/
│  ├─ controller/
│  │  ├─ AddressController.java
│  │  ├─ BannerController.java
│  │  ├─ CartController.java
│  │  ├─ CategoryController.java
│  │  ├─ HomePageController.java
│  │  ├─ OrderController.java
│  │  ├─ ProductController.java
│  │  └─ RecommendationController.java
│  ├─ domain/                        # 实体类
│  ├─ mapper/                        # Mapper 接口
│  └─ service/                       # 业务逻辑
└─ src/main/resources/
   ├─ application.yml
   └─ mapper/                        # MyBatis XML
```

## 4. 核心功能

### 用户端

- 首页展示
- 商品分类浏览
- 商品详情查看
- 购物车管理
- 收货地址管理
- 订单确认与订单查询
- 个人中心
- 基础推荐功能

### 管理后台

- 商品分类管理
- 商品管理
- 轮播图管理
- 订单管理
- 地址管理
- 基础系统管理

### 后端业务模块

- 商品模块
- 分类模块
- 购物车模块
- 地址模块
- 订单模块
- 首页统计模块
- 轮播图模块
- 推荐模块

## 5. 运行关系

### 后端

- 默认端口：`8080`
- 配置文件：`huacai-snack-web/huacai-springboot3/src/main/resources/application.yml`

### 管理后台

- 默认开发端口：`90`
- 代理规则：`/dev-api -> http://localhost:8080`
- 配置文件：`huacai-snack-web/huacai-admin-vue3/vite.config.js`

### 用户端

- 默认接口地址：`http://localhost:8080`
- 配置文件：`huacai-snack-app/config.js`

## 6. 快速启动

### 第一步：启动后端

1. 准备 MySQL 数据库
2. 导入项目 SQL
3. 修改 `application.yml` 和 `application-druid.yml` 中的数据库连接信息
4. 启动 `huacai-springboot3`

### 第二步：启动管理后台

```bash
cd huacai-snack-web/huacai-admin-vue3
npm install
npm run dev
```

启动后通常访问：

- `http://localhost:90`

### 第三步：启动用户端

```bash
cd huacai-snack-app
npm install
npm run dev
```

用户端一般需要通过 HBuilderX 或 UniApp 对应方式运行到浏览器、模拟器或小程序环境中。

### 6.1 数据库初始化

项目自带初始化 SQL：

- `huacai-snack-web/huacai-springboot3/sql/huacai-snack.sql`

推荐初始化步骤：

1. 在 MySQL 中新建数据库，例如：`huacai_snack`
2. 执行 `huacai-snack.sql`
3. 打开后端配置文件，确认数据库地址、用户名、密码
4. 启动后端后检查表是否已正确读取

后端配置文件位置：

- `huacai-snack-web/huacai-springboot3/src/main/resources/application.yml`
- `huacai-snack-web/huacai-springboot3/src/main/resources/application-druid.yml`

如果接手后端时出现启动失败，优先检查：

- MySQL 服务是否启动
- 数据库名是否正确
- 用户名密码是否正确
- JDBC 连接地址是否正确
- SQL 是否已完整导入

### 6.2 启动顺序建议

为了减少联调问题，建议按下面顺序启动：

1. 先启动 MySQL
2. 再启动后端 `huacai-springboot3`
3. 然后启动后台管理端 `huacai-admin-vue3`
4. 最后启动用户端 `huacai-snack-app`

启动后可按下面顺序检查：

1. 后端是否正常监听 `8080`
2. 后台是否能打开 `http://localhost:90`
3. 后台接口是否能通过 `/dev-api` 正常访问后端
4. 用户端接口地址是否仍指向 `http://localhost:8080`

## 7. 数据库与业务对象

项目核心业务表主要包括：

- `sys_user`：用户信息
- `category`：商品分类
- `product`：商品信息
- `cart`：购物车
- `address`：收货地址
- `order`：订单主表
- `order_products`：订单明细
- `banner`：首页轮播图

其中最核心的交易链路是：

`category -> product -> cart -> order -> order_products`

## 8. 推荐功能说明

项目中包含一个基础推荐模块，不是复杂的独立推荐系统。

当前实现思路大致为：

1. 读取用户历史订单
2. 如果没有历史订单，返回热门商品
3. 如果存在历史订单，提取已购商品
4. 查找相似用户偏好
5. 结合热门商品进行补充和去重
6. 返回推荐商品列表

这部分实现位于：

- `huacai-snack-web/huacai-springboot3/src/main/java/com/huacai/snack/controller/RecommendationController.java`
- `huacai-snack-web/huacai-springboot3/src/main/java/com/huacai/snack/service/impl/RecommendationServiceImpl.java`

## 9. 接手时建议先看哪里

如果是第一次接手这个项目，建议按下面顺序阅读：

1. 先看本 README，理解整体结构
2. 看用户端 `pages.json`，了解页面入口和业务流
3. 看后台 `src/views/snack`，了解后台管理范围
4. 看后端 `controller`，了解接口划分
5. 看 `domain + mapper + service`，理解数据和业务逻辑
6. 最后看数据库表结构和 SQL

## 10. 当前项目特点

- 项目结构完整，适合快速上手
- 商城主链路明确，适合理解电商基础业务
- 同时包含用户端、后台端和后端服务
- 推荐功能为基础实现，便于继续扩展
- 很适合论文说明、课程展示或做二次开发

## 11. 注意事项

- 项目中部分中文注释可能存在编码问题，不影响核心业务理解
- 运行前需要优先确认数据库、上传目录和接口地址
- 如果用于论文或展示，建议重点关注商品、购物车、订单和后台管理四条主线

## 12. 常见问题

### 1. 后端能启动，但前端请求失败

优先检查：

- 后端是否启动在 `8080`
- 后台代理是否仍为 `/dev-api -> http://localhost:8080`
- 用户端 `config.js` 中的 `baseUrl` 是否正确
- 是否存在跨域或代理未生效问题

### 2. 后台页面可以打开，但列表没有数据

优先检查：

- 数据库是否已导入初始化 SQL
- 接口是否返回成功
- 后端数据库连接是否正确
- 当前表中是否已有初始数据

### 3. 用户端能进首页，但商品、订单为空

通常排查：

- `product`、`category`、`banner` 表中是否有数据
- 用户是否已登录
- 订单、购物车接口是否正常返回

### 4. 图片上传或显示异常

优先检查：

- 后端上传目录配置
- 图片访问路径是否正确
- 本地文件目录是否存在读写权限

### 5. 推荐功能没有结果

这是正常现象之一。当前推荐模块是基础实现：

- 没有历史订单时，通常返回热门商品
- 数据量太少时，推荐结果会比较简单
- 如果商品和订单数据为空，推荐结果也会为空
