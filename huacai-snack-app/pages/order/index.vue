<template>
  <!-- 订单页面容器 -->
    <view class="order-container">
        <view class="tabs-section">
            <!-- 顶部标签页 -->
            <view class="tab-item" :class="{ active: activeTab === 'all' }" @click="switchTab('all')">
                全部
            </view>
            <view class="tab-item" :class="{ active: activeTab === '待收货' }" @click="switchTab('待收货')">
                待收货
            </view>
            <view class="tab-item" :class="{ active: activeTab === '已完成' }" @click="switchTab('已完成')">
                已完成
            </view>
            <view class="tab-item" :class="{ active: activeTab === '已取消' }" @click="switchTab('已取消')">
                已取消
            </view>
        </view>

        <!-- 订单列表 -->
        <view class="orders-content">
            <view class="order-item" v-for="order in filterOrders" :key="order.orderId">
                <!-- 订单头部 -->
                <view class="order-header">
                    <text class="order-no">订单号: {{ order.orderId }}</text>
                    <text class="order-status" :class="getStatusClass(order.status)">{{ order.status }}</text>
                </view>

                <!-- 订单商品项信息-->
                <view class="order-products">
                    <view class="product-item" v-for="(product, index) in order.orderProductsList" :key="index">
                        <!-- 商品图片-->
                        <image :src="getImageUrl(product.image)" class="product-image" mode="aspectFill"/>
                        <!-- 商品的信息-->
                        <view class="product-info">
                            <text class="product-name">{{ product.name }}</text>
                            <view class="product-price-quantity">
                                <text class="product-price">¥{{ product.price }}</text>
                                <text class="product-quantity">*{{ product.quantity }}</text>
                            </view>
                        </view>
                    </view>
                </view>

                <!-- 订单底部-->
                <view class="order-footer">
                    <text class="total-amount">共{{ order.productCount }}件商品 合计: ¥{{ order.totalAmount }}</text>
                    <view class="order-actions">
                        <!-- 订单操作按钮-->
                        <button v-if="order.status === '待收货'"
                                class="action-btn cancel-btn"
                                @click="cancelOrder(order)"
                        >取消订单
                        </button>
                        <button v-if="order.status === '待收货'"
                                class="action-btn confirm-btn"
                                @click="confirmOrder(order)"
                        >确认收货
                        </button>
                    </view>
                </view>

                <!-- 空状态提示 -->
                <view class="empty-orders" v-if="filterOrders.length === 0">
                    <text class="empty-text">暂无订单</text>
                    <button class="go-shopping-btn" @click="goToHome">去逛逛</button>
                </view>
            </view>
        </view>

    </view>
</template>

<script setup>
import {ref, computed} from 'vue'
import {onShow} from "@dcloudio/uni-app";
import {selectMyOrderList, updateOrder} from "@/pages/api/snack/order";

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

//当前激活的菜单
const activeTab = ref('all')

//订单数据源
const orders = ref([])

//计算属性: 根据当前激活的标签页筛选订单
const filterOrders = computed(() => {
    if (activeTab.value === 'all') {
        return orders.value
    }
    if (activeTab.value === '待收货') {
        return orders.value.filter(order => order.status === '待收货')
    }
    if (activeTab.value === '已完成') {
        return orders.value.filter(order => order.status === '已完成')
    }
    if (activeTab.value === '已取消') {
        return orders.value.filter(order => order.status === '已取消')
    }
})

//根据订单状态获取对应的CSS类名
const getStatusClass = (status) => {
    switch (status) {
        case '待收货':
            return 'status-shipped';
        case '已完成':
            return 'status-completed';
        case '已取消':
            return 'status-cancelled';
        default:
            return ''
    }
}

//去逛逛
const goToHome = () => {
    uni.switchTab({
        url: '/pages/index'
    })
}

//切换标签
const switchTab = (tab) => {
    activeTab.value = tab
}

//加载订单数据
const loadOrders = () => {
    selectMyOrderList().then(res => {
        orders.value = res.data
    })
}

//取消订单
const cancelOrder = (order) => {
    const item = {
        orderId: order.orderId,
        status: '已取消',
        orderProductsList: order.orderProductsList
    }
    uni.showModal({
        title: '提示',
        content: '确定要取消该订单吗?',
        success: (res) => {
            if (res.confirm) {
                //用户点击确定, 调用更新订单API
                updateOrder(item).then(res => {
                    //再次加载订单数据, 更新页面数据
                    loadOrders()
                    uni.showToast({
                        title: '订单已取消',
                        icon: "success"
                    })
                })
            }
        }
    })
}

//确认收货
const confirmOrder = (order) => {
    const item = {
        orderId: order.orderId,
        status: '已完成',
        orderProductsList: order.orderProductsList
    }
    uni.showModal({
        title: '提示',
        content: '确定已经收到货吗?',
        success: (res) => {
            if (res.confirm) {
                //用户点击确定, 调用更新订单API
                updateOrder(item).then(res => {
                    //再次加载订单数据, 更新页面数据
                    loadOrders()
                    uni.showToast({
                        title: '收货成功',
                        icon: "success"
                    })
                })
            }
        }
    })
}

//页面显示时调用
onShow(() => {
    loadOrders()
})

</script>

<style scoped>
/* 页面基础样式 */
page {
    background-color: #f8f9fa; /* 页面背景色 */
}

/* 订单容器样式 */
.order-container {
    display: flex;
    flex-direction: column; /* 垂直布局 */
    height: 100%; /* 全屏高度 */
    padding-top: env(safe-area-inset-top); /* 适配刘海屏顶部安全区域 */
    padding-bottom: env(safe-area-inset-bottom); /* 适配底部安全区域 */
}

/* 标签页区域样式 */
.tabs-section {
    display: flex;
    background-color: #fff; /* 白色背景 */
    padding: 10px 0; /* 上下内边距 */
    position: sticky; /* 粘性定位，滚动时保持固定 */
    top: 0; /* 固定在顶部 */
    z-index: 99; /* 确保在其他元素上方 */
    flex-shrink: 0; /* 防止被压缩 */
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05); /* 轻微阴影效果 */
}

/* 单个标签项样式 */
.tab-item {
    flex: 1; /* 等分宽度 */
    text-align: center; /* 文字居中 */
    padding: 10px 0; /* 上下内边距 */
    font-size: 14px; /* 字体大小 */
    color: #666; /* 默认文字颜色 */
    transition: all 0.3s ease; /* 过渡动画效果 */
}

/* 激活状态的标签项样式 */
.tab-item.active {
    color: #ff5339; /* 激活状态文字颜色 */
    font-weight: bold; /* 加粗 */
    position: relative; /* 相对定位，用于伪元素定位 */
}

/* 激活标签项的下划线 */
.tab-item.active::after {
    content: ''; /* 伪元素内容 */
    position: absolute; /* 绝对定位 */
    bottom: 0; /* 底部对齐 */
    left: 50%; /* 水平居中 */
    transform: translateX(-50%); /* 水平居中偏移 */
    width: 30px; /* 下划线宽度 */
    height: 3px; /* 下划线高度 */
    background-color: #ff5339; /* 下划线颜色 */
    border-radius: 3px; /* 圆角 */
}

/* 订单内容区域样式 */
.orders-content {
    flex: 1; /* 占据剩余空间 */
    overflow-y: auto; /* 垂直方向滚动 */
    -webkit-overflow-scrolling: touch; /* iOS平滑滚动 */
    padding-bottom: env(safe-area-inset-bottom); /* 适配底部安全区域 */
}

/* 单个订单项样式 */
.order-item {
    background-color: #fff; /* 白色背景 */
    margin: 10px; /* 外边距 */
    border-radius: 10px; /* 圆角 */
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05); /* 阴影效果 */
    overflow: hidden; /* 隐藏溢出内容 */
}

/* 订单头部样式 */
.order-header {
    display: flex;
    justify-content: space-between; /* 两端对齐 */
    align-items: center; /* 垂直居中 */
    padding: 15px; /* 内边距 */
    border-bottom: 1px solid #f0f0f0; /* 底部边框 */
}

/* 订单号样式 */
.order-no {
    font-size: 14px;
    color: #666; /* 灰色文字 */
}

/* 订单状态通用样式 */
.order-status {
    font-size: 14px;
    font-weight: bold; /* 加粗 */
}

/* 待收货状态样式 */
.order-status.status-shipped {
    color: #4e81ef; /* 蓝色 */
}

/* 已完成状态样式 */
.order-status.status-completed {
    color: #67c23a; /* 绿色 */
}

/* 已取消状态样式 */
.order-status.status-cancelled {
    color: #e6a23c; /* 橙色 */
}

/* 订单商品区域样式 */
.order-products {
    padding: 15px; /* 内边距 */
    border-bottom: 1px solid #f0f0f0; /* 底部边框 */
}

/* 单个商品项样式 */
.product-item {
    display: flex;
    margin-bottom: 15px; /* 底部外边距 */
}

/* 最后一个商品项取消底部外边距 */
.product-item:last-child {
    margin-bottom: 0;
}

/* 商品图片样式 */
.product-image {
    width: 80px; /* 固定宽度 */
    height: 80px; /* 固定高度 */
    border-radius: 8px; /* 圆角 */
    margin-right: 10px; /* 右侧外边距 */
}

/* 商品信息区域样式 */
.product-info {
    flex: 1; /* 占据剩余空间 */
    display: flex;
    flex-direction: column; /* 垂直布局 */
    justify-content: space-between; /* 两端对齐 */
}

/* 商品名称样式 */
.product-name {
    font-size: 15px;
    color: #333; /* 深色文字 */
    line-height: 1.3; /* 行高 */
}

/* 商品价格和数量容器样式 */
.product-price-quantity {
    display: flex;
    justify-content: space-between; /* 两端对齐 */
}

/* 商品价格样式 */
.product-price {
    font-size: 16px;
    color: #ff5339; /* 红色价格 */
    font-weight: bold; /* 加粗 */
}

/* 商品数量样式 */
.product-quantity {
    font-size: 14px;
    color: #666; /* 灰色文字 */
}

/* 订单底部样式 */
.order-footer {
    padding: 15px; /* 内边距 */
}

/* 总金额样式 */
.total-amount {
    font-size: 14px;
    color: #666; /* 灰色文字 */
    margin-bottom: 15px; /* 底部外边距 */
    display: block; /* 块级元素 */
    text-align: right; /* 右对齐 */
}

/* 订单操作按钮容器样式 */
.order-actions {
    display: flex;
    justify-content: space-between; /* 两端对齐 */
}

/* 操作按钮通用样式 */
.action-btn {
    margin-left: 0;
    margin-right: 0;
    padding: 8px 16px; /* 内边距 */
    font-size: 13px; /* 字体大小 */
    border-radius: 20px; /* 圆形边框 */
    border: 1px solid #ddd; /* 边框 */
    background: #fff; /* 白色背景 */
    transition: all 0.3s ease; /* 过渡动画 */
}

/* 确认收货按钮样式 */
.action-btn.confirm-btn {
    background: linear-gradient(135deg, #67c23a, #5daa34); /* 绿色渐变背景 */
    color: #fff; /* 白色文字 */
    border: none; /* 无边框 */
    margin-left: auto; /* 自动左外边距，推至右侧 */
}

/* 确认收货按钮点击效果 */
.action-btn.confirm-btn:active {
    transform: scale(0.95); /* 点击时缩小 */
}

/* 取消订单按钮样式 */
.action-btn.cancel-btn {
    background: linear-gradient(135deg, #f56c6c, #f03e3e); /* 红色渐变背景 */
    color: #fff; /* 白色文字 */
    border: none; /* 无边框 */
}

/* 取消订单按钮点击效果 */
.action-btn.cancel-btn:active {
    transform: scale(0.95); /* 点击时缩小 */
}

/* 空订单状态样式 */
.empty-orders {
    display: flex;
    flex-direction: column; /* 垂直布局 */
    align-items: center; /* 水平居中 */
    padding: 100px 20px 20px; /* 内边距 */
}

/* 空状态图标样式 */
.empty-icon {
    width: 120px; /* 固定宽度 */
    height: 120px; /* 固定高度 */
    margin-bottom: 20px; /* 底部外边距 */
    opacity: 0.7; /* 半透明 */
}

/* 空状态文字样式 */
.empty-text {
    font-size: 16px;
    color: #999; /* 浅灰色文字 */
    margin-bottom: 30px; /* 底部外边距 */
}

/* 去购物按钮样式 */
.go-shopping-btn {
    background: linear-gradient(135deg, #ff6b81, #ff4757); /* 粉色渐变背景 */
    color: #fff; /* 白色文字 */
    border: none; /* 无边框 */
    border-radius: 20px; /* 圆形边框 */
    padding: 12px 32px; /* 内边距 */
    font-size: 14px; /* 字体大小 */
    transition: all 0.3s ease; /* 过渡动画 */
}

/* 去购物按钮点击效果 */
.go-shopping-btn:active {
    transform: scale(0.95); /* 点击时缩小 */
}
</style>
