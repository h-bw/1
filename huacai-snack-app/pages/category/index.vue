<template>
  <!-- 分类页面容器 -->
    <view class="category-container">
        <!-- 顶部搜索框 -->
        <view class="search-section">
            <view class="search-box">
                <uni-icons type="search" size="18" color="#999"/>
                <!-- 搜索输入框 -->
                <input class="search-input"
                       placeholder="搜索商品"
                       v-model="query.name"
                       @confirm="handleSearch"
                />
            </view>
        </view>

        <!-- 分页内容区域 -->
        <view class="category-content">
            <!-- 左侧分类导航 -->
            <scroll-view class="category-nav"
                         scroll-y
                         scroll-with-animation
                         :scroll-into-view="navScrollIntoView"
            >
                <!-- 分类项 -->
                <view class="nav-item" v-for="(item, index) in categoryList" :key="index"
                      :class="{ active: activeCategoryIndex === index }"
                      :id="`nav-${index}`" @click="switchCategory(index)"
                >
                    <text class="nav-text">{{ item.name }}</text>
                </view>
            </scroll-view>

            <!-- 右侧商品列表 -->
            <scroll-view class="product-list"
                         scroll-y
                         scroll-with-animation
                         @scroll="onListScroll"
                         :show-scrollbar="false"
                         :scroll-into-view="listScrollIntoView"
            >
                <!-- 分类商品组 -->
                <view class="category-group"
                      v-for="(category, index) in categoryList"
                      :key="category.categoryId"
                      :id="`group-${index}`"
                >
                    <view class="category-title">
                        <text class="title-text">{{ category.name }}</text>
                        <text class="title-desc">{{ category.description }}</text>
                    </view>

                    <view class="productList-grid">
                        <!-- 商品卡片 -->
                        <view class="product-card"
                              v-for="product in getProductsByCategoryId(category.categoryId)"
                              :key="product.productId"
                              @click="goToProductDetail(product.productId)"
                        >
                            <!-- 商品图片 -->
                            <image :src="getImageUrl(product.image)" class="product-image" mode="aspectFill"/>
                            <!-- 商品信息 -->
                            <view class="product-info">
                                <text class="product-name">{{ product.name }}</text>
                                <text class="product-desc">{{ product.description }}</text>
                                <view class="product-bottom">
                                    <text class="product-price">¥{{ product.price }}</text>
                                    <view class="add-cart-btn" @click.stop="addToCart(product.productId)">
                                        <uni-icons type="cart" size="16" color="#fff"/>
                                    </view>
                                </view>
                            </view>

                        </view>
                    </view>

                </view>
            </scroll-view>

        </view>

    </view>
</template>

<script setup>
import {onLoad, onShow} from "@dcloudio/uni-app";
import {ref, nextTick} from 'vue'
import {listProduct} from "@/pages/api/snack/product";
import {listCategory} from "@/pages/api/snack/category";
import {addProductToCart} from "@/pages/api/snack/cart";

import config from '@/config'
const baseUrl = config.baseUrl

//判断图片 URL 是否为完整路径
const getImageUrl = (imagePath) => {
  if (!imagePath) return ''
  // 如果已经包含 http 或 https，直接返回
  if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
    return imagePath
  }
  // 否则拼接 baseUrl
  return baseUrl + imagePath
}

//左侧导航滚动到的目标元素ID
const navScrollIntoView = ref('')
//右侧导航滚动到的目标元素ID
const listScrollIntoView = ref('')

//当前激活的分类索引
const activeCategoryIndex = ref(0)

//是否手动滚动标志, 防止自动滚动触发事件
const isManualScroll = ref(false)

//查询参数
const query = ref({
    pageNum: 1, //页码
    pageSize: 100000, //每页的数量
    name: null, //商品名称
})

//添加商品到购物车
const addToCart = (productId) => {
    addProductToCart(productId).then(res => {
        //显示添加成功提示
        uni.showToast({
            title: '已添加至购物车',
            icon: 'success'
        })
    })
}

//跳转到商品详情页
const goToProductDetail = (productId) => {
    uni.navigateTo({
        url: `/pages/product/index?id=${productId}`
    })
}

//切换分类
const switchCategory = (index) => {
    //如果点击的是当前激活的分类, 不做任何操作
    if (activeCategoryIndex.value === index) return

    //设置手动滚动标志, 防止触发自动滚动监测
    isManualScroll.value = true
    //更新激活的分类索引
    activeCategoryIndex.value = index

    //滚动右侧商品列表到对应的分类组
    listScrollIntoView.value = `group-${index}`
    //滚动左侧导航到对应分类项
    navScrollIntoView.value = `nav-${index}`

    //3秒后重置手动滚动标志, 为了避免干扰后续的自动滚动检测
    setTimeout(() => {
        isManualScroll.value = false
    }, 3000)
}

//根据分类ID获取该分类下的商品列表
const getProductsByCategoryId = (categoryId) => {
    return productList.value.filter(product => product.categoryId === categoryId)
}

//商品列表数据
const productList = ref([])
//分类列表数据
const categoryList = ref([])

//防抖定时器
let scrollTimer = null

//右侧商品列表滚动事件
const onListScroll = (e) => {
    //如果是手动滚动触发的, 不处理自动激活逻辑
    if (isManualScroll.value) return

    if (scrollTimer) {
        clearTimeout(scrollTimer)
    }

    scrollTimer = setTimeout(() => {
        //查找最接近顶部的分类组
        let closestIndex = 0
        //最小距离
        let minDistance = Infinity

        //遍历所有分类组
        categoryList.value.forEach((_, index) => {
            //创建选择器查询
            const query = uni.createSelectorQuery()
            //获取分类组的边界信息
            query.select(`#group-${index}`).boundingClientRect()
            query.exec((res) => {
                if (res[0]) {
                    //计算当前分类组顶部与参考位置的距离
                    let distance = Math.abs(res[0].top - 100);
                    //更新最小距离和对应的索引
                    if (distance < minDistance) {
                        minDistance = distance
                        closestIndex = index
                    }
                }

                //如果是最后一个分类, 执行激活状态更新
                if (index === categoryList.value.length - 1) {
                    //如果找到的最接近分类与当前激活分类不同, 更新激活状态
                    if (activeCategoryIndex.value !== closestIndex) {
                        activeCategoryIndex.value = closestIndex
                        //更新左侧导航的滚动位置
                        updateNavScrollPosition()
                    }
                }
            })
        })

    }, 100) //防抖延迟100ms
}

//更新左侧导航滚动位置, 确保激活项在可视区域内
const updateNavScrollPosition = () => {
    const query = uni.createSelectorQuery()
    //获取激活的导航项和导航容器的边界信息
    query.select(`#nav-${activeCategoryIndex.value}`).boundingClientRect()
    query.select('.category-nav').boundingClientRect()
    query.exec((res) => {
        if (res[0] && res[1]) {
            const navItemTop = res[0].top
            const navHeight = res[1].height
            const itemHeight = res[0].height

            //检查激活想是否在可视区域外
            if (navItemTop < 0 || navItemTop > navHeight - itemHeight) {
                //滚动到激活项
                navScrollIntoView.value = `nav-${activeCategoryIndex.value}`
            }
        }
    })
}

//搜索确认事件
const handleSearch = () => {
    loadProduct()
}

//加载商品数据
const loadProduct = () => {
    listProduct(query.value).then(res => {
        productList.value = res.rows
    })
}

//每次页面显示时调用
onShow(() => {
    listCategory(query.value).then(res => {
        categoryList.value = res.rows
    })
    listProduct(query.value).then(res => {
        productList.value = res.rows
    })
})

//页面初次加载时调用
onLoad((options) => {
    //如果有传入分类ID, 则切换到对应的分类
    if (options && options.id) {
        //使用定时器检查数据是否加载完成
        const checkDateLoaded = setInterval(() => {
            if (categoryList.value.length > 0) {
                clearInterval(checkDateLoaded) //清除定时器
                //查找对应分类的索引
                const index = categoryList.value.findIndex(item => item.categoryId == options.id)
                if (index !== 1) {
                    //延迟执行, 确保页面渲染完成
                    nextTick(() => {
                        setTimeout(() => {
                            switchCategory(index)
                        }, 100)
                    })
                }
            }
        }, 50) //每50ms检查一次
    }
})

</script>

<style>
/* 页面基础样式 */
page {
    height: 100%; /* 页面高度100% */
    background-color: #f8f9fa; /* 背景色 */
}

/* 分类容器 */
.category-container {
    height: 100%; /* 高度100% */
    display: flex; /* 弹性布局 */
    flex-direction: column; /* 垂直方向排列 */
}

/* 搜索区域样式 */
.search-section {
    padding: 10px 15px; /* 内边距 */
    background-color: white; /* 背景色 */
    border-bottom: 1px solid #f0f0f0; /* 底部边框 */
}

/* 搜索框样式 */
.search-box {
    display: flex; /* 弹性布局 */
    align-items: center; /* 垂直居中 */
    background-color: #f5f5f5; /* 背景色 */
    border-radius: 20px; /* 圆角 */
    padding: 8px 15px; /* 内边距 */
}

/* 搜索输入框样式 */
.search-input {
    flex: 1; /* 占据剩余空间 */
    margin: 0 10px; /* 左右外边距 */
    background: transparent; /* 透明背景 */
    font-size: 14px; /* 字体大小 */
}

/* 分类内容区域 */
.category-content {
    flex: 1; /* 占据剩余空间 */
    display: flex; /* 弹性布局 */
    height: calc(100vh - 120px); /* 计算高度，减去搜索栏高度 */
}

/* 左侧分类导航样式 */
.category-nav {
    width: 90px; /* 固定宽度 */
    background-color: #f8f9fa; /* 背景色 */
    border-right: 1px solid #f0f0f0; /* 右侧边框 */
}

/* 导航项样式 */
.nav-item {
    padding: 16px 8px; /* 内边距 */
    text-align: center; /* 文字居中 */
    border-left: 3px solid transparent; /* 左侧边框，初始透明 */
    transition: all 0.3s; /* 过渡动画 */
    position: relative; /* 相对定位，用于伪元素定位 */
}

/* 激活状态的导航项 */
.nav-item.active {
    background-color: white; /* 背景色 */
    border-left-color: #ff4757; /* 左侧边框颜色 */
    color: #ff4757; /* 文字颜色 */
    font-weight: bold; /* 字体粗细 */
}

/* 激活状态导航项的指示条 */
.nav-item.active::before {
    content: ''; /* 伪元素内容 */
    position: absolute; /* 绝对定位 */
    left: 0; /* 左侧对齐 */
    top: 50%; /* 垂直居中 */
    transform: translateY(-50%); /* Y轴偏移 */
    width: 3px; /* 宽度 */
    height: 16px; /* 高度 */
    background-color: #ff4757; /* 背景色 */
    border-radius: 2px; /* 圆角 */
}

/* 导航文字样式 */
.nav-text {
    font-size: 13px; /* 字体大小 */
    line-height: 1.3; /* 行高 */
    display: block; /* 块级显示 */
}

/* 右侧商品列表样式 */
.product-list {
    flex: 1; /* 占据剩余空间 */
    background-color: white; /* 背景色 */
}

/* 分类组样式 */
.category-group {
    padding: 15px; /* 内边距 */
}

/* 分类标题区域 */
.category-title {
    margin-bottom: 15px; /* 底部外边距 */
    padding-bottom: 10px; /* 底部内边距 */
    border-bottom: 1px solid #f0f0f0; /* 底部边框 */
}

/* 分类主标题文字 */
.title-text {
    display: block; /* 块级显示 */
    font-size: 16px; /* 字体大小 */
    font-weight: bold; /* 字体粗细 */
    color: #333; /* 文字颜色 */
    margin-bottom: 4px; /* 底部外边距 */
}

/* 分类描述文字 */
.title-desc {
    display: block; /* 块级显示 */
    font-size: 12px; /* 字体大小 */
    color: #999; /* 文字颜色 */
}

/* 商品网格布局 */
.productList-grid {
    display: grid; /* 网格布局 */
    grid-template-columns: repeat(2, 1fr); /* 2列等宽网格 */
    gap: 12px; /* 网格间隙 */
}

/* 商品卡片样式 */
.product-card {
    background: #fff; /* 背景色 */
    border-radius: 8px; /* 圆角 */
    overflow: hidden; /* 溢出隐藏 */
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06); /* 阴影 */
    transition: all 0.3s; /* 过渡动画 */
}

/* 商品卡片点击效果 */
.product-card:active {
    transform: scale(0.98); /* 缩放效果 */
}

/* 商品图片样式 */
.product-image {
    width: 100%; /* 宽度100% */
    height: 120px; /* 固定高度 */
}

/* 商品信息区域 */
.product-info {
    padding: 10px; /* 内边距 */
}

/* 商品名称 */
.product-name {
    display: block; /* 块级显示 */
    font-size: 14px; /* 字体大小 */
    font-weight: 500; /* 字体粗细 */
    color: #333; /* 文字颜色 */
    margin-bottom: 4px; /* 底部外边距 */
    overflow: hidden; /* 溢出隐藏 */
    text-overflow: ellipsis; /* 文字溢出显示省略号 */
    white-space: nowrap; /* 不换行 */
}

/* 商品描述 */
.product-desc {
    display: block; /* 块级显示 */
    font-size: 12px; /* 字体大小 */
    color: #999; /* 文字颜色 */
    margin-bottom: 8px; /* 底部外边距 */
    overflow: hidden; /* 溢出隐藏 */
    text-overflow: ellipsis; /* 文字溢出显示省略号 */
    white-space: nowrap; /* 不换行 */
}

/* 商品底部区域（价格和按钮） */
.product-bottom {
    display: flex; /* 弹性布局 */
    justify-content: space-between; /* 两端对齐 */
    align-items: center; /* 垂直居中 */
}

/* 商品价格 */
.product-price {
    font-size: 16px; /* 字体大小 */
    color: #ff4757; /* 文字颜色 */
    font-weight: bold; /* 字体粗细 */
}

/* 添加到购物车按钮 */
.add-cart-btn {
    width: 24px; /* 宽度 */
    height: 24px; /* 高度 */
    border-radius: 12px; /* 圆形 */
    background: linear-gradient(135deg, #ff4757, #ff6b81); /* 渐变背景 */
    display: flex; /* 弹性布局 */
    align-items: center; /* 垂直居中 */
    justify-content: center; /* 水平居中 */
    box-shadow: 0 2px 4px rgba(255, 71, 87, 0.3); /* 阴影 */
}

/* 加载状态区域 */
.loading-section {
    text-align: center; /* 文字居中 */
    padding: 20px; /* 内边距 */
}

/* 加载文字 */
.loading-text {
    font-size: 14px; /* 字体大小 */
    color: #999; /* 文字颜色 */
}
</style>
