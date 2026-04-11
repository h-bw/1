<template>
  <!-- 购物车页面容器 -->
    <view class="cart-container">
        <!-- 购物车为空时显示 -->
        <view v-if="cartList.length === 0" class="empty-cart">
            <!-- 提示文字 -->
            <text class="empty-text">购物车还是空的</text>
            <!-- 跳转首页按钮 -->
            <button class="go-shopping-btn" @click="goToHome">去逛逛</button>
        </view>

        <!-- 购物车有数据时显示 -->
        <view v-else class="cart-content">
            <!-- 商品列表滚动区域 -->
            <scroll-view class="cart-list" scroll-y>
                <!-- 遍历购物车数据 -->
                <view class="cart-item" v-for="(item, index) in cartList" :key="index">
                    <!-- 选择框 -->
                    <view class="item-selector">
                        <uni-icons
                                :type="item.selected ? 'checkbox-filled' : 'circle'"
                                :color="item.selected ? '#ff5339' : '#ccc'"
                                size="24"
                                @click="toggleItemSelected(index)"
                        ></uni-icons>
                    </view>
                    <!-- 商品信息 -->
                    <view class="item-clickable" @click="goToProductDetail(item.productId)">
                        <!-- 商品图片 -->
                        <view class="item-image">
                            <image :src="getImageUrl(item.image)" mode="aspectFill"/>
                        </view>
                        <!-- 商品详细信息 -->
                        <view class="item-details">
                            <!-- 商品名称 -->
                            <view class="item-name">{{ item.name }}</view>
                            <!-- 商品描述 -->
                            <view class="item-specs">{{ item.description }}</view>
                            <!-- 价格和数量控制区域 -->
                            <view class="item-price-section">
                                <!-- 商品价格 -->
                                <text class="item-price">¥{{ item.price }}</text>
                                <!-- 数量加减 -->
                                <view class="item-quantity-control">
                                    <!-- 减少按钮 -->
                                    <uni-icons type="minus" size="20" @click="handleQuantityChange(index, -1)"
                                               :color="item.quantity <= 1 ? '#ccc' : '#333'">
                                    </uni-icons>
                                    <!-- 数量显示 -->
                                    <text class="quantity-input" type="number">{{ item.quantity }}</text>
                                    <!-- 增加按钮 -->
                                    <uni-icons type="plus" size="20" @click="handleQuantityChange(index, 1)"
                                               color="#333">
                                    </uni-icons>
                                </view>
                            </view>
                        </view>
                    </view>
                    <!-- 删除按钮 -->
                    <view class="delete-btn" @click="removeItem(item.cartId, index)">
                        <uni-icons type="trash" size="24" color="#f64343"/>
                    </view>
                </view>
            </scroll-view>

            <!-- 底部结算栏 -->
            <view class="cart-footer">
                <!-- 全选区域 -->
                <view class="select-all" @click="toggleSelectAll">
                    <uni-icons
                            :type="isAllSelected ? 'checkbox-filled' : 'circle'"
                            :color="isAllSelected ? '#ff5339' : '#ccc'"
                            size="24"
                    ></uni-icons>
                    <text class="select-all-text">全选</text>
                </view>
                <!-- 结算汇总区域 -->
                <view class="cart-summary">
                    <!-- 总价格 -->
                    <view class="total-price">合计: ¥{{ totalPrice.toFixed(2) }}</view>
                    <!-- 提交订单按钮 -->
                    <button class="checkout-btn" @click="checkOut" :disabled="selectedCount === 0">
                        提交订单
                    </button>
                </view>
            </view>

        </view>

    </view>
</template>

<script setup>
import {ref, computed} from 'vue'
import {onShow} from "@dcloudio/uni-app";
import {delCart, increaseQuantity, reduceQuantity, selectMyCartList} from "@/pages/api/snack/cart";

//当前用户的购物车列表数据
const cartList = ref([])

//页面显示时调用
onShow(() => {
    selectMyCartList().then(res => {
        cartList.value = res.data
    })
})

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

//计算属性: 当前是否全选状态
const isAllSelected = computed(() => {
    return cartList.value.length > 0 && cartList.value.every(item => item.selected)
})

//计算属性: 已选中的商品的总价格
const totalPrice = computed(() => {
    return cartList.value.filter(item => item.selected).reduce((total, item) => total + (item.price * item.quantity), 0)
})

//计算属性: 已选择的商品的总数量
const selectedCount = computed(() => {
    return cartList.value.filter(item => item.selected).reduce((count, item) => count + item.quantity, 0)
})

//商品数量增加或减少
const handleQuantityChange = (index, change) => {
    //阻止事件冒泡到父级元素
    event.stopPropagation()

    const cartId = cartList.value[index].cartId;

    //减少数量(数量不能小于1)
    if (change === -1 && cartList.value[index].quantity > 1 ) {
        reduceQuantity(cartId).then(res => {
            cartList.value[index].quantity--
        })
    } else {
        //增加数量
        increaseQuantity(cartId).then(res => {
            cartList.value[index].quantity++
        })
    }
}

//切换全选状态
const toggleSelectAll = () => {
    const newSelectedState = !isAllSelected.value
    cartList.value.forEach(item => {
        item.selected = newSelectedState
    })
}

//跳转到首页
const goToHome = () => {
    uni.switchTab({
        url: '/pages/index'
    })
}

//切换单个商品的选择状态
const toggleItemSelected = (index) => {
    cartList.value[index].selected = !cartList.value[index].selected
}

//跳转到商品详情页
const goToProductDetail = (productId) => {
    uni.navigateTo({
        url: `/pages/product/index?id=${productId}`
    })
}

//删除商品
const removeItem = (cartId, index) => {
    //显示确认对话框
    uni.showModal({
        title: '确认删除',
        content: '确定要删除这个商品吗?',
        success: (res) => {
            if (res.confirm) {
                //调用删除API
                delCart(cartId).then(res => {
                    //从列表中移出
                    cartList.value.splice(index, 1)
                })
            }
        }
    })
}

//提交订单
const checkOut = () => {
    //获取选中的商品
    const selectedItems = cartList.value.filter(item => item.selected);

    //验证是否有选中商品
    if (selectedItems.length === 0) {
        uni.showToast({
            title: '请选择要结算的商品',
            icon: 'none'
        })
        return
    }

    //构建订单项数据
    const orderItems = selectedItems.map(item => ({
        cartId: item.cartId,
        name: item.name,
        price: item.price,
        quantity: item.quantity,
        image: item.image,
    }))

    //将数据转换为JSON字符串并通过URL传递
    const itemsJson = encodeURIComponent(JSON.stringify(orderItems));
    const totalPriceValue = totalPrice.value;

    //跳转到订单确认页面
    uni.navigateTo({
        url: `/pages/order/confirm?items=${itemsJson}&total=${totalPriceValue}`
    })
}

</script>

<style scoped>
/* 页面背景色设置 */
page {
    background-color: #f8f9fa;
}

/* 购物车容器 */
.cart-container {
    padding-top: 2px;
}

/* 空购物车状态样式 */
.empty-cart {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding-top: 100px; /* 顶部间距 */
}

/* 空购物车图标 */
.empty-icon {
    width: 120px;
    height: 120px;
    margin-bottom: 20px; /* 图标与文字间距 */
}

/* 空购物车提示文字 */
.empty-text {
    font-size: 16px;
    color: #999; /* 灰色文字 */
    margin-bottom: 30px; /* 文字与按钮间距 */
}

/* 去逛逛按钮 */
.go-shopping-btn {
    width: 150px;
    height: 40px;
    background: linear-gradient(135deg, #ff6b81, #ff4757); /* 渐变背景 */
    color: #fff;
    border-radius: 20px; /* 圆角按钮 */
    font-size: 16px;
}

/* 购物车列表容器 */
.cart-content .cart-list {
    height: calc(100vh - 180px); /* 计算高度，留出底部空间 */
}

/* 单个购物车商品项 */
.cart-item {
    display: flex;
    align-items: center;
    background-color: #fff; /* 白色背景 */
    margin-bottom: 10px; /* 项与项之间的间距 */
    padding: 15px;
    position: relative; /* 为删除按钮定位提供参考 */
}

/* 选择框区域 */
.item-selector {
    margin-right: 10px; /* 与商品信息的间距 */
}

/* 可点击的商品信息区域 */
.item-clickable {
    display: flex;
    flex: 1; /* 占据剩余空间 */
}

/* 商品图片容器 */
.item-image {
    width: 80px;
    height: 80px;
    border-radius: 8px; /* 圆角图片 */
    overflow: hidden; /* 隐藏超出部分 */
    margin-right: 10px; /* 与文字信息的间距 */
}

/* 商品图片 */
.item-image image {
    width: 100%;
    height: 100%;
}

/* 商品详细信息区域 */
.item-details {
    flex: 1; /* 占据剩余空间 */
}

/* 商品名称 */
.item-name {
    font-size: 16px;
    color: #333; /* 深色文字 */
    margin-bottom: 5px;
    line-height: 1.3; /* 行高设置 */
}

/* 商品规格 */
.item-specs {
    font-size: 12px;
    color: #999; /* 浅灰色文字 */
    margin-bottom: 10px;
}

/* 价格和数量控制区域 */
.item-price-section {
    display: flex;
    justify-content: space-between; /* 两端对齐 */
    align-items: center;
}

/* 商品价格 */
.item-price {
    font-size: 16px;
    color: #ff5339; /* 主题红色 */
    font-weight: bold;
}

/* 数量控制容器 */
.item-quantity-control {
    display: flex;
    align-items: center;
}

/* 数量输入框 */
.quantity-input {
    width: 40px;
    text-align: center; /* 文字居中 */
    margin: 0 10px; /* 左右间距 */
    font-size: 16px;
}

/* 删除按钮 */
.delete-btn {
    position: absolute;
    top: 10px;
    right: 10px;
}

/* 底部结算栏 */
.cart-footer {
    position: fixed; /* 固定定位 */
    bottom: 50px; /* 距离底部距离 */
    left: 0;
    right: 0;
    height: 60px;
    background-color: #fff;
    display: flex;
    align-items: center;
    padding: 0 15px;
    box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1); /* 顶部阴影 */
    z-index: 999; /* 确保在最上层 */
}

/* 全选区域 */
.select-all {
    display: flex;
    align-items: center;
    margin-right: 15px; /* 与结算区域的间距 */
}

/* 全选文字 */
.select-all-text {
    margin-left: 5px; /* 与图标的间距 */
    font-size: 14px;
    color: #333;
}

/* 结算汇总区域 */
.cart-summary {
    flex: 1; /* 占据剩余空间 */
    display: flex;
    justify-content: flex-end; /* 右对齐 */
    align-items: center;
}

/* 总价格显示 */
.total-price {
    font-size: 16px;
    color: #ff5339; /* 主题红色 */
    font-weight: bold;
    margin-right: 15px; /* 与按钮的间距 */
}

/* 提交订单按钮 */
.checkout-btn {
    width: 100px;
    height: 40px;
    background: linear-gradient(135deg, #ff6b81, #ff4757); /* 渐变背景 */
    color: #fff;
    border-radius: 20px; /* 圆角按钮 */
    font-size: 16px;
}

/* 禁用状态的提交按钮 */
.checkout-btn:disabled {
    background: #ccc; /* 灰色背景 */
}
</style>
