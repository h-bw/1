<template>
    <!-- 首页容器 -->
    <view class="home-container">
        <!-- 轮播图区域 -->
        <view class="swiper-section">
            <!-- 轮播图组件 -->
            <swiper class="swiper" indicator-dots autoplay circular interval="6000" duration="500">
                <!-- 轮播图项 -->
                <swiper-item v-for="(item, index) in bannerList" :key="index">
                    <!-- 轮播图片 -->
                    <image :src="getImageUrl(item.image)" mode="aspectFill"/>
                </swiper-item>
            </swiper>
        </view>

        <!-- 分类导航区域 -->
        <view class="category-section">
            <!-- 分类网格布局 -->
            <view class="category-grid">
                <!-- 分类项 -->
                <view class="category-item" v-for="(item, index) in categoryList" :key="index"
                      @click="goToCategory(item.categoryId)">
                    <!-- 分类图片 -->
                    <image :src="getImageUrl(item.image)" class="category-image"/>
                    <!-- 分类名称 -->
                    <text class="category-name">{{ item.name }}</text>
                </view>
            </view>
        </view>

        <!-- 零食推荐区域 -->
        <view class="new-products">
            <!-- 区域标题 -->
            <view class="section-title">
                <text class="title-text">零食推荐</text>
            </view>

            <!-- 加载状态显示 -->
            <view v-if="loading" class="loading-placeholder">
                <!-- 加载图标 -->
                <uni-icons type="spinner" size="24" color="#999" class="loading-icon"></uni-icons>
                <text style="font-size: 14px; color: #999;">加载中...</text>
            </view>

            <!-- 商品网格布局 -->
            <view class="products-grid" v-else-if="newProducts">
                <!-- 商品卡片 -->
                <view class="product-card" v-for="(item, index) in newProducts" :key="index"
                      @click="goToProductDetail(item.productId)">
                    <!-- 商品图片 -->
                    <image :src="getImageUrl(item.image)" class="product-image"/>
                    <!-- 商品名称 -->
                    <text class="product-name">{{ item.name }}</text>
                    <!-- 商品价格 -->
                    <view class="product-price">
                        <text class="price-current">¥{{ item.price }}</text>
                    </view>
                    <!-- 加入购物车按钮 -->
                    <view class="add-cart-btn" @click.stop="addToCart(item.productId)">
                        <uni-icons type="cart" size="16" color="#fff"></uni-icons>
                    </view>
                </view>
            </view>
        </view>
    </view>
</template>

<script setup>
import {ref} from 'vue'
import {onShow} from "@dcloudio/uni-app";
import {listBanner} from "@/pages/api/snack/banner";
import {listCategory} from "@/pages/api/snack/category";
import {getAdvancedRecommendationsForUser} from "@/pages/api/snack/recommendation";
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

//轮播图列表数据
const bannerList = ref([])
//零食分类列表数据
const categoryList = ref([])

//加载状态
const loading = ref(false)

//零食推荐商品数据
const newProducts = ref([])

//轮播图查询参数
const bannerQuery = ref({
    pageNum: 1,
    pageSize: 10,
})

//零食分类查询参数
const categoryQuery = ref({
    pageNum: 1,
    pageSize: 8,
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

//跳转到分类页面
const goToCategory = (categoryId) => {
    uni.reLaunch({
        url: '/pages/category/index?id=' + (categoryId || '')
    })
}

//页面显示时执行
onShow(() => {
    //获取轮播图数据
    listBanner(bannerQuery.value).then(res => {
        bannerList.value = res.rows
    })

    //获取零食分类数据
    listCategory(categoryQuery.value).then(res => {
        categoryList.value = res.rows
    })

    //获取推荐商品数据
    loading.value = true
    getAdvancedRecommendationsForUser().then(res => {
        newProducts.value = res.rows
        loading.value = false
    })
})

</script>

<style scoped>
/* 页面基础样式 */
page {
    background-color: #f8f9fa; /* 页面背景色 */
}

/* 首页容器样式 */
.home-container {
    padding: 0 10px; /* 左右内边距 */
}

/* 轮播图区域样式 */
.swiper-section {
    margin: 10px 0; /* 上下外边距 */
    border-radius: 10px; /* 圆角边框 */
    overflow: hidden; /* 隐藏溢出内容 */
}

/* 轮播图组件样式 */
.swiper {
    height: 200px; /* 固定高度 */
}

/* 轮播图片样式 */
.swiper image {
    width: 100%; /* 宽度100% */
    height: 100%; /* 高度100% */
}

/* 分类导航区域样式 */
.category-section {
    background-color: white; /* 白色背景 */
    border-radius: 10px; /* 圆角边框 */
    padding: 15px; /* 内边距 */
    margin-bottom: 10px; /* 底部外边距 */
}

/* 分类网格布局样式 */
.category-grid {
    display: flex; /* 弹性布局 */
    flex-wrap: wrap; /* 允许换行 */
}

/* 分类项样式 */
.category-item {
    width: 25%; /* 每行4个，每个占25%宽度 */
    display: flex; /* 弹性布局 */
    flex-direction: column; /* 垂直方向排列 */
    align-items: center; /* 水平居中 */
    margin-bottom: 15px; /* 底部外边距 */
}

/* 分类图片样式 */
.category-image {
    width: 60px; /* 固定宽度 */
    height: 60px; /* 固定高度 */
    border-radius: 30px; /* 圆形边框 */
    margin-bottom: 8px; /* 底部外边距 */
}

/* 分类名称样式 */
.category-name {
    font-size: 13px; /* 字体大小 */
    color: #333; /* 字体颜色 */
}

/* 零食推荐区域样式 */
.new-products {
    background-color: white; /* 白色背景 */
    border-radius: 10px; /* 圆角边框 */
    padding: 15px; /* 内边距 */
}

/* 区域标题样式 */
.section-title {
    display: flex; /* 弹性布局 */
    justify-content: space-between; /* 两端对齐 */
    align-items: center; /* 垂直居中 */
    margin-bottom: 15px; /* 底部外边距 */
}

/* 标题文字样式 */
.title-text {
    font-size: 18px; /* 字体大小 */
    font-weight: bold; /* 字体粗细 */
    color: #333; /* 字体颜色 */
}

/* 加载状态占位样式 */
.loading-placeholder {
    display: flex; /* 弹性布局 */
    flex-direction: column; /* 垂直方向排列 */
    align-items: center; /* 水平居中 */
    justify-content: center; /* 垂直居中 */
    padding: 40px 0; /* 上下内边距 */
}

/* 加载图标样式 */
.loading-icon {
    margin-bottom: 10px; /* 底部外边距 */
    animation: rotate 1s linear infinite; /* 旋转动画 */
}

/* 商品网格布局样式 */
.products-grid {
    display: grid; /* 网格布局 */
    grid-template-columns: repeat(2, 1fr); /* 2列等宽网格 */
    gap: 15px; /* 网格间距 */
}

/* 商品卡片样式 */
.product-card {
    position: relative; /* 相对定位，用于绝对定位子元素 */
}

/* 商品图片样式 */
.product-image {
    width: 100%; /* 宽度100% */
    height: 150px; /* 固定高度 */
    border-radius: 8px; /* 圆角边框 */
    margin-bottom: 8px; /* 底部外边距 */
}

/* 商品名称样式 */
.product-name {
    font-size: 14px; /* 字体大小 */
    color: #333; /* 字体颜色 */
    display: block; /* 块级显示 */
    margin-bottom: 5px; /* 底部外边距 */
    overflow: hidden; /* 隐藏溢出内容 */
    text-overflow: ellipsis; /* 文本溢出显示省略号 */
    white-space: nowrap; /* 不换行 */
}

/* 当前价格样式 */
.price-current {
    font-size: 16px; /* 字体大小 */
    color: #ff4757; /* 红色价格 */
    font-weight: bold; /* 字体粗细 */
}

/* 加入购物车按钮样式 */
.add-cart-btn {
    position: absolute; /* 绝对定位 */
    bottom: 5px; /* 距离底部5px */
    right: 5px; /* 距离右侧5px */
    width: 24px; /* 按钮宽度 */
    height: 24px; /* 按钮高度 */
    border-radius: 12px; /* 圆形按钮 */
    /* 渐变背景色 */
    background: linear-gradient(135deg, #ff4757, #ff6b81);
    display: flex; /* 弹性布局 */
    align-items: center; /* 垂直居中 */
    justify-content: center; /* 水平居中 */
    /* 阴影效果 */
    box-shadow: 0 2px 4px rgba(255, 71, 87, 0.3);
}
</style>
