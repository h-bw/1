<template>
  <!-- 商品详情页面容器 -->
    <view class="product-detail-container">
        <!-- 商品图片区域 -->
        <view class="product-image-section">
            <image v-if="product"
                   :src="getImageUrl(product.image)"
                   class="product-image"
                   mode="aspectFill"
            />
            <!-- 图片加载中的占位符 -->
            <view v-else class="image-placeholder">
                <text>商品图片加载中...</text>
            </view>
        </view>

        <!-- 商品信息区域 -->
        <view class="product-info-section">
            <!-- 商品名称 -->
            <view class="product-name">
                {{ product ? product.name : '加载中...' }}
            </view>
            <!-- 商品描述 -->
            <view class="product-description">
                {{ product ? product.description : '加载中...' }}
            </view>
            <!-- 商品价格 -->
            <view class="product-price-section">
                <view class="price">¥{{ product ? product.price : '加载中...' }}</view>
            </view>
        </view>

        <!-- 底部操作栏 -->
        <view class="action-bar">
            <view class="cart-icon-wrapper" @click="goTCart">
                <view class="cart-icon">
                    <uni-icons type="cart" size="24" color="#ff5359"/>
                </view>
                <view class="cart-text"/>
            </view>
            <!-- 加入购物车按钮 -->
            <view class="cart-button" @click="addToCart">
                <text>加入购物车</text>
            </view>
        </view>

    </view>
</template>

<script setup>
import {ref} from 'vue'
import {onLoad} from "@dcloudio/uni-app";
import {getProduct} from "@/pages/api/snack/product";
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

//商品数据
const product = ref(null)

//跳转到购物车页面
const goTCart = () => {
    uni.switchTab({
        url: '/pages/cart/index'
    })
}

//添加商品到购物车
const addToCart = () => {
    addProductToCart(product.value.productId).then(res => {
        //显示添加成功提示
        uni.showToast({
            title: '已添加至购物车',
            icon: 'success'
        })
    })
}

//页面加载时调用
onLoad((options) => {
    //根据商品ID查询商品详情信息
    getProduct(options.id).then(res => {
        //将获取到的商品数据赋值给响应式变量
        product.value = res.data
    })
})

</script>

<style scoped>
/* 页面整体样式 */
page {
    background-color: #f8f9fa; /* 浅灰色背景 */
    padding-bottom: 80px; /* 底部内边距，为操作栏留出空间 */
}

/* 商品详情容器 */
.product-detail-container {
    /* 容器样式，可根据需要添加 */
}

/* 商品图片区域样式 */
.product-image-section {
    width: 100%; /* 宽度100% */
    height: 375px; /* 固定高度 */
    background-color: #fff; /* 白色背景 */
    display: flex; /* 弹性布局 */
    align-items: center; /* 垂直居中 */
    justify-content: center; /* 水平居中 */
}

/* 商品图片样式 */
.product-image {
    width: 100%; /* 宽度100%填充容器 */
    height: 100%; /* 高度100%填充容器 */
}

/* 图片加载占位符样式 */
.image-placeholder {
    color: #999; /* 浅灰色文字 */
    font-size: 14px; /* 字体大小 */
}

/* 商品信息区域样式 */
.product-info-section {
    background-color: #fff; /* 白色背景 */
    margin: 10px; /* 外边距10px */
    padding: 15px; /* 内边距15px */
    border-radius: 8px; /* 圆角边框 */
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06); /* 轻微阴影效果 */
}

/* 商品名称样式 */
.product-name {
    font-size: 18px; /* 较大字体 */
    font-weight: bold; /* 粗体 */
    color: #333; /* 深灰色文字 */
    margin-bottom: 10px; /* 底部外边距 */
    line-height: 1.4; /* 行高1.4倍 */
}

/* 商品描述样式 */
.product-description {
    font-size: 14px; /* 正常字体大小 */
    color: #666; /* 中灰色文字 */
    margin-bottom: 15px; /* 底部外边距 */
    line-height: 1.5; /* 行高1.5倍 */
}

/* 价格区域样式 */
.product-price-section {
    display: flex; /* 弹性布局 */
    align-items: center; /* 垂直居中 */
    flex-wrap: wrap; /* 允许换行 */
}

/* 价格文字样式 */
.price {
    font-size: 22px; /* 较大字体 */
    color: #ff5339; /* 美团主题红色 */
    font-weight: bold; /* 粗体 */
    margin-right: 10px; /* 右侧外边距 */
}

/* 底部操作栏样式 */
.action-bar {
    position: fixed; /* 固定定位 */
    bottom: 0; /* 底部对齐 */
    left: 0; /* 左侧对齐 */
    right: 0; /* 右侧对齐 */
    height: 60px; /* 固定高度 */
    background-color: #fff; /* 白色背景 */
    display: flex; /* 弹性布局 */
    flex-direction: row; /* 水平排列 */
    box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1); /* 顶部阴影效果 */
    padding: 10px; /* 内边距 */
}

/* 购物车图标容器样式 */
.cart-icon-wrapper {
    width: 25%; /* 宽度占25% */
    display: flex; /* 弹性布局 */
    flex-direction: column; /* 垂直排列 */
    align-items: center; /* 水平居中 */
    justify-content: center; /* 垂直居中 */
    position: relative; /* 相对定位 */
}

/* 购物车图标样式 */
.cart-icon {
    position: relative; /* 相对定位 */
    display: flex; /* 弹性布局 */
    align-items: center; /* 垂直居中 */
    justify-content: center; /* 水平居中 */
    width: 40px; /* 固定宽度 */
    height: 40px; /* 固定高度 */
    border-radius: 50%; /* 圆形 */
    background-color: #fff7f6; /* 浅红色背景 */
}

/* 购物车文字样式 */
.cart-text {
    font-size: 12px; /* 小字体 */
    color: #666; /* 中灰色文字 */
    margin-top: 4px; /* 顶部外边距 */
}

/* 加入购物车按钮样式 */
.cart-button {
    width: 75%; /* 宽度占75% */
    height: 100%; /* 高度100% */
    display: flex; /* 弹性布局 */
    align-items: center; /* 垂直居中 */
    justify-content: center; /* 水平居中 */
    border-radius: 30px; /* 大圆角 */
    font-size: 16px; /* 字体大小 */
    color: #fff; /* 白色文字 */
    font-weight: bold; /* 粗体 */
    /* 渐变背景色：从粉红到红色 */
    background: linear-gradient(135deg, #ff6b81, #ff4757);
}
</style>
